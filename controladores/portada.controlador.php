<?php
declare(strict_types=1);

/**
 * CANACO Card — Controlador de la Portada Pública
 *
 * Prepara todos los datos que necesita la vista portada.php:
 *   - configuración de secciones
 *   - promociones destacadas
 *   - afiliados destacados
 *   - contadores del hero
 */
class ControladorPortada
{
    /**
     * Página principal del sitio público.
     */
    public function index(): array
    {
        $modelo = new ModeloPortada();

        try {
            $secciones  = $modelo->obtenerConfigSecciones();
            $contadores = $modelo->obtenerContadores();
            $promociones = $modelo->obtenerPromocionesDestacadas(6);
            $afiliados   = $modelo->obtenerAfiliadosDestacados(8);
        } catch (\PDOException $e) {
            // Si la BD no está disponible, devolver datos vacíos
            registrarLog('Error en ControladorPortada::index — ' . $e->getMessage(), 'ERROR');
            $secciones   = [];
            $contadores  = ['total_afiliados' => 0, 'total_promociones' => 0, 'total_categorias' => 0];
            $promociones = [];
            $afiliados   = [];
        }

        // Proveer títulos de fallback si aún no hay datos en secciones_portada
        $seccionPromos = $secciones['PROMOCIONES_DESTACADAS'] ?? [
            'titulo'    => 'Últimas Promociones',
            'subtitulo' => 'Descubre las mejores ofertas de nuestros afiliados',
        ];
        $seccionEmpresas = $secciones['EMPRESAS_DESTACADAS'] ?? [
            'titulo'    => 'Empresas Afiliadas',
            'subtitulo' => 'Conoce el directorio de empresas de la Cámara',
        ];

        return [
            'secciones'         => $secciones,
            'seccion_promos'    => $seccionPromos,
            'seccion_empresas'  => $seccionEmpresas,
            'promociones'       => $promociones,
            'afiliados'         => $afiliados,
            'total_afiliados'   => (int) ($contadores['total_afiliados']   ?? 0),
            'total_promociones' => (int) ($contadores['total_promociones'] ?? 0),
            'total_categorias'  => (int) ($contadores['total_categorias']  ?? 0),
        ];
    }
}
