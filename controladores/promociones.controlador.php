<?php
declare(strict_types=1);

final class ControladorPromociones
{
    public function index(): array
    {
        $filtros = [
            'q' => mb_substr(trim((string) ($_GET['q'] ?? '')), 0, 100),
            'afiliado' => max(0, (int) ($_GET['afiliado'] ?? 0)),
            'estado' => in_array((string) ($_GET['estado'] ?? ''), ['0', '1'], true) ? (string) $_GET['estado'] : '',
        ];
        $alcance = $this->alcanceAfiliados();
        return [
            'filtros' => $filtros,
            'listado' => ModeloPromociones::listar($filtros, max(1, (int) ($_GET['pagina'] ?? 1)), 12, $alcance),
            'estadisticas' => ModeloPromociones::estadisticas($alcance),
            'afiliados' => ModeloPromociones::afiliadosActivos($alcance),
            'puedeCrear' => tienePermiso('promociones.crear') && $alcance !== [],
        ];
    }

    public function obtener(): void
    {
        $this->metodo('GET');
        $promocion = ModeloPromociones::obtener($this->idGet('id'));
        if (!$promocion) $this->json(['status' => 'error', 'message' => 'La promoción no existe.'], 404);
        if (!puedeGestionarPromocionDeAfiliado((int) $promocion['idAfiliado'], 'promociones.ver')) $this->prohibido();
        $this->json(['status' => 'success', 'data' => $promocion]);
    }

    public function guardar(): void
    {
        $this->metodo('POST');
        $this->csrf($_POST);
        $datos = $this->normalizar($_POST);
        $existente = $datos['idPromocion'] ? ModeloPromociones::obtener($datos['idPromocion']) : null;
        if ($datos['idPromocion'] && !$existente) $this->json(['status' => 'error', 'message' => 'La promoción no existe.'], 404);
        if ($existente && !puedeGestionarPromocionDeAfiliado((int) $existente['idAfiliado'], 'promociones.editar')) $this->prohibido();
        $permiso = $existente ? 'promociones.editar' : 'promociones.crear';
        if (!puedeGestionarPromocionDeAfiliado($datos['idAfiliado'], $permiso)) $this->prohibido();

        $errores = $this->validar($datos);
        $nuevas = $this->archivosEntrada($_FILES['galeria'] ?? null);
        $existentes = $datos['idPromocion'] ? ModeloPromociones::totalImagenes($datos['idPromocion']) : 0;
        if (!$datos['idPromocion'] && !$nuevas) $errores['galeria'] = 'Carga al menos una imagen para la promoción.';
        if ($existentes + count($nuevas) > 5) $errores['galeria'] = 'Una promoción admite máximo cinco imágenes.';
        if ($errores) $this->json(['status' => 'error', 'message' => 'Revisa los campos marcados.', 'errors' => $errores], 422);

        $datos['idUsuario'] = obtenerUsuarioSesion()['id'];
        $db = Conexion::conectar();
        $rutas = [];
        try {
            $db->beginTransaction();
            $id = ModeloPromociones::guardar($db, $datos);
            $orden = $existentes + 1;
            foreach ($nuevas as $archivo) {
                $subida = $this->subir($archivo);
                $rutas[] = $subida['ruta'];
                ModeloPromociones::agregarArchivo($db, $id, $subida, $orden++);
            }
            $db->commit();
            $this->json(['status' => 'success', 'message' => $datos['idPromocion'] ? 'Promoción actualizada correctamente.' : 'Promoción registrada correctamente.', 'data' => ['idPromocion' => $id]], $datos['idPromocion'] ? 200 : 201);
        } catch (PDOException $error) {
            if ($db->inTransaction()) $db->rollBack();
            $this->limpiar($rutas);
            registrarLog('Error al guardar promoción: '.$error->getMessage(), 'ERROR');
            $this->json(['status' => 'error', 'message' => 'No fue posible guardar la promoción.'], 500);
        } catch (RuntimeException $error) {
            if ($db->inTransaction()) $db->rollBack();
            $this->limpiar($rutas);
            $this->json(['status' => 'error', 'message' => $error->getMessage()], 422);
        }
    }

    public function cambiarEstado(): void
    {
        $this->metodo('POST');
        $entrada = $this->entrada();
        $this->csrf($entrada);
        $id = filter_var($entrada['idPromocion'] ?? null, FILTER_VALIDATE_INT, ['options' => ['min_range' => 1]]);
        $activo = filter_var($entrada['activo'] ?? null, FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE);
        if (!$id || $activo === null) $this->json(['status' => 'error', 'message' => 'Datos no válidos.'], 422);
        $promocion = ModeloPromociones::obtener((int) $id);
        if (!$promocion) $this->json(['status' => 'error', 'message' => 'La promoción no existe.'], 404);
        if (!puedeGestionarPromocionDeAfiliado((int) $promocion['idAfiliado'], 'promociones.activar')) $this->prohibido();
        if (!ModeloPromociones::cambiarEstado((int) $id, $activo, obtenerUsuarioSesion()['id'])) $this->json(['status' => 'error', 'message' => 'La promoción no existe o ya tiene ese estado.'], 404);
        $this->json(['status' => 'success', 'message' => $activo ? 'Promoción activada.' : 'Promoción desactivada.']);
    }

    private function alcanceAfiliados(): ?array
    {
        $usuario = obtenerUsuarioSesion();
        if ($usuario['rol'] === 'ADMIN_GENERAL') return null;
        if ($usuario['rol'] === 'ADMIN_CAMARA') {
            return $usuario['idCamara'] === null ? [] : ModeloPromociones::afiliadosPorCamara($usuario['idCamara']);
        }
        return $usuario['afiliados'];
    }

