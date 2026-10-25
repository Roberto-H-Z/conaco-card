<?php
declare(strict_types=1);

final class ModeloCamarasAdmin
{
    public static function listar(string $q = '', string $activo = ''): array
    {
        $where = []; $params = [];
        if ($q !== '') {
            $where[] = '(c.nombre LIKE ? OR c.clave LIKE ? OR c.nombre_corto LIKE ?)';
            $params = array_fill(0, 3, '%' . $q . '%');
        }
        if ($activo !== '') { $where[] = 'c.activo=?'; $params[] = (int)$activo; }
        $sql = 'SELECT c.*,m.nombre sede,e.nombre estado_sede,
            (SELECT COUNT(*) FROM afiliados a WHERE a.idCamara=c.idCamara) afiliados,
            (SELECT COUNT(*) FROM camaras_municipios cm WHERE cm.idCamara=c.idCamara AND cm.activo=1) ciudades
            FROM camaras c LEFT JOIN municipios m ON m.idMunicipio=c.idMunicipioSede
            LEFT JOIN estados e ON e.idEstado=m.idEstado';
        $stmt = Conexion::conectar()->prepare($sql . ($where ? ' WHERE '.implode(' AND ', $where) : '') . ' ORDER BY c.activo DESC,c.nombre,c.idCamara');
        $stmt->execute($params);
        return $stmt->fetchAll();
    }

    public static function obtener(int $id): ?array
    {
        $stmt = Conexion::conectar()->prepare('SELECT * FROM camaras WHERE idCamara=?');
        $stmt->execute([$id]); $camara = $stmt->fetch();
        if (!$camara) return null;
        $stmt = Conexion::conectar()->prepare('SELECT idMunicipio,tipo_cobertura FROM camaras_municipios WHERE idCamara=? AND activo=1 ORDER BY idMunicipio');
        $stmt->execute([$id]); $camara['ciudades'] = $stmt->fetchAll();
        return $camara;
    }

    public static function guardar(PDO $db, array $datos, array $ciudades): int
    {
        $valores = [$datos['clave'],$datos['nombre'],$datos['nombre_corto'] ?: null,$datos['correo'] ?: null,$datos['telefono'] ?: null,$datos['idMunicipioSede'],$datos['activo']];
        if ($datos['idCamara']) {
            $valores[] = $datos['idCamara'];
            $db->prepare('UPDATE camaras SET clave=?,nombre=?,nombre_corto=?,correo=?,telefono=?,idMunicipioSede=?,activo=? WHERE idCamara=?')->execute($valores);
            $id = $datos['idCamara'];
        } else {
            $db->prepare('INSERT INTO camaras(clave,nombre,nombre_corto,correo,telefono,idMunicipioSede,activo) VALUES(?,?,?,?,?,?,?)')->execute($valores);
            $id = (int)$db->lastInsertId();
        }
        // Se conservan las asignaciones anteriores como inactivas.
        $db->prepare('UPDATE camaras_municipios SET activo=0 WHERE idCamara=?')->execute([$id]);
        $stmt = $db->prepare('INSERT INTO camaras_municipios(idCamara,idMunicipio,tipo_cobertura,activo) VALUES(?,?,?,1) ON DUPLICATE KEY UPDATE tipo_cobertura=VALUES(tipo_cobertura),activo=1');
        foreach ($ciudades as $municipio => $tipo) $stmt->execute([$id,$municipio,$tipo]);
        return $id;
    }

    public static function cambiarEstado(int $id, bool $activo): bool
    {
        $stmt = Conexion::conectar()->prepare('UPDATE camaras SET activo=? WHERE idCamara=? AND activo<>?');
        $stmt->execute([(int)$activo,$id,(int)$activo]);
        return $stmt->rowCount() === 1;
    }
}
