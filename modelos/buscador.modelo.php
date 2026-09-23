<?php
declare(strict_types=1);

/** Consulta datos publicados directamente: una promoción vencida nunca queda en un índice obsoleto. */
class ModeloBuscador
{
    private PDO $db;
    public function __construct() { $this->db = Conexion::conectar(); }

    public function catalogos(): array
    {
        return [
            'ciudades' => $this->db->query('SELECT m.idMunicipio AS id, CONCAT(m.nombre, ", ", e.nombre) AS nombre FROM municipios m INNER JOIN estados e ON e.idEstado=m.idEstado AND e.activo=1 WHERE m.activo=1 AND EXISTS (SELECT 1 FROM localidades l INNER JOIN sucursales s ON s.idLocalidad=l.idLocalidad AND s.activo=1 INNER JOIN afiliados a ON a.idAfiliado=s.idAfiliado AND a.activo=1 INNER JOIN camaras ca ON ca.idCamara=a.idCamara AND ca.activo=1 WHERE l.idMunicipio=m.idMunicipio AND l.activo=1) ORDER BY m.nombre, e.nombre')->fetchAll(PDO::FETCH_ASSOC),
            'categorias' => $this->db->query('SELECT idCategoria AS id, nombre FROM categorias WHERE activo=1 ORDER BY nombre, idCategoria')->fetchAll(PDO::FETCH_ASSOC),
        ];
    }

    public function buscar(array $f): array
    {
        $params = [];
        $nivel = '0';
        if ($f['q'] !== '') {
            // ESCAPE explícito: % y _ introducidos por el visitante son texto literal.
            $like = '%' . strtr($f['q'], ['!'=>'!!', '%'=>'!%', '_'=>'!_']) . '%';
            $nivel = "CASE
                WHEN a.nombre_comercial = ? OR a.alias = ? THEN 1
                WHEN a.nombre_comercial LIKE ? ESCAPE '!' OR a.alias LIKE ? ESCAPE '!' THEN 2
                WHEN EXISTS (SELECT 1 FROM afiliados_categorias ac INNER JOIN categorias c ON c.idCategoria=ac.idCategoria AND c.activo=1 WHERE ac.idAfiliado=a.idAfiliado AND c.nombre LIKE ? ESCAPE '!') THEN 3
                WHEN EXISTS (SELECT 1 FROM afiliados_palabras_clave pc WHERE pc.idAfiliado=a.idAfiliado AND pc.activo=1 AND (pc.palabra LIKE ? ESCAPE '!' OR pc.palabra_normalizada LIKE ? ESCAPE '!')) THEN 4
                WHEN EXISTS (SELECT 1 FROM promociones p WHERE p.idAfiliado=a.idAfiliado AND p.activo=1 AND CURRENT_TIMESTAMP() BETWEEN p.inicio_vigencia AND p.fin_vigencia AND (p.titulo LIKE ? ESCAPE '!' OR p.descripcion LIKE ? ESCAPE '!')) THEN 5
                WHEN a.descripcion LIKE ? ESCAPE '!' THEN 6 ELSE 99 END";
            $params = [$f['q'], $f['q'], $like, $like, $like, $like, $like, $like, $like, $like];
        }
        $where = 'a.activo=1';
        if ($f['ciudad']) {
            $where .= ' AND EXISTS (SELECT 1 FROM sucursales s INNER JOIN localidades l ON l.idLocalidad=s.idLocalidad AND l.activo=1 INNER JOIN municipios m ON m.idMunicipio=l.idMunicipio AND m.activo=1 INNER JOIN estados e ON e.idEstado=m.idEstado AND e.activo=1 WHERE s.idAfiliado=a.idAfiliado AND s.activo=1 AND m.idMunicipio=?)';
            $params[] = $f['ciudad'];
        }
        if ($f['categoria']) {
            $where .= ' AND EXISTS (SELECT 1 FROM afiliados_categorias ac INNER JOIN categorias c ON c.idCategoria=ac.idCategoria AND c.activo=1 WHERE ac.idAfiliado=a.idAfiliado AND c.idCategoria=?)';
            $params[] = $f['categoria'];
        }
        $base = "SELECT a.idAfiliado, a.nombre_comercial, a.alias, a.slug, a.descripcion, $nivel AS nivel FROM afiliados a INNER JOIN camaras ca ON ca.idCamara=a.idCamara AND ca.activo=1 WHERE $where";
        $stmt = $this->db->prepare("SELECT COUNT(*) FROM ($base) resultados WHERE nivel < 99");
        $stmt->execute($params);
        $total = (int) $stmt->fetchColumn();
        $paginas = max(1, (int) ceil($total / 12));
        $pagina = min($paginas, $f['pagina']);
        $offset = ($pagina - 1) * 12;
        $stmt = $this->db->prepare("SELECT * FROM ($base) resultados WHERE nivel < 99 ORDER BY nivel, nombre_comercial, idAfiliado LIMIT 12 OFFSET $offset");
        $stmt->execute($params);
        $items = $stmt->fetchAll(PDO::FETCH_ASSOC);
        if ($items) $this->completar($items, $f['ciudad'], $f['q']);
        return compact('total', 'paginas', 'pagina', 'items');
    }

