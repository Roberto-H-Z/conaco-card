<?php
declare(strict_types=1);

final class ControladorAfiliados
{
    public function index(): array
    {
        $filtros=['busqueda'=>mb_substr(trim((string)($_GET['q']??'')),0,100),'estado'=>in_array((string)($_GET['estado']??''),['0','1'],true)?(string)$_GET['estado']:'','camara'=>max(0,(int)($_GET['camara']??0)),'localidad'=>max(0,(int)($_GET['localidad']??0)),'categoria'=>max(0,(int)($_GET['categoria']??0))];
        $usuario=obtenerUsuarioSesion();
        $alcance=$usuario['rol']==='AFILIADO'?$usuario['afiliados']:null;
        $camaraEstadisticas=$usuario['rol']==='ADMIN_CAMARA'?$usuario['idCamara']:null;
        return ['listado'=>ModeloAfiliados::listar($filtros,max(1,(int)($_GET['pagina']??1)),15,$alcance),'estadisticas'=>ModeloAfiliados::estadisticas($alcance,$camaraEstadisticas),'camaras'=>ModeloAfiliados::obtenerCamaras(),'estados'=>ModeloAfiliados::obtenerEstados(),'localidadesFiltro'=>ModeloAfiliados::obtenerLocalidadesParaFiltro(),'categorias'=>ModeloAfiliados::obtenerCategorias(),'filtros'=>$filtros,'puedeCrear'=>puedeCrearAfiliado()];
    }

    public function obtener(): void { $this->exigirMetodo('GET');$id=$this->idGet('id');if(!puedeVerAfiliado($id))$this->prohibido();$a=ModeloAfiliados::obtenerPorId($id);if(!$a)$this->json(['status'=>'error','message'=>'El afiliado no existe.'],404);$this->json(['status'=>'success','data'=>$a]); }
    public function municipios(): void { $this->exigirMetodo('GET');$this->json(['status'=>'success','data'=>ModeloAfiliados::obtenerMunicipios($this->idGet('estado'))]); }
    public function localidades(): void { $this->exigirMetodo('GET');$this->json(['status'=>'success','data'=>ModeloAfiliados::obtenerLocalidades($this->idGet('municipio'))]); }

