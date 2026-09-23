# Revisión del rediseño de Inicio

Revisión inicial independiente: composición, contenido, adaptación móvil, temas y estados.
La continuación del revisor alcanzó su límite de uso; la verificación de las correcciones
se completó directamente sobre código, capturas actualizadas y comprobaciones del navegador.

## Veredicto de las correcciones

- Resuelto: los controles de series ocultas conservan el texto opaco y legible; el estado usa tachado y una muestra de línea atenuada.
- Resuelto: Sitio web usa `ki-chrome`, disponible en la biblioteca instalada.
- Resuelto: la captura de error se tomó después de que terminara el cambio de tema.
- Resuelto: el escenario de prueba vacío muestra cero promociones tanto en la lista como en el resumen de empresa.

## Alcance comprobado

Capturas `inicio-desktop.png`, `inicio-light.png`, `inicio-mobile.png`, `inicio-empty.png`
e `inicio-error.png`: 1600/1440 px de escritorio y 390/375 px de móvil, temas claro y oscuro.
Se comprobaron filtros de series, selección de día con Home/End, 30 filas de datos diarios,
ausencia del separador Gestión, ausencia de desbordamiento horizontal y errores JavaScript.
Los datos son ilustrativos: las pruebas no usan la base de datos dañada ni prueban el servidor.
Las consultas y tablas de producción se conservan.

Disposición: **ship**, limitada a las correcciones enumeradas y las comprobaciones descritas.
