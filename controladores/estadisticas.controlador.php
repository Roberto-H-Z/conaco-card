<?php
declare(strict_types=1);

/** Consulta y exportación comparten filtros, validación y alcance por perfil. */
final class ControladorEstadisticas
{
    public function index(): array
    {
        if (!tieneRol('ADMIN_GENERAL','ADMIN_CAMARA') || !tienePermiso('estadisticas.ver')) {
            http_response_code(403);
            return ['error'=>'No tienes permiso para consultar esta sección.'];
        }
        try {
            $datos = $this->datos();
            $pagina = $this->entero('pagina',1);
            $paginas = max(1,(int)ceil(count($datos['filas'])/20));
            $pagina = max(1,min($pagina,$paginas));
            $datos['listado'] = array_slice($datos['filas'],($pagina-1)*20,20);
            $datos['paginacion'] = ['pagina'=>$pagina,'paginas'=>$paginas,'total'=>count($datos['filas'])];
            return $datos;
        } catch (InvalidArgumentException $e) {
            http_response_code(400); return ['error'=>$e->getMessage()];
        } catch (OutOfBoundsException $e) {
            http_response_code(403); return ['error'=>$e->getMessage()];
        } catch (PDOException $e) {
            registrarLog('Consulta de estadísticas: '.$e->getMessage(),'ERROR');
            http_response_code(503);
            return ['error'=>'No pudimos cargar las estadísticas. Intenta de nuevo en unos momentos.'];
        }
    }

    public function exportar(): void
    {
        header('Cache-Control: private, no-store');
        header('X-Content-Type-Options: nosniff');
        if (($_SERVER['REQUEST_METHOD'] ?? 'GET') !== 'GET') {
            http_response_code(405); header('Allow: GET'); return;
        }
        if (!tieneRol('ADMIN_GENERAL','ADMIN_CAMARA','AFILIADO') || !tienePermiso('estadisticas.ver')) {
            http_response_code(403); exit('No tienes permiso para exportar estadísticas.');
        }
        $formato = $_GET['formato'] ?? '';
        if (!is_string($formato) || !in_array($formato,['xlsx','pdf'],true)) {
            http_response_code(400); exit('Selecciona un formato de exportación válido.');
        }
        try {
            $datos = $this->datos();
            $archivo = new ExportadorEstadisticas();
            $contenido = $formato === 'xlsx' ? $archivo->excel($datos) : $archivo->pdf($datos);
        } catch (InvalidArgumentException $e) {
            http_response_code(400); exit($e->getMessage());
        } catch (OutOfBoundsException $e) {
            http_response_code(403); exit($e->getMessage());
        } catch (Throwable $e) {
            registrarLog('Exportación de estadísticas: '.$e->getMessage(),'ERROR');
            http_response_code(503); exit('No pudimos generar el reporte. Regresa a estadísticas e inténtalo de nuevo.');
        }
        header('Content-Type: '.($formato==='xlsx' ? 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' : 'application/pdf'));
        header('Content-Disposition: attachment; filename="estadisticas-canaco-'.$datos['periodo']['hasta'].'.'.$formato.'"');
        header('Content-Length: '.strlen($contenido));
        echo $contenido;
    }

    private function entero(string $clave,int $predeterminado=0): int
    {
        $raw = $_GET[$clave] ?? (string)$predeterminado;
        if (!is_string($raw) || !ctype_digit($raw) || strlen($raw)>10 || (float)$raw>2147483647) throw new InvalidArgumentException('Selecciona filtros válidos.');
        return (int)$raw;
    }

    private function datos(): array
    {
        $usuario = obtenerUsuarioSesion();
        $q = $_GET['q'] ?? '';
        if (!is_string($q) || mb_strlen($q)>100 || preg_match('/[\x00-\x1F]/u',$q)) throw new InvalidArgumentException('La búsqueda admite hasta 100 caracteres.');
        $f = ['q'=>trim($q),'camara'=>$this->entero('camara'),'afiliado'=>$this->entero('afiliado')];
        if ($usuario['rol']!=='ADMIN_GENERAL' && $f['camara']>0 && $f['camara']!==$usuario['idCamara']) throw new OutOfBoundsException('No tienes acceso a las estadísticas de esa cámara.');
        if ($usuario['rol']==='ADMIN_CAMARA' && !$usuario['idCamara']) throw new OutOfBoundsException('Tu usuario no tiene una cámara asignada.');
        $modelo = new ModeloEstadisticas();
        $camaras = $modelo->camarasVisibles($usuario);
        if ($usuario['rol']==='ADMIN_GENERAL' && $f['camara']>0 && !in_array($f['camara'],array_map('intval',array_column($camaras,'idCamara')),true)) throw new InvalidArgumentException('La cámara seleccionada no existe.');
        $empresa = $f['afiliado']>0 ? $modelo->empresaVisible($usuario,$f['afiliado']) : null;
        if ($f['afiliado']>0 && $empresa===null) throw new OutOfBoundsException('No tienes acceso a las estadísticas de esa empresa.');
        $filas = $modelo->reporte($usuario,$empresa ? ['q'=>'','camara'=>0,'afiliado'=>$f['afiliado']] : $f);
        $totales = array_fill_keys(['apariciones','visitas','telefono','whatsapp','web','redes','mapa','promociones','contactos'],0);
        foreach ($filas as $fila) foreach ($totales as $k=>$_) $totales[$k] += $fila[$k];
        $alcance = match ($usuario['rol']) {
            'ADMIN_GENERAL'=>'Todas las cámaras', 'ADMIN_CAMARA'=>'Afiliados de tu cámara', default=>'Tus empresas',
        };
        if ($f['camara']>0 && $camaras) foreach ($camaras as $c) if ((int)$c['idCamara']===$f['camara']) $alcance=$c['nombre'];
        $datos = ['filtros'=>$f,'camaras'=>$camaras,'filas'=>$filas,'totales'=>$totales,'empresa'=>$empresa,
            'periodo'=>$modelo->periodo(),'alcance'=>$empresa ? $empresa['nombre_comercial'] : $alcance,
            'administracion'=>true,'urlRegreso'=>base_url('estadisticas').'?'.http_build_query(['camara'=>$f['camara'],'q'=>$f['q']])];
        if ($empresa) {
            $datos += ['empresas'=>[],'resumen'=>$modelo->resumen($f['afiliado']),'serie'=>$modelo->serieDiaria($f['afiliado']),
                'busquedas'=>$modelo->busquedasFrecuentes($f['afiliado']),'promociones'=>$modelo->promociones($f['afiliado']),
                'perfil'=>$modelo->perfil($f['afiliado'])];
        }
        return $datos;
    }
}