    private function normalizar(array $entrada): array
    {
        $texto = fn(string $clave, int $maximo): string => mb_substr(trim((string) ($entrada[$clave] ?? '')), 0, $maximo);
        $id = filter_var($entrada['idPromocion'] ?? null, FILTER_VALIDATE_INT, ['options' => ['min_range' => 1]]);
        return ['idPromocion' => $id ?: null, 'idAfiliado' => (int) ($entrada['idAfiliado'] ?? 0), 'titulo' => $texto('titulo', 180), 'descripcion' => $texto('descripcion', 5000), 'restricciones' => $texto('restricciones', 5000), 'inicio' => str_replace('T', ' ', $texto('inicio_vigencia', 19)), 'fin' => str_replace('T', ' ', $texto('fin_vigencia', 19))];
    }

    private function validar(array $datos): array
    {
        $errores = [];
        if (!ModeloPromociones::afiliadoActivoExiste($datos['idAfiliado'])) $errores['idAfiliado'] = 'Selecciona un afiliado activo.';
        if ($datos['titulo'] === '') $errores['titulo'] = 'El título es obligatorio.';
        if ($datos['descripcion'] === '') $errores['descripcion'] = 'La descripción es obligatoria.';
        $inicio = strtotime($datos['inicio']);
        $fin = strtotime($datos['fin']);
        if (!$inicio) $errores['inicio_vigencia'] = 'Captura una fecha de inicio válida.';
        if (!$fin) $errores['fin_vigencia'] = 'Captura una fecha de fin válida.';
        if ($inicio && $fin && $fin < $inicio) $errores['fin_vigencia'] = 'La fecha final no puede ser menor que la inicial.';
        return $errores;
    }

    private function archivosEntrada(?array $galeria): array
    {
        if (!$galeria || !is_array($galeria['name'])) return [];
        $archivos = [];
        foreach ($galeria['name'] as $indice => $nombre) {
            if ($nombre === '') continue;
            $archivo = [];
            foreach (['name', 'tmp_name', 'error', 'size'] as $campo) $archivo[$campo] = $galeria[$campo][$indice];
            $archivos[] = $archivo;
        }
        return $archivos;
    }

    private function subir(array $archivo): array
    {
        if (($archivo['error'] ?? 0) !== UPLOAD_ERR_OK) throw new RuntimeException('No fue posible cargar una imagen.');
        if (($archivo['size'] ?? 0) > 2 * 1024 * 1024) throw new RuntimeException('Cada imagen puede pesar máximo 2 MB.');
        $mime = (new finfo(FILEINFO_MIME_TYPE))->file($archivo['tmp_name']);
        $extension = ['image/jpeg' => 'jpg', 'image/png' => 'png', 'image/webp' => 'webp'][$mime] ?? null;
        if (!$extension || !($dimensiones = getimagesize($archivo['tmp_name']))) throw new RuntimeException('Solo se permiten imágenes JPG, PNG o WEBP válidas.');
        $relativa = 'promociones/' . gmdate('Y/m') . '/' . bin2hex(random_bytes(16)) . '.' . $extension;
        $ruta = UPLOADS_PATH . $relativa;
        $directorio = dirname($ruta);
        if (!is_dir($directorio) && !mkdir($directorio, 0755, true) && !is_dir($directorio)) throw new RuntimeException('No fue posible preparar el almacenamiento.');
        if (!move_uploaded_file($archivo['tmp_name'], $ruta)) throw new RuntimeException('No fue posible guardar la imagen.');
        return ['nombre' => mb_substr(basename($archivo['name']), 0, 255), 'key' => $relativa, 'url' => base_url('uploads/' . $relativa), 'mime' => $mime, 'peso' => (int) $archivo['size'], 'ancho' => (int) $dimensiones[0], 'alto' => (int) $dimensiones[1], 'hash' => hash_file('sha256', $ruta), 'alt' => 'Imagen de promoción', 'ruta' => $ruta];
    }

    private function idGet(string $nombre): int
    {
        $id = filter_input(INPUT_GET, $nombre, FILTER_VALIDATE_INT, ['options' => ['min_range' => 1]]);
        if (!$id) $this->json(['status' => 'error', 'message' => 'Identificador inválido.'], 422);
        return (int) $id;
    }

    private function entrada(): array
    {
        $datos = json_decode((string) file_get_contents('php://input'), true);
        if (!is_array($datos)) $this->json(['status' => 'error', 'message' => 'Solicitud inválida.'], 400);
        return $datos;
    }

    private function csrf(array $entrada): void
    {
        if (!validarTokenCSRF((string) ($_SERVER['HTTP_X_CSRF_TOKEN'] ?? ($entrada['csrf_token'] ?? '')))) $this->json(['status' => 'error', 'message' => 'La sesión del formulario expiró. Recarga la página.'], 419);
    }

    private function metodo(string $metodo): void
    {
        if (($_SERVER['REQUEST_METHOD'] ?? 'GET') !== $metodo) $this->json(['status' => 'error', 'message' => 'Método no permitido.'], 405);
    }

    private function limpiar(array $rutas): void
    {
        foreach ($rutas as $ruta) if (is_file($ruta)) @unlink($ruta);
    }

    private function prohibido(): never
    {
        $this->json(['status' => 'error', 'message' => 'No tienes permiso para acceder a la información solicitada.'], 403);
    }

    private function json(array $datos, int $estado = 200): never
    {
        http_response_code($estado);
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode($datos, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        exit;
    }
}
