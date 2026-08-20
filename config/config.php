<?php
declare(strict_types=1);

/**
 * CANACO Card — Configuración general de la aplicación
 * 
 * Este archivo centraliza las constantes principales del sistema.
 * Modificar BASE_URL cuando se despliegue en producción.
 */

// ── Entorno ──────────────────────────────────────────────────
define('APP_NAME', 'CANACO Card');
define('APP_ENV', 'development'); // development | production
define('APP_VERSION', '1.0.0');

// ── URL base ─────────────────────────────────────────────────
// Ajustar al dominio real en producción
define('BASE_URL', '/canaco-card/');

// ── Rutas del filesystem ─────────────────────────────────────
define('APP_ROOT', dirname(__DIR__) . DIRECTORY_SEPARATOR);
define('CONFIG_PATH', APP_ROOT . 'config' . DIRECTORY_SEPARATOR);
define('CONTROLLERS_PATH', APP_ROOT . 'controladores' . DIRECTORY_SEPARATOR);
define('MODELS_PATH', APP_ROOT . 'modelos' . DIRECTORY_SEPARATOR);
define('VIEWS_PATH', APP_ROOT . 'vistas' . DIRECTORY_SEPARATOR);
define('HELPERS_PATH', APP_ROOT . 'helpers' . DIRECTORY_SEPARATOR);
define('AJAX_PATH', APP_ROOT . 'ajax' . DIRECTORY_SEPARATOR);
define('STORAGE_PATH', APP_ROOT . 'storage' . DIRECTORY_SEPARATOR);
define('UPLOADS_PATH', APP_ROOT . 'uploads' . DIRECTORY_SEPARATOR);

// ── Zona horaria interna ─────────────────────────────────────
date_default_timezone_set('UTC');

// ── Manejo de errores según entorno ──────────────────────────
if (APP_ENV === 'development') {
    error_reporting(E_ALL);
    ini_set('display_errors', '1');
} else {
    error_reporting(0);
    ini_set('display_errors', '0');
    ini_set('log_errors', '1');
    ini_set('error_log', STORAGE_PATH . 'logs' . DIRECTORY_SEPARATOR . 'php-errors.log');
}
