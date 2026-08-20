<?php
declare(strict_types=1);

/**
 * CANACO Card — Controlador de Login
 * 
 * Estructura base para la autenticación.
 * La lógica real de autenticación se implementará posteriormente.
 */

class ControladorLogin
{
    /**
     * Mostrar formulario de login.
     */
    public function index(): array
    {
        // Si ya está autenticado, redirigir al dashboard
        if (estaAutenticado()) {
            header('Location: ' . base_url('inicio'));
            exit;
        }

        return [];
    }

    /**
     * Procesar intento de login (POST).
     * Preparado para implementación futura con password_verify().
     */
    public function autenticar(): array
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            header('Location: ' . base_url('login'));
            exit;
        }

        // Validar CSRF
        $tokenCSRF = $_POST['csrf_token'] ?? '';
        if (!validarTokenCSRF($tokenCSRF)) {
            return ['error' => 'Token de seguridad inválido. Recargue la página.'];
        }

        $correo = sanitizar($_POST['correo'] ?? '');
        $password = $_POST['password'] ?? '';

        // Validaciones básicas
        if (!validarRequerido($correo) || !validarRequerido($password)) {
            return ['error' => 'Complete todos los campos.'];
        }

        if (!validarCorreo($correo)) {
            return ['error' => 'Formato de correo electrónico inválido.'];
        }

        // TODO: Implementar autenticación real
        // 1. Buscar usuario por correo (prepared statement)
        // 2. Verificar password_verify($password, $hash)
        // 3. Verificar que el usuario esté activo
        // 4. Verificar bloqueo por intentos fallidos
        // 5. Registrar ultimo_acceso_at
        // 6. iniciarSesionUsuario()
        // 7. Redirigir a /inicio

        return ['error' => 'Funcionalidad de login en desarrollo.'];
    }

    /**
     * Cerrar sesión.
     */
    public function cerrar(): void
    {
        cerrarSesion();
        header('Location: ' . base_url('portada'));
        exit;
    }
}
