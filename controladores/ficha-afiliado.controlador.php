<?php
declare(strict_types=1);

/** Controlador de la ficha pública, compartible, de un afiliado activo. */
class ControladorFichaAfiliado
{
    public function mostrar(): array
    {
        $slug = strtolower(trim((string) ($_GET['slug'] ?? '')));
        if (!preg_match('/^[a-z0-9]+(?:-[a-z0-9]+)*$/', $slug)) {
            return $this->noEncontrada();
        }

        try {
            $afiliado = (new ModeloFichaAfiliado())->obtenerPorSlugActivo($slug);
        } catch (\PDOException $e) {
            registrarLog('Error en ControladorFichaAfiliado::mostrar — ' . $e->getMessage(), 'ERROR');
            $afiliado = null;
        }

        if ($afiliado === null) {
            return $this->noEncontrada();
        }

        ControladorBuscador::registrarFicha((int)$afiliado['idAfiliado']);
        $descripcion = trim((string) ($afiliado['descripcion'] ?? ''));
        $metaDescripcion = $descripcion !== ''
            ? mb_substr($descripcion, 0, 155)
            : 'Consulta la ficha pública de ' . $afiliado['nombre_comercial'] . ' en CANACO Card.';

        $retorno = base_url('portada#empresas');
        $token = $_GET['busqueda'] ?? '';
        if (is_string($token)) {
            foreach (($_SESSION['buscador_registros'] ?? []) as $registro) {
                if (hash_equals($registro['token'], $token) && isset($registro['filtros'])) {
                    $retorno = base_url('buscar').'?'.http_build_query($registro['filtros']);
                    break;
                }
            }
        }
        return [
            'afiliado' => $afiliado,
            'retorno_directorio' => $retorno,
            'meta_titulo' => $afiliado['nombre_comercial'],
            'meta_descripcion' => $metaDescripcion,
            'meta_imagen' => $afiliado['logo']['url_publica'] ?? null,
        ];
    }

    private function noEncontrada(): array
    {
        http_response_code(404);
        return [
            'afiliado' => null,
            'meta_titulo' => 'Afiliado no encontrado',
            'meta_descripcion' => 'La ficha solicitada no existe o ya no está disponible.',
        ];
    }
}
