<?php
declare(strict_types=1);

/** Autenticación del panel administrativo. */
final class ControladorLogin
{
    public function index(): array
    {
        if (estaAutenticado()) {
            header('Location: ' . base_url('afiliados'));
            exit;
        }
        return [];
    }

    public function autenticar(): void
    {
        if (($_SERVER['REQUEST_METHOD'] ?? 'GET') !== 'POST') {
            http_response_code(405);
            header('Allow: POST');
            exit('Método no permitido.');
        }

        if (!validarTokenCSRF((string) ($_POST['csrf_token'] ?? ''))) {
            $this->fallo('La sesión del formulario expiró. Recarga la página e inténtalo nuevamente.');
        }

        $correo = mb_strtolower(trim((string) ($_POST['correo'] ?? '')), 'UTF-8');
        $password = (string) ($_POST['password'] ?? '');
        if (!validarCorreo($correo) || mb_strlen($correo, 'UTF-8') > 254 || $password === '') {
            $this->fallo();
        }

        $usuario = ModeloUsuarios::buscarParaAutenticacion($correo);
        $ahora = new DateTimeImmutable('now', new DateTimeZone('UTC'));
        $bloqueado = $usuario !== null
            && !empty($usuario['bloqueado_hasta'])
            && new DateTimeImmutable((string) $usuario['bloqueado_hasta'], new DateTimeZone('UTC')) > $ahora;
        $asignacionValida = $usuario !== null && (
            $usuario['rol_clave'] === 'ADMIN_GENERAL'
            || ($usuario['rol_clave'] === 'ADMIN_CAMARA' && $usuario['idCamara'] !== null)
            || ($usuario['rol_clave'] === 'AFILIADO' && $usuario['afiliados'] !== [])
        );
        $credencialValida = $usuario !== null && password_verify($password, (string) $usuario['password_hash']);

        if ($usuario === null || !(bool) $usuario['activo'] || !(bool) $usuario['rol_activo'] || $bloqueado || !$asignacionValida || !$credencialValida) {
            if ($usuario !== null && !$bloqueado) {
                ModeloUsuarios::registrarFallo((int) $usuario['idUsuario']);
            }
            $this->fallo();
        }

        $nuevoHash = password_needs_rehash((string) $usuario['password_hash'], PASSWORD_DEFAULT)
            ? password_hash($password, PASSWORD_DEFAULT)
            : null;
        ModeloUsuarios::registrarIngreso((int) $usuario['idUsuario'], $nuevoHash);
        iniciarSesionUsuario($usuario);
        header('Location: ' . base_url('afiliados'));
        exit;
    }

    public function cerrar(): void
    {
        if (($_SERVER['REQUEST_METHOD'] ?? 'GET') !== 'POST' || !validarTokenCSRF((string) ($_POST['csrf_token'] ?? ''))) {
            http_response_code(419);
            exit('La solicitud para cerrar sesión no es válida.');
        }
        cerrarSesion();
        header('Location: ' . base_url('portada'));
        exit;
    }

    private function fallo(string $mensaje = 'No fue posible iniciar sesión con esas credenciales.'): never
    {
        $_SESSION['login_error'] = $mensaje;
        header('Location: ' . base_url('login'));
        exit;
    }
}
