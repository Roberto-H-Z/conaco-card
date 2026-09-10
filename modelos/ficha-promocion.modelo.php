<?php
declare(strict_types=1);

/** Consultas públicas de una promoción vigente, resueltas en un número fijo de lecturas. */
class ModeloFichaPromocion
{
    private \PDO $db;

    public function __construct()
    {
        $this->db = Conexion::conectar();
    }

    public function obtenerVigentePorId(int $idPromocion): ?array
    {
        $promocion = $this->obtenerPromocion($idPromocion);
        if ($promocion === null) {
            return null;
        }

        $idAfiliado = (int) $promocion['idAfiliado'];
        $promocion['imagenes'] = $this->obtenerImagenes($idPromocion);
        $promocion['canales'] = $this->obtenerCanales($idAfiliado);
        $promocion['telefonos'] = $this->obtenerTelefonos($idAfiliado);
        $promocion['otras_promociones'] = $this->obtenerOtrasPromociones($idPromocion, $idAfiliado);

        return $promocion;
    }

    private function obtenerPromocion(int $idPromocion): ?array
    {
        $sql = 'SELECT p.idPromocion, p.idAfiliado, p.titulo, p.descripcion,
                       p.restricciones, p.inicio_vigencia, p.fin_vigencia,
                       a.nombre_comercial, a.alias, a.slug AS afiliado_slug,
                       a.descripcion AS afiliado_descripcion, a.correo_general,
                       c.nombre AS camara_nombre, cat.nombre AS categoria_principal,
                       logo.url_publica AS logo_url, logo.ancho_px AS logo_ancho,
                       logo.alto_px AS logo_alto
                  FROM promociones p
                 INNER JOIN afiliados a ON a.idAfiliado = p.idAfiliado AND a.activo = 1
                 INNER JOIN camaras c ON c.idCamara = a.idCamara AND c.activo = 1
             LEFT JOIN afiliados_categorias ac
                    ON ac.idAfiliado = a.idAfiliado AND ac.es_principal = 1
             LEFT JOIN categorias cat
                    ON cat.idCategoria = ac.idCategoria AND cat.activo = 1
             LEFT JOIN afiliados_archivos aa
                    ON aa.idAfiliado = a.idAfiliado AND aa.tipo = \'LOGOTIPO\'
                   AND aa.activo = 1
             LEFT JOIN archivos logo
                    ON logo.idArchivo = aa.idArchivo AND logo.activo = 1
                 WHERE p.idPromocion = :idPromocion
                   AND p.activo = 1
                   AND CURRENT_TIMESTAMP() BETWEEN p.inicio_vigencia AND p.fin_vigencia
                 LIMIT 1';

        $stmt = $this->db->prepare($sql);
        $stmt->execute([':idPromocion' => $idPromocion]);
        $fila = $stmt->fetch(\PDO::FETCH_ASSOC);

        return $fila ?: null;
    }

    private function obtenerImagenes(int $idPromocion): array
    {
        $sql = 'SELECT pa.orden, pa.texto_alternativo, f.url_publica,
                       f.ancho_px, f.alto_px
                  FROM promociones_archivos pa
                 INNER JOIN archivos f ON f.idArchivo = pa.idArchivo AND f.activo = 1
                 WHERE pa.idPromocion = :idPromocion AND pa.activo = 1
                 ORDER BY pa.orden ASC';

        return $this->consultarTodas($sql, [':idPromocion' => $idPromocion]);
    }

    private function obtenerCanales(int $idAfiliado): array
    {
        $sql = 'SELECT tipo, url, nombre_usuario, es_principal
                  FROM canales_digitales
                 WHERE idAfiliado = :idAfiliado AND idSucursal IS NULL AND activo = 1
                 ORDER BY es_principal DESC, tipo ASC';

        return $this->consultarTodas($sql, [':idAfiliado' => $idAfiliado]);
    }

    private function obtenerTelefonos(int $idAfiliado): array
    {
        $sql = 'SELECT st.tipo, st.numero_original, st.numero_normalizado,
                       st.extension_telefono, st.etiqueta, st.es_principal
                  FROM sucursales s
                 INNER JOIN sucursales_telefonos st
                    ON st.idSucursal = s.idSucursal AND st.activo = 1
                 WHERE s.idAfiliado = :idAfiliado AND s.activo = 1
                 ORDER BY s.es_matriz DESC, st.es_principal DESC,
                          FIELD(st.tipo, \'WHATSAPP\', \'TELEFONO\'), st.idSucursalTelefono ASC';

        return $this->consultarTodas($sql, [':idAfiliado' => $idAfiliado]);
    }

    private function obtenerOtrasPromociones(int $idPromocion, int $idAfiliado): array
    {
        $sql = 'SELECT p.idPromocion, p.titulo, p.descripcion, p.fin_vigencia,
                       imagen.url_publica AS imagen_url,
                       imagen.texto_alternativo
                  FROM promociones p
             LEFT JOIN (
                       SELECT pa.idPromocion, pa.texto_alternativo, f.url_publica
                         FROM promociones_archivos pa
                        INNER JOIN archivos f ON f.idArchivo = pa.idArchivo AND f.activo = 1
                        WHERE pa.activo = 1 AND pa.orden = 1
                       ) imagen ON imagen.idPromocion = p.idPromocion
                 WHERE p.idAfiliado = :idAfiliado
                   AND p.idPromocion <> :idPromocion
                   AND p.activo = 1
                   AND CURRENT_TIMESTAMP() BETWEEN p.inicio_vigencia AND p.fin_vigencia
                 ORDER BY p.fin_vigencia ASC, p.idPromocion DESC
                 LIMIT 3';

        return $this->consultarTodas($sql, [
            ':idPromocion' => $idPromocion,
            ':idAfiliado' => $idAfiliado,
        ]);
    }

    private function consultarTodas(string $sql, array $parametros): array
    {
        $stmt = $this->db->prepare($sql);
        $stmt->execute($parametros);

        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }
}
