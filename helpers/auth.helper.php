<?php
declare(strict_types=1);

/** Funciones de sesión, RBAC y alcance de datos del usuario autenticado. */
function estaAutenticado(): bool
{
    return isset($_SESSION['usuario_id']) && (int) $_SESSION['usuario_id'] > 0;
}

/**
 * @return array{id: int, nombre: string, correo: string, rol: string, idRol: int, idCamara: int|null, afiliados: array<int>, permisos: array<string>}|null
 */
function obtenerUsuarioSesion(): ?array
{
    if (!estaAutenticado()) return null;

    return [
        'id'        => (int) $_SESSION['usuario_id'],
        'nombre'    => (string) ($_SESSION['usuario_nombre'] ?? ''),
        'correo'    => (string) ($_SESSION['usuario_correo'] ?? ''),
        'rol'       => (string) ($_SESSION['usuario_rol'] ?? ''),
        'idRol'     => (int) ($_SESSION['usuario_idRol'] ?? 0),
        'idCamara'  => isset($_SESSION['usuario_idCamara']) ? (int) $_SESSION['usuario_idCamara'] : null,
        'afiliados' => array_values(array_map('intval', (array) ($_SESSION['usuario_afiliados'] ?? []))),
        'permisos'  => array_values(array_map('strval', (array) ($_SESSION['usuario_permisos'] ?? []))),
    ];
}

/** Regenera la sesión y conserva solo los datos de autorización necesarios. */
function iniciarSesionUsuario(array $usuario): void
{
    session_regenerate_id(true);
    $_SESSION['usuario_id']        = (int) $usuario['idUsuario'];
    $_SESSION['usuario_nombre']    = (string) $usuario['nombre'];
    $_SESSION['usuario_correo']    = (string) $usuario['correo'];
    $_SESSION['usuario_rol']       = (string) ($usuario['rol_clave'] ?? '');
    $_SESSION['usuario_idRol']     = (int) $usuario['idRol'];
    $_SESSION['usuario_idCamara']  = $usuario['idCamara'] ?? null;
    $_SESSION['usuario_afiliados'] = array_values(array_map('intval', (array) ($usuario['afiliados'] ?? [])));
    $_SESSION['usuario_permisos']  = array_values(array_map('strval', (array) ($usuario['permisos'] ?? [])));
    $_SESSION['usuario_firma']     = firmaAutorizacion($usuario);
    $_SESSION['login_timestamp']   = time();
    $_SESSION['ultima_actividad_at'] = $_SESSION['login_timestamp'];
    generarTokenCSRF();
}

/** El vencimiento se calcula en el servidor, sin depender de la cookie ni del navegador. */
function sesionDentroDeLimites(array $sesion, int $ahora): bool
{
    $inicio = $sesion['login_timestamp'] ?? null;
    $ultimaActividad = $sesion['ultima_actividad_at'] ?? null;
    return is_int($inicio) && is_int($ultimaActividad)
        && $inicio > 0 && $inicio <= $ultimaActividad && $ultimaActividad <= $ahora
        && ($ahora - $ultimaActividad) < SESSION_IDLE_TIMEOUT
        && ($ahora - $inicio) < SESSION_ABSOLUTE_TIMEOUT;
}

/** Solo las interacciones del usuario renuevan el plazo de inactividad. */
function registrarActividadSesion(): void
{
    if (!estaAutenticado()) return;
    $_SESSION['ultima_actividad_at'] = time();
    // El CSRF del formulario también debe mantenerse vigente mientras hay actividad.
    if (!empty($_SESSION['csrf_token'])) $_SESSION['csrf_token_time'] = $_SESSION['ultima_actividad_at'];
}

