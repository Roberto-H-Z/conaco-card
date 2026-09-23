# Revisión de seguridad — 19 de septiembre de 2026

Alcance: revisión del código de autenticación, sesiones, rutas, permisos, administración de usuarios, afiliados, promociones, validaciones, cargas de imágenes y configuración. No se modificó la aplicación ni se escribieron datos en la base de datos.

Se ejecutaron comprobaciones aisladas con PHP CLI sobre los helpers reales y la normalización del controlador. Apache local no respondió en `http://localhost/canaco-card/` (curl devolvió 000); no se pudo validar el comportamiento HTTP, las reglas efectivas de Apache ni el despliegue de producción. No es una certificación de ausencia de vulnerabilidades.

## Hallazgos de mayor prioridad

### 1. Alta — La desactivación y los cambios de permisos o contraseña no revocan sesiones existentes

**Corregido el 22 de septiembre de 2026.** El servidor compara el estado, hash de contraseña, rol, cámara asignada, afiliados asignados y permisos vigentes en cada solicitud de una sesión autenticada. Cierra la sesión si cualquiera cambia. Las sesiones anteriores al despliegue carecen de la nueva firma y se cerrarán al siguiente acceso. Prueba: `tests/seguridad-sesiones-camaras.php`.

Evidencia: `helpers/auth.helper.php:5`, `:28`, `:56`; `modelos/usuarios.modelo.php:186`, `:201`, `:229`.

`estaAutenticado()` solo comprueba un ID positivo en la sesión. Rol, permisos y afiliados asignados se copian al iniciar sesión; no se revalidan contra la base de datos. Desactivar una cuenta, reducir sus permisos, retirar una asignación o cambiar su contraseña no invalida esa autorización almacenada. Una sesión comprometida puede conservar acceso después de estas acciones administrativas.

Corrección: validar estado y una versión de sesión del usuario en cada petición protegida; incrementar esa versión ante cambios de contraseña, permisos, asignaciones o estado. Refrescar o invalidar también las sesiones cuando se modifique el rol compartido.

### 2. Alta — Un afiliado puede cambiar su propia cámara

**Corregido el 22 de septiembre de 2026.** En una edición, el servidor conserva la cámara actual y la sentencia SQL solo permite actualizar `idCamara` cuando el perfil es Administrador General. El selector aparece deshabilitado para afiliados. Prueba: `tests/seguridad-sesiones-camaras.php`.

Evidencia: `controladores/afiliados.controlador.php:32`, `:35`, `:162`, `:166`; `modelos/afiliados.modelo.php:95`.

La autorización comprueba que el afiliado pueda editar su empresa, pero acepta el `idCamara` enviado por el cliente. Solo se sustituye por la cámara de sesión para `ADMIN_CAMARA`; para `AFILIADO` se conserva el valor enviado. La validación solo exige una cámara activa y el UPDATE persiste ese valor. Esto permite trasladar una empresa entre ámbitos administrativos y retirarla del control de su cámara original; no demuestra acceso a empresas ajenas.

Corrección: conservar la cámara actual al editar como afiliado y autorizar explícitamente las transferencias únicamente al perfil administrativo correspondiente.

### 3. Media — Contraseñas enviadas por correo sin caducidad ni cambio obligatorio

Evidencia: `controladores/afiliados.controlador.php:135`, `:139`, `:221`; `modelos/usuarios.modelo.php:229`; `controladores/login.controlador.php:33`.

El envío de acceso reemplaza la contraseña real y la incluye legible en el correo. Aunque se llama temporal, el login no comprueba vencimiento ni exige sustituirla. Una copia del correo conserva una credencial utilizable hasta el siguiente cambio. El flujo disponible tampoco ofrece al afiliado una pantalla para cambiarla.

Corrección: enviar un enlace de activación/restablecimiento con token aleatorio, de un solo uso y vencimiento corto, almacenando solo su hash. Dejar que el destinatario establezca su contraseña y revocar las sesiones previas al completar el cambio.

### 4. Media — No hay vencimiento de sesión controlado por la aplicación

**Corregido el 22 de septiembre de 2026.** La sesión vence tras 15 minutos sin actividad o 8 horas desde el login. La navegación por el panel y las interacciones reales dentro de la página renuevan solo el plazo de inactividad; el servidor comprueba ambos límites antes de autorizar cada solicitud. Las sesiones previas a esta actualización se cerrarán porque carecen del nuevo registro de actividad. Prueba: `tests/seguridad-sesiones-camaras.php`.

Evidencia: `helpers/auth.helper.php:5`, `:41`; `index.php:10`.

`login_timestamp` se guarda, pero nunca se utiliza para verificar antigüedad. No hay límite absoluto ni control explícito de inactividad. La limpieza de sesiones de PHP y la duración de la cookie no sustituyen esa comprobación. Una sesión que siga existiendo se acepta independientemente de su fecha de inicio.

