<?php
declare(strict_types=1);

final class ControladorUsuarios
{
    public function index(): array
    {
        $this->autorizar();
        $filtros = ['q'=>mb_substr(trim((string) ($_GET['q'] ?? '')),0,100),'rol'=>max(0,(int) ($_GET['rol'] ?? 0)),'estado'=>in_array((string) ($_GET['estado'] ?? ''),['0','1'],true) ? (string) $_GET['estado'] : ''];
        return ['filtros'=>$filtros,'listado'=>ModeloUsuarios::listarAdministracion($filtros,max(1,(int) ($_GET['pagina'] ?? 1)),15),'estadisticas'=>ModeloUsuarios::estadisticasAdministracion(),'roles'=>ModeloUsuarios::rolesActivos(),'camaras'=>ModeloUsuarios::camarasActivas(),'afiliados'=>ModeloUsuarios::afiliadosActivos()];
    }

    public function obtener(): void
    {
        $this->autorizar(); $this->metodo('GET');
        $usuario = ModeloUsuarios::obtenerAdministracion($this->idGet('id'));
        if (!$usuario) $this->json(['status'=>'error','message'=>'El usuario no existe.'],404);
        $this->json(['status'=>'success','data'=>$usuario]);
    }

    public function guardar(): void
    {
        $this->autorizar(); $this->metodo('POST'); $entrada = $_POST ?: $this->entrada(); $this->csrf($entrada);
        $datos = $this->normalizar($entrada);
        if ($datos['idUsuario'] !== null && !ModeloUsuarios::obtenerAdministracion($datos['idUsuario'])) $this->json(['status'=>'error','message'=>'El usuario no existe.'],404);
        if ($datos['idUsuario'] === obtenerUsuarioSesion()['id'] && (!$datos['activo'] || $datos['rolClave'] !== 'ADMIN_GENERAL')) $this->json(['status'=>'error','message'=>'No puedes desactivar ni cambiar el perfil de tu propia sesión.'],422);
        $errores = $this->validar($datos);
        if ($errores) $this->json(['status'=>'error','message'=>'Revisa los campos marcados.','errors'=>$errores],422);
        $db = Conexion::conectar();
        try { $db->beginTransaction(); $id = ModeloUsuarios::guardarAdministracion($db,$datos); $db->commit(); }
        catch (Throwable $e) { if ($db->inTransaction()) $db->rollBack(); registrarLog('Error al guardar usuario: '.get_class($e).' '.$e->getMessage(),'ERROR'); $this->json(['status'=>'error','message'=>'No fue posible guardar el usuario.'],500); }
        $this->json(['status'=>'success','message'=>$datos['idUsuario'] ? 'Usuario actualizado correctamente.' : 'Usuario registrado correctamente.','data'=>['idUsuario'=>$id]],$datos['idUsuario'] ? 200 : 201);
    }

    public function cambiarEstado(): void
    {
        $this->autorizar(); $this->metodo('POST'); $entrada=$this->entrada(); $this->csrf($entrada);
        $id=filter_var($entrada['idUsuario']??null,FILTER_VALIDATE_INT,['options'=>['min_range'=>1]]); $activo=filter_var($entrada['activo']??null,FILTER_VALIDATE_BOOLEAN,FILTER_NULL_ON_FAILURE);
        if (!$id || $activo===null) $this->json(['status'=>'error','message'=>'Los datos para cambiar el estado no son válidos.'],422);
        if ((int)$id === obtenerUsuarioSesion()['id'] && !$activo) $this->json(['status'=>'error','message'=>'No puedes desactivar tu propia sesión.'],422);
        if (!ModeloUsuarios::cambiarEstadoAdministracion((int)$id,$activo)) $this->json(['status'=>'error','message'=>'El usuario no existe o ya tiene ese estado.'],404);
        $this->json(['status'=>'success','message'=>$activo ? 'Usuario activado.' : 'Usuario desactivado.']);
    }

