<?php
declare(strict_types=1);

final class ControladorAfiliados
{
    public function index(): array
    {
        $filtros=['busqueda'=>mb_substr(trim((string)($_GET['q']??'')),0,100),'estado'=>in_array((string)($_GET['estado']??''),['0','1'],true)?(string)$_GET['estado']:'','camara'=>max(0,(int)($_GET['camara']??0)),'localidad'=>max(0,(int)($_GET['localidad']??0)),'categoria'=>max(0,(int)($_GET['categoria']??0))];
        $usuario=obtenerUsuarioSesion();
        if($usuario['rol']==='ADMIN_CAMARA'){
            if($usuario['idCamara']===null)$this->prohibido();
            $filtros['camara']=$usuario['idCamara'];
        }
        $alcance=$usuario['rol']==='AFILIADO'?$usuario['afiliados']:null;
        $camaraEstadisticas=$usuario['rol']==='ADMIN_CAMARA'?$usuario['idCamara']:null;
        return ['listado'=>ModeloAfiliados::listar($filtros,max(1,(int)($_GET['pagina']??1)),15,$alcance),'estadisticas'=>ModeloAfiliados::estadisticas($alcance,$camaraEstadisticas),'camaras'=>ModeloAfiliados::obtenerCamaras(),'estados'=>ModeloAfiliados::obtenerEstados(),'localidadesFiltro'=>ModeloAfiliados::obtenerLocalidadesParaFiltro(),'categorias'=>ModeloAfiliados::obtenerCategorias(),'filtros'=>$filtros,'puedeCrear'=>puedeCrearAfiliado(),'googleMapsKey'=>(string)(getenv('GOOGLE_MAPS_API_KEY')?:'')];
    }

    public function obtener(): void { $this->exigirMetodo('GET');$id=$this->idGet('id');if(!puedeVerAfiliado($id))$this->prohibido();$a=ModeloAfiliados::obtenerPorId($id);if(!$a)$this->json(['status'=>'error','message'=>'El afiliado no existe.'],404);$this->json(['status'=>'success','data'=>$a]); }
    public function municipios(): void { $this->exigirMetodo('GET');$this->json(['status'=>'success','data'=>ModeloAfiliados::obtenerMunicipios($this->idGet('estado'))]); }
    public function localidades(): void { $this->exigirMetodo('GET');$this->json(['status'=>'success','data'=>ModeloAfiliados::obtenerLocalidades($this->idGet('municipio'))]); }

