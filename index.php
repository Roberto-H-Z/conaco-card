<?php
declare(strict_types=1);

require_once __DIR__ . '/config/config.php';

if (session_status() === PHP_SESSION_NONE) {
    session_start([
        'cookie_httponly' => true,
        'cookie_samesite' => 'Strict',
        'use_strict_mode' => true,
    ]);
}

require_once CONFIG_PATH . 'autoload.php';
require_once HELPERS_PATH . 'funciones.php';
require_once HELPERS_PATH . 'auth.helper.php';
require_once HELPERS_PATH . 'validation.helper.php';

$rutas = require CONFIG_PATH . 'routes.php';

// Obtener ruta solicitada; la raíz ('') cargará la portada pública
$rutaSolicitada = trim((string) ($_GET['ruta'] ?? ''), '/');

// Buscar configuración de ruta (incluye la clave vacía '' para la raíz)
if (!isset($rutas[$rutaSolicitada])) {
    http_response_code(404);
    $rutaConfig = [
        'controlador' => 'ControladorPlantilla',
        'metodo'      => 'error404',
        'vista'       => '404',
        'auth'        => false,
        'roles'       => [],
        'titulo'      => 'Página no encontrada',
        'breadcrumbs' => [],
        'js'          => [],
        'layout'      => 'admin',
    ];
} else {
    $rutaConfig = $rutas[$rutaSolicitada];
}

if (($rutaConfig['auth'] ?? false) && !estaAutenticado()) {
    http_response_code(401);
    exit('Autenticación requerida.');
}

$nombreControlador = $rutaConfig['controlador'];
$metodo            = $rutaConfig['metodo'];
$datosVista        = [];

if (!class_exists($nombreControlador) || !method_exists($nombreControlador, $metodo)) {
    http_response_code(500);
    exit('No fue posible resolver la solicitud.');
}

$controlador = new $nombreControlador();
$datosVista  = $controlador->$metodo() ?? [];

if (!empty($rutaConfig['api'])) {
    exit;
}

// Variables para la plantilla
$vista        = $rutaConfig['vista']        ?? '404';
$tituloModulo = $rutaConfig['titulo']       ?? 'Página';
$breadcrumbs  = $rutaConfig['breadcrumbs']  ?? [];
$jsModulo     = $rutaConfig['js']           ?? [];
$jsPublico    = $rutaConfig['js_publico']   ?? [];
$rutaActual   = explode('/', $rutaSolicitada)[0];
$layout       = $rutaConfig['layout']       ?? 'admin';

// Elegir la plantilla según el layout
if ($layout === 'publico') {
    require VIEWS_PATH . 'plantilla_publica.php';
} else {
    require VIEWS_PATH . 'plantilla.php';
}

