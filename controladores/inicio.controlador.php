<?php
declare(strict_types=1);

/**
 * CANACO Card — Controlador de Inicio (Dashboard)
 * 
 * Prepara los datos para el dashboard principal.
 * En esta primera fase retorna datos placeholder.
 */

class ControladorInicio
{
    /**
     * Dashboard principal.
     * Retorna datos de demostración para las tarjetas del dashboard.
     */
    public function index(): array
    {
        // Datos placeholder para el dashboard
        // Posteriormente se consultarán de la BD real
        return [
            'tarjetas' => [
                [
                    'titulo'      => 'Afiliados activos',
                    'valor'       => '0',
                    'icono'       => 'ki-filled ki-shop',
                    'color'       => 'primary',
                    'descripcion' => 'Empresas registradas',
                ],
                [
                    'titulo'      => 'Promociones vigentes',
                    'valor'       => '0',
                    'icono'       => 'ki-filled ki-discount',
                    'color'       => 'success',
                    'descripcion' => 'Activas actualmente',
                ],
                [
                    'titulo'      => 'Sucursales registradas',
                    'valor'       => '0',
                    'icono'       => 'ki-filled ki-geolocation',
                    'color'       => 'info',
                    'descripcion' => 'Ubicaciones físicas',
                ],
                [
                    'titulo'      => 'Búsquedas del mes',
                    'valor'       => '0',
                    'icono'       => 'ki-filled ki-magnifier',
                    'color'       => 'warning',
                    'descripcion' => 'En el portal público',
                ],
            ],
            'actividad' => [],
        ];
    }
}
