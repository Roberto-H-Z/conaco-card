<?php
declare(strict_types=1);

final class ModeloAfiliados
{
    public static function listar(array $filtros, int $pagina, int $porPagina): array
    {
        $condiciones = [];
        $parametros = [];
        if ($filtros['busqueda'] !== '') {
            $condiciones[] = '(a.nombre_comercial LIKE :q1 OR a.razon_social LIKE :q2 OR a.alias LIKE :q3 OR a.rfc LIKE :q4)';
            foreach (['q1', 'q2', 'q3', 'q4'] as $nombre) $parametros[$nombre] = '%' . $filtros['busqueda'] . '%';
        }
        if ($filtros['estado'] !== '') { $condiciones[] = 'a.activo = :estado'; $parametros['estado'] = (int) $filtros['estado']; }
        if ($filtros['camara'] > 0) { $condiciones[] = 'a.idCamara = :camara'; $parametros['camara'] = $filtros['camara']; }
        if ($filtros['localidad'] > 0) { $condiciones[] = 'EXISTS (SELECT 1 FROM sucursales sf WHERE sf.idAfiliado = a.idAfiliado AND sf.es_matriz = 1 AND sf.activo = 1 AND sf.idLocalidad = :localidad)'; $parametros['localidad'] = $filtros['localidad']; }
        if ($filtros['categoria'] > 0) { $condiciones[] = 'EXISTS (SELECT 1 FROM afiliados_categorias acf WHERE acf.idAfiliado = a.idAfiliado AND acf.idCategoria = :categoria)'; $parametros['categoria'] = $filtros['categoria']; }
        $where = $condiciones ? ' WHERE ' . implode(' AND ', $condiciones) : '';
        $pdo = Conexion::conectar();
        $conteo = $pdo->prepare('SELECT COUNT(*) FROM afiliados a' . $where);
        self::vincular($conteo, $parametros); $conteo->execute(); $total = (int) $conteo->fetchColumn();
        $paginas = max(1, (int) ceil($total / $porPagina)); $pagina = min(max(1, $pagina), $paginas); $offset = ($pagina - 1) * $porPagina;
        $sql = 'SELECT a.idAfiliado, a.idCamara, a.rfc, a.razon_social, a.nombre_comercial, a.alias, a.correo_general, a.activo, c.nombre AS camara_nombre,
                       (SELECT l.nombre FROM sucursales s INNER JOIN localidades l ON l.idLocalidad=s.idLocalidad WHERE s.idAfiliado=a.idAfiliado AND s.es_matriz=1 AND s.activo=1 LIMIT 1) AS localidad_nombre,
                       (SELECT cat.nombre FROM afiliados_categorias ac INNER JOIN categorias cat ON cat.idCategoria=ac.idCategoria WHERE ac.idAfiliado=a.idAfiliado AND ac.es_principal=1 LIMIT 1) AS categoria_nombre
                  FROM afiliados a INNER JOIN camaras c ON c.idCamara=a.idCamara' . $where .
               ' ORDER BY a.activo DESC, a.actualizado_at DESC, a.idAfiliado DESC LIMIT :limite OFFSET :offset';
        $stmt = $pdo->prepare($sql); self::vincular($stmt, $parametros);
        $stmt->bindValue(':limite', $porPagina, PDO::PARAM_INT); $stmt->bindValue(':offset', $offset, PDO::PARAM_INT); $stmt->execute();
        return ['registros' => $stmt->fetchAll(), 'total' => $total, 'pagina' => $pagina, 'paginas' => $paginas, 'porPagina' => $porPagina];
    }

    public static function estadisticas(): array
    {
        return Conexion::conectar()->query('SELECT COUNT(*) total, COALESCE(SUM(activo=1),0) activos, COALESCE(SUM(activo=0),0) inactivos, COUNT(DISTINCT idCamara) camaras FROM afiliados')->fetch() ?: [];
    }

