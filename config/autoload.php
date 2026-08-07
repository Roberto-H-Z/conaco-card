<?php
declare(strict_types=1);

/**
 * CANACO Card — Autoloader
 * 
 * Registra un autoloader sencillo usando spl_autoload_register.
 * Busca clases en: controladores/, modelos/, helpers/
 */

spl_autoload_register(function (string $clase): void {
    // Mapeo de convención: el nombre de archivo se deriva del nombre de clase
    $directorios = [
        CONTROLLERS_PATH,
        MODELS_PATH,
        HELPERS_PATH,
    ];

    // Convenciones de nombre de archivo:
    // ControladorInicio  => inicio.controlador.php
    // ModeloAfiliados    => afiliados.modelo.php
    // Conexion           => conexion.php
    $archivoPosibles = [];

    // Patrón 1: Controlador* => *.controlador.php
    if (str_starts_with($clase, 'Controlador')) {
        $nombre = lcfirst(substr($clase, strlen('Controlador')));
        $nombre = strtolower(preg_replace('/[A-Z]/', '-$0', $nombre) ?? $nombre);
        $nombre = ltrim($nombre, '-');
        $archivoPosibles[] = $nombre . '.controlador.php';
    }

    // Patrón 2: Modelo* => *.modelo.php
    if (str_starts_with($clase, 'Modelo')) {
        $nombre = lcfirst(substr($clase, strlen('Modelo')));
        $nombre = strtolower(preg_replace('/[A-Z]/', '-$0', $nombre) ?? $nombre);
        $nombre = ltrim($nombre, '-');
        $archivoPosibles[] = $nombre . '.modelo.php';
    }

    // Patrón 3: nombre directo (ej: Conexion => conexion.php)
    $archivoPosibles[] = strtolower($clase) . '.php';

    // Patrón 4: con puntos como helper (ej: AuthHelper => auth.helper.php)
    if (str_ends_with($clase, 'Helper')) {
        $nombre = substr($clase, 0, -strlen('Helper'));
        $nombre = strtolower(preg_replace('/[A-Z]/', '-$0', $nombre) ?? $nombre);
        $nombre = ltrim($nombre, '-');
        $archivoPosibles[] = $nombre . '.helper.php';
    }

    foreach ($directorios as $directorio) {
        foreach ($archivoPosibles as $archivo) {
            $ruta = $directorio . $archivo;
            if (file_exists($ruta)) {
                require_once $ruta;
                return;
            }
        }
    }
});