    public function guardar(): void
    {
        $this->exigirMetodo('POST');
        $this->validarTamanoPeticion();
        $input=$_POST ?: $this->entradaJson();
        $this->validarCsrf($input);
        $pdo=null;$rutas=[];$d=[];$etapa='validación inicial';
        try {
            $d=$this->normalizar($input);
            if($d['idAfiliado']===null&&!$this->puedeCrear())$this->prohibido();
            if($d['idAfiliado']!==null&&!puedeModificarAfiliado($d['idAfiliado']))$this->prohibido();
            $usuario=obtenerUsuarioSesion();
            if($usuario['rol']==='ADMIN_CAMARA'){
                if($usuario['idCamara']===null)$this->prohibido();
                $d['idCamara']=$usuario['idCamara'];
            }
            $d['idUsuario']=$usuario['id'];
            $errores=$this->validar($d);
            if($d['idAfiliado']===null && (($_FILES['logo']['error']??UPLOAD_ERR_NO_FILE)!==UPLOAD_ERR_OK))$errores['logo']=$this->mensajeErrorCarga((int)($_FILES['logo']['error']??UPLOAD_ERR_NO_FILE),'El logotipo es obligatorio al registrar un afiliado.');
            if($errores)$this->json(['status'=>'error','message'=>'Revisa los campos marcados.','errors'=>$errores],422);

            $etapa='generación de la URL pública';
            $slugBase=$this->slug($d['nombre_comercial']);$d['slug']=$slugBase;$i=2;
            while(ModeloAfiliados::slugExiste($d['slug'],$d['idAfiliado']))$d['slug']=$slugBase.'-'.$i++;

            $etapa='conexión y datos del afiliado';
            $pdo=Conexion::conectar();$pdo->beginTransaction();
            $id=ModeloAfiliados::guardarCompleto($pdo,$d);
            if($d['crearUsuarioAcceso']){
                $etapa='creación del usuario de acceso';
                ModeloUsuarios::crearAccesoAfiliado($pdo,$id,$d['usuarioNombre'],$d['correo_general'],password_hash($d['usuarioPassword'],PASSWORD_DEFAULT));
            }
            $etapa='carga del logotipo';
            $logo=$this->subirUno($_FILES['logo']??null,'logo');
            if($logo){$rutas[]=$logo['ruta'];ModeloAfiliados::guardarArchivo($pdo,$id,$logo,'LOGOTIPO',1);}
            $etapa='carga de la galería';
            $galeria=$_FILES['galeria']??null;
            if($galeria&&is_array($galeria['name'])){
                if(count(array_filter($galeria['name']))>10)throw new RuntimeException('La galería admite como máximo 10 imágenes por carga.');
                $orden=1;
                foreach($galeria['name'] as $n=>$nombre){
                    if($nombre==='')continue;
                    $file=[];foreach(['name','type','tmp_name','error','size'] as $k)$file[$k]=$galeria[$k][$n];
                    $img=$this->subirUno($file,'galeria');
                    if($img){$rutas[]=$img['ruta'];ModeloAfiliados::guardarArchivo($pdo,$id,$img,'GALERIA',$orden++);}
                }
            }
            $etapa='confirmación de los cambios';
            $pdo->commit();
            $mensaje=$d['idAfiliado']?'Afiliado actualizado correctamente.':($d['crearUsuarioAcceso']?'Afiliado y usuario de acceso registrados correctamente.':'Afiliado registrado correctamente.');
            $this->json(['status'=>'success','message'=>$mensaje,'data'=>['idAfiliado'=>$id]],$d['idAfiliado']?200:201);
        } catch(PDOException $e){
            if($pdo instanceof PDO&&$pdo->inTransaction())$pdo->rollBack();$this->limpiarArchivos($rutas);
            $referencia=$this->registrarErrorGuardar($e,$etapa,$d);
            [$mensaje,$estado]=$this->mensajeErrorBaseDatos($e,$referencia);
            header('X-Request-ID: '.$referencia);$this->json(['status'=>'error','message'=>$mensaje,'reference'=>$referencia],$estado);
        } catch(RuntimeException $e){
            if($pdo instanceof PDO&&$pdo->inTransaction())$pdo->rollBack();$this->limpiarArchivos($rutas);
            $referencia=$this->registrarErrorGuardar($e,$etapa,$d);
            header('X-Request-ID: '.$referencia);$this->json(['status'=>'error','message'=>$e->getMessage().' Referencia: '.$referencia.'.','reference'=>$referencia],422);
        } catch(Throwable $e){
            if($pdo instanceof PDO&&$pdo->inTransaction())$pdo->rollBack();$this->limpiarArchivos($rutas);
            $referencia=$this->registrarErrorGuardar($e,$etapa,$d);
            header('X-Request-ID: '.$referencia);$this->json(['status'=>'error','message'=>'No fue posible completar el registro durante la etapa de '.$etapa.'. Referencia: '.$referencia.'.','reference'=>$referencia],500);
        }
    }