    public function guardar(): void
    {
        $this->exigirMetodo('POST'); $input=$_POST ?: $this->entradaJson(); $this->validarCsrf($input);
        $d=$this->normalizar($input);
        if($d['idAfiliado']===null&&!this->puedeCrear())$this->prohibido();
        if($d['idAfiliado']!==null&&!puedeModificarAfiliado($d['idAfiliado']))$this->prohibido();
        $usuario=obtenerUsuarioSesion();
        if($usuario['rol']==='ADMIN_CAMARA'){
            if($usuario['idCamara']===null)$this->prohibido();
            $d['idCamara']=$usuario['idCamara'];
        }
        $d['idUsuario']=$usuario['id'];
        $errores=$this->validar($d);
        if($d['idAfiliado']===null && (($_FILES['logo']['error']??UPLOAD_ERR_NO_FILE)!==UPLOAD_ERR_OK))$errores['logo']='El logotipo es obligatorio al registrar un afiliado.';
        if($errores)$this->json(['status'=>'error','message'=>'Revisa los campos marcados.','errors'=>$errores],422);
        $slugBase=$this->slug($d['nombre_comercial']);$d['slug']=$slugBase;$i=2;while(ModeloAfiliados::slugExiste($d['slug'],$d['idAfiliado']))$d['slug']=$slugBase.'-'.$i++;
        $pdo=Conexion::conectar();$rutas=[];
        try {
            $pdo->beginTransaction();$id=ModeloAfiliados::guardarCompleto($pdo,$d);
            if($d['crearUsuarioAcceso']) ModeloUsuarios::crearAccesoAfiliado($pdo,$id,$d['usuarioNombre'],$d['correo_general'],password_hash($d['usuarioPassword'],PASSWORD_DEFAULT));
            $logo=$this->subirUno($_FILES['logo']??null,'logo');if($logo){$rutas[]=$logo['ruta'];ModeloAfiliados::guardarArchivo($pdo,$id,$logo,'LOGOTIPO',1);}
            $galeria=$_FILES['galeria']??null;if($galeria&&is_array($galeria['name'])){if(count(array_filter($galeria['name']))>10)throw new RuntimeException('La galería admite como máximo 10 imágenes por carga.');$orden=1;foreach($galeria['name'] as $n=>$nombre){if($nombre==='')continue;$file=[];foreach(['name','type','tmp_name','error','size'] as $k)$file[$k]=$galeria[$k][$n];$img=$this->subirUno($file,'galeria');if($img){$rutas[]=$img['ruta'];ModeloAfiliados::guardarArchivo($pdo,$id,$img,'GALERIA',$orden++);}}}
            $pdo->commit();$mensaje=$d['idAfiliado']?'Afiliado actualizado correctamente.':($d['crearUsuarioAcceso']?'Afiliado y usuario de acceso registrados correctamente.':'Afiliado registrado correctamente.');$this->json(['status'=>'success','message'=>$mensaje,'data'=>['idAfiliado'=>$id]],$d['idAfiliado']?200:201);
        } catch(PDOException $e){if($pdo->inTransaction())$pdo->rollBack();$this->limpiarArchivos($rutas);registrarLog('No se pudo guardar afiliado: '.$e->getMessage(),'ERROR');$duplicado=$e->getCode()==='23000';$this->json(['status'=>'error','message'=>$duplicado?'Existe un registro duplicado (RFC, canal o archivo).':'No fue posible guardar el afiliado.'],$duplicado?409:500);}
        catch(RuntimeException $e){if($pdo->inTransaction())$pdo->rollBack();$this->limpiarArchivos($rutas);$this->json(['status'=>'error','message'=>$e->getMessage()],422);}
    }

    public function cambiarEstado(): void { $this->exigirMetodo('POST');$in=$this->entradaJson();$this->validarCsrf($in);$id=filter_var($in['idAfiliado']??null,FILTER_VALIDATE_INT,['options'=>['min_range'=>1]]);$activo=filter_var($in['activo']??null,FILTER_VALIDATE_BOOLEAN,FILTER_NULL_ON_FAILURE);$motivo=trim((string)($in['motivo']??''));if(!$id||$activo===null||mb_strlen($motivo)>500)$this->json(['status'=>'error','message'=>'Los datos para cambiar el estado no son válidos.'],422);if(!puedeCambiarEstadoAfiliado((int)$id))$this->prohibido();if(!ModeloAfiliados::cambiarEstado((int)$id,$activo,$motivo?:null,obtenerUsuarioSesion()['id']))$this->json(['status'=>'error','message'=>'El afiliado no existe o ya tiene ese estado.'],404);$this->json(['status'=>'success','message'=>$activo?'Afiliado activado.':'Afiliado desactivado.']); }