    private function completar(array &$items, int $ciudad, string $q): void
    {
        $ids = array_column($items, 'idAfiliado');
        $marks = implode(',', array_fill(0, count($ids), '?'));
        $sql = [
            'categorias' => "SELECT ac.idAfiliado, c.nombre FROM afiliados_categorias ac JOIN categorias c ON c.idCategoria=ac.idCategoria AND c.activo=1 WHERE ac.idAfiliado IN ($marks) ORDER BY ac.es_principal DESC, ac.orden, c.nombre",
            'logos' => "SELECT aa.idAfiliado, f.url_publica FROM afiliados_archivos aa JOIN archivos f ON f.idArchivo=aa.idArchivo AND f.activo=1 WHERE aa.idAfiliado IN ($marks) AND aa.activo=1 AND aa.tipo='LOGOTIPO' ORDER BY aa.orden",
            'ciudades' => "SELECT s.idAfiliado, m.idMunicipio, CONCAT(m.nombre, ', ', e.nombre) AS nombre FROM sucursales s JOIN localidades l ON l.idLocalidad=s.idLocalidad AND l.activo=1 JOIN municipios m ON m.idMunicipio=l.idMunicipio AND m.activo=1 JOIN estados e ON e.idEstado=m.idEstado AND e.activo=1 WHERE s.idAfiliado IN ($marks) AND s.activo=1 ORDER BY s.es_matriz DESC, m.nombre",
            'promociones' => "SELECT p.idAfiliado, p.idPromocion, p.titulo FROM promociones p WHERE p.idAfiliado IN ($marks) AND p.activo=1 AND CURRENT_TIMESTAMP() BETWEEN p.inicio_vigencia AND p.fin_vigencia ORDER BY p.fin_vigencia, p.idPromocion",
        ];
        $datos = [];
        foreach ($sql as $tipo => $consulta) {
            $parametros = $ids;
            if ($tipo === 'promociones' && $q !== '') {
                $like = '%' . strtr($q, ['!'=>'!!', '%'=>'!%', '_'=>'!_']) . '%';
                $consulta = str_replace('ORDER BY p.fin_vigencia, p.idPromocion', "ORDER BY CASE WHEN p.titulo LIKE ? ESCAPE '!' OR p.descripcion LIKE ? ESCAPE '!' THEN 0 ELSE 1 END, p.fin_vigencia, p.idPromocion", $consulta);
                array_push($parametros, $like, $like);
            }
            $stmt = $this->db->prepare($consulta);
            $stmt->execute($parametros);
            foreach ($stmt->fetchAll(PDO::FETCH_ASSOC) as $row) {
                if ($tipo === 'ciudades' && $ciudad && (int)$row['idMunicipio'] !== $ciudad) continue;
                $datos[$tipo][$row['idAfiliado']] ??= $row;
            }
        }
        foreach ($items as &$item) {
            $id = $item['idAfiliado'];
            $item['categoria'] = $datos['categorias'][$id]['nombre'] ?? 'Empresa afiliada';
            $item['ciudad'] = $datos['ciudades'][$id]['nombre'] ?? 'Ubicación por confirmar';
            $item['logo'] = $datos['logos'][$id]['url_publica'] ?? null;
            $item['promocion'] = $datos['promociones'][$id] ?? null;
        }
    }

    public function registrar(array $f, array $resultado, int $duracion): int
    {
        $this->db->beginTransaction();
        try {
            $stmt = $this->db->prepare('INSERT INTO busquedas (termino_original, termino_normalizado, idMunicipio, idCategoria, cantidad_resultados, duracion_ms) VALUES (?,?,?,?,?,?)');
            $stmt->execute([$f['q'], mb_strtolower($f['q']), $f['ciudad'] ?: null, $f['categoria'] ?: null, $resultado['total'], $duracion]);
            $id = (int)$this->db->lastInsertId();
            if ($resultado['items']) {
                $rows = []; $values = [];
                foreach ($resultado['items'] as $i => $item) {
                    $rows[] = '(?,?,?,?)';
                    array_push($values, $id, $item['idAfiliado'], ($resultado['pagina']-1)*12+$i+1, 100-(int)$item['nivel']);
                }
                $this->db->prepare('INSERT INTO busquedas_resultados (idBusqueda,idAfiliado,posicion,puntaje_relevancia) VALUES '.implode(',', $rows))->execute($values);
            }
            $this->db->commit();
            return $id;
        } catch (Throwable $e) {
            $this->db->rollBack();
            throw $e;
        }
    }

    public function registrarConsulta(int $idBusqueda, int $idAfiliado): bool
    {
        $s = $this->db->prepare("INSERT INTO interacciones_afiliados (idBusqueda,idAfiliado,tipo) SELECT idBusqueda,idAfiliado,'VISITA_FICHA' FROM busquedas_resultados WHERE idBusqueda=? AND idAfiliado=?");
        $s->execute([$idBusqueda, $idAfiliado]);
        return $s->rowCount() > 0;
    }
}