    public function cambiarEstado(): void
    {
        $this->exigirMetodo('POST');
        $in=$this->entradaJson();
        $this->validarCsrf($in);
        $id=filter_var($in['idAfiliado']??null,FILTER_VALIDATE_INT,['options'=>['min_range'=>1]]);
        $activo=filter_var($in['activo']??null,FILTER_VALIDATE_BOOLEAN,FILTER_NULL_ON_FAILURE);
        $motivo=trim((string)($in['motivo']??''));
        if(!$id||$activo===null||mb_strlen($motivo)>500)$this->json(['status'=>'error','message'=>'Los datos para cambiar el estado no son válidos.'],422);
        if(!$activo&&$motivo==='')$this->json(['status'=>'error','message'=>'Indica el motivo de la desactivación.','errors'=>['motivo'=>'El motivo de desactivación es obligatorio.']],422);
        if(!puedeCambiarEstadoAfiliado((int)$id))$this->prohibido();

        try{
            if(!ModeloAfiliados::cambiarEstado((int)$id,$activo,$motivo?:null,obtenerUsuarioSesion()['id']))$this->json(['status'=>'error','message'=>'El afiliado no existe o ya tiene ese estado.'],404);
        }catch(Throwable $e){
            $referencia='EST-'.gmdate('Ymd-His').'-'.strtoupper(bin2hex(random_bytes(3)));
            registrarLog('Error al cambiar estado del afiliado '.json_encode(['referencia'=>$referencia,'afiliado'=>(int)$id,'activo'=>$activo,'excepcion'=>get_class($e),'codigo'=>(string)$e->getCode(),'mensaje'=>$e->getMessage()],JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES),'ERROR');
            header('X-Request-ID: '.$referencia);
            $mensaje=(string)$e->getCode()==='42S22'
                ? 'La tabla de afiliados del servidor no tiene todas las columnas requeridas para registrar la desactivación.'
                : 'No fue posible cambiar el estado del afiliado.';
            $this->json(['status'=>'error','message'=>$mensaje.' Referencia: '.$referencia.'.','reference'=>$referencia],500);
        }

        $this->json(['status'=>'success','message'=>$activo?'Afiliado activado.':'Afiliado desactivado.']);
    }

    public function enviarAcceso(): void
    {
        $this->exigirMetodo('POST');
        $in=$this->entradaJson();
        $this->validarCsrf($in);
        $id=filter_var($in['idAfiliado']??null,FILTER_VALIDATE_INT,['options'=>['min_range'=>1]]);
        if(!$id)$this->json(['status'=>'error','message'=>'El afiliado indicado no es válido.'],422);
        if(!puedeEnviarAccesoAfiliado((int)$id))$this->prohibido();

        $acceso=ModeloAfiliados::obtenerAcceso((int)$id);
        if(!$acceso)$this->json(['status'=>'error','message'=>'Este afiliado todavía no tiene un usuario de acceso vinculado.'],422);
        if((int)$acceso['activo']!==1)$this->json(['status'=>'error','message'=>'El usuario de acceso está inactivo. Actívalo antes de enviar sus datos.'],422);
        if(!filter_var($acceso['correo'],FILTER_VALIDATE_EMAIL))$this->json(['status'=>'error','message'=>'El usuario no tiene un correo válido.'],422);

        $clave='acceso_afiliado_'.(int)$id;
        $ultimo=(int)($_SESSION[$clave]??0);
        if($ultimo>time()-60)$this->json(['status'=>'error','message'=>'Espera un minuto antes de volver a enviar este correo.'],429);

        $passwordTemporal=$this->generarPasswordTemporal();
        $pdo=Conexion::conectar();
        try{
            $pdo->beginTransaction();
            ModeloUsuarios::actualizarPasswordAcceso($pdo,(int)$acceso['idUsuario'],password_hash($passwordTemporal,PASSWORD_DEFAULT));
            $acceso['password_temporal']=$passwordTemporal;
            if(!$this->enviarCorreoAcceso($acceso))throw new RuntimeException('El servidor de correo no confirmó el envío.');
            $pdo->commit();
        }catch(Throwable $e){
            if($pdo->inTransaction())$pdo->rollBack();
            $referencia='MAIL-'.gmdate('Ymd-His').'-'.strtoupper(bin2hex(random_bytes(3)));
            registrarLog('Error al enviar acceso '.$referencia.': '.get_class($e).' '.$e->getMessage(),'ERROR');
            header('X-Request-ID: '.$referencia);
            $this->json(['status'=>'error','message'=>'No fue posible enviar los datos de acceso. La contraseña anterior se conservó. Referencia: '.$referencia.'.','reference'=>$referencia],503);
        }
        $_SESSION[$clave]=time();
        $this->json(['status'=>'success','message'=>'Se generó una nueva contraseña y los datos de acceso se enviaron a '.$acceso['correo'].'.']);
    }

