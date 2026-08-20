<?php
declare(strict_types=1);

/**
 * Rutas disponibles.
 * layout: 'publico' => usa plantilla_publica.php (portal visitantes)
 * layout: 'admin'   => usa plantilla.php (panel administrativo)
 */
return [

    /* ── PORTAL PÚBLICO ──────────────────────────────────────────────── */
    '' => [
        'controlador' => 'ControladorPortada',
        'metodo'      => 'index',
        'vista'       => 'portada',
        'auth'        => false,
        'roles'       => [],
        'titulo'      => 'Inicio',
        'layout'      => 'publico',
        'js_publico'  => ['portada.js'],
    ],
    'portada' => [
        'controlador' => 'ControladorPortada',
        'metodo'      => 'index',
        'vista'       => 'portada',
        'auth'        => false,
        'roles'       => [],
        'titulo'      => 'Inicio',
        'layout'      => 'publico',
        'js_publico'  => ['portada.js'],
    ],

    /* ── PANEL ADMINISTRATIVO ────────────────────────────────────────── */
    'afiliados' => [
        'controlador' => 'ControladorAfiliados',
        'metodo'      => 'index',
        'vista'       => 'afiliados',
        'auth'        => false,
        'roles'       => [],
        'titulo'      => 'Afiliados',
        'breadcrumbs' => [],
        'js'          => ['afiliados.js'],
        'layout'      => 'admin',
    ],
    'afiliados/guardar' => [
        'controlador' => 'ControladorAfiliados',
        'metodo'      => 'guardar',
        'auth'        => false,
        'roles'       => [],
        'api'         => true,
    ],
    'afiliados/obtener' => [
        'controlador' => 'ControladorAfiliados',
        'metodo'      => 'obtener',
        'auth'        => false,
        'roles'       => [],
        'api'         => true,
    ],
    'afiliados/municipios' => [
        'controlador' => 'ControladorAfiliados', 'metodo' => 'municipios', 'auth' => false, 'roles' => [], 'api' => true,
    ],
    'afiliados/localidades' => [
        'controlador' => 'ControladorAfiliados', 'metodo' => 'localidades', 'auth' => false, 'roles' => [], 'api' => true,
    ],
    'afiliados/cambiar-estado' => [
        'controlador' => 'ControladorAfiliados',
        'metodo'      => 'cambiarEstado',
        'auth'        => false,
        'roles'       => [],
        'api'         => true,
    ],
    'promociones' => [
        'controlador' => 'ControladorPromociones',
        'metodo'      => 'index',
        'vista'       => 'promociones',
        'auth'        => false,
        'roles'       => [],
        'titulo'      => 'Promociones',
        'breadcrumbs' => [],
        'js'          => ['promociones.js'],
        'layout'      => 'admin',
    ],
    'promociones/guardar'        => ['controlador'=>'ControladorPromociones','metodo'=>'guardar','auth'=>false,'roles'=>[],'api'=>true],
    'promociones/obtener'        => ['controlador'=>'ControladorPromociones','metodo'=>'obtener','auth'=>false,'roles'=>[],'api'=>true],
    'promociones/cambiar-estado' => ['controlador'=>'ControladorPromociones','metodo'=>'cambiarEstado','auth'=>false,'roles'=>[],'api'=>true],
    
    /* ── AUTENTICACIÓN ───────────────────────────────────────────────── */
    'logout' => [
        'controlador' => 'ControladorLogin',
        'metodo'      => 'cerrar',
        'auth'        => false,
        'roles'       => [],
    ],
];