    public static function obtenerPorId(int $id): ?array
    {
        $pdo = Conexion::conectar();
        $stmt = $pdo->prepare('SELECT * FROM afiliados WHERE idAfiliado=:id'); $stmt->execute(['id' => $id]); $a = $stmt->fetch();
        if (!$a) return null;
        $a['contacto'] = self::fila($pdo, 'SELECT nombre,cargo,correo,telefono FROM contactos_afiliados WHERE idAfiliado=:id AND activo=1 ORDER BY es_principal DESC,idContactoAfiliado LIMIT 1', $id);
        $a['matriz'] = self::fila($pdo, 'SELECT s.*,l.idMunicipio,m.idEstado FROM sucursales s INNER JOIN localidades l ON l.idLocalidad=s.idLocalidad INNER JOIN municipios m ON m.idMunicipio=l.idMunicipio WHERE s.idAfiliado=:id AND s.es_matriz=1 AND s.activo=1 LIMIT 1', $id);
        $a['telefonos'] = self::filas($pdo, 'SELECT tipo,numero_original FROM sucursales_telefonos WHERE idSucursal=:id AND activo=1', (int) ($a['matriz']['idSucursal'] ?? 0));
        $a['canales'] = self::filas($pdo, 'SELECT tipo,url FROM canales_digitales WHERE idAfiliado=:id AND idSucursal IS NULL AND activo=1', $id);
        $a['categorias'] = self::filas($pdo, 'SELECT idCategoria FROM afiliados_categorias WHERE idAfiliado=:id ORDER BY es_principal DESC,orden', $id);
        $a['palabras_clave'] = self::filas($pdo, 'SELECT palabra FROM afiliados_palabras_clave WHERE idAfiliado=:id AND activo=1 ORDER BY idAfiliadoPalabraClave', $id);
        $a['archivos'] = self::filas($pdo, 'SELECT aa.tipo,aa.orden,aa.texto_alternativo,f.idArchivo,f.url_publica,f.nombre_original FROM afiliados_archivos aa INNER JOIN archivos f ON f.idArchivo=aa.idArchivo WHERE aa.idAfiliado=:id AND aa.activo=1 AND f.activo=1 ORDER BY aa.tipo,aa.orden', $id);
        return $a;
    }

    public static function obtenerCamaras(): array { return Conexion::conectar()->query('SELECT idCamara,COALESCE(nombre_corto,nombre) nombre FROM camaras WHERE activo=1 ORDER BY nombre')->fetchAll(); }
    public static function obtenerEstados(): array { return Conexion::conectar()->query('SELECT idEstado,nombre FROM estados WHERE activo=1 ORDER BY nombre')->fetchAll(); }
    public static function obtenerMunicipios(int $estado): array { return self::consulta('SELECT idMunicipio,nombre FROM municipios WHERE idEstado=:id AND activo=1 ORDER BY nombre', $estado); }
    public static function obtenerLocalidades(int $municipio): array { return self::consulta('SELECT idLocalidad,nombre FROM localidades WHERE idMunicipio=:id AND activo=1 ORDER BY nombre', $municipio); }
    public static function obtenerLocalidadesParaFiltro(): array { return Conexion::conectar()->query('SELECT l.idLocalidad, CONCAT(l.nombre, " — ", m.nombre, ", ", e.nombre) nombre FROM localidades l INNER JOIN municipios m ON m.idMunicipio=l.idMunicipio INNER JOIN estados e ON e.idEstado=m.idEstado WHERE l.activo=1 AND m.activo=1 AND e.activo=1 ORDER BY e.nombre,m.nombre,l.nombre')->fetchAll(); }
    public static function obtenerCategorias(): array { return Conexion::conectar()->query('SELECT idCategoria,nombre,idCategoriaPadre FROM categorias WHERE activo=1 ORDER BY nombre')->fetchAll(); }
    public static function camaraActivaExiste(int $id): bool { return self::existe('SELECT 1 FROM camaras WHERE idCamara=:id AND activo=1', $id); }
    public static function localidadActivaExiste(int $id): bool { return self::existe('SELECT 1 FROM localidades WHERE idLocalidad=:id AND activo=1', $id); }
    public static function categoriasValidas(array $ids): bool { if (!$ids) return false; $in = implode(',', array_fill(0,count($ids),'?')); $s=Conexion::conectar()->prepare("SELECT COUNT(*) FROM categorias WHERE activo=1 AND idCategoria IN ($in)"); $s->execute($ids); return (int)$s->fetchColumn()===count($ids); }
    public static function slugExiste(string $slug, ?int $excepto=null): bool { $sql='SELECT 1 FROM afiliados WHERE slug=:slug'.($excepto?' AND idAfiliado<>:id':'');$s=Conexion::conectar()->prepare($sql);$s->execute($excepto?['slug'=>$slug,'id'=>$excepto]:['slug'=>$slug]);return(bool)$s->fetchColumn(); }