    private function normalizar(array $in): array
    {
        $id=empty($in['idAfiliado'])?null:filter_var($in['idAfiliado'],FILTER_VALIDATE_INT,['options'=>['min_range'=>1]]);
        $palabras=array_values(array_unique(array_filter(array_map('trim',preg_split('/[,\n]+/',(string)($in['palabras_clave']??''))?:[]))));
        $categorias=array_values(array_unique(array_filter(array_map('intval',(array)($in['categorias']??[])))));
        $texto=fn(string $k,int $max=5000)=>mb_substr(trim((string)($in[$k]??'')),0,$max);
        $calle=$texto('calle',160);
        if($calle==='')$calle=$texto('direccion_busqueda',160);
        return ['idAfiliado'=>$id===false?null:$id,'idCamara'=>(int)($in['idCamara']??0),'rfc'=>strtoupper(preg_replace('/\s+/','',$texto('rfc',13))??''),'nombre_comercial'=>$texto('nombre_comercial',180),'razon_social'=>$texto('razon_social',180),'descripcion'=>$texto('descripcion'),'correo_general'=>strtolower($texto('correo_general',254)),'encargado'=>$texto('encargado',160),'cargo_encargado'=>$texto('cargo_encargado',100),'idLocalidad'=>(int)($in['idLocalidad']??0),'calle'=>$calle,'numero_exterior'=>$texto('numero_exterior',20),'numero_interior'=>$texto('numero_interior',20),'colonia'=>$texto('colonia',130),'codigo_postal'=>$texto('codigo_postal',5),'referencias'=>$texto('referencias',500),'latitud'=>$texto('latitud',20),'longitud'=>$texto('longitud',20),'google_place_id'=>$texto('google_place_id',255),'telefono'=>$texto('telefono',50),'whatsapp'=>$texto('whatsapp',50),'facebook'=>$texto('facebook',700),'instagram'=>$texto('instagram',700),'tiktok'=>$texto('tiktok',700),'sitio_web'=>$texto('sitio_web',700),'categorias'=>$categorias,'palabras'=>$palabras,'crearUsuarioAcceso'=>(string)($in['crear_usuario_acceso']??'')==='1','usuarioNombre'=>$texto('usuario_nombre',150),'usuarioPassword'=>(string)($in['usuario_password']??''),'usuarioPasswordConfirmacion'=>(string)($in['usuario_password_confirmacion']??'')];
    }
    private function validar(array $d): array
    {
        $e=[];
        if(!$d['idCamara']||!ModeloAfiliados::camaraActivaExiste($d['idCamara']))$e['idCamara']='Selecciona una cámara válida.';
        if(!preg_match('/^[A-Z0-9Ñ&]{12,13}$/u',$d['rfc'])){
            $e['rfc']='Captura un RFC válido de 12 o 13 caracteres.';
        }elseif(ModeloAfiliados::rfcExiste($d['rfc'],$d['idAfiliado'])){
            $e['rfc']='Este RFC ya pertenece a otro afiliado. Búscalo en el listado para editarlo o reactivarlo.';
        }
        if($d['nombre_comercial']==='')$e['nombre_comercial']='El nombre comercial es obligatorio.';
        if($d['descripcion']==='')$e['descripcion']='La descripción es obligatoria.';
        if(!filter_var($d['correo_general'],FILTER_VALIDATE_EMAIL))$e['correo_general']='Captura un correo válido.';
        if($d['encargado']==='')$e['encargado']='El nombre del encargado es obligatorio.';
        if(!$d['idLocalidad']||!ModeloAfiliados::localidadActivaExiste($d['idLocalidad']))$e['idLocalidad']='Selecciona una localidad válida.';
        if($d['calle']===''||$d['google_place_id']===''||$d['latitud']===''||$d['longitud']==='')$e['google_place_id']='Selecciona un domicilio de las sugerencias de Google Maps.';
        if(preg_replace('/\D+/','',$d['telefono'])==='')$e['telefono']='El teléfono es obligatorio.';
        if(!$d['categorias']||!ModeloAfiliados::categoriasValidas($d['categorias']))$e['categorias']='Selecciona al menos una categoría activa.';
        if(count($d['palabras'])>10)$e['palabras_clave']='Puedes registrar máximo 10 palabras clave.';
        foreach($d['palabras'] as $p)if(mb_strlen($p)>80){$e['palabras_clave']='Cada palabra clave admite hasta 80 caracteres.';break;}
        foreach(['facebook','instagram','tiktok','sitio_web']as$campo)if($d[$campo]!==''&&!filter_var($d[$campo],FILTER_VALIDATE_URL))$e[$campo]='Captura una URL válida, incluyendo https://.';
        if($d['codigo_postal']!==''&&!preg_match('/^\d{5}$/',$d['codigo_postal']))$e['codigo_postal']='El código postal debe tener 5 dígitos.';
        if(($d['latitud']!==''&&!is_numeric($d['latitud']))||($d['longitud']!==''&&!is_numeric($d['longitud'])))$e['google_place_id']='Google Maps devolvió coordenadas inválidas. Selecciona nuevamente el domicilio.';
        if(is_numeric($d['latitud'])&&((float)$d['latitud'] < -90||(float)$d['latitud'] > 90))$e['google_place_id']='Google Maps devolvió una latitud inválida.';
        if(is_numeric($d['longitud'])&&((float)$d['longitud'] < -180||(float)$d['longitud'] > 180))$e['google_place_id']='Google Maps devolvió una longitud inválida.';
        if($d['crearUsuarioAcceso']){
            if($d['idAfiliado']!==null)$e['crear_usuario_acceso']='El usuario de acceso solo se crea al registrar un nuevo afiliado.';
            if($d['usuarioNombre']==='')$e['usuario_nombre']='Captura el nombre de la persona que tendrá acceso.';
            if(mb_strlen($d['usuarioPassword'])<10||!preg_match('/[A-Za-z]/',$d['usuarioPassword'])||!preg_match('/\d/',$d['usuarioPassword']))$e['usuario_password']='Usa mínimo 10 caracteres, incluyendo letras y números.';
            if($d['usuarioPassword']!==$d['usuarioPasswordConfirmacion'])$e['usuario_password_confirmacion']='Las contraseñas no coinciden.';
            if(filter_var($d['correo_general'],FILTER_VALIDATE_EMAIL)&&ModeloUsuarios::correoExiste($d['correo_general']))$e['correo_general']='Este correo ya está registrado como usuario.';
        }
        return$e;
    }

