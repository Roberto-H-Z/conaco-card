<?php
declare(strict_types=1);

require dirname(__DIR__) . '/config/config.php';
require CONFIG_PATH . 'autoload.php';
require HELPERS_PATH . 'funciones.php';
require HELPERS_PATH . 'auth.helper.php';
require HELPERS_PATH . 'validation.helper.php';

function verificar(bool $condicion, string $descripcion): void
{
    if (!$condicion) throw new RuntimeException($descripcion);
    echo "OK: $descripcion\n";
}

$filtros = ['busqueda' => '', 'estado' => '', 'camara' => 0, 'localidad' => 0, 'categoria' => 0];
$primera = ModeloAfiliados::listar($filtros, 1, 15);
$segunda = ModeloAfiliados::listar($filtros, 2, 15);
verificar($primera['porPagina'] === 15 && count($primera['registros']) <= 15, 'límite de 15 afiliados por página');
verificar($primera['total'] === $segunda['total'], 'el total se conserva entre páginas');
if ($primera['paginas'] > 1) {
    $idsPrimera = array_column($primera['registros'], 'idAfiliado');
    $idsSegunda = array_column($segunda['registros'], 'idAfiliado');
    verificar(!array_intersect($idsPrimera, $idsSegunda), 'las páginas no repiten afiliados');
}
$ultima = ModeloAfiliados::listar($filtros, 999999, 15);
verificar($ultima['pagina'] === $ultima['paginas'], 'una página fuera de rango se ajusta a la última');

$_SESSION = ['usuario_id' => 1, 'usuario_rol' => 'ADMIN_GENERAL', 'usuario_permisos' => []];
$_GET = ['pagina' => 1, 'estado' => '1'];
$datosVista = (new ControladorAfiliados())->index();
ob_start();
try {
    require VIEWS_PATH . 'modulos/afiliados.php';
    $html = ob_get_clean();
} catch (Throwable $error) {
    ob_end_clean();
    throw $error;
}
verificar(count($datosVista['listado']['registros']) <= 15, 'el controlador también entrega 15 registros');
if ($datosVista['listado']['paginas'] > 1) {
    verificar(str_contains($html, 'aria-label="Páginas de afiliados"'), 'la vista muestra controles de paginación');
    verificar(str_contains($html, 'estado=1&amp;pagina=2'), 'los enlaces de página conservan el filtro activo');
}
