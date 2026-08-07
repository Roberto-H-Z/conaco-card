<?php
declare(strict_types=1);

/**
 * CANACO Card — Configuración de base de datos
 * 
 * Credenciales centralizadas para la conexión PDO.
 * En producción, migrar a un archivo .env fuera del repositorio.
 */

return [
    'host'     => '127.0.0.1',
    'port'     => 3306,
    'database' => 'canaco_card',
    'username' => 'root',
    'password' => '',
    'charset'  => 'utf8mb4',
    'options'  => [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,
    ],
];
