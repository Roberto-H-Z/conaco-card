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

    public static function registrarIngreso(int $idUsuario, ?string $nuevoHash = null): void
    {
        $sql = 'UPDATE usuarios
                SET ultimo_acceso_at = UTC_TIMESTAMP(6), intentos_fallidos = 0, bloqueado_hasta = NULL';
        $params = ['id' => $idUsuario];
        if ($nuevoHash !== null) {
            $sql .= ', password_hash = :hash, password_actualizado_at = UTC_TIMESTAMP(6)';
            $params['hash'] = $nuevoHash;
        }
        $sql .= ' WHERE idUsuario = :id';
        Conexion::conectar()->prepare($sql)->execute($params);
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