    private function normalizar(array $in): array
    {
        $id=empty($in['idAfiliado'])?null:filter_var($in['idAfiliado'],FILTER_VALIDATE_INT,['options'=>['min_range'=>1]]);
        $palabras=array_values(array_unique(array_filter(array_map('trim',preg_split('/[,\n]+/',(string)($in['palabras_clave']??''))?:[]))));
        $categorias=array_values(array_unique(array_filter(array_map('intval',(array)($in['categorias']??[])))));
        $texto=fn(string $k,int $max=5000)=>mb_substr(trim((string)($in[$k]??'')),0,$max);
        return ['idAfiliado'=>$id===false?null:$id,'idCamara'=>(int)($in['idCamara']??0),'rfc'=>strtoupper(preg_replace('/\s+/','',$texto('rfc',13))??''),'nombre_comercial'=>$texto('nombre_comercial',180),'razon_social'=>$texto('razon_social',180),'alias'=>$texto('alias',120),'descripcion'=>$texto('descripcion'),'correo_general'=>strtolower($texto('correo_general',254)),'encargado'=>$texto('encargado',160),'cargo_encargado'=>$texto('cargo_encargado',100),'idLocalidad'=>(int)($in['idLocalidad']??0),'calle'=>$texto('calle',160),'numero_exterior'=>$texto('numero_exterior',20),'numero_interior'=>$texto('numero_interior',20),'colonia'=>$texto('colonia',130),'codigo_postal'=>$texto('codigo_postal',5),'referencias'=>$texto('referencias',500),'latitud'=>$texto('latitud',20),'longitud'=>$texto('longitud',20),'google_place_id'=>$texto('google_place_id',255),'telefono'=>$texto('telefono',50),'whatsapp'=>$texto('whatsapp',50),'facebook'=>$texto('facebook',700),'instagram'=>$texto('instagram',700),'sitio_web'=>$texto('sitio_web',700),'categorias'=>$categorias,'palabras'=>$palabras,'crearUsuarioAcceso'=>(string)($in['crear_usuario_acceso']??'')==='1','usuarioNombre'=>$texto('usuario_nombre',150),'usuarioPassword'=>(string)($in['usuario_password']??''),'usuarioPasswordConfirmacion'=>(string)($in['usuario_password_confirmacion']??'')];
    }
    private function validar(array $d): array
    {
        $e=[];if(!$d['idCamara']||!ModeloAfiliados::camaraActivaExiste($d['idCamara']))$e['idCamara']='Selecciona una cámara válida.';if(!preg_match('/^[A-Z0-9Ñ&]{12,13}$/u',$d['rfc']))$e['rfc']='Captura un RFC válido de 12 o 13 caracteres.';if($d['nombre_comercial']==='')$e['nombre_comercial']='El nombre comercial es obligatorio.';if($d['descripcion']==='')$e['descripcion']='La descripción es obligatoria.';if(!filter_var($d['correo_general'],FILTER_VALIDATE_EMAIL))$e['correo_general']='Captura un correo válido.';if($d['encargado']==='')$e['encargado']='El nombre del encargado es obligatorio.';if(!$d['idLocalidad']||!ModeloAfiliados::localidadActivaExiste($d['idLocalidad']))$e['idLocalidad']='Selecciona una localidad válida.';if($d['calle']==='')$e['calle']='El domicilio es obligatorio.';if(preg_replace('/\D+/','',$d['telefono'])==='')$e['telefono']='El teléfono es obligatorio.';if(!$d['categorias']||!ModeloAfiliados::categoriasValidas($d['categorias']))$e['categorias']='Selecciona al menos una categoría activa.';if(count($d['palabras'])>10)$e['palabras_clave']='Puedes registrar máximo 10 palabras clave.';foreach($d['palabras'] as $p)if(mb_strlen($p)>80){$e['palabras_clave']='Cada palabra clave admite hasta 80 caracteres.';break;}foreach(['facebook','instagram','sitio_web']as$campo)if($d[$campo]!==''&&!filter_var($d[$campo],FILTER_VALIDATE_URL))$e[$campo]='Captura una URL válida, incluyendo https://.';if($d['codigo_postal']!==''&&!preg_match('/^\d{5}$/',$d['codigo_postal']))$e['codigo_postal']='El código postal debe tener 5 dígitos.';if(($d['latitud']!==''&&!is_numeric($d['latitud']))||($d['longitud']!==''&&!is_numeric($d['longitud'])))$e['latitud']='Las coordenadas deben ser numéricas.';if($d['crearUsuarioAcceso']){if($d['idAfiliado']!==null)$e['crear_usuario_acceso']='El usuario de acceso solo se crea al registrar un nuevo afiliado.';if($d['usuarioNombre']==='')$e['usuario_nombre']='Captura el nombre de la persona que tendrá acceso.';if(mb_strlen($d['usuarioPassword'])<10||!preg_match('/[A-Za-z]/',$d['usuarioPassword'])||!preg_match('/\d/',$d['usuarioPassword']))$e['usuario_password']='Usa mínimo 10 caracteres, incluyendo letras y números.';if($d['usuarioPassword']!==$d['usuarioPasswordConfirmacion'])$e['usuario_password_confirmacion']='Las contraseñas no coinciden.';if(filter_var($d['correo_general'],FILTER_VALIDATE_EMAIL)&&ModeloUsuarios::correoExiste($d['correo_general']))$e['correo_general']='Este correo ya está registrado como usuario.';}return$e;
    }
    private function subirUno(?array $file,string $tipo):?array
    {
        if(!$file||($file['error']??UPLOAD_ERR_NO_FILE)===UPLOAD_ERR_NO_FILE)return null;if(($file['error']??0)!==UPLOAD_ERR_OK)throw new RuntimeException('No fue posible cargar una imagen.');if(($file['size']??0)>2*1024*1024)throw new RuntimeException('Cada imagen puede pesar máximo 2 MB.');$finfo=new finfo(FILEINFO_MIME_TYPE);$mime=$finfo->file($file['tmp_name']);$ext=['image/jpeg'=>'jpg','image/png'=>'png','image/webp'=>'webp'][$mime]??null;if(!$ext)throw new RuntimeException('Solo se permiten imágenes JPG, PNG o WEBP.');$dim=getimagesize($file['tmp_name']);if(!$dim)throw new RuntimeException('El archivo de imagen no es válido.');$rel='afiliados/'.gmdate('Y/m').'/'.bin2hex(random_bytes(16)).'.'.$ext;$dest=UPLOADS_PATH.$rel;$dir=dirname($dest);if(!is_dir($dir)&&!mkdir($dir,0755,true)&&!is_dir($dir))throw new RuntimeException('No fue posible preparar el almacenamiento de imágenes.');if(!move_uploaded_file($file['tmp_name'],$dest))throw new RuntimeException('No fue posible guardar la imagen.');return['nombre'=>mb_substr(basename((string)$file['name']),0,255),'key'=>$rel,'url'=>base_url('uploads/'.$rel),'mime'=>$mime,'peso'=>(int)$file['size'],'ancho'=>(int)$dim[0],'alto'=>(int)$dim[1],'hash'=>hash_file('sha256',$dest),'alt'=>$tipo==='logo'?'Logotipo':'Galería','ruta'=>$dest];
    }
    private function limpiarArchivos(array $rutas):void{foreach($rutas as $ruta)if(is_file($ruta))@unlink($ruta);}
    private function idGet(string $nombre):int{$id=filter_input(INPUT_GET,$nombre,FILTER_VALIDATE_INT,['options'=>['min_range'=>1]]);if(!$id)$this->json(['status'=>'error','message'=>'Identificador inválido.'],422);return(int)$id;}
    private function slug(string $t):string{$ascii=iconv('UTF-8','ASCII//TRANSLIT//IGNORE',$t)?:$t;$slug=strtolower(trim((string)preg_replace('/[^a-zA-Z0-9]+/','-',$ascii),'-'));return mb_substr($slug?:'afiliado',0,180);}
    private function entradaJson():array{$d=json_decode((string)file_get_contents('php://input'),true);if(!is_array($d))$this->json(['status'=>'error','message'=>'El cuerpo de la solicitud no es válido.'],400);return$d;}
    private function validarCsrf(array $in):void{$token=(string)($_SERVER['HTTP_X_CSRF_TOKEN']??($in['csrf_token']??''));if(!validarTokenCSRF($token))$this->json(['status'=>'error','message'=>'La sesión del formulario expiró. Recarga la página.'],419);}
    private function exigirMetodo(string $m):void{if(($_SERVER['REQUEST_METHOD']??'GET')!==$m){header('Allow: '.$m);$this->json(['status'=>'error','message'=>'Método no permitido.'],405);}}
    private function puedeCrear():bool{return puedeCrearAfiliado();}
    private function prohibido():never{$this->json(['status'=>'error','message'=>'No tienes permiso para acceder a la información solicitada.'],403);}
    private function json(array $d,int $s=200):never{http_response_code($s);header('Content-Type: application/json; charset=utf-8');echo json_encode($d,JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES);exit;}
}