Corrección: comprobar tanto la última actividad como la fecha de autenticación, destruir la sesión al superar los límites definidos y solicitar autenticación nueva.

### 5. Media — El login diferencia cuentas por trabajo computacional y carece de límite por origen

Evidencia: `controladores/login.controlador.php:33`, `:44`, `:47`; `modelos/usuarios.modelo.php:26`.

Una cuenta inexistente omite `password_verify`; una existente lo ejecuta incluso bloqueada. El mensaje es genérico, pero el trabajo computacional difiere y puede facilitar enumeración por tiempos. Existe bloqueo por cuenta durante 15 minutos, pero no un límite por origen ni global en el código. Un atacante puede distribuir intentos entre cuentas o provocar bloqueos a usuarios conocidos. No se midió el canal temporal ni se comprobó si un proxy aplica límites externos.

Corrección: verificar un hash ficticio para usuarios inexistentes e incorporar límites persistentes por cuenta y origen, con registro de eventos y políticas que reduzcan el bloqueo malicioso de cuentas.

## Riesgos de configuración que requieren validar el despliegue

### 6. Alta si se usa en producción — Base de datos con usuario root y contraseña vacía

Evidencia: `config/database.php:15`; `modelos/conexion.php:28`.

La conexión utiliza directamente esa configuración; cargar `.env.local` no reemplaza estos valores. Es una configuración local de alto privilegio que no debe trasladarse a producción. No se consultaron los privilegios reales del servidor ni se intentó acceder a bases de datos.

Corrección: usar un usuario exclusivo con permisos mínimos sobre esta base y leer sus credenciales desde configuración privada del entorno.

### 7. Media — Errores visibles y transporte HTTPS no exigido en la aplicación

Evidencia: `config/config.php:36`, `:60`; `index.php:7`; `.htaccess`.

El entorno está fijado a development y activa `display_errors`. Excepciones no controladas pueden revelar rutas y detalles internos. La aplicación no redirige obligatoriamente a HTTPS; si se sirve por HTTP, permite enviar credenciales y crea una cookie sin Secure. Debe comprobarse si Apache o el proxy ya exigen HTTPS; no se confirmó exposición en producción.

Corrección: entorno configurable con errores ocultos y registros internos en producción; HTTPS obligatorio y tratamiento de cabeceras reenviadas solo desde proxies confiables.

### 8. Media, condicionada al servidor — Dominio del correo derivado de Host y bloqueo incompleto de archivos internos

Evidencia: `controladores/afiliados.controlador.php:200`; `.htaccess:28`.

Los enlaces de acceso y el remitente por defecto se construyen desde HTTP_HOST. Si el servidor acepta un Host arbitrario en una petición autenticada de envío, el correo puede apuntar a un dominio controlado por quien hace esa petición. La explotación requiere permiso de envío y CSRF válido; no se observó un restablecimiento público sin autenticación. Usar un origen canónico configurado evita esta dependencia.

Las reglas bloquean .env y ciertas extensiones, pero no deniegan por directorio `.git`, `tmp` o `tests`. Archivos como `.git/HEAD`, `.git/config` y documentos internos con extensiones no bloqueadas podrían servirse si se despliega el árbol completo y no existen otras restricciones. No se confirmó que estén accesibles por HTTP. Publicar solo los recursos necesarios y bloquear explícitamente directorios internos.

## Comprobaciones realizadas y controles presentes

- PHP CLI aceptó una sesión sintética con inicio de hace 30 días y devolvió su permiso almacenado sin consultar la base de datos. Esto demuestra la ausencia de comprobación en los helpers; no implica que PHP conserve siempre las sesiones durante 30 días.
- PHP CLI confirmó que un afiliado con permiso de edición sobre su empresa pasa la autorización y que la normalización conserva una cámara distinta enviada por el cliente. La persistencia se comprobó por lectura del UPDATE; no se ejecutó una transferencia real.
- Se observaron hash de contraseñas con password_hash/password_verify, regeneración del ID de sesión al autenticar, cookies HttpOnly/SameSite Strict, protección CSRF y exigencia de POST para acciones modificadoras.
- Los flujos revisados utilizan consultas preparadas, escape de texto HTML y comprobaciones de pertenencia para operaciones sobre afiliados y promociones. Las imágenes se restringen por MIME, dimensiones válidas, extensión generada y tamaño.
- No se confirmó SQL injection, XSS ni ejecución remota de código en los flujos inspeccionados. Esto no sustituye pruebas completas con cada perfil y con el servidor operativo.

Orden propuesto: revocación y límites de sesión; restricción de cambios de cámara; configuración de producción; sustitución del correo de contraseñas; límites y registro del login; validación HTTP y pruebas de regresión entre perfiles.
