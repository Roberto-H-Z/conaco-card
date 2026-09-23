<?php
declare(strict_types=1);

/** Consultas de autenticación y pertenencia usadas por el RBAC. */
final class ModeloUsuarios
{
    public static function buscarParaAutenticacion(string $correo): ?array
    {
        $db = Conexion::conectar();
        $stmt = $db->prepare(
            'SELECT u.*, r.clave AS rol_clave, r.activo AS rol_activo
             FROM usuarios u
             INNER JOIN roles r ON r.idRol = u.idRol
             WHERE u.correo = :correo
             LIMIT 1'
        );
        $stmt->execute(['correo' => $correo]);
        $usuario = $stmt->fetch();
        if (!$usuario) return null;

        return self::completarAutorizacion($usuario);
    }

    /** Consulta la autorización vigente para invalidar sesiones con datos anteriores. */
    public static function buscarParaSesion(int $idUsuario): ?array
    {
        $stmt = Conexion::conectar()->prepare(
            'SELECT u.idUsuario, u.idRol, u.password_hash, u.activo, r.clave AS rol_clave, r.activo AS rol_activo
             FROM usuarios u
             INNER JOIN roles r ON r.idRol = u.idRol
             WHERE u.idUsuario = :id
             LIMIT 1'
        );
        $stmt->execute(['id' => $idUsuario]);
        $usuario = $stmt->fetch();
        return $usuario ? self::completarAutorizacion($usuario) : null;
    }

    private static function completarAutorizacion(array $usuario): array
    {
        $usuario['permisos'] = self::permisos((int) $usuario['idRol']);
        $usuario['idCamara'] = self::camaraAsignada((int) $usuario['idUsuario']);
        $usuario['afiliados'] = self::afiliadosAsignados((int) $usuario['idUsuario']);
        return $usuario;
    }

    public static function registrarFallo(int $idUsuario): void
    {
        $stmt = Conexion::conectar()->prepare(
            'UPDATE usuarios
             SET intentos_fallidos = intentos_fallidos + 1,
                 bloqueado_hasta = CASE
                    WHEN intentos_fallidos + 1 >= 5 THEN DATE_ADD(UTC_TIMESTAMP(6), INTERVAL 15 MINUTE)
                    ELSE bloqueado_hasta
                 END
             WHERE idUsuario = :id'
        );
        $stmt->execute(['id' => $idUsuario]);
    }

    public static function registrarIngreso(int $idUsuario, string $hashAnterior, ?string $nuevoHash = null): bool
    {
        $sql = 'UPDATE usuarios
                SET ultimo_acceso_at = UTC_TIMESTAMP(6), intentos_fallidos = 0, bloqueado_hasta = NULL';
        $params = ['id' => $idUsuario];
        if ($nuevoHash !== null) {
            $sql .= ', password_hash = :hash, password_actualizado_at = UTC_TIMESTAMP(6)';
            $params['hash'] = $nuevoHash;
        }
        $sql .= ' WHERE idUsuario = :id AND BINARY password_hash = BINARY :hash_anterior AND activo = 1';
        $params['hash_anterior'] = $hashAnterior;
        $stmt = Conexion::conectar()->prepare($sql);
        $stmt->execute($params);
        return $stmt->rowCount() === 1;
    }

    public static function afiliadoPerteneceACamara(int $idAfiliado, int $idCamara): bool
    {
        $stmt = Conexion::conectar()->prepare(
            'SELECT 1 FROM afiliados WHERE idAfiliado = :afiliado AND idCamara = :camara LIMIT 1'
        );
        $stmt->execute(['afiliado' => $idAfiliado, 'camara' => $idCamara]);
        return (bool) $stmt->fetchColumn();
    }

    public static function correoExiste(string $correo): bool
    {
        $stmt = Conexion::conectar()->prepare('SELECT 1 FROM usuarios WHERE correo = :correo LIMIT 1');
        $stmt->execute(['correo' => $correo]);
        return (bool) $stmt->fetchColumn();
    }

