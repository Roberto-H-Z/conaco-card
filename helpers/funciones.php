<?php
declare(strict_types=1);

/**
 * CANACO Card — Funciones auxiliares globales
 * 
 * Helpers para URL, assets, escape y utilidades generales.
 */

/**
 * Genera la URL completa a partir de una ruta relativa.
 * Ejemplo: base_url('afiliados/editar/5') => /canaco-card/afiliados/editar/5
 */
function base_url(string $ruta = ''): string
{
    return rtrim(BASE_URL, '/') . '/' . ltrim($ruta, '/');
}

/**
 * Genera la URL completa para un asset estático.
 * Ejemplo: asset('css/styles.css') => /canaco-card/vistas/assets/css/styles.css
 */
function asset(string $ruta): string
{
    return rtrim(BASE_URL, '/') . '/vistas/assets/' . ltrim($ruta, '/');
}

/**
 * Genera la URL para un asset CSS personalizado de CANACO.
 * Ejemplo: canaco_css('canaco.css') => /canaco-card/vistas/css/canaco.css
 */
function canaco_css(string $archivo): string
{
    return rtrim(BASE_URL, '/') . '/vistas/css/' . ltrim($archivo, '/');
}

/**
 * Genera la URL para un archivo JS personalizado de CANACO.
 * Ejemplo: canaco_js('app.js') => /canaco-card/vistas/js/app.js
 */
function canaco_js(string $archivo): string
{
    return rtrim(BASE_URL, '/') . '/vistas/js/' . ltrim($archivo, '/');
}

/**
 * Escape de HTML para prevenir XSS.
 * Wrapper de htmlspecialchars con configuración segura.
 */
function e(?string $valor): string
{
    return htmlspecialchars($valor ?? '', ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

/**
 * Registrar un mensaje en el log del sistema.
 */
function registrarLog(string $mensaje, string $nivel = 'INFO'): void
{
    $archivo = STORAGE_PATH . 'logs' . DIRECTORY_SEPARATOR . 'app-' . date('Y-m-d') . '.log';
    $linea = sprintf(
        "[%s] [%s] %s\n",
        date('Y-m-d H:i:s'),
        strtoupper($nivel),
        $mensaje
    );
    @file_put_contents($archivo, $linea, FILE_APPEND | LOCK_EX);
}

/**
 * Verificar si la ruta actual coincide con un patrón dado.
 * Útil para marcar elementos activos en el sidebar.
 */
function rutaActiva(string $ruta, string $rutaActual): bool
{
    return $ruta === $rutaActual;
}

/**
 * Generar clase CSS 'active' si la ruta coincide.
 */
function claseActiva(string $ruta, string $rutaActual, string $clase = 'active'): string
{
    return rutaActiva($ruta, $rutaActual) ? $clase : '';
}
