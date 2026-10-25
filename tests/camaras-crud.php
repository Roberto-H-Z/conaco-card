<?php
declare(strict_types=1);
if (PHP_SAPI !== 'cli') { http_response_code(404); exit; }
require dirname(__DIR__).'/config/config.php';
require CONFIG_PATH.'autoload.php';
require HELPERS_PATH.'funciones.php';
require HELPERS_PATH.'auth.helper.php';
require HELPERS_PATH.'validation.helper.php';

function comprobarCamara(bool $ok, string $mensaje): void {
    if (!$ok) throw new RuntimeException($mensaje);
    echo "OK: $mensaje\n";
}

$db = Conexion::conectar();
$db->beginTransaction();
try {
    $ciudades = ModeloCatalogosAdmin::ciudades();
    $activas = array_values(array_filter($ciudades, static fn($c)=>(int)$c['activo']===1));
    comprobarCamara(count($activas)>=2,'hay dos ciudades para probar coberturas');
    $sede=(int)$activas[0]['idMunicipio'];$otra=(int)$activas[1]['idMunicipio'];
    $clave='TEST-'.bin2hex(random_bytes(5));
    $datos=['idCamara'=>null,'clave'=>$clave,'nombre'=>'Cámara de prueba','nombre_corto'=>'Prueba','correo'=>'prueba@example.com','telefono'=>'2281234567','idMunicipioSede'=>$sede,'activo'=>1];
    $id=ModeloCamarasAdmin::guardar($db,$datos,[$sede=>'DIRECTA',$otra=>'EXTENDIDA']);
    $creada=ModeloCamarasAdmin::obtener($id);
    comprobarCamara($creada['clave']===$clave && count($creada['ciudades'])===2,'crear cámara con ciudad sede y dos coberturas');
    comprobarCamara(count(ModeloCamarasAdmin::listar($clave,'1'))===1,'buscar y filtrar cámara');
    $datos['idCamara']=$id;$datos['nombre']='Cámara editada';
    ModeloCamarasAdmin::guardar($db,$datos,[$sede=>'EXTENDIDA']);
    $editada=ModeloCamarasAdmin::obtener($id);
    comprobarCamara($editada['nombre']==='Cámara editada' && count($editada['ciudades'])===1 && $editada['ciudades'][0]['tipo_cobertura']==='EXTENDIDA','editar datos, retirar ciudad y cambiar cobertura');
    $stmt=$db->prepare('SELECT activo FROM camaras_municipios WHERE idCamara=? AND idMunicipio=?');$stmt->execute([$id,$otra]);
    comprobarCamara($stmt->fetchColumn()===0,'la ciudad retirada permanece como vínculo inactivo');
    ModeloCamarasAdmin::guardar($db,$datos,[$sede=>'DIRECTA',$otra=>'DIRECTA']);
    comprobarCamara(count(ModeloCamarasAdmin::obtener($id)['ciudades'])===2,'reasignar ciudad sin duplicarla');
    comprobarCamara(ModeloCamarasAdmin::cambiarEstado($id,false),'desactivar cámara');
    comprobarCamara(count(ModeloCamarasAdmin::obtener($id)['ciudades'])===2,'desactivar conserva las ciudades');
    comprobarCamara(ModeloCamarasAdmin::cambiarEstado($id,true),'reactivar cámara');
    $_SESSION=['usuario_id'=>1,'usuario_rol'=>'ADMIN_GENERAL','usuario_permisos'=>[]];$_GET=['q'=>$clave];
    $datosVista=(new ControladorCamaras())->index();
    ob_start();try {require VIEWS_PATH.'modulos/camaras.php';$html=ob_get_clean();}catch(Throwable $e){ob_end_clean();throw $e;}
    comprobarCamara(str_contains($html,'formCamara') && str_contains($html,$clave),'renderizar gestión con datos reales');
} finally {
    $db->rollBack();
    echo "Transacción revertida; no se conservan datos de prueba.\n";
}