    /** Datos para la administración exclusiva del Administrador General. */
    public static function listarAdministracion(array $filtros, int $pagina, int $porPagina): array
    {
        $condiciones = [];
        $parametros = [];
        if ($filtros['q'] !== '') {
            $condiciones[] = '(u.nombre LIKE :q OR u.correo LIKE :q)';
            $parametros['q'] = '%' . $filtros['q'] . '%';
        }
        if ($filtros['rol'] > 0) { $condiciones[] = 'u.idRol = :rol'; $parametros['rol'] = $filtros['rol']; }
        if ($filtros['estado'] !== '') { $condiciones[] = 'u.activo = :estado'; $parametros['estado'] = (int) $filtros['estado']; }
        $where = $condiciones ? ' WHERE ' . implode(' AND ', $condiciones) : '';
        $db = Conexion::conectar();
        $conteo = $db->prepare('SELECT COUNT(*) FROM usuarios u' . $where);
        $conteo->execute($parametros);
        $total = (int) $conteo->fetchColumn();
        $paginas = max(1, (int) ceil($total / $porPagina));
        $pagina = min(max(1, $pagina), $paginas);
        $offset = ($pagina - 1) * $porPagina;
        $sql = "SELECT u.idUsuario,u.nombre,u.correo,u.idRol,u.activo,u.ultimo_acceso_at,r.clave AS rol_clave,r.nombre AS rol_nombre,
                       c.nombre AS camara_nombre,
                       (SELECT GROUP_CONCAT(a.nombre_comercial ORDER BY ua.es_principal DESC,a.nombre_comercial SEPARATOR ' | ')
                          FROM usuarios_afiliados ua INNER JOIN afiliados a ON a.idAfiliado=ua.idAfiliado
                         WHERE ua.idUsuario=u.idUsuario) AS afiliados_nombres
                  FROM usuarios u
                  INNER JOIN roles r ON r.idRol=u.idRol
                  LEFT JOIN usuarios_camaras uc ON uc.idUsuario=u.idUsuario
                  LEFT JOIN camaras c ON c.idCamara=uc.idCamara" . $where .
               ' ORDER BY u.activo DESC,u.nombre ASC,u.idUsuario DESC LIMIT :limite OFFSET :offset';
        $stmt = $db->prepare($sql);
        foreach ($parametros as $nombre => $valor) $stmt->bindValue(':' . $nombre, $valor, is_int($valor) ? PDO::PARAM_INT : PDO::PARAM_STR);
        $stmt->bindValue(':limite', $porPagina, PDO::PARAM_INT);
        $stmt->bindValue(':offset', $offset, PDO::PARAM_INT);
        $stmt->execute();
        return ['registros' => $stmt->fetchAll(), 'total' => $total, 'pagina' => $pagina, 'paginas' => $paginas, 'porPagina' => $porPagina];
    }

    public static function estadisticasAdministracion(): array
    {
        return Conexion::conectar()->query('SELECT COUNT(*) total, COALESCE(SUM(activo=1),0) activos, COALESCE(SUM(activo=0),0) inactivos, COUNT(DISTINCT idRol) perfiles FROM usuarios')->fetch() ?: [];
    }

    public static function rolesActivos(): array
    {
        return Conexion::conectar()->query('SELECT idRol,clave,nombre FROM roles WHERE activo=1 ORDER BY idRol')->fetchAll();
    }

    public static function camarasActivas(): array
    {
        return Conexion::conectar()->query('SELECT idCamara,COALESCE(nombre_corto,nombre) nombre FROM camaras WHERE activo=1 ORDER BY nombre')->fetchAll();
    }

    public static function afiliadosActivos(): array
    {
        return Conexion::conectar()->query('SELECT idAfiliado,nombre_comercial FROM afiliados WHERE activo=1 ORDER BY nombre_comercial')->fetchAll();
    }

    public static function obtenerAdministracion(int $idUsuario): ?array
    {
        $db = Conexion::conectar();
        $stmt = $db->prepare('SELECT idUsuario,idRol,nombre,correo,activo FROM usuarios WHERE idUsuario=:id');
        $stmt->execute(['id' => $idUsuario]);
        $usuario = $stmt->fetch();
        if (!$usuario) return null;
        $camara = $db->prepare('SELECT idCamara FROM usuarios_camaras WHERE idUsuario=:id');
        $camara->execute(['id' => $idUsuario]);
        $usuario['idCamara'] = $camara->fetchColumn() ?: null;
        $afiliados = $db->prepare('SELECT idAfiliado FROM usuarios_afiliados WHERE idUsuario=:id ORDER BY es_principal DESC,idAfiliado');
        $afiliados->execute(['id' => $idUsuario]);
        $usuario['afiliados'] = array_values(array_map('intval', $afiliados->fetchAll(PDO::FETCH_COLUMN)));
        return $usuario;
    }

