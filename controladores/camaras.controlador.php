<?php
declare(strict_types=1);

final class ControladorCamaras extends ControladorCatalogosAdmin
{
    public function index(): array
    {
        $this->autorizar(null);
        $q = mb_substr(trim((string)($_GET['q'] ?? '')),0,100);
        $activo = in_array($_GET['estado'] ?? '', ['0','1'], true) ? $_GET['estado'] : '';
        return ['listado'=>ModeloCamarasAdmin::listar($q,$activo), 'filtros'=>['q'=>$q,'estado'=>$activo], 'ciudades'=>ModeloCatalogosAdmin::ciudades()];
    }

    public function obtener(): never
    {
        $this->autorizar(null); $this->metodo('GET');
        $camara = ModeloCamarasAdmin::obtener($this->idGet());
        if (!$camara) $this->json(['status'=>'error','message'=>'La cámara no existe.'],404);
        $this->json(['status'=>'success','data'=>$camara]);
    }

    public function guardar(): never
    {
        $this->autorizar(null); $this->metodo('POST');
        $in = $this->entrada(); $this->csrf($in);
        $id = empty($in['idCamara']) ? null : filter_var($in['idCamara'], FILTER_VALIDATE_INT, ['options'=>['min_range'=>1]]);
        if ($id === false) $this->json(['status'=>'error','message'=>'Identificador inválido.'],422);
        $actual = $id ? ModeloCamarasAdmin::obtener($id) : null;
        if ($id && !$actual) $this->json(['status'=>'error','message'=>'La cámara no existe.'],404);
        $datos = ['idCamara'=>$id]; $errores = [];
        foreach (['clave'=>30,'nombre'=>180,'nombre_corto'=>80,'correo'=>254,'telefono'=>20] as $campo=>$max) {
            $datos[$campo] = trim((string)($in[$campo] ?? ''));
            if (mb_strlen($datos[$campo]) > $max) $errores[$campo] = "Máximo $max caracteres.";
        }
        if ($datos['clave']==='') $errores['clave']='La clave es obligatoria.';
        if ($datos['nombre']==='') $errores['nombre']='El nombre es obligatorio.';
        if ($datos['correo']!=='' && !filter_var($datos['correo'],FILTER_VALIDATE_EMAIL)) $errores['correo']='Captura un correo válido.';
        if ($datos['telefono']!=='' && (!preg_match('/^[+()\d .-]{7,20}$/',$datos['telefono']) || strlen(preg_replace('/\D/','',$datos['telefono']) ?? '')<7)) $errores['telefono']='Captura un teléfono válido.';
        $sede = empty($in['idMunicipioSede']) ? null : filter_var($in['idMunicipioSede'],FILTER_VALIDATE_INT,['options'=>['min_range'=>1]]);
        $datos['idMunicipioSede'] = $sede ?: null;
        if (!in_array((string)($in['activo'] ?? '1'),['0','1'],true)) $errores['activo']='Estado inválido.';
        $datos['activo'] = (int)($in['activo'] ?? 1);
        $opciones = [];
        foreach (ModeloCatalogosAdmin::ciudades() as $c) $opciones[(int)$c['idMunicipio']] = $c;
        $anteriores = array_map('intval',array_column($actual['ciudades'] ?? [],'idMunicipio'));
        $seleccionadas = $in['ciudades'] ?? []; $tipos = $in['cobertura'] ?? []; $ciudades = [];
        if (!is_array($seleccionadas) || !is_array($tipos)) $errores['ciudades']='La selección de ciudades no es válida.';
        else foreach ($seleccionadas as $valor) {
            $municipio = filter_var($valor,FILTER_VALIDATE_INT,['options'=>['min_range'=>1]]);
            if (!$municipio || !isset($opciones[$municipio]) || (!(int)$opciones[$municipio]['activo'] && !in_array($municipio,$anteriores,true))) {
                $errores['ciudades']='Selecciona ciudades existentes y activas.'; continue;
            }
            $tipo = $tipos[$municipio] ?? 'DIRECTA';
            if (!in_array($tipo,['DIRECTA','EXTENDIDA'],true)) $errores['ciudades']='Tipo de cobertura inválido.';
            else $ciudades[$municipio] = $tipo;
        }
        if ($sede === false || ($sede && (!isset($opciones[$sede]) || (!(int)$opciones[$sede]['activo'] && (int)($actual['idMunicipioSede'] ?? 0)!==$sede)))) $errores['idMunicipioSede']='Selecciona una ciudad sede válida.';
        if ($sede && !isset($ciudades[$sede])) $errores['ciudades']='Incluye la ciudad sede entre las ciudades de cobertura.';
        $stmt = Conexion::conectar()->prepare('SELECT 1 FROM camaras WHERE clave=? AND idCamara<>?');
        $stmt->execute([$datos['clave'],$id ?? 0]);
        if ($stmt->fetchColumn()) $errores['clave']='Esta clave ya está registrada.';
        if ($errores) $this->json(['status'=>'error','message'=>'Revisa los campos marcados.','errors'=>$errores],422);
        $db = Conexion::conectar();
        try {
            $db->beginTransaction();
            $nuevoId = ModeloCamarasAdmin::guardar($db,$datos,$ciudades);
            $db->commit();
        } catch (Throwable $error) {
            if ($db->inTransaction()) $db->rollBack();
            registrarLog('Error al guardar cámara: '.$error->getMessage(),'ERROR');
            $this->json(['status'=>'error','message'=>'No fue posible guardar la cámara. Comprueba que la clave no esté duplicada e intenta de nuevo.'],500);
        }
        $this->json(['status'=>'success','message'=>'Cámara guardada correctamente.','data'=>['idCamara'=>$nuevoId]],$id ? 200 : 201);
    }

    public function cambiarEstado(): never
    {
        $this->autorizar(null); $this->metodo('POST'); $in=$this->entrada(); $this->csrf($in);
        $id=filter_var($in['idCamara'] ?? null,FILTER_VALIDATE_INT,['options'=>['min_range'=>1]]);
        $activo=isset($in['activo']) ? filter_var($in['activo'],FILTER_VALIDATE_BOOLEAN,FILTER_NULL_ON_FAILURE) : null;
        if (!$id || $activo===null) $this->json(['status'=>'error','message'=>'Datos inválidos.'],422);
        if (!ModeloCamarasAdmin::cambiarEstado($id,$activo)) $this->json(['status'=>'error','message'=>'La cámara no existe o ya tiene ese estado.'],404);
        $this->json(['status'=>'success','message'=>$activo?'Cámara activada.':'Cámara desactivada.']);
    }
}