/** Los datos de acceso guardados al iniciar sesión deben seguir iguales en la BD. */
function firmaAutorizacion(array $usuario): string
{
    $permisos = array_values(array_map('strval', (array) ($usuario['permisos'] ?? [])));
    $afiliados = array_values(array_map('intval', (array) ($usuario['afiliados'] ?? [])));
    sort($permisos, SORT_STRING);
    sort($afiliados, SORT_NUMERIC);
    return hash('sha256', json_encode([
        (int) $usuario['idUsuario'],
        (string) $usuario['password_hash'],
        (int) $usuario['activo'],
        (int) $usuario['rol_activo'],
        (int) $usuario['idRol'],
        (string) $usuario['rol_clave'],
        $usuario['idCamara'] === null ? null : (int) $usuario['idCamara'],
        $afiliados,
        $permisos,
    ], JSON_THROW_ON_ERROR));
}

/** Revoca la sesión si la cuenta, sus credenciales o sus permisos cambiaron. */
function validarSesionActual(): bool
{
    if (!estaAutenticado()) return false;
    if (!sesionDentroDeLimites($_SESSION, time())) {
        cerrarSesion();
        return false;
    }
    $usuario = ModeloUsuarios::buscarParaSesion((int) $_SESSION['usuario_id']);
    $firma = $_SESSION['usuario_firma'] ?? null;
    $valida = $usuario !== null
        && (int) $usuario['activo'] === 1
        && (int) $usuario['rol_activo'] === 1
        && is_string($firma)
        && hash_equals($firma, firmaAutorizacion($usuario));
    if (!$valida) cerrarSesion();
    return $valida;
}

function cerrarSesion(): void
{
    $_SESSION = [];
    if (ini_get('session.use_cookies')) {
        $params = session_get_cookie_params();
        setcookie(session_name(), '', time() - 42000, $params['path'], $params['domain'], $params['secure'], $params['httponly']);
    }
    session_destroy();
}

function tienePermiso(string $permiso): bool
{
    $usuario = obtenerUsuarioSesion();
    return $usuario !== null && in_array($permiso, $usuario['permisos'], true);
}

function tieneRol(string ...$roles): bool
{
    $usuario = obtenerUsuarioSesion();
    return $usuario !== null && in_array($usuario['rol'], $roles, true);
}

function puedeCrearAfiliado(): bool
{
    return tienePermiso('afiliados.crear') && !tieneRol('AFILIADO');
}

function puedeVerAfiliado(int $idAfiliado): bool
{
    $usuario = obtenerUsuarioSesion();
    if ($usuario === null || !tienePermiso('afiliados.ver')) return false;
    if ($usuario['rol'] === 'ADMIN_GENERAL') return true;
    if ($usuario['rol'] === 'ADMIN_CAMARA') {
        return $usuario['idCamara'] !== null
            && ModeloUsuarios::afiliadoPerteneceACamara($idAfiliado, $usuario['idCamara']);
    }
    return in_array($idAfiliado, $usuario['afiliados'], true);
}

function puedeEnviarAccesoAfiliado(int $idAfiliado): bool
{
    return tieneRol('ADMIN_GENERAL', 'ADMIN_CAMARA') && puedeVerAfiliado($idAfiliado);
}

function puedeModificarAfiliado(int $idAfiliado): bool
{
    $usuario = obtenerUsuarioSesion();
    if ($usuario === null || !tienePermiso('afiliados.editar')) return false;
    if ($usuario['rol'] === 'ADMIN_GENERAL') return true;
    if ($usuario['rol'] === 'ADMIN_CAMARA') {
        return $usuario['idCamara'] !== null
            && ModeloUsuarios::afiliadoPerteneceACamara($idAfiliado, $usuario['idCamara']);
    }
    return $usuario['rol'] === 'AFILIADO' && in_array($idAfiliado, $usuario['afiliados'], true);
}

function puedeCambiarEstadoAfiliado(int $idAfiliado): bool
{
    return tienePermiso('afiliados.activar') && puedeModificarAfiliado($idAfiliado);
}

function puedeGestionarPromocionDeAfiliado(int $idAfiliado, string $permiso): bool
{
    return tienePermiso($permiso) && puedeModificarAfiliado($idAfiliado);
}
