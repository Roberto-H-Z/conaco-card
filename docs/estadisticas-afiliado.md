# Estadísticas de afiliados y administración

El periodo de consulta acordado para RF-008 es el último mes: 30 días naturales, incluido el día actual, en UTC (zona horaria usada por la conexión de datos). La pantalla `inicio` está disponible únicamente para el perfil AFILIADO con el permiso `estadisticas.ver`. Cuando el usuario administra varias empresas, el selector solo ofrece las vinculadas en `usuarios_afiliados`; el servidor vuelve a comprobar la vinculación antes de consultar cada ID.

## Consulta administrativa y descargas

La sección **Estadísticas** del menú administrativo abre `/estadisticas`. El Administrador General consulta todas las empresas y puede filtrar por cámara y nombre comercial. El Administrador de Cámara consulta exclusivamente las empresas que pertenecen actualmente a su cámara. Incluye afiliados inactivos y sin eventos para consultar su historial. La tabla se pagina de 20 en 20; sus totales y descargas abarcan todos los resultados filtrados.

Seleccionar una empresa abre `/estadisticas?afiliado=ID` con la misma tendencia, canales, datos diarios, búsquedas frecuentes y promociones del dashboard del afiliado. El enlace de regreso conserva los filtros. La consulta y `/estadisticas/exportar` vuelven a validar el alcance desde la sesión: cambiar IDs en la URL nunca amplía los permisos. Ambos requieren `estadisticas.ver`; los perfiles afiliados también pueden exportar desde su inicio y únicamente sus propias empresas.

Las descargas son archivos reales XLSX y PDF. El resumen contiene ocho indicadores por empresa y sus totales. Al exportar un detalle se añaden los 30 días de actividad, las cinco búsquedas frecuentes y hasta cinco promociones vigentes que muestra el dashboard. Las promociones son las vigentes al momento de consulta; las visitas corresponden al periodo indicado. XLSX conserva números y fechas con sus tipos y almacena los textos como cadenas, para impedir fórmulas inyectadas mediante nombres o búsquedas. Requiere la extensión PHP ZIP. PDF usa A4 horizontal, fuentes estándar, encabezados de tabla repetidos y paginación. No requiere Composer ni servicios externos.

`tests/estadisticas-permisos.php` comprueba aislamiento de perfiles, filtros, conteos, periodo UTC, coincidencia entre resumen/detalle/serie y exportaciones. Usa tablas temporales que desaparecen al cerrar la conexión. `tests/estadisticas-browser.cjs` comprueba navegación, descargas autenticadas, rechazo de exportaciones ajenas y responsividad. Sus sesiones de QA se crean y destruyen mediante un helper exclusivo de CLI; no modifica contraseñas ni accesos de las cuentas.

## Correspondencia con RF-008

| Indicador | Fuente |
| --- | --- |
| Apariciones en búsquedas | `busquedas_resultados.mostrado_at` de la empresa |
| Visitas a ficha | `interacciones_afiliados`, tipo `VISITA_FICHA` |
| Clics en teléfono | `CLIC_TELEFONO` |
| Clics en WhatsApp | `CLIC_WHATSAPP` |
| Clics en sitio web | `CLIC_SITIO_WEB` |
| Clics en redes sociales | `CLIC_FACEBOOK`, `CLIC_INSTAGRAM`, `CLIC_RED_SOCIAL` |

Las apariciones se registran cuando una empresa está en la página de resultados mostrada; no equivalen a visitas. Las visitas directas a la ficha y las visitas desde el buscador se registran del lado del servidor. Cada búsqueda y visita se deduplica según las reglas existentes; la visita directa y la promoción se deduplican por sesión durante 30 minutos. Los clics se envían sin bloquear la navegación. Los indicadores adicionales son clics en mapa, visitas a promociones, tendencia diaria, búsquedas frecuentes y datos publicados del negocio. Un clic no confirma contacto efectivo ni venta.

Las consultas toman los eventos fuente, no la tabla `estadisticas_diarias_afiliados`, que no cuenta con un proceso de actualización en esta entrega. No se reconstruye actividad previa a la instrumentación.

## Esquema existente

El tipo `CLIC_RED_SOCIAL` permite medir TikTok, YouTube y otros canales distintos de Facebook e Instagram. En bases existentes se debe ejecutar `docs/migracion-estadisticas.sql` antes de habilitar el registro de esos clics. La instalación local revisada el 22 de septiembre de 2026 reportó que `interacciones_afiliados` existe en el catálogo y en archivos `.frm`/`.ibd`, pero no en el motor InnoDB (`SQLSTATE 42S02`, error 1932); esa tabla requiere recuperación de la base antes de aplicar la migración y probar el dashboard con datos reales. No se borró ni reconstruyó la tabla para preservar sus datos.

El 15 de octubre se confirmó que la tabla original continúa inaccesible y que `interacciones_afiliados_v2` ya existía, era consultable y estaba vacía. Se configuró **solo en `.env.local`** `ESTADISTICAS_TABLA_INTERACCIONES=interacciones_afiliados_v2` para reactivar el registro y la consulta de eventos. La búsqueda, ficha, promoción, clics y reportes comparten esa fuente. La tabla y archivos originales se conservaron. Esta continuidad no recupera los eventos del tablespace original. Por solicitud del usuario, el aviso técnico no aparece en pantallas ni exportaciones. Sin esa variable, otras instalaciones continúan usando `interacciones_afiliados`. Solo se admiten esos dos nombres de tabla; no existe conmutación automática que esconda fallas o entregue ceros ficticios.

## Ajustes móviles

A menos de 768 px, la portada muestra el buscador antes del título y la descripción, inmediatamente bajo la navegación. El mismo formulario conserva su búsqueda GET y sus nombres accesibles. En escritorio permanece el orden original. El acceso al panel sigue disponible en el menú móvil. La navegación y los controles mantienen áreas táctiles de al menos 44 px; la tabla de estadísticas presenta los indicadores por empresa en dos columnas en teléfono. Los campos y diálogos del panel aprovechan el ancho disponible y los campos móviles mantienen 16 px para evitar el zoom automático del teclado.