    private function normalizar(array $entrada): array
    {
        $id=empty($entrada['idUsuario']) ? null : filter_var($entrada['idUsuario'],FILTER_VALIDATE_INT,['options'=>['min_range'=>1]]);
        $afiliados=array_values(array_unique(array_filter(array_map('intval',(array)($entrada['afiliados']??[])),fn($valor)=>$valor>0)));
        $idRol=(int)($entrada['idRol']??0); $rolClave=ModeloUsuarios::rolActivo($idRol);
        return ['idUsuario'=>$id === false ? null : $id,'idRol'=>$idRol,'rolClave'=>$rolClave,'nombre'=>mb_substr(trim((string)($entrada['nombre']??'')),0,150),'correo'=>mb_strtolower(mb_substr(trim((string)($entrada['correo']??'')),0,254)),'password'=>(string)($entrada['password']??''),'passwordConfirmacion'=>(string)($entrada['password_confirmacion']??''),'idCamara'=>max(0,(int)($entrada['idCamara']??0)),'afiliados'=>$afiliados,'activo'=>(string)($entrada['activo']??'1') !== '0'];
    }

    private function validar(array $datos): array
    {
        $errores=[];
        if ($datos['nombre']==='') $errores['nombre']='El nombre es obligatorio.';
        if (!filter_var($datos['correo'],FILTER_VALIDATE_EMAIL)) $errores['correo']='Captura un correo electrónico válido.';
        elseif (ModeloUsuarios::correoExisteExcepto($datos['correo'],$datos['idUsuario'])) $errores['correo']='Ya existe un usuario con este correo electrónico.';
        if (!$datos['rolClave']) $errores['idRol']='Selecciona un perfil válido.';
        if ($datos['idUsuario']===null && $datos['password']==='') $errores['password']='La contraseña es obligatoria al registrar un usuario.';
        if ($datos['password']!=='' && (!preg_match('/^(?=.*[A-Za-z])(?=.*\d).{10,}$/',$datos['password']))) $errores['password']='Usa mínimo 10 caracteres, incluyendo letras y números.';
        if ($datos['password']!==$datos['passwordConfirmacion']) $errores['password_confirmacion']='Las contraseñas no coinciden.';
        if ($datos['rolClave']==='ADMIN_CAMARA' && (!$datos['idCamara'] || !ModeloUsuarios::camaraActiva($datos['idCamara']))) $errores['idCamara']='Selecciona una cámara activa.';
        if ($datos['rolClave']==='AFILIADO' && !ModeloUsuarios::afiliadosActivosValidos($datos['afiliados'])) $errores['afiliados']='Selecciona al menos un afiliado activo para este perfil.';
        return $errores;
    }

    private function autorizar(): void { if (!tieneRol('ADMIN_GENERAL') || !tienePermiso('usuarios.ver')) $this->prohibido(); }
    private function idGet(string $nombre): int { $id=filter_input(INPUT_GET,$nombre,FILTER_VALIDATE_INT,['options'=>['min_range'=>1]]); if(!$id)$this->json(['status'=>'error','message'=>'Identificador inválido.'],422); return (int)$id; }
    private function entrada(): array { $entrada=json_decode((string)file_get_contents('php://input'),true); if(!is_array($entrada))$this->json(['status'=>'error','message'=>'Solicitud inválida.'],400); return $entrada; }
    private function csrf(array $entrada): void { if(!validarTokenCSRF((string)($_SERVER['HTTP_X_CSRF_TOKEN']??($entrada['csrf_token']??''))))$this->json(['status'=>'error','message'=>'La sesión del formulario expiró. Recarga la página.'],419); }
    private function metodo(string $metodo): void { if(($_SERVER['REQUEST_METHOD']??'GET')!==$metodo)$this->json(['status'=>'error','message'=>'Método no permitido.'],405); }
    private function prohibido(): never { $this->json(['status'=>'error','message'=>'Esta gestión está disponible únicamente para el Administrador General.'],403); }
    private function json(array $datos,int $estado=200): never { http_response_code($estado); header('Content-Type: application/json; charset=utf-8'); echo json_encode($datos,JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES); exit; }
}