    private function enviarCorreoAcceso(array $acceso): bool
    {
        $host=preg_replace('/[^a-z0-9.-]/i','',(string)($_SERVER['HTTP_HOST']??'canacocard.mx'))?:'canacocard.mx';
        $host=preg_replace('/:\d+$/','',$host);
        $remitente=(string)(getenv('MAIL_FROM')?:('no-reply@'.$host));
        if(!filter_var($remitente,FILTER_VALIDATE_EMAIL))$remitente='no-reply@canacocard.mx';
        $seguro=(!empty($_SERVER['HTTPS'])&&$_SERVER['HTTPS']!=='off')||((string)($_SERVER['HTTP_X_FORWARDED_PROTO']??'')==='https');
        $origen=($seguro?'https':'http').'://'.$host;
        $login=base_url('login');
        if(!preg_match('#^https?://#i',$login))$login=$origen.'/'.ltrim($login,'/');
        $logo=asset('media/app/CANACOCARD_Logo.png');
        if(!preg_match('#^https?://#i',$logo))$logo=$origen.'/'.ltrim($logo,'/');
        $asunto=mb_encode_mimeheader('Datos de acceso a CANACO Card','UTF-8');
        $mensaje=$this->generarHtmlCorreoAcceso($acceso,$login,$logo);
        $headers=['From: CANACO Card <'.$remitente.'>','Reply-To: '.$remitente,'MIME-Version: 1.0','Content-Type: text/html; charset=UTF-8','Content-Transfer-Encoding: 8bit','X-CANACO-Template: acceso-afiliado-v2','X-Mailer: PHP/'.PHP_VERSION];
        return mail((string)$acceso['correo'],$asunto,$mensaje,implode("\r\n",$headers));
    }

