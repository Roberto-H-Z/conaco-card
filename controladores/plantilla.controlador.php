<?php
declare(strict_types=1);

/**
 * CANACO Card — Controlador de Plantilla
 * 
 * Controlador base que maneja vistas genéricas:
 * - Módulos en construcción
 * - Errores 404
 */

class ControladorPlantilla
{
    /**
     * Mostrar página de módulo en construcción.
     */
    public function enConstruccion(): array
    {
        return [
            'mensaje' => 'Este módulo está en desarrollo.',
        ];
    }

    /**
     * Mostrar página de error 404.
     */
    public function error404(): array
    {
        return [
            'mensaje' => 'La página que buscas no existe.',
        ];
    }
}
