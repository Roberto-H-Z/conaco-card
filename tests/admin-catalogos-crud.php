<?php
declare(strict_types=1);

/* Prueba de integración local: todos los registros se revierten al finalizar. */
require dirname(__DIR__) . '/config/config.php';
require CONFIG_PATH . 'autoload.php';
require HELPERS_PATH . 'funciones.php';
require HELPERS_PATH . 'auth.helper.php';
require HELPERS_PATH . 'validation.helper.php';

function comprobar(bool $condicion, string $mensaje): void
{
    if (!$condicion) throw new RuntimeException($mensaje);
    echo "OK: $mensaje\n";
}

$db = Conexion::conectar();
$sufijo = substr(bin2hex(random_bytes(5)), 0, 10);
$exitCode = 0;
$_SESSION = ['usuario_id' => 1, 'usuario_rol' => 'ADMIN_GENERAL', 'usuario_permisos' => ['sucursales.gestionar', 'categorias.gestionar']];
$_GET = [];
set_error_handler(static function (int $nivel, string $mensaje): never { throw new ErrorException($mensaje, 0, $nivel); });
$db->beginTransaction();
try {
    $categoria = ModeloCatalogosAdmin::guardarCategoria(['id' => null, 'padre' => null, 'nombre' => "Prueba $sufijo", 'slug' => "prueba-$sufijo", 'descripcion' => 'Prueba reversible', 'activo' => 1]);
    comprobar(ModeloCatalogosAdmin::categoria($categoria)['nombre'] === "Prueba $sufijo", 'crear y consultar categoría');
    ModeloCatalogosAdmin::guardarCategoria(['id' => $categoria, 'padre' => null, 'nombre' => "Prueba editada $sufijo", 'slug' => "prueba-editada-$sufijo", 'descripcion' => 'Editada', 'activo' => 1]);
    comprobar(ModeloCatalogosAdmin::categoria($categoria)['slug'] === "prueba-editada-$sufijo", 'editar categoría');
    comprobar(count(ModeloCatalogosAdmin::categorias(['q' => $sufijo, 'estado' => '1'])) >= 1, 'buscar categoría');
    comprobar(ModeloCatalogosAdmin::estadoCategoria($categoria, false), 'desactivar categoría');
    comprobar(ModeloCatalogosAdmin::estadoCategoria($categoria, true), 'reactivar categoría');

    $estado = ModeloCatalogosAdmin::guardarGeo('estado', ['id' => null, 'parent' => 0, 'clave' => '98', 'nombre' => "Estado $sufijo", 'tipo' => '', 'activo' => 1]);
    comprobar(ModeloCatalogosAdmin::estado($estado)['nombre'] === "Estado $sufijo", 'crear y consultar estado');
    ModeloCatalogosAdmin::guardarGeo('estado', ['id' => $estado, 'parent' => 0, 'clave' => '98', 'nombre' => "Estado editado $sufijo", 'tipo' => '', 'activo' => 1]);
    comprobar(ModeloCatalogosAdmin::estado($estado)['nombre'] === "Estado editado $sufijo", 'editar estado');
    $ciudad = ModeloCatalogosAdmin::guardarGeo('ciudad', ['id' => null, 'parent' => $estado, 'clave' => '98765', 'nombre' => "Ciudad $sufijo", 'tipo' => '', 'activo' => 1]);
    comprobar((int) ModeloCatalogosAdmin::ciudad($ciudad)['idEstado'] === $estado, 'crear y consultar ciudad');
    ModeloCatalogosAdmin::guardarGeo('ciudad', ['id' => $ciudad, 'parent' => $estado, 'clave' => '98765', 'nombre' => "Ciudad editada $sufijo", 'tipo' => '', 'activo' => 1]);
    comprobar(ModeloCatalogosAdmin::ciudad($ciudad)['nombre'] === "Ciudad editada $sufijo", 'editar ciudad');
    $localidad = ModeloCatalogosAdmin::guardarGeo('localidad', ['id' => null, 'parent' => $ciudad, 'clave' => '', 'nombre' => "Localidad $sufijo", 'tipo' => 'Colonia', 'activo' => 1]);
    comprobar((int) ModeloCatalogosAdmin::localidad($localidad)['idMunicipio'] === $ciudad, 'crear y consultar localidad');
    ModeloCatalogosAdmin::guardarGeo('localidad', ['id' => $localidad, 'parent' => $ciudad, 'clave' => '', 'nombre' => "Localidad editada $sufijo", 'tipo' => 'Barrio', 'activo' => 1]);
    comprobar(ModeloCatalogosAdmin::localidad($localidad)['nombre'] === "Localidad editada $sufijo", 'editar localidad');
    comprobar(ModeloCatalogosAdmin::localidadesAdmin($sufijo)['total'] >= 1, 'buscar localidad');
    foreach (['localidad' => $localidad, 'ciudad' => $ciudad, 'estado' => $estado] as $tipo => $id) {
        comprobar(ModeloCatalogosAdmin::estadoGeo($tipo, $id, false), "desactivar $tipo");
        comprobar(ModeloCatalogosAdmin::estadoGeo($tipo, $id, true), "reactivar $tipo");
    }

    $afiliado = $db->query('SELECT idAfiliado FROM afiliados WHERE activo=1 ORDER BY idAfiliado LIMIT 1')->fetchColumn();
    comprobar($afiliado !== false, 'existe afiliado activo para prueba de sucursal');
    $datos = ['id' => null, 'idAfiliado' => (int) $afiliado, 'idLocalidad' => $localidad, 'nombre' => "Sucursal $sufijo", 'es_matriz' => 0, 'calle' => 'Calle de prueba', 'numero_exterior' => '1', 'numero_interior' => '', 'colonia' => '', 'codigo_postal' => '', 'referencias' => '', 'latitud' => '19.5', 'longitud' => '-96.9', 'google_place_id' => "test-$sufijo", 'telefono' => '2281234567', 'whatsapp' => '2287654321', 'extension' => '', 'etiqueta' => '', 'etiqueta_whatsapp' => ''];
    $sucursal = ModeloSucursalesAdmin::guardar($db, $datos);
    comprobar(ModeloSucursalesAdmin::obtener($sucursal)['telefono'] === '2281234567', 'crear y consultar sucursal con teléfono');
    $datos['id'] = $sucursal;
    $datos['nombre'] = "Sucursal editada $sufijo";
    $datos['telefono'] = '2281111111';
    ModeloSucursalesAdmin::guardar($db, $datos);
    comprobar(ModeloSucursalesAdmin::obtener($sucursal)['telefono'] === '2281111111', 'editar sucursal y teléfono');
    comprobar(ModeloSucursalesAdmin::listar(['q' => $sufijo, 'afiliado' => 0, 'estado' => ''])['total'] >= 1, 'buscar sucursal');
    comprobar(ModeloSucursalesAdmin::cambiarEstado($sucursal, false), 'desactivar sucursal');
    comprobar(ModeloSucursalesAdmin::cambiarEstado($sucursal, true), 'reactivar sucursal');
    foreach (['sucursales' => new ControladorSucursales(), 'categorias' => new ControladorCategorias(), 'ciudades' => new ControladorCiudades()] as $vista => $controlador) {
        $datosVista = $controlador->index();
        ob_start();
        try { require VIEWS_PATH . "modulos/$vista.php"; $html = ob_get_clean(); }
        catch (Throwable $e) { ob_end_clean(); throw $e; }
        comprobar(str_contains($html, '<section'), "cargar y renderizar $vista sin avisos PHP");
    }
    echo "Pruebas completadas; se revierte la transacción.\n";
} catch (Throwable $e) {
    fwrite(STDERR, 'ERROR: ' . $e->getMessage() . "\n");
    $exitCode = 1;
} finally {
    if ($db->inTransaction()) $db->rollBack();
}

exit($exitCode);