    public static function guardarCompleto(PDO $pdo, array $d): int
    {
        $nulos=['razon_social','alias']; foreach($nulos as $campo) if($d[$campo]==='') $d[$campo]=null;
        if ($d['idAfiliado'] === null) {
            $s=$pdo->prepare('INSERT INTO afiliados(idCamara,rfc,razon_social,nombre_comercial,alias,slug,descripcion,correo_general) VALUES(:idCamara,:rfc,:razon_social,:nombre_comercial,:alias,:slug,:descripcion,:correo_general)');
        } else {
            $s=$pdo->prepare('UPDATE afiliados SET idCamara=:idCamara,rfc=:rfc,razon_social=:razon_social,nombre_comercial=:nombre_comercial,alias=:alias,slug=:slug,descripcion=:descripcion,correo_general=:correo_general WHERE idAfiliado=:idAfiliado'); $s->bindValue(':idAfiliado',$d['idAfiliado'],PDO::PARAM_INT);
        }
        foreach(['idCamara','rfc','razon_social','nombre_comercial','alias','slug','descripcion','correo_general'] as $c) $s->bindValue(':'.$c,$d[$c],$c==='idCamara'?PDO::PARAM_INT:($d[$c]===null?PDO::PARAM_NULL:PDO::PARAM_STR)); $s->execute();
        $id=$d['idAfiliado']??(int)$pdo->lastInsertId(); self::guardarContacto($pdo,$id,$d); $sucursal=self::guardarMatriz($pdo,$id,$d); self::guardarTelefonos($pdo,$sucursal,$d); self::guardarCanales($pdo,$id,$d); self::guardarCategorias($pdo,$id,$d['categorias']); self::guardarPalabras($pdo,$id,$d['palabras']);
        return $id;
    }

    public static function guardarArchivo(PDO $pdo,int $afiliado,array $archivo,string $tipo,int $orden): void
    {
        $s=$pdo->prepare('INSERT INTO archivos(nombre_original,storage_key,url_publica,mime_type,peso_bytes,ancho_px,alto_px,checksum_sha256) VALUES(:nombre,:key,:url,:mime,:peso,:ancho,:alto,:hash)');$s->execute(['nombre'=>$archivo['nombre'],'key'=>$archivo['key'],'url'=>$archivo['url'],'mime'=>$archivo['mime'],'peso'=>$archivo['peso'],'ancho'=>$archivo['ancho'],'alto'=>$archivo['alto'],'hash'=>$archivo['hash']]);$id=(int)$pdo->lastInsertId();
        if($tipo==='LOGOTIPO') $pdo->prepare("UPDATE afiliados_archivos SET activo=0 WHERE idAfiliado=? AND tipo='LOGOTIPO' AND activo=1")->execute([$afiliado]);
        $pdo->prepare('INSERT INTO afiliados_archivos(idAfiliado,idArchivo,tipo,orden,texto_alternativo) VALUES(?,?,?,?,?)')->execute([$afiliado,$id,$tipo,$orden,$archivo['alt']]);
    }

    public static function cambiarEstado(int $id,bool $activo,?string $motivo): bool { $s=Conexion::conectar()->prepare('UPDATE afiliados SET activo=:activo,desactivado_at=:fecha,motivo_desactivacion=:motivo WHERE idAfiliado=:id');$s->execute(['activo'=>$activo?1:0,'fecha'=>$activo?null:gmdate('Y-m-d H:i:s'),'motivo'=>$activo?null:$motivo,'id'=>$id]);return$s->rowCount()>0; }

