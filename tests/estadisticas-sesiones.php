<?php
declare(strict_types=1);
// Sesiones de QA locales: no cambia usuarios, contraseñas ni el último acceso de las cuentas.
if (PHP_SAPI!=='cli') { http_response_code(404); exit; }
require __DIR__.'/../config/config.php';
require CONFIG_PATH.'autoload.php';
require HELPERS_PATH.'auth.helper.php';
require HELPERS_PATH.'validation.helper.php';
if (($argv[1]??'')==='limpiar') {
    foreach(json_decode(stream_get_contents(STDIN),true) ?: [] as $s) {
        session_id($s['sid']); session_start(); session_destroy();
    }
    exit;
}
$db=Conexion::conectar(); $salida=[];
foreach(['ADMIN_GENERAL','ADMIN_CAMARA','AFILIADO'] as $rol) {
    $s=$db->prepare('SELECT u.correo FROM usuarios u JOIN roles r ON r.idRol=u.idRol WHERE r.clave=? AND u.activo=1 ORDER BY u.idUsuario'); $s->execute([$rol]);
    foreach($s->fetchAll(PDO::FETCH_COLUMN) as $correo) {
        $u=ModeloUsuarios::buscarParaAutenticacion($correo);
        if(!$u || ($rol==='ADMIN_CAMARA'&&!$u['idCamara']) || ($rol==='AFILIADO'&&!$u['afiliados'])) continue;
        session_id(bin2hex(random_bytes(20))); session_start(); iniciarSesionUsuario($u);
        $salida[$rol]=['sid'=>session_id(),'afiliados'=>$u['afiliados'],'camara'=>$u['idCamara']]; session_write_close(); break;
    }
}
echo json_encode($salida,JSON_THROW_ON_ERROR);