    private function generarHtmlCorreoAcceso(array $acceso,string $login,string $logo):string
    {
        $nombre=htmlspecialchars((string)$acceso['usuario_nombre'],ENT_QUOTES|ENT_SUBSTITUTE,'UTF-8');
        $empresa=htmlspecialchars((string)$acceso['nombre_comercial'],ENT_QUOTES|ENT_SUBSTITUTE,'UTF-8');
        $correo=htmlspecialchars((string)$acceso['correo'],ENT_QUOTES|ENT_SUBSTITUTE,'UTF-8');
        $password=htmlspecialchars((string)$acceso['password_temporal'],ENT_QUOTES|ENT_SUBSTITUTE,'UTF-8');
        $loginSeguro=htmlspecialchars($login,ENT_QUOTES|ENT_SUBSTITUTE,'UTF-8');
        $logoSeguro=htmlspecialchars($logo,ENT_QUOTES|ENT_SUBSTITUTE,'UTF-8');

        return <<<HTML
<!doctype html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="color-scheme" content="light only">
    <title>Datos de acceso a CANACO Card</title>
</head>
<body style="margin:0;padding:0;background:#f5f8fc;color:#162255;font-family:Arial,Helvetica,sans-serif;-webkit-text-size-adjust:100%;">
    <div style="display:none;max-height:0;overflow:hidden;opacity:0;color:transparent;">Tu acceso al panel de {$empresa} ya está disponible.</div>
    <table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0" style="width:100%;background:#f5f8fc;">
        <tr>
            <td align="center" style="padding:32px 16px;">
                <table role="presentation" width="620" cellspacing="0" cellpadding="0" border="0" style="width:100%;max-width:620px;background:#ffffff;border-radius:16px;overflow:hidden;box-shadow:0 18px 48px rgba(22,34,85,.12);">
                    <tr>
                        <td style="height:6px;background:#39a8dd;font-size:0;line-height:0;">&nbsp;</td>
                    </tr>
                    <tr>
                        <td style="padding:28px 40px 24px;background:#ffffff;border-bottom:1px solid #e5ebf5;">
                            <img src="{$logoSeguro}" width="176" alt="CANACO Card — De la montaña al mar" style="display:block;width:176px;max-width:100%;height:auto;border:0;">
                        </td>
                    </tr>
                    <tr>
                        <td style="padding:38px 40px 34px;background:#162255;">
                            <h1 style="margin:0;color:#ffffff;font-size:30px;line-height:1.15;letter-spacing:-.02em;font-weight:700;">Tu acceso está listo</h1>
                            <p style="margin:12px 0 0;color:#cbd5ee;font-size:16px;line-height:1.6;">Hola, {$nombre}. Ya puedes administrar la información de <strong style="color:#ffffff;">{$empresa}</strong> desde CANACO Card.</p>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding:36px 40px 18px;background:#ffffff;">
                            <p style="margin:0 0 18px;color:#52617c;font-size:14px;line-height:1.65;">Utiliza estos datos para iniciar sesión. La contraseña mostrada sustituye cualquier contraseña anterior asociada a esta cuenta.</p>
                            <table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0" style="width:100%;background:#f5f8fc;border:1px solid #dce5f2;border-radius:12px;">
                                <tr>
                                    <td style="padding:20px 22px 8px;color:#71809a;font-size:11px;line-height:1.4;font-weight:700;text-transform:uppercase;letter-spacing:.06em;">Correo de acceso</td>
                                </tr>
                                <tr>
                                    <td style="padding:0 22px 20px;color:#162255;font-family:'Courier New',Courier,monospace;font-size:16px;line-height:1.5;font-weight:700;word-break:break-word;">{$correo}</td>
                                </tr>
                                <tr>
                                    <td style="height:1px;padding:0 22px;background:#dce5f2;font-size:0;line-height:0;">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td style="padding:20px 22px 8px;color:#71809a;font-size:11px;line-height:1.4;font-weight:700;text-transform:uppercase;letter-spacing:.06em;">Contraseña temporal</td>
                                </tr>
                                <tr>
                                    <td style="padding:0 22px 20px;color:#26318c;font-family:'Courier New',Courier,monospace;font-size:19px;line-height:1.5;font-weight:700;letter-spacing:.02em;word-break:break-word;">{$password}</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding:14px 40px 30px;background:#ffffff;">
                            <table role="presentation" cellspacing="0" cellpadding="0" border="0">
                                <tr>
                                    <td align="center" bgcolor="#39a8dd" style="border-radius:12px;">
                                        <a href="{$loginSeguro}" target="_blank" rel="noopener noreferrer" style="display:inline-block;padding:15px 24px;color:#082044;font-size:14px;line-height:1.2;font-weight:700;text-decoration:none;">Ingresar al panel&nbsp;&nbsp;→</a>
                                    </td>
                                </tr>
                            </table>
                            <p style="margin:18px 0 0;color:#71809a;font-size:12px;line-height:1.6;">Si el botón no funciona, copia esta dirección en tu navegador:<br><a href="{$loginSeguro}" style="color:#1778bd;text-decoration:underline;word-break:break-all;">{$loginSeguro}</a></p>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding:22px 40px;background:#edf6e5;border-top:1px solid #d8ebc8;">
                            <p style="margin:0;color:#2f5d24;font-size:13px;line-height:1.6;"><strong>Protege tu acceso.</strong> No compartas estas credenciales. Si no solicitaste este correo, comunícate con tu Cámara CANACO.</p>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" style="padding:24px 32px;background:#f5f8fc;color:#71809a;font-size:11px;line-height:1.6;">
                            CANACO Card · De la montaña al mar<br>Este mensaje fue generado automáticamente; por favor, no compartas su contenido.
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>
HTML;
    }
    private function subirUno(?array $file,string $tipo):?array
    {
        if(!$file||($file['error']??UPLOAD_ERR_NO_FILE)===UPLOAD_ERR_NO_FILE)return null;
        if(($file['error']??UPLOAD_ERR_OK)!==UPLOAD_ERR_OK)throw new RuntimeException($this->mensajeErrorCarga((int)$file['error'],'No fue posible cargar una imagen.'));
        if(($file['size']??0)>2*1024*1024)throw new RuntimeException('Cada imagen puede pesar máximo 2 MB.');
        if(!class_exists('finfo'))throw new RuntimeException('El servidor no tiene habilitada la extensión Fileinfo necesaria para validar imágenes.');
        $finfo=new finfo(FILEINFO_MIME_TYPE);$mime=$finfo->file($file['tmp_name']);$ext=['image/jpeg'=>'jpg','image/png'=>'png','image/webp'=>'webp'][$mime]??null;
        if(!$ext)throw new RuntimeException('Solo se permiten imágenes JPG, PNG o WEBP.');$dim=getimagesize($file['tmp_name']);if(!$dim)throw new RuntimeException('El archivo de imagen no es válido.');$rel='afiliados/'.gmdate('Y/m').'/'.bin2hex(random_bytes(16)).'.'.$ext;$dest=UPLOADS_PATH.$rel;$dir=dirname($dest);if(!is_dir($dir)&&!mkdir($dir,0755,true)&&!is_dir($dir))throw new RuntimeException('No fue posible preparar el almacenamiento de imágenes. Verifica los permisos de la carpeta uploads.');if(!is_writable($dir))throw new RuntimeException('La carpeta de imágenes no tiene permisos de escritura en el servidor.');if(!move_uploaded_file($file['tmp_name'],$dest))throw new RuntimeException('El servidor recibió la imagen, pero no pudo guardarla en la carpeta uploads.');return['nombre'=>mb_substr(basename((string)$file['name']),0,255),'key'=>$rel,'url'=>base_url('uploads/'.$rel),'mime'=>$mime,'peso'=>(int)$file['size'],'ancho'=>(int)$dim[0],'alto'=>(int)$dim[1],'hash'=>hash_file('sha256',$dest),'alt'=>$tipo==='logo'?'Logotipo':'Galería','ruta'=>$dest];
    }
    private function validarTamanoPeticion():void{$longitud=(int)($_SERVER['CONTENT_LENGTH']??0);$limite=$this->bytesIni((string)ini_get('post_max_size'));if($longitud>0&&$limite>0&&$longitud>$limite)$this->json(['status'=>'error','message'=>'La carga completa supera el límite permitido por el servidor (post_max_size: '.ini_get('post_max_size').'). Reduce el peso de las imágenes.'],413);}
    private function bytesIni(string $valor):int{$valor=trim($valor);if($valor==='')return 0;$numero=(float)$valor;$unidad=strtolower(substr($valor,-1));return(int)round($numero*match($unidad){'g'=>1024**3,'m'=>1024**2,'k'=>1024,default=>1});}
    private function mensajeErrorCarga(int $codigo,string $predeterminado):string{return match($codigo){UPLOAD_ERR_INI_SIZE=>'La imagen supera upload_max_filesize del servidor ('.ini_get('upload_max_filesize').').',UPLOAD_ERR_FORM_SIZE=>'La imagen supera el tamaño permitido por el formulario.',UPLOAD_ERR_PARTIAL=>'La imagen se cargó parcialmente. Inténtalo nuevamente.',UPLOAD_ERR_NO_TMP_DIR=>'El servidor no tiene disponible la carpeta temporal de cargas.',UPLOAD_ERR_CANT_WRITE=>'El servidor no pudo escribir la imagen en su almacenamiento temporal.',UPLOAD_ERR_EXTENSION=>'Una extensión de PHP bloqueó la carga de la imagen.',default=>$predeterminado};}
    private function registrarErrorGuardar(Throwable $e,string $etapa,array $d):string{$referencia='AFL-'.gmdate('Ymd-His').'-'.strtoupper(bin2hex(random_bytes(3)));$contexto=['referencia'=>$referencia,'etapa'=>$etapa,'excepcion'=>get_class($e),'codigo'=>(string)$e->getCode(),'mensaje'=>$e->getMessage(),'archivo'=>basename($e->getFile()),'linea'=>$e->getLine(),'usuario'=>(int)($d['idUsuario']??0),'afiliado'=>(int)($d['idAfiliado']??0),'camara'=>(int)($d['idCamara']??0),'logo_error'=>(int)($_FILES['logo']['error']??UPLOAD_ERR_NO_FILE),'logo_bytes'=>(int)($_FILES['logo']['size']??0),'galeria_archivos'=>is_array($_FILES['galeria']['name']??null)?count(array_filter($_FILES['galeria']['name'])):0];registrarLog('Error al guardar afiliado '.json_encode($contexto,JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES),'ERROR');return$referencia;}
    private function mensajeErrorBaseDatos(PDOException $e,string $referencia):array{$codigo=(string)$e->getCode();$texto=mb_strtolower($e->getMessage());if($codigo==='23000'){if(str_contains($texto,'rfc'))return['Ese RFC fue registrado por otro proceso. Busca el afiliado existente para editarlo o reactivarlo. Referencia: '.$referencia.'.',409];if(str_contains($texto,'slug'))return['Ya existe una dirección pública igual para otro afiliado. Referencia: '.$referencia.'.',409];return['Existe un dato duplicado o una relación no válida en la base de datos. Referencia: '.$referencia.'.',409];}if(in_array($codigo,['42S02','42S22'],true))return['La estructura de la base de datos de producción no coincide con la versión del módulo. Referencia: '.$referencia.'.',500];if($codigo==='22001'||str_contains($texto,'data too long'))return['Uno de los datos supera el tamaño admitido por la base de datos. Referencia: '.$referencia.'.',422];return['La base de datos no pudo completar el registro. Referencia: '.$referencia.'.',500];}
    private function generarPasswordTemporal():string{return 'Cc7-'.strtoupper(bin2hex(random_bytes(5)));}
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
