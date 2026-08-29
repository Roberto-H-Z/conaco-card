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
    $_SESSION['login_timestamp']   = time();
    generarTokenCSRF();
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
    if (in_array($usuario['rol'], ['ADMIN_GENERAL', 'ADMIN_CAMARA'], true)) return true;
    return in_array($idAfiliado, $usuario['afiliados'], true);
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
