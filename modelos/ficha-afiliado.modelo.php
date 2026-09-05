<?php
declare(strict_types=1);

/**
 * Consultas públicas de una ficha de afiliado.
 *
 * Todas las colecciones se obtienen en un número fijo de consultas para evitar
 * cargar datos por cada elemento renderizado en la vista.
 */
class ModeloFichaAfiliado
{
    private \PDO $db;

    public function __construct()
    {
        $this->db = Conexion::conectar();
    }

    public function obtenerPorSlugActivo(string $slug): ?array
    {
        $afiliado = $this->obtenerAfiliado($slug);
        if ($afiliado === null) {
            return null;
        }

        $idAfiliado = (int) $afiliado['idAfiliado'];
        $categorias = $this->obtenerCategorias($idAfiliado);
        $archivos = $this->obtenerArchivos($idAfiliado);
        $sucursales = $this->obtenerSucursales($idAfiliado);
        $telefonos = $this->obtenerTelefonosSucursales($idAfiliado);
        $canales = $this->obtenerCanales($idAfiliado);

        foreach ($sucursales as &$sucursal) {
            $sucursal['telefonos'] = [];
        }
        unset($sucursal);

        $indiceSucursales = [];
        foreach ($sucursales as $indice => $sucursal) {
            $indiceSucursales[(int) $sucursal['idSucursal']] = $indice;
        }
        foreach ($telefonos as $telefono) {
            $idSucursal = (int) $telefono['idSucursal'];
            if (isset($indiceSucursales[$idSucursal])) {
                $sucursales[$indiceSucursales[$idSucursal]]['telefonos'][] = $telefono;
            }
        }

        $logo = null;
        $galeria = [];
        foreach ($archivos as $archivo) {
            if ($archivo['tipo'] === 'LOGOTIPO' && $logo === null) {
                $logo = $archivo;
                continue;
            }
            if ($archivo['tipo'] === 'GALERIA') {
                $galeria[] = $archivo;
            }
        }

        $sitioWeb = null;
        $redes = [];
        foreach ($canales as $canal) {
            if ($canal['tipo'] === 'SITIO_WEB' && $sitioWeb === null) {
                $sitioWeb = $canal;
                continue;
            }
            $redes[] = $canal;
        }

        $afiliado['categorias'] = $categorias;
        $afiliado['logo'] = $logo;
        $afiliado['galeria'] = $galeria;
        $afiliado['sucursales'] = $sucursales;
        $afiliado['sitio_web'] = $sitioWeb;
        $afiliado['redes'] = $redes;
        $afiliado['promociones'] = $this->obtenerPromocionesVigentes($idAfiliado);
        $afiliado['relacionadas'] = $this->obtenerRelacionadas(
            $idAfiliado,
            array_column($categorias, 'idCategoria')
        );

        return $afiliado;
    }