    private static function guardarContacto(PDO $p,int $id,array $d):void { $actual=self::fila($p,'SELECT idContactoAfiliado FROM contactos_afiliados WHERE idAfiliado=:id AND activo=1 ORDER BY es_principal DESC LIMIT 1',$id);$sql=$actual?'UPDATE contactos_afiliados SET nombre=?,cargo=?,correo=?,telefono=?,es_principal=1 WHERE idContactoAfiliado=?':'INSERT INTO contactos_afiliados(idAfiliado,nombre,cargo,correo,telefono,es_principal,es_publico) VALUES(?,?,?,?,?,1,0)';$v=$actual?[$d['encargado'],$d['cargo_encargado']?:null,$d['correo_general'],$d['telefono'],$actual['idContactoAfiliado']]:[$id,$d['encargado'],$d['cargo_encargado']?:null,$d['correo_general'],$d['telefono']];$p->prepare($sql)->execute($v); }
    private static function guardarMatriz(PDO $p,int $id,array $d):int { $a=self::fila($p,'SELECT idSucursal FROM sucursales WHERE idAfiliado=:id AND es_matriz=1 AND activo=1 LIMIT 1',$id);$campos=['idLocalidad','calle','numero_exterior','numero_interior','colonia','codigo_postal','referencias','latitud','longitud','google_place_id'];if($a){$sets=implode(',',array_map(fn($x)=>"$x=?",$campos));$v=array_map(fn($x)=>$d[$x]?:null,$campos);$v[]=$a['idSucursal'];$p->prepare("UPDATE sucursales SET $sets WHERE idSucursal=?")->execute($v);return(int)$a['idSucursal'];}$v=array_map(fn($x)=>$d[$x]?:null,$campos);array_unshift($v,$id);$p->prepare('INSERT INTO sucursales(idAfiliado,idLocalidad,calle,numero_exterior,numero_interior,colonia,codigo_postal,referencias,latitud,longitud,google_place_id,es_matriz) VALUES(?,?,?,?,?,?,?,?,?,?,?,1)')->execute($v);return(int)$p->lastInsertId(); }
    private static function guardarTelefonos(PDO $p,int $sucursal,array $d):void { foreach(['TELEFONO'=>'telefono','WHATSAPP'=>'whatsapp'] as $tipo=>$campo){$numero=$d[$campo]??'';$actual=self::fila($p,'SELECT idSucursalTelefono FROM sucursales_telefonos WHERE idSucursal=:id AND tipo=:tipo ORDER BY activo DESC LIMIT 1',$sucursal,['tipo'=>$tipo]);if($numero===''){if($actual)$p->prepare('UPDATE sucursales_telefonos SET activo=0 WHERE idSucursalTelefono=?')->execute([$actual['idSucursalTelefono']]);continue;}$normal=preg_replace('/\D+/','',$numero);if($actual)$p->prepare('UPDATE sucursales_telefonos SET numero_original=?,numero_normalizado=?,activo=1,es_principal=1 WHERE idSucursalTelefono=?')->execute([$numero,$normal,$actual['idSucursalTelefono']]);else $p->prepare('INSERT INTO sucursales_telefonos(idSucursal,tipo,numero_original,numero_normalizado,es_principal) VALUES(?,?,?,?,1)')->execute([$sucursal,$tipo,$numero,$normal]);} }
    private static function guardarCanales(PDO $p,int $id,array $d):void { foreach(['FACEBOOK'=>'facebook','INSTAGRAM'=>'instagram','SITIO_WEB'=>'sitio_web'] as $tipo=>$campo){$url=$d[$campo]??'';$a=self::fila($p,'SELECT idCanalDigital FROM canales_digitales WHERE idAfiliado=:id AND idSucursal IS NULL AND tipo=:tipo ORDER BY activo DESC LIMIT 1',$id,['tipo'=>$tipo]);if($url===''){if($a)$p->prepare('UPDATE canales_digitales SET activo=0 WHERE idCanalDigital=?')->execute([$a['idCanalDigital']]);continue;}if($a)$p->prepare('UPDATE canales_digitales SET url=?,activo=1,es_principal=1 WHERE idCanalDigital=?')->execute([$url,$a['idCanalDigital']]);else $p->prepare('INSERT INTO canales_digitales(idAfiliado,tipo,url,es_principal) VALUES(?,?,?,1)')->execute([$id,$tipo,$url]);} }
    private static function guardarCategorias(PDO $p,int $id,array $cats):void { $p->prepare('DELETE FROM afiliados_categorias WHERE idAfiliado=?')->execute([$id]);$s=$p->prepare('INSERT INTO afiliados_categorias(idAfiliado,idCategoria,es_principal,orden) VALUES(?,?,?,?)');foreach($cats as $i=>$cat)$s->execute([$id,$cat,$i===0?1:0,$i+1]); }
    private static function guardarPalabras(PDO $p,int $id,array $palabras):void {$p->prepare('UPDATE afiliados_palabras_clave SET activo=0 WHERE idAfiliado=?')->execute([$id]);foreach($palabras as $palabra){$normal=mb_strtolower(trim($palabra),'UTF-8');$a=self::fila($p,'SELECT idAfiliadoPalabraClave FROM afiliados_palabras_clave WHERE idAfiliado=:id AND palabra_normalizada=:normal',$id,['normal'=>$normal]);if($a)$p->prepare('UPDATE afiliados_palabras_clave SET palabra=?,activo=1 WHERE idAfiliadoPalabraClave=?')->execute([$palabra,$a['idAfiliadoPalabraClave']]);else $p->prepare('INSERT INTO afiliados_palabras_clave(idAfiliado,palabra,palabra_normalizada) VALUES(?,?,?)')->execute([$id,$palabra,$normal]);} }
    private static function consulta(string $sql,int $id):array{$s=Conexion::conectar()->prepare($sql);$s->execute(['id'=>$id]);return$s->fetchAll();}
    private static function existe(string $sql,int $id):bool{$s=Conexion::conectar()->prepare($sql);$s->execute(['id'=>$id]);return(bool)$s->fetchColumn();}
    private static function fila(PDO $p,string $sql,int $id,array $extra=[]):?array{$s=$p->prepare($sql);$s->execute(['id'=>$id]+$extra);return$s->fetch()?:null;}
    private static function filas(PDO $p,string $sql,int $id):array{$s=$p->prepare($sql);$s->execute(['id'=>$id]);return$s->fetchAll();}
    private static function vincular(PDOStatement $s,array $p):void{foreach($p as $n=>$v)$s->bindValue(':'.$n,$v,is_int($v)?PDO::PARAM_INT:PDO::PARAM_STR);}
}
