<?php
declare(strict_types=1);

/**
 * CANACO Card — Helper de autenticación
 * 
 * Funciones para gestionar sesiones de usuario.
 * Preparado para integrar con la tabla `usuarios` y sistema RBAC.
 */

/**
 * Verificar si el usuario está autenticado.
 */
function estaAutenticado(): bool
{
    return isset($_SESSION['usuario_id']) && !empty($_SESSION['usuario_id']);
}

/**
 * Obtener los datos del usuario en sesión.
 * Retorna null si no hay sesión activa.
 * 
 * @return array{id: int, nombre: string, correo: string, rol: string, idRol: int, idCamara: int|null}|null
 */
function obtenerUsuarioSesion(): ?array
{
    if (!estaAutenticado()) {
        return null;
    }

    return [
        'id'       => (int) ($_SESSION['usuario_id'] ?? 0),
        'nombre'   => $_SESSION['usuario_nombre'] ?? '',
        'correo'   => $_SESSION['usuario_correo'] ?? '',
        'rol'      => $_SESSION['usuario_rol'] ?? '',
        'idRol'    => (int) ($_SESSION['usuario_idRol'] ?? 0),
        'idCamara' => isset($_SESSION['usuario_idCamara']) ? (int) $_SESSION['usuario_idCamara'] : null,
    ];
}

/**
 * Iniciar sesión para un usuario autenticado.
 * Regenera el Session ID para prevenir session fixation.
 */
function iniciarSesionUsuario(array $usuario): void
{
    session_regenerate_id(true);

    $_SESSION['usuario_id']       = $usuario['idUsuario'];
    $_SESSION['usuario_nombre']   = $usuario['nombre'];
    $_SESSION['usuario_correo']   = $usuario['correo'];
    $_SESSION['usuario_rol']      = $usuario['rol_clave'] ?? '';
    $_SESSION['usuario_idRol']    = $usuario['idRol'];
    $_SESSION['usuario_idCamara'] = $usuario['idCamara'] ?? null;
    $_SESSION['login_timestamp']  = time();
}

/**
 * Cerrar la sesión actual.
 */
function cerrarSesion(): void
{
    $_SESSION = [];

    if (ini_get('session.use_cookies')) {
        $params = session_get_cookie_params();
        setcookie(
            session_name(),
            '',
            time() - 42000,
            $params['path'],
            $params['domain'],
            $params['secure'],
            $params['httponly']
        );
    }

    session_destroy();
}

/**
 * Verificar si el usuario tiene un permiso específico.
 * Preparado para consultar la BD con roles_permisos.
 */
function tienePermiso(string $permiso): bool
{
    // TODO: Implementar consulta a roles_permisos cuando se active la autenticación
    $usuario = obtenerUsuarioSesion();
    
    if ($usuario === null) {
        return false;
    }

    // Administrador General tiene todos los permisos
    if ($usuario['rol'] === 'ADMIN_GENERAL') {
        return true;
    }

    // Por ahora, retornar false para los demás
    return false;
}

/**
 * Verificar si el usuario tiene uno de los roles indicados.
 */
function tieneRol(string ...$roles): bool
{
    $usuario = obtenerUsuarioSesion();
    
    if ($usuario === null) {
        return false;
    }

    return in_array($usuario['rol'], $roles, true);
}
