<?php
declare(strict_types=1);

/** Controlador de la ficha pública y compartible de una promoción vigente. */
class ControladorFichaPromocion
{
    public function mostrar(): array
    {
        $id = filter_var($_GET['id'] ?? null, FILTER_VALIDATE_INT, [
            'options' => ['min_range' => 1],
        ]);

        if ($id === false) {
            return $this->noEncontrada();
        }

        try {
            $promocion = (new ModeloFichaPromocion())->obtenerVigentePorId((int) $id);
        } catch (\PDOException $e) {
            registrarLog('Error en ControladorFichaPromocion::mostrar — ' . $e->getMessage(), 'ERROR');
            $promocion = null;
        }

        if ($promocion === null) {
            return $this->noEncontrada();
        }

        $descripcion = trim((string) ($promocion['descripcion'] ?? ''));
        $metaDescripcion = $descripcion !== ''
            ? mb_substr($descripcion, 0, 155)
            : 'Consulta la promoción vigente de ' . $promocion['nombre_comercial'] . ' en CANACO Card.';

        return [
            'promocion' => $promocion,
            'meta_titulo' => $promocion['titulo'] . ' | ' . $promocion['nombre_comercial'],
            'meta_descripcion' => $metaDescripcion,
            'meta_imagen' => $promocion['imagenes'][0]['url_publica'] ?? $promocion['logo_url'] ?? null,
        ];
    }

    private function noEncontrada(): array
    {
        http_response_code(404);

        return [
            'promocion' => null,
            'meta_titulo' => 'Promoción no disponible',
            'meta_descripcion' => 'La promoción solicitada no existe, terminó o ya no está disponible.',
        ];
    }
}
