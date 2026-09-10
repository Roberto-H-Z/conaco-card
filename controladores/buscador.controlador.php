<?php
declare(strict_types=1);

class ControladorBuscador
{
    public static function filtros(array $entrada): array
    {
        $f = ['q'=>'', 'ciudad'=>0, 'categoria'=>0, 'pagina'=>1];
        foreach ($f as $key => $default) {
            if (!isset($entrada[$key])) continue;
            if (!is_string($entrada[$key])) throw new InvalidArgumentException('Los filtros de búsqueda no son válidos.');
            if ($key === 'q') {
                $q = trim($entrada[$key]);
                if (!mb_check_encoding($q, 'UTF-8') || mb_strlen($q) > 120 || preg_match('/[\x00-\x1F\x7F]/', $q)) throw new InvalidArgumentException('Escribe una búsqueda de hasta 120 caracteres, sin caracteres de control.');
                $f[$key] = preg_replace('/\s+/u', ' ', $q);
            } elseif ($entrada[$key] !== '') {
                $value = filter_var($entrada[$key], FILTER_VALIDATE_INT, ['options'=>['min_range'=>$key === 'pagina' ? 1 : 0, 'max_range'=>2147483647]]);
                if ($value === false) throw new InvalidArgumentException('Selecciona una ciudad, categoría y página válidas.');
                $f[$key] = $value;
            }
        }
        return $f;
    }

    public function index(): array
    {
        $inicio = microtime(true);
        $datos = ['filtros'=>['q'=>'','ciudad'=>0,'categoria'=>0,'pagina'=>1], 'catalogos'=>['ciudades'=>[], 'categorias'=>[]], 'resultado'=>['total'=>0,'paginas'=>1,'pagina'=>1,'items'=>[]], 'error'=>null, 'busqueda_token'=>null, 'meta_titulo'=>'Buscar empresas', 'meta_descripcion'=>'Encuentra empresas y promociones vigentes por nombre, ciudad o categoría en CANACO Card.'];
        try {
            $modelo = new ModeloBuscador();
            $datos['catalogos'] = $modelo->catalogos();
            $f = self::filtros($_GET);
            $datos['filtros'] = $f;
            foreach (['ciudad'=>'ciudades','categoria'=>'categorias'] as $key=>$catalogo) {
                if ($f[$key] && !in_array($f[$key], array_map('intval', array_column($datos['catalogos'][$catalogo], 'id')), true)) throw new InvalidArgumentException('La ciudad o categoría seleccionada no está disponible. Ajusta los filtros e intenta otra vez.');
            }
            $datos['resultado'] = $modelo->buscar($f);
            // Una recarga o regreso a la misma página no infla las estadísticas durante diez minutos.
            $key = hash('sha256', json_encode([$f['q'],$f['ciudad'],$f['categoria'],$datos['resultado']['pagina']]));
            $reciente = $_SESSION['buscador_registros'][$key] ?? null;
            if ($reciente && $reciente['hasta'] > time()) {
                $datos['busqueda_token'] = $reciente['token'];
            } else {
                try {
                    $id = $modelo->registrar($f, $datos['resultado'], (int) round((microtime(true)-$inicio)*1000));
                    $token = bin2hex(random_bytes(16));
                    $_SESSION['buscador_registros'][$key] = ['id'=>$id,'token'=>$token,'hasta'=>time()+600,'filtros'=>array_merge($f,['pagina'=>$datos['resultado']['pagina']])];
                    $_SESSION['buscador_registros'] = array_slice($_SESSION['buscador_registros'], -30, null, true);
                    $datos['busqueda_token'] = $token;
                } catch (Throwable $e) { registrarLog('Estadística de búsqueda: '.$e->getMessage(), 'ERROR'); }
            }
        } catch (InvalidArgumentException $e) {
            http_response_code(400);
            $datos['error'] = $e->getMessage();
        } catch (PDOException $e) {
            http_response_code(503);
            registrarLog('Buscador: '.$e->getMessage(), 'ERROR');
            $datos['error'] = 'No pudimos consultar el directorio. Intenta nuevamente en unos momentos.';
        }
        return $datos;
    }

    public static function registrarFicha(int $idAfiliado): void
    {
        $token = $_GET['busqueda'] ?? '';
        if (!is_string($token) || !preg_match('/^[a-f0-9]{32}$/', $token)) return;
        foreach (($_SESSION['buscador_registros'] ?? []) as $registro) {
            if (!hash_equals($registro['token'], $token) || $registro['hasta'] < time()) continue;
            $clave = $registro['id'].':'.$idAfiliado;
            if (isset($_SESSION['buscador_visitas'][$clave])) return;
            try {
                (new ModeloBuscador())->registrarConsulta($registro['id'], $idAfiliado);
                $_SESSION['buscador_visitas'][$clave] = time();
                $_SESSION['buscador_visitas'] = array_slice($_SESSION['buscador_visitas'], -100, null, true);
            } catch (PDOException $e) { registrarLog('Consulta desde buscador: '.$e->getMessage(), 'ERROR'); }
            return;
        }
    }
}
