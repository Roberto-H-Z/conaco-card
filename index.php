<?php
declare(strict_types=1);

/**
 * CANACO Card — Front Controller
 * 
 * Punto de entrada único de la aplicación.
 * 1. Carga configuración
 * 2. Inicializa sesión
 * 3. Registra autoloader
 * 4. Carga helpers
 * 5. Resuelve la ruta
 * 6. Ejecuta el controlador
 * 7. Renderiza la vista
 */

// ── 1. Configuración ────────────────────────────────────────
require_once __DIR__ . '/config/config.php';

// ── 2. Sesión ───────────────────────────────────────────────
if (session_status() === PHP_SESSION_NONE) {
    session_start([
        'cookie_httponly' => true,
        'cookie_samesite' => 'Strict',
        'use_strict_mode' => true,
    ]);
}

// ── 3. Autoloader ───────────────────────────────────────────
require_once CONFIG_PATH . 'autoload.php';

// ── 4. Helpers ──────────────────────────────────────────────
require_once HELPERS_PATH . 'funciones.php';
require_once HELPERS_PATH . 'auth.helper.php';
require_once HELPERS_PATH . 'validation.helper.php';

// ── 5. Resolver ruta ────────────────────────────────────────
$rutas = require CONFIG_PATH . 'routes.php';

// Obtener la ruta solicitada
$rutaSolicitada = isset($_GET['ruta']) ? trim($_GET['ruta'], '/') : 'inicio';

// Separar segmentos (para rutas como /afiliados/editar/15)
$segmentos = explode('/', $rutaSolicitada);
$rutaBase = $segmentos[0] ?: 'inicio';

// Redirigir raíz a inicio
if ($rutaBase === '' || $rutaSolicitada === '') {
    $rutaBase = 'inicio';
}

// ── 6. Verificar existencia de la ruta ──────────────────────
if (!isset($rutas[$rutaBase])) {
    // Ruta no encontrada: 404
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
    $rutaConfig = $rutas[$rutaBase];
}

// ── 7. Verificar autenticación (preparado para el futuro) ───
if ($rutaConfig['auth'] && !estaAutenticado()) {
    header('Location: ' . base_url('login'));
    exit;
}

// ── 8. Verificar roles (preparado para el futuro) ───────────
if ($rutaConfig['auth'] && !empty($rutaConfig['roles'])) {
    $usuarioSesion = obtenerUsuarioSesion();
    if ($usuarioSesion && !in_array($usuarioSesion['rol'] ?? '', $rutaConfig['roles'], true)) {
        http_response_code(403);
        $rutaConfig['vista'] = '404';
        $rutaConfig['titulo'] = 'Acceso denegado';
    }
}

// ── 9. Ejecutar controlador ─────────────────────────────────
$nombreControlador = $rutaConfig['controlador'];
$metodo = $rutaConfig['metodo'];

// Parámetros adicionales de la URL
$parametros = array_slice($segmentos, 1);

$datosVista = [];
if (class_exists($nombreControlador)) {
    $controlador = new $nombreControlador();
    if (method_exists($controlador, $metodo)) {
        $datosVista = $controlador->$metodo(...$parametros) ?? [];
    }
}

// ── 10. Renderizar ──────────────────────────────────────────
// Variables disponibles en las vistas
$vista = $rutaConfig['vista'];
$tituloModulo = $rutaConfig['titulo'];
$breadcrumbs = $rutaConfig['breadcrumbs'];
$jsModulo = $rutaConfig['js'];
$layoutTipo = $rutaConfig['layout'];
$rutaActual = $rutaBase;

if ($layoutTipo === 'auth') {
    // Layout sin sidebar (login, registro, etc.)
    require VIEWS_PATH . 'modulos/' . $vista . '.php';
} else {
    // Layout administrativo completo
    require VIEWS_PATH . 'plantilla.php';
}