    public static function correoExisteExcepto(string $correo, ?int $idUsuario = null): bool
    {
        $sql = 'SELECT 1 FROM usuarios WHERE correo=:correo' . ($idUsuario ? ' AND idUsuario<>:id' : '') . ' LIMIT 1';
        $stmt = Conexion::conectar()->prepare($sql);
        $params = ['correo' => $correo];
        if ($idUsuario) $params['id'] = $idUsuario;
        $stmt->execute($params);
        return (bool) $stmt->fetchColumn();
    }

    public static function rolActivo(int $idRol): ?string
    {
        $stmt = Conexion::conectar()->prepare('SELECT clave FROM roles WHERE idRol=:id AND activo=1');
        $stmt->execute(['id' => $idRol]);
        $clave = $stmt->fetchColumn();
        return $clave === false ? null : (string) $clave;
    }

    public static function camaraActiva(int $idCamara): bool
    {
        $stmt = Conexion::conectar()->prepare('SELECT 1 FROM camaras WHERE idCamara=:id AND activo=1');
        $stmt->execute(['id' => $idCamara]);
        return (bool) $stmt->fetchColumn();
    }

    public static function afiliadosActivosValidos(array $ids): bool
    {
        if (!$ids) return false;
        $marcadores = implode(',', array_fill(0, count($ids), '?'));
        $stmt = Conexion::conectar()->prepare("SELECT COUNT(*) FROM afiliados WHERE activo=1 AND idAfiliado IN ($marcadores)");
        $stmt->execute($ids);
        return (int) $stmt->fetchColumn() === count($ids);
    }

    public static function guardarAdministracion(PDO $db, array $datos): int
    {
        if ($datos['idUsuario'] === null) {
            $stmt = $db->prepare('INSERT INTO usuarios(idRol,nombre,correo,password_hash,password_actualizado_at,activo,desactivado_at) VALUES(:rol,:nombre,:correo,:password,UTC_TIMESTAMP(6),:activo,:desactivado)');
            $stmt->execute(['rol'=>$datos['idRol'],'nombre'=>$datos['nombre'],'correo'=>$datos['correo'],'password'=>password_hash($datos['password'], PASSWORD_DEFAULT),'activo'=>$datos['activo'] ? 1 : 0,'desactivado'=>$datos['activo'] ? null : gmdate('Y-m-d H:i:s')]);
            $idUsuario = (int) $db->lastInsertId();
        } else {
            $sql = 'UPDATE usuarios SET idRol=:rol,nombre=:nombre,correo=:correo,activo=:activo,desactivado_at=:desactivado';
            $params = ['rol'=>$datos['idRol'],'nombre'=>$datos['nombre'],'correo'=>$datos['correo'],'activo'=>$datos['activo'] ? 1 : 0,'desactivado'=>$datos['activo'] ? null : gmdate('Y-m-d H:i:s'),'id'=>$datos['idUsuario']];
            if ($datos['password'] !== '') { $sql .= ',password_hash=:password,password_actualizado_at=UTC_TIMESTAMP(6),intentos_fallidos=0,bloqueado_hasta=NULL'; $params['password'] = password_hash($datos['password'], PASSWORD_DEFAULT); }
            $sql .= ' WHERE idUsuario=:id';
            $db->prepare($sql)->execute($params);
            $idUsuario = $datos['idUsuario'];
        }
        $db->prepare('DELETE FROM usuarios_camaras WHERE idUsuario=?')->execute([$idUsuario]);
        $db->prepare('DELETE FROM usuarios_afiliados WHERE idUsuario=?')->execute([$idUsuario]);
        if ($datos['rolClave'] === 'ADMIN_CAMARA') $db->prepare('INSERT INTO usuarios_camaras(idUsuario,idCamara) VALUES(?,?)')->execute([$idUsuario, $datos['idCamara']]);
        if ($datos['rolClave'] === 'AFILIADO') {
            $vinculo = $db->prepare('INSERT INTO usuarios_afiliados(idUsuario,idAfiliado,es_principal) VALUES(?,?,?)');
            foreach ($datos['afiliados'] as $indice => $idAfiliado) $vinculo->execute([$idUsuario, $idAfiliado, $indice === 0 ? 1 : 0]);
        }
        return $idUsuario;
    }

