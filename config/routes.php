<?php
declare(strict_types=1);

/**
 * CANACO Card — Definición de rutas
 * 
 * Cada ruta define:
 *   'controlador' => Clase del controlador
 *   'metodo'      => Método a ejecutar
 *   'vista'       => Nombre de la vista dentro de vistas/modulos/
 *   'auth'        => true si requiere autenticación
 *   'roles'       => Array de roles permitidos (vacío = todos los autenticados)
 *   'titulo'      => Título de la página (para <title> y toolbar)
 *   'breadcrumbs' => Array de breadcrumbs [ ['titulo' => '...', 'url' => '...'] ]
 *   'js'          => Array de archivos JS específicos del módulo
 *   'layout'      => 'admin' (con sidebar) o 'auth' (sin sidebar, para login)
 */

return [

    // ── Dashboard ────────────────────────────────────────────
    'inicio' => [
        'controlador' => 'ControladorInicio',
        'metodo'      => 'index',
        'vista'       => 'inicio',
        'auth'        => false, // Temporalmente false durante desarrollo
        'roles'       => [],
        'titulo'      => 'Inicio',
        'breadcrumbs' => [],
        'js'          => [],
        'layout'      => 'admin',
    ],

    // ── Autenticación ────────────────────────────────────────
    'login' => [
        'controlador' => 'ControladorLogin',
        'metodo'      => 'index',
        'vista'       => 'login',
        'auth'        => false,
        'roles'       => [],
        'titulo'      => 'Iniciar sesión',
        'breadcrumbs' => [],
        'js'          => ['login.js'],
        'layout'      => 'auth',
    ],

    // ── Gestión (en construcción) ────────────────────────────
    'afiliados' => [
        'controlador' => 'ControladorPlantilla',
        'metodo'      => 'enConstruccion',
        'vista'       => 'en-construccion',
        'auth'        => false,
        'roles'       => [],
        'titulo'      => 'Afiliados',
        'breadcrumbs' => [
            ['titulo' => 'Gestión', 'url' => '#'],
        ],
        'js'          => [],
        'layout'      => 'admin',
    ],

    'promociones' => [
        'controlador' => 'ControladorPlantilla',
        'metodo'      => 'enConstruccion',
        'vista'       => 'en-construccion',
        'auth'        => false,
        'roles'       => [],
        'titulo'      => 'Promociones',
        'breadcrumbs' => [
            ['titulo' => 'Gestión', 'url' => '#'],
        ],
        'js'          => [],
        'layout'      => 'admin',
    ],

    'sucursales' => [
        'controlador' => 'ControladorPlantilla',
        'metodo'      => 'enConstruccion',
        'vista'       => 'en-construccion',
        'auth'        => false,
        'roles'       => [],
        'titulo'      => 'Sucursales',
        'breadcrumbs' => [
            ['titulo' => 'Gestión', 'url' => '#'],
        ],
        'js'          => [],
        'layout'      => 'admin',
    ],

    // ── Administración (en construcción) ─────────────────────
    'usuarios' => [
        'controlador' => 'ControladorPlantilla',
        'metodo'      => 'enConstruccion',
        'vista'       => 'en-construccion',
        'auth'        => false,
        'roles'       => [],
        'titulo'      => 'Usuarios',
        'breadcrumbs' => [
            ['titulo' => 'Administración', 'url' => '#'],
        ],
        'js'          => [],
        'layout'      => 'admin',
    ],

    'camaras' => [
        'controlador' => 'ControladorPlantilla',
        'metodo'      => 'enConstruccion',
        'vista'       => 'en-construccion',
        'auth'        => false,
        'roles'       => [],
        'titulo'      => 'Cámaras',
        'breadcrumbs' => [
            ['titulo' => 'Administración', 'url' => '#'],
        ],
        'js'          => [],
        'layout'      => 'admin',
    ],

    'categorias' => [
        'controlador' => 'ControladorPlantilla',
        'metodo'      => 'enConstruccion',
        'vista'       => 'en-construccion',
        'auth'        => false,
        'roles'       => [],
        'titulo'      => 'Categorías',
        'breadcrumbs' => [
            ['titulo' => 'Administración', 'url' => '#'],
        ],
        'js'          => [],
        'layout'      => 'admin',
    ],

    'ubicaciones' => [
        'controlador' => 'ControladorPlantilla',
        'metodo'      => 'enConstruccion',
        'vista'       => 'en-construccion',
        'auth'        => false,
        'roles'       => [],
        'titulo'      => 'Ubicaciones',
        'breadcrumbs' => [
            ['titulo' => 'Administración', 'url' => '#'],
        ],
        'js'          => [],
        'layout'      => 'admin',
    ],

    // ── Analítica (en construcción) ──────────────────────────
    'estadisticas' => [
        'controlador' => 'ControladorPlantilla',
        'metodo'      => 'enConstruccion',
        'vista'       => 'en-construccion',
        'auth'        => false,
        'roles'       => [],
        'titulo'      => 'Estadísticas',
        'breadcrumbs' => [
            ['titulo' => 'Analítica', 'url' => '#'],
        ],
        'js'          => [],
        'layout'      => 'admin',
    ],

    'busquedas' => [
        'controlador' => 'ControladorPlantilla',
        'metodo'      => 'enConstruccion',
        'vista'       => 'en-construccion',
        'auth'        => false,
        'roles'       => [],
        'titulo'      => 'Búsquedas',
        'breadcrumbs' => [
            ['titulo' => 'Analítica', 'url' => '#'],
        ],
        'js'          => [],
        'layout'      => 'admin',
    ],

    'reportes' => [
        'controlador' => 'ControladorPlantilla',
        'metodo'      => 'enConstruccion',
        'vista'       => 'en-construccion',
        'auth'        => false,
        'roles'       => [],
        'titulo'      => 'Reportes',
        'breadcrumbs' => [
            ['titulo' => 'Analítica', 'url' => '#'],
        ],
        'js'          => [],
        'layout'      => 'admin',
    ],

    // ── Contenido (en construcción) ──────────────────────────
    'portada' => [
        'controlador' => 'ControladorPlantilla',
        'metodo'      => 'enConstruccion',
        'vista'       => 'en-construccion',
        'auth'        => false,
        'roles'       => [],
        'titulo'      => 'Portada',
        'breadcrumbs' => [
            ['titulo' => 'Contenido', 'url' => '#'],
        ],
        'js'          => [],
        'layout'      => 'admin',
    ],

    // ── Sistema (en construcción) ────────────────────────────
    'configuracion' => [
        'controlador' => 'ControladorPlantilla',
        'metodo'      => 'enConstruccion',
        'vista'       => 'en-construccion',
        'auth'        => false,
        'roles'       => [],
        'titulo'      => 'Configuración',
        'breadcrumbs' => [
            ['titulo' => 'Sistema', 'url' => '#'],
        ],
        'js'          => [],
        'layout'      => 'admin',
    ],

    'auditoria' => [
        'controlador' => 'ControladorPlantilla',
        'metodo'      => 'enConstruccion',
        'vista'       => 'en-construccion',
        'auth'        => false,
        'roles'       => [],
        'titulo'      => 'Auditoría',
        'breadcrumbs' => [
            ['titulo' => 'Sistema', 'url' => '#'],
        ],
        'js'          => [],
        'layout'      => 'admin',
    ],
];
