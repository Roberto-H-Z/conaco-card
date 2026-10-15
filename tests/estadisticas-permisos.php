<?php
declare(strict_types=1);

// Solo CLI. Las tablas temporales desaparecen al cerrar esta conexión y no cambian los datos reales.
if (PHP_SAPI!=='cli') { http_response_code(404); exit; }
require __DIR__.'/../config/config.php';
require CONFIG_PATH.'autoload.php';
require HELPERS_PATH.'auth.helper.php';
require HELPERS_PATH.'funciones.php';
require HELPERS_PATH.'validation.helper.php';
session_start();
$db=Conexion::conectar();
$tabla=ModeloEstadisticas::tablaInteracciones();
foreach([
 'camaras'=>'idCamara INT,nombre VARCHAR(180)',
 'afiliados'=>'idAfiliado INT,idCamara INT,nombre_comercial VARCHAR(180),slug VARCHAR(180),descripcion TEXT,activo INT',
 'usuarios_afiliados'=>'idUsuario INT,idAfiliado INT',
 'busquedas_resultados'=>'idAfiliado INT,idBusqueda INT,mostrado_at DATETIME',
 $tabla=>'idAfiliado INT,idPromocion INT,tipo VARCHAR(40),ocurrido_at DATETIME',
 'busquedas'=>'idBusqueda INT,termino_normalizado VARCHAR(180)',
 'promociones'=>'idPromocion INT,idAfiliado INT,titulo VARCHAR(180),inicio_vigencia DATETIME,fin_vigencia DATETIME,activo INT',
 'sucursales'=>'idAfiliado INT,activo INT',
 'canales_digitales'=>'idAfiliado INT,activo INT',
] as $nombre=>$campos) $db->exec("CREATE TEMPORARY TABLE $nombre ($campos)");
$db->exec("INSERT INTO camaras VALUES (1,'Cámara Sierra'),(2,'Cámara Costa')");
$db->exec("INSERT INTO afiliados VALUES (1,1,'Café 100% Sierra','cafe','Empresa de prueba',1),(2,2,'Empresa Costa','costa','Otra empresa',1),(3,1,'Sin eventos','sin-eventos','Sin eventos',0)");
$db->exec('INSERT INTO usuarios_afiliados VALUES (101,1)');
$db->exec("INSERT INTO busquedas VALUES (1,'café')");
$db->exec('INSERT INTO busquedas_resultados VALUES (1,1,UTC_TIMESTAMP()),(1,1,UTC_TIMESTAMP()),(2,1,UTC_TIMESTAMP()),(1,1,DATE_SUB(UTC_DATE(),INTERVAL 30 DAY)),(1,1,DATE_ADD(UTC_DATE(),INTERVAL 1 DAY))');
$db->exec("INSERT INTO $tabla VALUES (1,NULL,'VISITA_FICHA',UTC_TIMESTAMP()),(1,NULL,'CLIC_TELEFONO',UTC_TIMESTAMP()),(1,NULL,'CLIC_WHATSAPP',DATE_SUB(UTC_DATE(),INTERVAL 29 DAY)),(1,NULL,'CLIC_RED_SOCIAL',UTC_TIMESTAMP()),(2,NULL,'VISITA_FICHA',UTC_TIMESTAMP()),(1,NULL,'VISITA_FICHA',DATE_SUB(UTC_DATE(),INTERVAL 30 DAY)),(1,NULL,'VISITA_FICHA',DATE_ADD(UTC_DATE(),INTERVAL 1 DAY))");
$general=['id'=>100,'rol'=>'ADMIN_GENERAL','idCamara'=>null];
$camara=['id'=>102,'rol'=>'ADMIN_CAMARA','idCamara'=>1];
$afiliado=['id'=>101,'rol'=>'AFILIADO','idCamara'=>null];
$modelo=new ModeloEstadisticas(); $f=['q'=>'','camara'=>0,'afiliado'=>0];
$ok=static function(bool $valor,string $mensaje):void { if(!$valor) throw new RuntimeException($mensaje); echo "OK $mensaje\n"; };
$todos=$modelo->reporte($general,$f);
$ok(count($todos)===3,'General incluye ambas cámaras y empresas sin eventos');
$filas=$modelo->reporte($camara,$f);
$ok(array_map('intval',array_column($filas,'idAfiliado'))===[1,3],'Cámara solo incluye sus afiliados');
$ok(count($modelo->reporte([...$camara,'idCamara'=>null],$f))===0,'Cámara sin asignación no recibe datos');
$ok(count($modelo->reporte($afiliado,$f))===1 && $modelo->empresaVisible($afiliado,2)===null,'Afiliado solo accede a sus empresas');
$fila=$todos[0];
$ok($fila['apariciones']===2 && $fila['visitas']===1 && $fila['contactos']===3,'Conteos no se multiplican y respetan ambos límites del periodo UTC');
$r=$modelo->resumen(1); $s=$modelo->serieDiaria(1);
$ok($r['apariciones']===$fila['apariciones'] && $r['visitas']===$fila['visitas'] && array_sum(array_column($s,'contactos'))===$fila['contactos'],'Listado, detalle y serie diaria concuerdan');
$ok(count($modelo->reporte($general,[...$f,'q'=>'100%']))===1,'Búsqueda trata porcentaje como texto literal');
$sesion=static function(array $u):void { $_SESSION=['usuario_id'=>$u['id'],'usuario_rol'=>$u['rol'],'usuario_idCamara'=>$u['idCamara'],'usuario_permisos'=>['estadisticas.ver']]; http_response_code(200); };
$sesion($camara); $_GET=['afiliado'=>'2'];
$respuesta=(new ControladorEstadisticas())->index();
$ok(http_response_code()===403 && isset($respuesta['error']),'Controlador rechaza el detalle de otra cámara');
$sesion($camara); $_GET=['camara'=>'2']; (new ControladorEstadisticas())->index();
$ok(http_response_code()===403,'Controlador rechaza cámara ajena enviada en URL');
$sesion($general); $_GET=['afiliado'=>['1']]; (new ControladorEstadisticas())->index();
$ok(http_response_code()===400,'Controlador rechaza parámetros de tipo array');
$sesion($general); $_GET=['afiliado'=>'1','q'=>'nombre-distinto']; $datos=(new ControladorEstadisticas())->index();
$ok(http_response_code()===200 && count($datos['filas'])===1 && $datos['resumen']['visitas']===1,'Detalle mantiene empresa y filtros de regreso sin alterar sus métricas');
$salida=__DIR__.'/../tmp/estadisticas-qa'; if(!is_dir($salida)) mkdir($salida,0755,true);
$exportador=new ExportadorEstadisticas();
$pdf=$exportador->pdf($datos); $xlsx=$exportador->excel($datos);
file_put_contents($salida.'/detalle.pdf',$pdf); file_put_contents($salida.'/detalle.xlsx',$xlsx);
$ok(str_starts_with($pdf,'%PDF-1.4') && str_starts_with($xlsx,'PK'),'Exportaciones PDF y XLSX generadas');
$z=new ZipArchive(); $z->open($salida.'/detalle.xlsx');
$ok(str_contains((string)$z->getFromName('xl/worksheets/sheet1.xml'),'Café 100% Sierra'),'Excel conserva acentos y alcance seleccionado'); $z->close();
$datos['filas']=array_fill(0,65,[...$fila,'nombre_comercial'=>'Empresa de nombre largo con acentos: cafetería y artículos para el hogar','camara'=>'Cámara de Comercio, Servicios y Turismo de la Sierra']);
unset($datos['serie']); $datos['empresa']=null; $datos['alcance']='Todas las cámaras';
file_put_contents($salida.'/paginado.pdf',$exportador->pdf($datos));
echo "OK PDF de varias páginas preparado para revisión visual\n";
session_destroy();
