<?php
declare(strict_types=1);

/**
 * CANACO Card — Helper de validación
 * 
 * Funciones para CSRF tokens y validaciones server-side.
 */

/**
 * Generar un token CSRF y almacenarlo en la sesión.
 * Retorna el token generado.
 */
function generarTokenCSRF(): string
{
    $token = bin2hex(random_bytes(32));
    $_SESSION['csrf_token'] = $token;
    $_SESSION['csrf_token_time'] = time();
    return $token;
}

/**
 * Obtener el token CSRF actual de la sesión.
 * Si no existe, genera uno nuevo.
 */
function obtenerTokenCSRF(): string
{
    if (empty($_SESSION['csrf_token'])) {
        return generarTokenCSRF();
    }
    return $_SESSION['csrf_token'];
}

/**
 * Validar un token CSRF enviado por formulario.
 * Verifica que coincida con el token en sesión y que no haya expirado.
 * 
 * @param string $token Token recibido del formulario
 * @param int $maxEdadSegundos Tiempo máximo de validez (default: 1 hora)
 */
function validarTokenCSRF(string $token, int $maxEdadSegundos = 3600): bool
{
    if (empty($_SESSION['csrf_token'])) {
        return false;
    }

    if (!hash_equals($_SESSION['csrf_token'], $token)) {
        return false;
    }

    // Verificar expiración
    $tiempoCreacion = $_SESSION['csrf_token_time'] ?? 0;
    if ((time() - $tiempoCreacion) > $maxEdadSegundos) {
        unset($_SESSION['csrf_token'], $_SESSION['csrf_token_time']);
        return false;
    }

    return true;
}

/**
 * Generar el campo HTML hidden para CSRF.
 */
function campoCSRF(): string
{
    $token = obtenerTokenCSRF();
    return '<input type="hidden" name="csrf_token" value="' . e($token) . '">';
}

/**
 * Validar que un valor no esté vacío.
 */
function validarRequerido(mixed $valor): bool
{
    if (is_string($valor)) {
        return trim($valor) !== '';
    }
    return $valor !== null && $valor !== '';
}

/**
 * Validar formato de correo electrónico.
 */
function validarCorreo(string $correo): bool
{
    return filter_var(trim($correo), FILTER_VALIDATE_EMAIL) !== false;
}

/**
 * Validar longitud mínima de una cadena.
 */
function validarLongitudMinima(string $valor, int $minimo): bool
{
    return mb_strlen(trim($valor), 'UTF-8') >= $minimo;
}

/**
 * Validar longitud máxima de una cadena.
 */
function validarLongitudMaxima(string $valor, int $maximo): bool
{
    return mb_strlen(trim($valor), 'UTF-8') <= $maximo;
}

/**
 * Sanitizar una cadena para uso seguro.
 */
function sanitizar(string $valor): string
{
    return trim(strip_tags($valor));
}
