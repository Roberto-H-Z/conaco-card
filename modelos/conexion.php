<?php
declare(strict_types=1);

/**
 * CANACO Card — Clase de Conexión a Base de Datos
 * 
 * Singleton ligero basado en PDO.
 * Usa las credenciales definidas en config/database.php.
 * 
 * Características:
 * - utf8mb4
 * - Excepciones habilitadas
 * - Prepared statements reales (no emulados)
 * - Modo fetch asociativo por defecto
 */

class Conexion
{
    /** @var PDO|null Instancia única de la conexión */
    private static ?PDO $conexion = null;

    /**
     * Obtener la conexión PDO (Singleton).
     * Si la BD no está disponible, lanza PDOException.
     */
    public static function conectar(): PDO
    {
        if (self::$conexion === null) {
            $config = require CONFIG_PATH . 'database.php';

            $dsn = sprintf(
                'mysql:host=%s;port=%d;dbname=%s;charset=%s',
                $config['host'],
                $config['port'],
                $config['database'],
                $config['charset']
            );

            self::$conexion = new PDO($dsn, $config['username'], $config['password'], $config['options']);

            // Forzar zona horaria UTC en la conexión
            self::$conexion->exec("SET time_zone = '+00:00'");
        }

        return self::$conexion;
    }

    /**
     * Cerrar la conexión (útil para tests o limpieza).
     */
    public static function desconectar(): void
    {
        self::$conexion = null;
    }

    /**
     * Prevenir instanciación directa.
     */
    private function __construct() {}
    private function __clone() {}
}
