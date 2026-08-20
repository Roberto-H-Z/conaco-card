<?php
declare(strict_types=1);

/**
 * CANACO Card — Modelo de la Portada Pública
 *
 * Consultas para:
 *   - Configuración de secciones de portada (secciones_portada)
 *   - Promociones vigentes con imagen (vw_promociones_portada)
 *   - Afiliados activos con logotipo (vw_afiliados_portada)
 *   - Contadores del hero
 */
class ModeloPortada
{
    private \PDO $db;

    public function __construct()
    {
        $this->db = Conexion::conectar();
    }

    /* ── Configuración de secciones ─────────────────────────────────────── */

    /**
     * Retorna las secciones de portada activas, ordenadas.
     */
    public function obtenerConfigSecciones(): array
    {
        $sql = 'SELECT codigo, tipo, titulo, subtitulo, orden
                  FROM secciones_portada
                 WHERE activo = 1
                 ORDER BY orden ASC';

        $stmt = $this->db->query($sql);
        $rows = $stmt->fetchAll(\PDO::FETCH_ASSOC);

        // Indexar por código para acceso rápido en la vista
        $resultado = [];
        foreach ($rows as $row) {
            $resultado[$row['codigo']] = $row;
        }
        return $resultado;
    }

    /* ── Promociones ────────────────────────────────────────────────────── */

    /**
     * Retorna las promociones vigentes más recientes para la portada.
     * Usa la vista vw_promociones_vigentes (ya existente) + JOIN a archivos.
     *
     * @param int $limite Número máximo de promociones a devolver
     */
    public function obtenerPromocionesDestacadas(int $limite = 6): array
    {
        // Fallback directo sin depender de la vista vw_promociones_portada
        $sql = '
            SELECT
                p.idPromocion,
                p.idAfiliado,
                a.nombre_comercial,
                a.slug          AS afiliado_slug,
                p.titulo,
                p.descripcion,
                p.restricciones,
                p.inicio_vigencia,
                p.fin_vigencia,
                f.url_publica   AS imagen_url,
                f.storage_key   AS imagen_key
            FROM promociones p
            INNER JOIN afiliados a  ON a.idAfiliado = p.idAfiliado AND a.activo = 1
            INNER JOIN camaras  c   ON c.idCamara   = a.idCamara   AND c.activo = 1
            LEFT JOIN (
                SELECT pa.idPromocion, fi.url_publica, fi.storage_key
                  FROM promociones_archivos pa
                 INNER JOIN archivos fi ON fi.idArchivo = pa.idArchivo
                 WHERE pa.activo = 1 AND pa.orden = 1
            ) f ON f.idPromocion = p.idPromocion
            WHERE p.activo = 1
              AND CURRENT_TIMESTAMP() BETWEEN p.inicio_vigencia AND p.fin_vigencia
            ORDER BY p.inicio_vigencia DESC
            LIMIT :limite
        ';

        $stmt = $this->db->prepare($sql);
        $stmt->bindValue(':limite', $limite, \PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }

    /* ── Afiliados ──────────────────────────────────────────────────────── */

    /**
     * Retorna afiliados activos con su logotipo y categoría principal.
     * Ordenados por nombre comercial.
     *
     * @param int $limite Número máximo de afiliados
     */
    public function obtenerAfiliadosDestacados(int $limite = 8): array
    {
        $sql = '
            SELECT
                a.idAfiliado,
                a.nombre_comercial,
                a.alias,
                a.slug,
                a.descripcion,
                a.correo_general,
                cat.nombre       AS categoria_principal,
                f.url_publica    AS logo_url,
                f.storage_key    AS logo_key,
                (
                    SELECT COUNT(*)
                      FROM promociones pr
                     WHERE pr.idAfiliado = a.idAfiliado
                       AND pr.activo = 1
                       AND CURRENT_TIMESTAMP() BETWEEN pr.inicio_vigencia AND pr.fin_vigencia
                ) AS promociones_activas
            FROM afiliados a
            INNER JOIN camaras c ON c.idCamara = a.idCamara AND c.activo = 1
            LEFT JOIN afiliados_categorias ac
                   ON ac.idAfiliado = a.idAfiliado AND ac.es_principal = 1
            LEFT JOIN categorias cat
                   ON cat.idCategoria = ac.idCategoria AND cat.activo = 1
            LEFT JOIN (
                SELECT aa.idAfiliado, fi.url_publica, fi.storage_key
                  FROM afiliados_archivos aa
                 INNER JOIN archivos fi ON fi.idArchivo = aa.idArchivo
                 WHERE aa.tipo = \'LOGOTIPO\' AND aa.activo = 1
            ) f ON f.idAfiliado = a.idAfiliado
            WHERE a.activo = 1
            ORDER BY a.nombre_comercial ASC
            LIMIT :limite
        ';

        $stmt = $this->db->prepare($sql);
        $stmt->bindValue(':limite', $limite, \PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }

    /* ── Contadores del hero ────────────────────────────────────────────── */

    /**
     * Retorna totales para el hero: afiliados y promociones activas.
     */
    public function obtenerContadores(): array
    {
        $sql = '
            SELECT
                (
                    SELECT COUNT(*)
                      FROM afiliados a
                     INNER JOIN camaras c ON c.idCamara = a.idCamara AND c.activo = 1
                     WHERE a.activo = 1
                ) AS total_afiliados,
                (
                    SELECT COUNT(*)
                      FROM promociones p
                     INNER JOIN afiliados a ON a.idAfiliado = p.idAfiliado AND a.activo = 1
                     WHERE p.activo = 1
                       AND CURRENT_TIMESTAMP() BETWEEN p.inicio_vigencia AND p.fin_vigencia
                ) AS total_promociones,
                (
                    SELECT COUNT(*)
                      FROM categorias
                     WHERE activo = 1 AND idCategoriaPadre IS NULL
                ) AS total_categorias
        ';

        $stmt = $this->db->query($sql);
        return $stmt->fetch(\PDO::FETCH_ASSOC) ?: [
            'total_afiliados'   => 0,
            'total_promociones' => 0,
            'total_categorias'  => 0,
        ];
    }
}