    public static function cambiarEstadoAdministracion(int $idUsuario, bool $activo): bool
    {
        $stmt = Conexion::conectar()->prepare('UPDATE usuarios SET activo=:activo,desactivado_at=:fecha WHERE idUsuario=:id AND activo<>:activo_actual');
        $stmt->execute(['activo'=>$activo ? 1 : 0,'fecha'=>$activo ? null : gmdate('Y-m-d H:i:s'),'id'=>$idUsuario,'activo_actual'=>$activo ? 1 : 0]);
        return $stmt->rowCount() === 1;
    }

    /** Crea el acceso del afiliado y lo vincula a la empresa recién registrada. */
    public static function crearAccesoAfiliado(PDO $db, int $idAfiliado, string $nombre, string $correo, string $passwordHash): int
    {
        $rol = $db->prepare("SELECT idRol FROM roles WHERE clave = 'AFILIADO' AND activo = 1 LIMIT 1");
        $rol->execute();
        $idRol = $rol->fetchColumn();
        if ($idRol === false) throw new RuntimeException('El rol de afiliado no está disponible.');

        $usuario = $db->prepare(
            'INSERT INTO usuarios (idRol, nombre, correo, password_hash, password_actualizado_at, activo)
             VALUES (:rol, :nombre, :correo, :password, UTC_TIMESTAMP(6), 1)'
        );
        $usuario->execute(['rol' => $idRol, 'nombre' => $nombre, 'correo' => $correo, 'password' => $passwordHash]);
        $idUsuario = (int) $db->lastInsertId();

        $vinculo = $db->prepare('INSERT INTO usuarios_afiliados (idUsuario, idAfiliado, es_principal) VALUES (:usuario, :afiliado, 1)');
        $vinculo->execute(['usuario' => $idUsuario, 'afiliado' => $idAfiliado]);
        return $idUsuario;
    }

    /** Sustituye la contraseña del acceso afiliado dentro de una transacción controlada. */
    public static function actualizarPasswordAcceso(PDO $db, int $idUsuario, string $passwordHash): void
    {
        $stmt = $db->prepare(
            'UPDATE usuarios
             SET password_hash = :password,
                 password_actualizado_at = UTC_TIMESTAMP(6),
                 intentos_fallidos = 0,
                 bloqueado_hasta = NULL
             WHERE idUsuario = :usuario AND activo = 1'
        );
        $stmt->execute(['password' => $passwordHash, 'usuario' => $idUsuario]);
        if ($stmt->rowCount() !== 1) {
            throw new RuntimeException('No fue posible actualizar la contraseña del usuario afiliado.');
        }
    }

    private static function permisos(int $idRol): array
    {
        $stmt = Conexion::conectar()->prepare(
            'SELECT p.clave
             FROM roles_permisos rp
             INNER JOIN permisos p ON p.idPermiso = rp.idPermiso
             WHERE rp.idRol = :rol AND p.activo = 1'
        );
        $stmt->execute(['rol' => $idRol]);
        return array_values(array_map('strval', $stmt->fetchAll(PDO::FETCH_COLUMN)));
    }

    private static function camaraAsignada(int $idUsuario): ?int
    {
        $stmt = Conexion::conectar()->prepare('SELECT idCamara FROM usuarios_camaras WHERE idUsuario = :id LIMIT 1');
        $stmt->execute(['id' => $idUsuario]);
        $idCamara = $stmt->fetchColumn();
        return $idCamara === false ? null : (int) $idCamara;
    }

    private static function afiliadosAsignados(int $idUsuario): array
    {
        $stmt = Conexion::conectar()->prepare('SELECT idAfiliado FROM usuarios_afiliados WHERE idUsuario = :id');
        $stmt->execute(['id' => $idUsuario]);
        return array_values(array_map('intval', $stmt->fetchAll(PDO::FETCH_COLUMN)));
    }
}
