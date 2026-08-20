<?php
declare(strict_types=1);

final class ModeloPromociones
{
    public static function listar(array $f, int $pagina=1, int $porPagina=12): array
    {
        $w=[];$p=[];
        if($f['q']!==''){$w[]='(p.titulo LIKE :q OR p.descripcion LIKE :q)';$p['q']='%'.$f['q'].'%';}
        if($f['afiliado']>0){$w[]='p.idAfiliado=:afiliado';$p['afiliado']=$f['afiliado'];}
        if($f['estado']!==''){$w[]='p.activo=:activo';$p['activo']=(int)$f['estado'];}
        $where=$w?' WHERE '.implode(' AND ',$w):'';$db=Conexion::conectar();
        $count=$db->prepare('SELECT COUNT(*) FROM promociones p'.$where);self::bind($count,$p);$count->execute();$total=(int)$count->fetchColumn();$paginas=max(1,(int)ceil($total/$porPagina));$pagina=min(max(1,$pagina),$paginas);
        $sql='SELECT p.*,a.nombre_comercial, (SELECT f.url_publica FROM promociones_archivos pa INNER JOIN archivos f ON f.idArchivo=pa.idArchivo WHERE pa.idPromocion=p.idPromocion AND pa.activo=1 AND f.activo=1 ORDER BY pa.orden LIMIT 1) imagen_principal FROM promociones p INNER JOIN afiliados a ON a.idAfiliado=p.idAfiliado'.$where.' ORDER BY p.activo DESC, p.inicio_vigencia DESC, p.idPromocion DESC LIMIT :limite OFFSET :offset';
        $s=$db->prepare($sql);self::bind($s,$p);$s->bindValue(':limite',$porPagina,PDO::PARAM_INT);$s->bindValue(':offset',($pagina-1)*$porPagina,PDO::PARAM_INT);$s->execute();return ['registros'=>$s->fetchAll(),'total'=>$total,'pagina'=>$pagina,'paginas'=>$paginas];
    }
    public static function estadisticas():array{return Conexion::conectar()->query("SELECT COUNT(*) total,COALESCE(SUM(activo=1 AND CURRENT_TIMESTAMP BETWEEN inicio_vigencia AND fin_vigencia),0) vigentes,COALESCE(SUM(activo=1 AND inicio_vigencia>CURRENT_TIMESTAMP),0) programadas,COALESCE(SUM(activo=0),0) inactivas FROM promociones")->fetch()?:[];}
    public static function afiliadosActivos():array{return Conexion::conectar()->query('SELECT idAfiliado,nombre_comercial FROM afiliados WHERE activo=1 ORDER BY nombre_comercial')->fetchAll();}
    public static function afiliadoActivoExiste(int $id):bool{$s=Conexion::conectar()->prepare('SELECT 1 FROM afiliados WHERE idAfiliado=? AND activo=1');$s->execute([$id]);return(bool)$s->fetchColumn();}
    public static function obtener(int $id):?array{$db=Conexion::conectar();$s=$db->prepare('SELECT p.*,a.nombre_comercial FROM promociones p INNER JOIN afiliados a ON a.idAfiliado=p.idAfiliado WHERE p.idPromocion=?');$s->execute([$id]);$r=$s->fetch();if(!$r)return null;$s=$db->prepare('SELECT pa.idArchivo,pa.orden,pa.texto_alternativo,f.nombre_original,f.url_publica FROM promociones_archivos pa INNER JOIN archivos f ON f.idArchivo=pa.idArchivo WHERE pa.idPromocion=? AND pa.activo=1 AND f.activo=1 ORDER BY pa.orden');$s->execute([$id]);$r['archivos']=$s->fetchAll();return$r;}
    public static function guardar(PDO $db,array $d):int{if($d['idPromocion']){$s=$db->prepare('UPDATE promociones SET idAfiliado=:idAfiliado,titulo=:titulo,descripcion=:descripcion,restricciones=:restricciones,inicio_vigencia=:inicio,fin_vigencia=:fin WHERE idPromocion=:id');$s->execute(['idAfiliado'=>$d['idAfiliado'],'titulo'=>$d['titulo'],'descripcion'=>$d['descripcion'],'restricciones'=>$d['restricciones']?:null,'inicio'=>$d['inicio'],'fin'=>$d['fin'],'id'=>$d['idPromocion']]);return$d['idPromocion'];}$s=$db->prepare('INSERT INTO promociones(idAfiliado,titulo,descripcion,restricciones,inicio_vigencia,fin_vigencia) VALUES(:idAfiliado,:titulo,:descripcion,:restricciones,:inicio,:fin)');$s->execute(['idAfiliado'=>$d['idAfiliado'],'titulo'=>$d['titulo'],'descripcion'=>$d['descripcion'],'restricciones'=>$d['restricciones']?:null,'inicio'=>$d['inicio'],'fin'=>$d['fin']]);return(int)$db->lastInsertId();}
    public static function agregarArchivo(PDO $db,int $promocion,array $a,int $orden):void{$s=$db->prepare('INSERT INTO archivos(nombre_original,storage_key,url_publica,mime_type,peso_bytes,ancho_px,alto_px,checksum_sha256) VALUES(:nombre,:key,:url,:mime,:peso,:ancho,:alto,:hash)');$s->execute(['nombre'=>$a['nombre'],'key'=>$a['key'],'url'=>$a['url'],'mime'=>$a['mime'],'peso'=>$a['peso'],'ancho'=>$a['ancho'],'alto'=>$a['alto'],'hash'=>$a['hash']]);$db->prepare('INSERT INTO promociones_archivos(idPromocion,idArchivo,orden,texto_alternativo) VALUES(?,?,?,?)')->execute([$promocion,(int)$db->lastInsertId(),$orden,$a['alt']]);}
    public static function totalImagenes(int $id):int{$s=Conexion::conectar()->prepare('SELECT COUNT(*) FROM promociones_archivos WHERE idPromocion=? AND activo=1');$s->execute([$id]);return(int)$s->fetchColumn();}
    public static function cambiarEstado(int $id,bool $activo):bool{$s=Conexion::conectar()->prepare('UPDATE promociones SET activo=?,desactivado_at=? WHERE idPromocion=?');$s->execute([$activo?1:0,$activo?null:gmdate('Y-m-d H:i:s'),$id]);return$s->rowCount()>0;}
    private static function bind(PDOStatement $s,array $p):void{foreach($p as$n=>$v)$s->bindValue(':'.$n,$v,is_int($v)?PDO::PARAM_INT:PDO::PARAM_STR);}
}
