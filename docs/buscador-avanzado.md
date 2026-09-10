# Buscador avanzado público

Estado local: 9 de septiembre de 2026. Implementación del alcance RF10–RF19 en `/buscar`, integrada con la búsqueda de portada, las fichas de empresas y las promociones. El orden inicial de relevancia está implementado; su validación con el cliente sigue pendiente (RN28).

## Cobertura de requerimientos

| Requisito | Cobertura y pendiente |
| --- | --- |
| RF010 | Búsqueda general por términos completos o parciales. |
| RF011 | Filtros combinables de ciudad/municipio y categoría. |
| RF012 | Nombre, alias, descripción, categorías, palabras clave y promociones vigentes. |
| RF013 | Propuesta de seis niveles de relevancia implementada. |
| RF014 | Logo, nombre, categoría principal, ciudad, resumen y promoción disponible. |
| RF015 | Acceso a la ficha pública existente del afiliado. |
| RF016 | Orden inicial operativo; aprobación del algoritmo pendiente RN028/P005. |
| RF017 | Registro de términos, total, ciudad, categoría y afiliados consultados. |
| RF018 | Estado sin resultados con sugerencias y acciones para quitar filtros. |
| RF019 | Consulta paginada y comprobación local; sin umbral numérico acordado ni validación de carga masiva. |

## Funcionamiento

La búsqueda devuelve empresas, una vez por afiliado. Combina texto, ciudad/municipio y categoría mediante filtros acumulativos. Sin texto muestra el directorio en orden alfabético. Cada resultado ofrece nombre, categoría principal disponible, municipio, descripción resumida, logotipo o iniciales, enlace a la ficha y, cuando existe, una promoción vigente.

Parámetros GET de `/buscar`:

| Parámetro | Valor y regla |
| --- | --- |
| `q` | Texto opcional UTF-8 de hasta 120 caracteres; recorta extremos y agrupa espacios; rechaza caracteres de control. |
| `ciudad` | ID de municipio; vacío o `0` significa todos. El catálogo incluye municipios activos con sucursales, afiliados y cámaras activos. |
| `categoria` | ID de categoría activa; vacío o `0` significa todas. |
| `pagina` | Entero desde `1`; se ajusta a la última página disponible. |

Las entradas deben ser escalares válidas. IDs fuera del catálogo producen HTTP 400 con un mensaje recuperable. Los fallos de consulta producen HTTP 503. Los resultados se paginan de 12 en 12; los enlaces conservan texto y filtros y el formulario inicia una nueva búsqueda en la primera página. Hay acciones para limpiar filtros y estados explícitos de error y ausencia de coincidencias.

## Relevancia y datos publicados

RF13 utiliza el primer nivel coincidente: (1) nombre comercial o alias exacto, (2) nombre o alias parcial, (3) categoría, (4) palabra clave activa, (5) título o descripción de promoción vigente, (6) descripción de empresa. Los empates se ordenan por nombre comercial e ID. No hay pesos acordados con el cliente, búsqueda semántica ni tolerancia a errores tipográficos; RN28 permanece pendiente.

Las consultas preparadas usan `LIKE`, tratando `%` y `_` del visitante como texto literal. Se consultan directamente las tablas vigentes, sin índice materializado que requiera reconstrucción. Solo participan afiliados de cámaras activas; categorías, palabras clave, ubicaciones y archivos respetan sus indicadores de actividad. El filtro municipal usa sucursales activas y la cadena localidad–municipio–estado activa; la ciudad mostrada coincide con el filtro.

RF14 destaca una promoción activa dentro del intervalo inclusivo entre inicio y fin de vigencia, según el reloj de la base de datos. Si hay texto, prioriza una promoción coincidente; después ordena por vencimiento e ID. Promociones futuras o vencidas no aportan coincidencias ni se muestran como vigentes.

## Estadísticas y regreso a resultados

