<?php
declare(strict_types=1);

/** Métricas del último mes (30 días incluidos hoy), calculadas de los eventos fuente. */
final class ModeloEstadisticas
{
    private PDO $db;
    public function __construct() { $this->db = Conexion::conectar(); }

    public function periodo(): array
    {
        $fin = new DateTimeImmutable('today');
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

    public function resumen(int $id): array
    {
        $s = $this->db->prepare('SELECT COUNT(*) FROM busquedas_resultados WHERE idAfiliado=? AND mostrado_at>=?');
        $s->execute([$id,$this->desde()]);
        $apariciones = (int)$s->fetchColumn();
        $s = $this->db->prepare('SELECT tipo,COUNT(*) AS total FROM interacciones_afiliados WHERE idAfiliado=? AND ocurrido_at>=? GROUP BY tipo');
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
        $s = $this->db->prepare('SELECT DATE(mostrado_at) AS fecha,COUNT(*) AS total FROM busquedas_resultados WHERE idAfiliado=? AND mostrado_at>=? GROUP BY DATE(mostrado_at)');
        $s->execute([$id,$this->desde()]);
        foreach ($s->fetchAll(PDO::FETCH_ASSOC) as $f) if (isset($dias[$f['fecha']])) $dias[$f['fecha']]['apariciones'] = (int)$f['total'];
        $s = $this->db->prepare("SELECT DATE(ocurrido_at) AS fecha,SUM(tipo='VISITA_FICHA') AS visitas,SUM(tipo IN ('CLIC_TELEFONO','CLIC_WHATSAPP','CLIC_SITIO_WEB','CLIC_FACEBOOK','CLIC_INSTAGRAM','CLIC_RED_SOCIAL')) AS contactos FROM interacciones_afiliados WHERE idAfiliado=? AND ocurrido_at>=? GROUP BY DATE(ocurrido_at)");
        $s->execute([$id,$this->desde()]);
        foreach ($s->fetchAll(PDO::FETCH_ASSOC) as $f) if (isset($dias[$f['fecha']])) {
            $dias[$f['fecha']]['visitas'] = (int)$f['visitas']; $dias[$f['fecha']]['contactos'] = (int)$f['contactos'];
        }
        return $dias;
    }

    public function busquedasFrecuentes(int $id): array
    {
        $s = $this->db->prepare("SELECT b.termino_normalizado AS termino,COUNT(*) AS apariciones FROM busquedas_resultados r JOIN busquedas b ON b.idBusqueda=r.idBusqueda WHERE r.idAfiliado=? AND r.mostrado_at>=? AND b.termino_normalizado<>'' GROUP BY b.termino_normalizado ORDER BY apariciones DESC,termino ASC LIMIT 5");
        $s->execute([$id,$this->desde()]);
        return $s->fetchAll(PDO::FETCH_ASSOC);
    }

    public function promociones(int $id): array
    {
        $s = $this->db->prepare("SELECT p.idPromocion,p.titulo,p.fin_vigencia,(SELECT COUNT(*) FROM interacciones_afiliados i WHERE i.idPromocion=p.idPromocion AND i.tipo='VISITA_PROMOCION' AND i.ocurrido_at>=?) AS visitas FROM promociones p WHERE p.idAfiliado=? AND p.activo=1 AND CURRENT_TIMESTAMP BETWEEN p.inicio_vigencia AND p.fin_vigencia ORDER BY p.fin_vigencia ASC LIMIT 5");
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
        $s = $this->db->prepare("INSERT INTO interacciones_afiliados(idAfiliado,tipo) VALUES (?,'VISITA_FICHA')");
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
        $s = $this->db->prepare('INSERT INTO interacciones_afiliados(idAfiliado,idPromocion,idSucursal,idCanalDigital,tipo) VALUES (?,?,?,?,?)');
        $s->execute([$idAfiliado,$idPromocion,$idSucursal,$idCanal,$tipo]);
        return true;
    }
}