    private function obtenerAfiliado(string $slug): ?array
    {
        $sql = 'SELECT a.idAfiliado, a.nombre_comercial, a.alias, a.slug, a.descripcion,
                       a.correo_general, c.nombre AS camara_nombre
                  FROM afiliados a
                 INNER JOIN camaras c ON c.idCamara = a.idCamara AND c.activo = 1
                 WHERE a.slug = :slug AND a.activo = 1
                 LIMIT 1';
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':slug' => $slug]);
        $fila = $stmt->fetch(\PDO::FETCH_ASSOC);

        return $fila ?: null;
    }

    private function obtenerCategorias(int $idAfiliado): array
    {
        $sql = 'SELECT c.idCategoria, c.nombre, c.slug, ac.es_principal, ac.orden
                  FROM afiliados_categorias ac
                 INNER JOIN categorias c ON c.idCategoria = ac.idCategoria AND c.activo = 1
                 WHERE ac.idAfiliado = :idAfiliado
                 ORDER BY ac.es_principal DESC, ac.orden ASC, c.nombre ASC';
        return $this->consultarTodas($sql, [':idAfiliado' => $idAfiliado]);
    }

    private function obtenerArchivos(int $idAfiliado): array
    {
        $sql = 'SELECT aa.tipo, aa.orden, aa.texto_alternativo, f.url_publica, f.ancho_px, f.alto_px
                  FROM afiliados_archivos aa
                 INNER JOIN archivos f ON f.idArchivo = aa.idArchivo AND f.activo = 1
                 WHERE aa.idAfiliado = :idAfiliado
                   AND aa.activo = 1
                   AND aa.tipo IN (\'LOGOTIPO\', \'GALERIA\')
                 ORDER BY FIELD(aa.tipo, \'LOGOTIPO\', \'GALERIA\'), aa.orden ASC';
        return $this->consultarTodas($sql, [':idAfiliado' => $idAfiliado]);
    }

    private function obtenerSucursales(int $idAfiliado): array
    {
        $sql = 'SELECT s.idSucursal, s.nombre, s.es_matriz, s.calle, s.numero_exterior,
                       s.numero_interior, s.colonia, s.codigo_postal, s.referencias,
                       s.latitud, s.longitud, s.google_place_id, l.nombre AS localidad,
                       m.nombre AS municipio, e.nombre AS estado
                  FROM sucursales s
                 INNER JOIN localidades l ON l.idLocalidad = s.idLocalidad AND l.activo = 1
                 INNER JOIN municipios m ON m.idMunicipio = l.idMunicipio AND m.activo = 1
                 INNER JOIN estados e ON e.idEstado = m.idEstado AND e.activo = 1
                 WHERE s.idAfiliado = :idAfiliado AND s.activo = 1
                 ORDER BY s.es_matriz DESC, s.nombre ASC';
        return $this->consultarTodas($sql, [':idAfiliado' => $idAfiliado]);
    }

    private function obtenerTelefonosSucursales(int $idAfiliado): array
    {
        $sql = 'SELECT st.idSucursal, st.tipo, st.numero_original, st.numero_normalizado,
                       st.extension_telefono, st.etiqueta, st.es_principal
                  FROM sucursales_telefonos st
                 INNER JOIN sucursales s ON s.idSucursal = st.idSucursal AND s.activo = 1
                 WHERE s.idAfiliado = :idAfiliado AND st.activo = 1
                 ORDER BY st.es_principal DESC, st.idSucursal ASC, st.idSucursalTelefono ASC';
        return $this->consultarTodas($sql, [':idAfiliado' => $idAfiliado]);
    }

    private function obtenerCanales(int $idAfiliado): array
    {
        $sql = 'SELECT tipo, url, nombre_usuario, es_principal
                  FROM canales_digitales
                 WHERE idAfiliado = :idAfiliado AND idSucursal IS NULL AND activo = 1
                 ORDER BY es_principal DESC, tipo ASC';
        return $this->consultarTodas($sql, [':idAfiliado' => $idAfiliado]);
    }

    private function obtenerPromocionesVigentes(int $idAfiliado): array
    {
        $sql = 'SELECT p.idPromocion, p.titulo, p.descripcion, p.restricciones,
                       p.inicio_vigencia, p.fin_vigencia, fi.url_publica AS imagen_url,
                       pa.texto_alternativo
                  FROM promociones p
             LEFT JOIN promociones_archivos pa
                    ON pa.idPromocion = p.idPromocion AND pa.activo = 1 AND pa.orden = 1
             LEFT JOIN archivos fi ON fi.idArchivo = pa.idArchivo AND fi.activo = 1
                 WHERE p.idAfiliado = :idAfiliado
                   AND p.activo = 1
                   AND CURRENT_TIMESTAMP() BETWEEN p.inicio_vigencia AND p.fin_vigencia
                 ORDER BY p.fin_vigencia ASC, p.inicio_vigencia DESC';
        return $this->consultarTodas($sql, [':idAfiliado' => $idAfiliado]);
    }

    private function obtenerRelacionadas(int $idAfiliado, array $idsCategorias): array
    {
        $idsCategorias = array_values(array_filter(array_map('intval', $idsCategorias)));
        if ($idsCategorias === []) {
            return [];
        }

        $marcadores = implode(', ', array_fill(0, count($idsCategorias), '?'));
        $sql = "SELECT DISTINCT a.idAfiliado, a.nombre_comercial, a.alias, a.slug,
                       COALESCE(cp.nombre, c.nombre) AS categoria_principal, f.url_publica AS logo_url
                  FROM afiliados a
                 INNER JOIN camaras ca ON ca.idCamara = a.idCamara AND ca.activo = 1
                 INNER JOIN afiliados_categorias ac ON ac.idAfiliado = a.idAfiliado
                 INNER JOIN categorias c ON c.idCategoria = ac.idCategoria AND c.activo = 1
             LEFT JOIN afiliados_categorias acp
                    ON acp.idAfiliado = a.idAfiliado AND acp.es_principal = 1
             LEFT JOIN categorias cp ON cp.idCategoria = acp.idCategoria AND cp.activo = 1
             LEFT JOIN afiliados_archivos aa
                    ON aa.idAfiliado = a.idAfiliado AND aa.tipo = 'LOGOTIPO' AND aa.activo = 1 AND aa.orden = 1
             LEFT JOIN archivos f ON f.idArchivo = aa.idArchivo AND f.activo = 1
                 WHERE a.activo = 1
                   AND a.idAfiliado <> ?
                   AND ac.idCategoria IN ($marcadores)
                 ORDER BY a.nombre_comercial ASC
                 LIMIT 3";

        $stmt = $this->db->prepare($sql);
        $stmt->execute(array_merge([$idAfiliado], $idsCategorias));
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }

    private function consultarTodas(string $sql, array $parametros): array
    {
        $stmt = $this->db->prepare($sql);
        $stmt->execute($parametros);
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }
}