RF17 registra término original y normalizado, municipio, categoría, total encontrado y duración en `busquedas`; guarda únicamente las empresas de la página mostrada en `busquedas_resultados`, con posición global y puntaje derivado del nivel (`100 - nivel`).

La sesión evita registros duplicados durante diez minutos para la misma combinación de texto, filtros y página efectiva. Conserva hasta 30 combinaciones y genera un token aleatorio de 32 caracteres hexadecimales. El enlace a la empresa incorpora `busqueda=<token>`; un token vigente de esa sesión permite registrar `VISITA_FICHA` solo para empresas guardadas entre los resultados. La visita se deduplica por búsqueda y afiliado, conservando hasta 100 claves en sesión. Un fallo de estadísticas se registra en el log sin impedir mostrar resultados.

La ficha reconstruye el enlace de regreso con los filtros y página almacenados; con historial utilizable, el navegador vuelve a la página anterior. Sin un token reconocido, el respaldo es el directorio de portada. El token depende de la sesión y no constituye un enlace compartible al estado de búsqueda; la URL GET del buscador sí conserva ese estado.

## Interfaz y comprobaciones

Extiende la identidad pública existente: marino, blanco, tipografías Inter/Outfit y Keenicons. Usa filtros laterales y resultados legibles en escritorio, con una columna en móvil. Conserva etiquetas visibles, foco, enlaces normales y búsqueda sin JavaScript. El movimiento de entrada dura 200 ms y respeta la preferencia de movimiento reducido. Este documento describe la extensión local y no sustituye el `DESIGN.md` del login.

`tests/buscador.php` comprueba relevancia, alias, categoría y municipio, datos inactivos, vigencia, promoción coincidente, comodines literales, validación y separación entre páginas. Las fixtures se revierten en una transacción. Su aserción final requiere registros de búsqueda y visita de la prueba de navegador previa; las comprobaciones de municipio y paginación dependen de los datos locales disponibles.

`tests/buscador-browser.cjs` comprueba portada → búsqueda → ficha → regreso con filtros, estado vacío, HTTP 400, errores JavaScript y ausencia de desbordamiento a 375, 768, 1024 y 1440 px; genera capturas en `.impeccable/review/`. Sus rutas de Chrome y Playwright son locales y requieren adaptación en otro equipo. La revisión visual local fue satisfactoria. Estas verificaciones no equivalen a aprobación del algoritmo por el cliente ni a una prueba de carga masiva.

## Entrega y límites

Archivos propios: `controladores/buscador.controlador.php`, `modelos/buscador.modelo.php`, `vistas/modulos/buscar.php` y `vistas/js/buscar.js`. Integraciones necesarias: `config/routes.php`, `vistas/modulos/portada.php`, `vistas/js/portada.js`, `vistas/css/canaco_publico.css`, `vistas/plantilla_publica.php`, `controladores/ficha-afiliado.controlador.php`, `vistas/modulos/ficha-afiliado.php` y `vistas/js/ficha-afiliado.js`. La navegación y enlaces de promociones requieren los archivos del módulo de ficha de promoción, incluido `vistas/js/ficha-promocion.js`. Los cambios previos en `modelos/portada.modelo.php` pertenecen a la rotación diaria y no a este módulo.

No se modificaron credenciales, conexión, configuración de entorno ni esquema de base de datos para el buscador. Producción debe contar con las tablas existentes de catálogo y estadísticas, sesiones PHP y `mbstring`. Pruebas y capturas son evidencia local, no archivos necesarios para atender visitantes. No se ha publicado este cambio desde esta documentación.

`LIKE '%texto%'`, subconsultas y conteo total pueden requerir optimización al crecer el directorio. No se ha medido comportamiento con carga masiva o concurrencia de producción; cualquier compromiso de escala requiere medición con datos representativos y revisión de índices/estrategia de búsqueda.

El autocompletado corresponde a una fase posterior; los sinónimos quedan como mejora futura.
