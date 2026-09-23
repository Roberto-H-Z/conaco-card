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
    'empresa/{slug}' => [
        'patron'      => '#^empresa/(?P<slug>[a-z0-9]+(?:-[a-z0-9]+)*)$#',
        'controlador' => 'ControladorFichaAfiliado',
        'metodo'      => 'mostrar',
        'vista'       => 'ficha-afiliado',
        'auth'        => false,
        'roles'       => [],
        'titulo'      => 'Ficha de afiliado',
        'layout'      => 'publico',
        'js_publico'  => ['estadisticas-publicas.js', 'ficha-afiliado.js'],
    ],
    'promocion/{id}' => [
        'patron'      => '#^promocion/(?P<id>[1-9][0-9]*)$#',
        'controlador' => 'ControladorFichaPromocion',
        'metodo'      => 'mostrar',
        'vista'       => 'ficha-promocion',
        'auth'        => false,
        'roles'       => [],
        'titulo'      => 'Ficha de promoción',
        'layout'      => 'publico',
        'js_publico'  => ['estadisticas-publicas.js', 'ficha-promocion.js'],
    ],

    /* ── PANEL ADMINISTRATIVO ────────────────────────────────────────── */
    'inicio' => [
        'controlador'=>'ControladorInicio', 'metodo'=>'index', 'vista'=>'inicio',
        'auth'=>true, 'permiso'=>'estadisticas.ver', 'roles'=>['AFILIADO'],
        'titulo'=>'Inicio', 'breadcrumbs'=>[], 'layout'=>'admin', 'js'=>['inicio.js'],
    ],

    'estadisticas/evento' => [
        'controlador'=>'ControladorEventoPublico', 'metodo'=>'registrar',
        'auth'=>false, 'roles'=>[], 'api'=>true,
    ],

    'buscar' => [
        'controlador'=>'ControladorBuscador', 'metodo'=>'index', 'vista'=>'buscar',
        'auth'=>false, 'roles'=>[], 'titulo'=>'Buscar empresas', 'layout'=>'publico',
        'js_publico'=>['ficha-promocion.js', 'buscar.js'],
    ],

    'afiliados' => [
        'controlador' => 'ControladorAfiliados',
        'metodo'      => 'index',
        'vista'       => 'afiliados',
        'auth'        => true,
        'permiso'     => 'afiliados.ver',
        'roles'       => [],
        'titulo'      => 'Afiliados',
        'breadcrumbs' => [],
        'js'          => ['afiliados.js'],
        'layout'      => 'admin',
    ],
    'afiliados/guardar' => [
        'controlador' => 'ControladorAfiliados',
        'metodo'      => 'guardar',
        'auth'        => true,
        'permiso'     => 'afiliados.ver',
        'roles'       => [],
        'api'         => true,
    ],
    'afiliados/obtener' => [
        'controlador' => 'ControladorAfiliados',
        'metodo'      => 'obtener',
        'auth'        => true,
        'permiso'     => 'afiliados.ver',
        'roles'       => [],
        'api'         => true,
    ],
    'afiliados/municipios' => [
        'controlador' => 'ControladorAfiliados', 'metodo' => 'municipios', 'auth' => true, 'permiso' => 'afiliados.ver', 'roles' => [], 'api' => true,
    ],
    'afiliados/localidades' => [
        'controlador' => 'ControladorAfiliados', 'metodo' => 'localidades', 'auth' => true, 'permiso' => 'afiliados.ver', 'roles' => [], 'api' => true,
    ],
    'afiliados/cambiar-estado' => [
        'controlador' => 'ControladorAfiliados',
        'metodo'      => 'cambiarEstado',
        'auth'        => true,
        'permiso'     => 'afiliados.activar',
        'roles'       => [],
        'api'         => true,
    ],
    'afiliados/enviar-acceso' => [
        'controlador' => 'ControladorAfiliados',
        'metodo'      => 'enviarAcceso',
        'auth'        => true,
        'permiso'     => 'afiliados.ver',
        'roles'       => [],
        'api'         => true,
    ],
    'usuarios' => [
        'controlador'=>'ControladorUsuarios','metodo'=>'index','vista'=>'usuarios','auth'=>true,'permiso'=>'usuarios.ver','roles'=>['ADMIN_GENERAL'],'titulo'=>'Usuarios','breadcrumbs'=>[],'js'=>['usuarios.js'],'layout'=>'admin',
    ],
    'usuarios/obtener' => ['controlador'=>'ControladorUsuarios','metodo'=>'obtener','auth'=>true,'permiso'=>'usuarios.ver','roles'=>['ADMIN_GENERAL'],'api'=>true],
    'usuarios/guardar' => ['controlador'=>'ControladorUsuarios','metodo'=>'guardar','auth'=>true,'permiso'=>'usuarios.crear','roles'=>['ADMIN_GENERAL'],'api'=>true],
    'usuarios/cambiar-estado' => ['controlador'=>'ControladorUsuarios','metodo'=>'cambiarEstado','auth'=>true,'permiso'=>'usuarios.activar','roles'=>['ADMIN_GENERAL'],'api'=>true],
    'sucursales' => ['controlador'=>'ControladorSucursales','metodo'=>'index','vista'=>'sucursales','auth'=>true,'permiso'=>'sucursales.gestionar','roles'=>['ADMIN_GENERAL','AFILIADO'],'titulo'=>'Sucursales','breadcrumbs'=>[],'js'=>['sucursales.js'],'layout'=>'admin'],
    'sucursales/obtener' => ['controlador'=>'ControladorSucursales','metodo'=>'obtener','auth'=>true,'permiso'=>'sucursales.gestionar','roles'=>['ADMIN_GENERAL','AFILIADO'],'api'=>true],
    'sucursales/guardar' => ['controlador'=>'ControladorSucursales','metodo'=>'guardar','auth'=>true,'permiso'=>'sucursales.gestionar','roles'=>['ADMIN_GENERAL','AFILIADO'],'api'=>true],
    'sucursales/cambiar-estado' => ['controlador'=>'ControladorSucursales','metodo'=>'cambiarEstado','auth'=>true,'permiso'=>'sucursales.gestionar','roles'=>['ADMIN_GENERAL','AFILIADO'],'api'=>true],
    'categorias' => ['controlador'=>'ControladorCategorias','metodo'=>'index','vista'=>'categorias','auth'=>true,'permiso'=>'categorias.gestionar','roles'=>['ADMIN_GENERAL'],'titulo'=>'Categorías','breadcrumbs'=>[],'js'=>['catalogos.js'],'layout'=>'admin'],
    'categorias/obtener' => ['controlador'=>'ControladorCategorias','metodo'=>'obtener','auth'=>true,'permiso'=>'categorias.gestionar','roles'=>['ADMIN_GENERAL'],'api'=>true],
    'categorias/guardar' => ['controlador'=>'ControladorCategorias','metodo'=>'guardar','auth'=>true,'permiso'=>'categorias.gestionar','roles'=>['ADMIN_GENERAL'],'api'=>true],
    'categorias/cambiar-estado' => ['controlador'=>'ControladorCategorias','metodo'=>'cambiarEstado','auth'=>true,'permiso'=>'categorias.gestionar','roles'=>['ADMIN_GENERAL'],'api'=>true],
    'ciudades' => ['controlador'=>'ControladorCiudades','metodo'=>'index','vista'=>'ciudades','auth'=>true,'roles'=>['ADMIN_GENERAL'],'titulo'=>'Ciudades','breadcrumbs'=>[],'js'=>['catalogos.js'],'layout'=>'admin'],
    'ciudades/obtener' => ['controlador'=>'ControladorCiudades','metodo'=>'obtener','auth'=>true,'roles'=>['ADMIN_GENERAL'],'api'=>true],
    'ciudades/guardar' => ['controlador'=>'ControladorCiudades','metodo'=>'guardar','auth'=>true,'roles'=>['ADMIN_GENERAL'],'api'=>true],
    'ciudades/cambiar-estado' => ['controlador'=>'ControladorCiudades','metodo'=>'cambiarEstado','auth'=>true,'roles'=>['ADMIN_GENERAL'],'api'=>true],
    'promociones' => [
        'controlador' => 'ControladorPromociones',
        'metodo'      => 'index',
        'vista'       => 'promociones',
        'auth'        => true,
        'permiso'     => 'promociones.ver',
        'roles'       => [],
        'titulo'      => 'Promociones',
        'breadcrumbs' => [],
        'js'          => ['promociones.js'],
        'layout'      => 'admin',
    ],
    'promociones/guardar'        => ['controlador'=>'ControladorPromociones','metodo'=>'guardar','auth'=>true,'roles'=>[],'api'=>true],
    'promociones/obtener'        => ['controlador'=>'ControladorPromociones','metodo'=>'obtener','auth'=>true,'permiso'=>'promociones.ver','roles'=>[],'api'=>true],
    'promociones/cambiar-estado' => ['controlador'=>'ControladorPromociones','metodo'=>'cambiarEstado','auth'=>true,'permiso'=>'promociones.activar','roles'=>[],'api'=>true],
    
    /* ── AUTENTICACIÓN ───────────────────────────────────────────────── */
    'login' => [
        'controlador' => 'ControladorLogin',
        'metodo'      => 'index',
        'vista'       => 'login',
        'auth'        => false,
        'roles'       => [],
        'layout'      => 'login',
    ],
    'login/autenticar' => [
        'controlador' => 'ControladorLogin',
        'metodo'      => 'autenticar',
        'auth'        => false,
        'roles'       => [],
    ],
    'sesion/actividad' => [
        'controlador' => 'ControladorLogin',
        'metodo'      => 'actividad',
        'auth'        => true,
        'api'         => true,
    ],
    'logout' => [
        'controlador' => 'ControladorLogin',
        'metodo'      => 'cerrar',
        'auth'        => true,
        'roles'       => [],
    ],
];
