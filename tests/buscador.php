<?php
/** Prueba de integración local. Las fixtures se revierten incluso si falla una aserción. */
declare(strict_types=1);
require __DIR__.'/../config/config.php';
require CONFIG_PATH.'autoload.php';
$db = Conexion::conectar();
$model = new ModeloBuscador();
function check(bool $ok, string $message): void { if (!$ok) throw new RuntimeException($message); echo "OK $message\n"; }
$defaults = ['q'=>'','ciudad'=>0,'categoria'=>0,'pagina'=>1];
$db->beginTransaction();
try {
    $tag = 'qa'.bin2hex(random_bytes(4));
    $db->prepare('INSERT INTO camaras (clave,nombre) VALUES (?,?)')->execute([$tag,$tag]);
    $camara = (int)$db->lastInsertId();
    $ids=[];
    for ($i=1;$i<=7;$i++) {
        $nombre = $i===1 ? $tag : ($i===2 ? $tag.' parcial' : 'Prueba '.$i.' '.$tag.'x');
        if ($i>2) $nombre='Prueba '.$i;
        $db->prepare('INSERT INTO afiliados (idCamara,rfc,nombre_comercial,slug,descripcion,activo) VALUES (?,?,?,?,?,?)')->execute([$camara,str_pad($tag.$i,12,'0'),$nombre,$tag.'-'.$i,$i===6 ? $tag : 'Descripción general',$i===7?0:1]);
        $ids[$i]=(int)$db->lastInsertId();
    }
    $db->prepare('INSERT INTO categorias (nombre,slug) VALUES (?,?)')->execute([$tag,$tag]);
    $cat=(int)$db->lastInsertId();
    $db->prepare('INSERT INTO afiliados_categorias (idAfiliado,idCategoria,es_principal) VALUES (?,?,1)')->execute([$ids[3],$cat]);
    $db->prepare('INSERT INTO afiliados_palabras_clave (idAfiliado,palabra,palabra_normalizada) VALUES (?,?,?)')->execute([$ids[4],$tag,$tag]);
    $db->prepare('INSERT INTO promociones (idAfiliado,titulo,descripcion,inicio_vigencia,fin_vigencia) VALUES (?,?,?,CURRENT_TIMESTAMP()-INTERVAL 1 DAY,CURRENT_TIMESTAMP()+INTERVAL 1 DAY)')->execute([$ids[5],$tag,'Oferta']);
    $promo=(int)$db->lastInsertId();
    $r=$model->buscar(array_merge($defaults,['q'=>$tag]));
    $niveles=array_map('intval',array_column($r['items'],'nivel')); sort($niveles);
    check($niveles === [1,2,3,4,5,6], 'RF13 seis niveles de coincidencia conservados');
    $repetida=$model->buscar(array_merge($defaults,['q'=>$tag]));
    check(array_column($r['items'],'idAfiliado') !== array_column($repetida['items'],'idAfiliado'), 'Misma búsqueda cambia de orden');
    $conservada=$model->buscar(array_merge($defaults,['q'=>$tag,'orden'=>$r['orden']]));
    check(array_column($r['items'],'idAfiliado') === array_column($conservada['items'],'idAfiliado'), 'Token conserva orden para navegar');
    check($r['total']===6,'Afiliado inactivo excluido');
    check(array_column($r['items'],null,'idAfiliado')[$ids[5]]['promocion']['idPromocion']===$promo,'RF14 promoción destacada en el resultado');
    $db->prepare('INSERT INTO promociones (idAfiliado,titulo,descripcion,inicio_vigencia,fin_vigencia) VALUES (?,?,?,CURRENT_TIMESTAMP()-INTERVAL 1 DAY,CURRENT_TIMESTAMP()+INTERVAL 1 HOUR)')->execute([$ids[5],'Otra oferta','No coincide']);
    $destacada=$model->buscar(array_merge($defaults,['q'=>$tag]));
    check(array_column($destacada['items'],null,'idAfiliado')[$ids[5]]['promocion']['idPromocion']===$promo,'Destacada prioriza promoción coincidente frente a otra que vence antes');
    $portada=new ModeloPortada();
    $p1=$portada->obtenerPromocionesDestacadas();
    $p2=$portada->obtenerPromocionesDestacadas();
    check(array_column($p1,'idPromocion') !== array_column($p2,'idPromocion'), 'Carrusel cambia de orden o selección en cada carga');
    check(count($p2)<=6 && count(array_unique(array_column($p2,'idPromocion')))===count($p2), 'Carrusel respeta límite sin duplicados');
    check($model->buscar(array_merge($defaults,['q'=>$tag,'categoria'=>$cat]))['total']===1,'Filtro por categoría combinado');
    $db->prepare('UPDATE promociones SET fin_vigencia=CURRENT_TIMESTAMP()-INTERVAL 1 HOUR WHERE idPromocion=?')->execute([$promo]);
    check($model->buscar(array_merge($defaults,['q'=>$tag]))['total']===5,'Promoción vencida excluida automáticamente');
    $db->prepare('UPDATE promociones SET inicio_vigencia=CURRENT_TIMESTAMP()+INTERVAL 1 DAY,fin_vigencia=CURRENT_TIMESTAMP()+INTERVAL 2 DAY WHERE idPromocion=?')->execute([$promo]);
    check($model->buscar(array_merge($defaults,['q'=>$tag]))['total']===5,'Promoción futura excluida');
    check($model->buscar(array_merge($defaults,['q'=>$tag.'%']))['total']===0,'Porcentaje tratado como texto literal');
    $db->prepare('UPDATE afiliados SET alias=? WHERE idAfiliado=?')->execute([$tag.'alias',$ids[6]]);
    check($model->buscar(array_merge($defaults,['q'=>$tag.'alias']))['items'][0]['nivel']===1,'Coincidencia exacta por alias');
    $db->prepare('UPDATE camaras SET activo=0 WHERE idCamara=?')->execute([$camara]);
    check($model->buscar(array_merge($defaults,['q'=>$tag]))['total']===0,'Cámara inactiva excluida');
    foreach ([['q'=>[]],['ciudad'=>'-1'],['pagina'=>'0'],['q'=>str_repeat('x',121)],['orden'=>[]],['orden'=>'invalido']] as $bad) {
        try { ControladorBuscador::filtros($bad); throw new RuntimeException('Se aceptó filtro inválido'); } catch (InvalidArgumentException $e) { echo "OK filtro inválido rechazado\n"; }
    }
} finally { $db->rollBack(); }
echo "Fixtures revertidas.\n";
$catalogos=$model->catalogos();
if ($catalogos['ciudades']) {
    $ciudad=(int)$catalogos['ciudades'][0]['id'];
    $r=$model->buscar(array_merge($defaults,['ciudad'=>$ciudad]));
    check($r['total']>0,'Filtro de ciudad obtiene empresas de sucursales activas');
    foreach ($r['items'] as $item) check($item['ciudad']===$catalogos['ciudades'][0]['nombre'],'Ciudad mostrada coincide con filtro');
}
$r=$model->buscar($defaults);
if($r['total']>12) {
    $r2=$model->buscar(array_merge($defaults,['pagina'=>2,'orden'=>$r['orden']]));
    check(!array_intersect(array_column($r['items'],'idAfiliado'),array_column($r2['items'],'idAfiliado')),'Paginación sin empresas repetidas');
}
$busquedas=(int)$db->query("SELECT COUNT(*) FROM busquedas WHERE termino_normalizado='cafe'")->fetchColumn();
$visitas=(int)$db->query("SELECT COUNT(*) FROM interacciones_afiliados i JOIN busquedas b ON b.idBusqueda=i.idBusqueda WHERE b.termino_normalizado='cafe' AND i.tipo='VISITA_FICHA'")->fetchColumn();
check($busquedas>0 && $visitas>0,'RF17 búsqueda y consulta de ficha registradas por prueba de navegador');
