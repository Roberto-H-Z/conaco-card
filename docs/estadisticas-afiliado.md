# Inicio y estadísticas del afiliado

El periodo de consulta acordado para RF-008 es el último mes: 30 días naturales, incluido el día actual, en UTC (zona horaria usada por la conexión de datos). La pantalla `inicio` está disponible únicamente para el perfil AFILIADO con el permiso `estadisticas.ver`. Cuando el usuario administra varias empresas, el selector solo ofrece las vinculadas en `usuarios_afiliados`; el servidor vuelve a comprobar la vinculación antes de consultar cada ID.

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
