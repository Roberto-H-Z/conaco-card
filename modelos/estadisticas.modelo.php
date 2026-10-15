<?php
declare(strict_types=1);

/** Métricas del último mes (30 días incluidos hoy), calculadas de los eventos fuente. */
final class ModeloEstadisticas
{
    private PDO $db;
    public function __construct() { $this->db = Conexion::conectar(); }

    /** Configuración de servidor; la lista cerrada impide interpolar identificadores arbitrarios. */
    public static function tablaInteracciones(): string
    {
        $tabla=(string)(getenv('ESTADISTICAS_TABLA_INTERACCIONES') ?: 'interacciones_afiliados');
        if (!in_array($tabla,['interacciones_afiliados','interacciones_afiliados_v2'],true)) throw new RuntimeException('Tabla de estadísticas no válida.');
        return $tabla;
    }

    public function periodo(): array
    {
        $fin = new DateTimeImmutable('today',new DateTimeZone('UTC'));
        return ['desde' => $fin->modify('-29 days')->format('Y-m-d'), 'hasta' => $fin->format('Y-m-d')];
    }
    private function desde(): string { return $this->periodo()['desde'] . ' 00:00:00'; }

    public function empresasDelUsuario(int $idUsuario): array
    {
        $s = $this->db->prepare('SELECT a.idAfiliado,a.nombre_comercial,a.slug,a.descripcion,a.correo_general,a.activo,c.nombre AS camara
            FROM usuarios_afiliados ua JOIN afiliados a ON a.idAfiliado=ua.idAfiliado
            JOIN camaras c ON c.idCamara=a.idCamara WHERE ua.idUsuario=? ORDER BY ua.es_principal DESC,a.nombre_comercial');
        $s->execute([$idUsuario]);
        return $s->fetchAll(PDO::FETCH_ASSOC);
    }

    /** El alcance se obtiene de la sesión validada, nunca de parámetros del navegador. */
    private function alcance(array $usuario): array
    {
        return match ($usuario['rol'] ?? '') {
            'ADMIN_GENERAL' => ['1=1', []],
            'ADMIN_CAMARA' => ['a.idCamara=?', [(int)($usuario['idCamara'] ?? 0)]],
            'AFILIADO' => ['EXISTS (SELECT 1 FROM usuarios_afiliados ua WHERE ua.idAfiliado=a.idAfiliado AND ua.idUsuario=?)', [(int)$usuario['id']]],
            default => ['1=0', []],
        };
    }

    public function camarasVisibles(array $usuario): array
    {
        if (($usuario['rol'] ?? '') !== 'ADMIN_GENERAL') return [];
        return $this->db->query('SELECT idCamara,nombre FROM camaras ORDER BY nombre')->fetchAll(PDO::FETCH_ASSOC);
    }

    public function empresaVisible(array $usuario, int $id): ?array
    {
        [$where,$params] = $this->alcance($usuario);
        $s = $this->db->prepare('SELECT a.idAfiliado,a.nombre_comercial,a.slug,a.descripcion,a.activo,c.nombre AS camara FROM afiliados a JOIN camaras c ON c.idCamara=a.idCamara WHERE '.$where.' AND a.idAfiliado=?');
        $s->execute([...$params,$id]);
        return $s->fetch(PDO::FETCH_ASSOC) ?: null;
    }

    /** Una fila por empresa. No unir directamente ambos eventos: multiplicaría los conteos. */
    public function reporte(array $usuario, array $filtros): array
    {
        $tabla=self::tablaInteracciones();
        [$where,$params] = $this->alcance($usuario);
        if ($filtros['camara'] > 0) { $where .= ' AND a.idCamara=?'; $params[] = $filtros['camara']; }
        if ($filtros['afiliado'] > 0) { $where .= ' AND a.idAfiliado=?'; $params[] = $filtros['afiliado']; }
        if ($filtros['q'] !== '') {
            $where .= " AND a.nombre_comercial LIKE ? ESCAPE '!'";
            $params[] = '%'.strtr($filtros['q'], ['!'=>'!!','%'=>'!%','_'=>'!_']).'%';
        }
        $s = $this->db->prepare("SELECT a.idAfiliado,a.nombre_comercial,a.activo,c.nombre AS camara,
            COALESCE(b.apariciones,0) AS apariciones,COALESCE(i.visitas,0) AS visitas,
            COALESCE(i.telefono,0) AS telefono,COALESCE(i.whatsapp,0) AS whatsapp,
            COALESCE(i.web,0) AS web,COALESCE(i.redes,0) AS redes,
            COALESCE(i.mapa,0) AS mapa,COALESCE(i.promociones,0) AS promociones
            FROM afiliados a JOIN camaras c ON c.idCamara=a.idCamara
            LEFT JOIN (SELECT idAfiliado,COUNT(*) AS apariciones FROM busquedas_resultados WHERE mostrado_at>=? AND mostrado_at<DATE_ADD(UTC_DATE(),INTERVAL 1 DAY) GROUP BY idAfiliado) b ON b.idAfiliado=a.idAfiliado
            LEFT JOIN (SELECT idAfiliado,SUM(tipo='VISITA_FICHA') AS visitas,
                SUM(tipo='CLIC_TELEFONO') AS telefono,SUM(tipo='CLIC_WHATSAPP') AS whatsapp,
                SUM(tipo='CLIC_SITIO_WEB') AS web,SUM(tipo IN ('CLIC_FACEBOOK','CLIC_INSTAGRAM','CLIC_RED_SOCIAL')) AS redes,
                SUM(tipo='CLIC_MAPA') AS mapa,SUM(tipo='VISITA_PROMOCION') AS promociones
                FROM $tabla WHERE ocurrido_at>=? AND ocurrido_at<DATE_ADD(UTC_DATE(),INTERVAL 1 DAY) GROUP BY idAfiliado) i ON i.idAfiliado=a.idAfiliado
            WHERE $where ORDER BY a.nombre_comercial,a.idAfiliado");
        $s->execute([$this->desde(),$this->desde(),...$params]);
        $filas = $s->fetchAll(PDO::FETCH_ASSOC);
        foreach ($filas as &$fila) {
            foreach (['apariciones','visitas','telefono','whatsapp','web','redes','mapa','promociones'] as $k) $fila[$k] = (int)$fila[$k];
            $fila['contactos'] = $fila['telefono']+$fila['whatsapp']+$fila['web']+$fila['redes'];
        }
        unset($fila);
        return $filas;
    }

    public function resumen(int $id): array
    {
        $s = $this->db->prepare('SELECT COUNT(*) FROM busquedas_resultados WHERE idAfiliado=? AND mostrado_at>=? AND mostrado_at<DATE_ADD(UTC_DATE(),INTERVAL 1 DAY)');
        $s->execute([$id,$this->desde()]);
        $apariciones = (int)$s->fetchColumn();
        $s = $this->db->prepare('SELECT tipo,COUNT(*) AS total FROM '.self::tablaInteracciones().' WHERE idAfiliado=? AND ocurrido_at>=? AND ocurrido_at<DATE_ADD(UTC_DATE(),INTERVAL 1 DAY) GROUP BY tipo');
        $s->execute([$id,$this->desde()]);
        $tipos = array_fill_keys(['VISITA_FICHA','CLIC_TELEFONO','CLIC_WHATSAPP','CLIC_SITIO_WEB','CLIC_FACEBOOK','CLIC_INSTAGRAM','CLIC_RED_SOCIAL','CLIC_MAPA','VISITA_PROMOCION'],0);
        foreach ($s->fetchAll(PDO::FETCH_ASSOC) as $fila) $tipos[$fila['tipo']] = (int)$fila['total'];
        return ['apariciones'=>$apariciones,'visitas'=>$tipos['VISITA_FICHA'],
            'telefono'=>$tipos['CLIC_TELEFONO'],'whatsapp'=>$tipos['CLIC_WHATSAPP'],
            'web'=>$tipos['CLIC_SITIO_WEB'],'redes'=>$tipos['CLIC_FACEBOOK']+$tipos['CLIC_INSTAGRAM']+$tipos['CLIC_RED_SOCIAL'],
            'mapa'=>$tipos['CLIC_MAPA'],'promociones'=>$tipos['VISITA_PROMOCION']];
    }

    public function serieDiaria(int $id): array
    {
        $dias = [];
        $inicio = new DateTimeImmutable($this->periodo()['desde']);
        for ($i=0;$i<30;$i++) $dias[$inicio->modify("+$i days")->format('Y-m-d')] = ['apariciones'=>0,'visitas'=>0,'contactos'=>0];
        $s = $this->db->prepare('SELECT DATE(mostrado_at) AS fecha,COUNT(*) AS total FROM busquedas_resultados WHERE idAfiliado=? AND mostrado_at>=? AND mostrado_at<DATE_ADD(UTC_DATE(),INTERVAL 1 DAY) GROUP BY DATE(mostrado_at)');
        $s->execute([$id,$this->desde()]);
        foreach ($s->fetchAll(PDO::FETCH_ASSOC) as $f) if (isset($dias[$f['fecha']])) $dias[$f['fecha']]['apariciones'] = (int)$f['total'];
        $s = $this->db->prepare("SELECT DATE(ocurrido_at) AS fecha,SUM(tipo='VISITA_FICHA') AS visitas,SUM(tipo IN ('CLIC_TELEFONO','CLIC_WHATSAPP','CLIC_SITIO_WEB','CLIC_FACEBOOK','CLIC_INSTAGRAM','CLIC_RED_SOCIAL')) AS contactos FROM ".self::tablaInteracciones()." WHERE idAfiliado=? AND ocurrido_at>=? AND ocurrido_at<DATE_ADD(UTC_DATE(),INTERVAL 1 DAY) GROUP BY DATE(ocurrido_at)");
        $s->execute([$id,$this->desde()]);
        foreach ($s->fetchAll(PDO::FETCH_ASSOC) as $f) if (isset($dias[$f['fecha']])) {
            $dias[$f['fecha']]['visitas'] = (int)$f['visitas']; $dias[$f['fecha']]['contactos'] = (int)$f['contactos'];
        }
        return $dias;
    }

    public function busquedasFrecuentes(int $id): array
    {
        $s = $this->db->prepare("SELECT b.termino_normalizado AS termino,COUNT(*) AS apariciones FROM busquedas_resultados r JOIN busquedas b ON b.idBusqueda=r.idBusqueda WHERE r.idAfiliado=? AND r.mostrado_at>=? AND r.mostrado_at<DATE_ADD(UTC_DATE(),INTERVAL 1 DAY) AND b.termino_normalizado<>'' GROUP BY b.termino_normalizado ORDER BY apariciones DESC,termino ASC LIMIT 5");
        $s->execute([$id,$this->desde()]);
        return $s->fetchAll(PDO::FETCH_ASSOC);
    }

    public function promociones(int $id): array
    {
        $s = $this->db->prepare("SELECT p.idPromocion,p.titulo,p.fin_vigencia,(SELECT COUNT(*) FROM ".self::tablaInteracciones()." i WHERE i.idPromocion=p.idPromocion AND i.tipo='VISITA_PROMOCION' AND i.ocurrido_at>=? AND i.ocurrido_at<DATE_ADD(UTC_DATE(),INTERVAL 1 DAY)) AS visitas FROM promociones p WHERE p.idAfiliado=? AND p.activo=1 AND CURRENT_TIMESTAMP BETWEEN p.inicio_vigencia AND p.fin_vigencia ORDER BY p.fin_vigencia ASC LIMIT 5");
        $s->execute([$this->desde(),$id]);
        return $s->fetchAll(PDO::FETCH_ASSOC);
    }

    public function perfil(int $id): array
    {
        $s = $this->db->prepare('SELECT (SELECT COUNT(*) FROM sucursales WHERE idAfiliado=? AND activo=1) AS sucursales,(SELECT COUNT(*) FROM promociones WHERE idAfiliado=? AND activo=1 AND CURRENT_TIMESTAMP BETWEEN inicio_vigencia AND fin_vigencia) AS promociones,(SELECT COUNT(*) FROM canales_digitales WHERE idAfiliado=? AND activo=1) AS canales');
        $s->execute([$id,$id,$id]);
        return $s->fetch(PDO::FETCH_ASSOC) ?: [];
    }

    public function registrarVisita(int $idAfiliado): void
    {
        $s = $this->db->prepare('INSERT INTO '.self::tablaInteracciones()."(idAfiliado,tipo) VALUES (?,'VISITA_FICHA')");
        $s->execute([$idAfiliado]);
    }

    public function registrarEvento(int $idAfiliado,string $tipo,?int $idPromocion,?int $idSucursal,?int $idCanal): bool
    {
        $s = $this->db->prepare('SELECT 1 FROM afiliados a JOIN camaras c ON c.idCamara=a.idCamara AND c.activo=1 WHERE a.idAfiliado=? AND a.activo=1');
        $s->execute([$idAfiliado]);
        if (!$s->fetchColumn()) return false;
        foreach ([
            [$idPromocion,'SELECT 1 FROM promociones WHERE idPromocion=? AND idAfiliado=? AND activo=1 AND CURRENT_TIMESTAMP BETWEEN inicio_vigencia AND fin_vigencia'],
            [$idSucursal,'SELECT 1 FROM sucursales WHERE idSucursal=? AND idAfiliado=? AND activo=1'],
            [$idCanal,'SELECT 1 FROM canales_digitales WHERE idCanalDigital=? AND idAfiliado=? AND activo=1']
        ] as [$relacion,$sql]) {
            if ($relacion === null) continue;
            $s = $this->db->prepare($sql); $s->execute([$relacion,$idAfiliado]);
            if (!$s->fetchColumn()) return false;
        }
        $s = $this->db->prepare('INSERT INTO '.self::tablaInteracciones().'(idAfiliado,idPromocion,idSucursal,idCanalDigital,tipo) VALUES (?,?,?,?,?)');
        $s->execute([$idAfiliado,$idPromocion,$idSucursal,$idCanal,$tipo]);
        return true;
    }
}
