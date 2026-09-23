---
name: CANACO Card — Inicio
description: Informe visual de actividad comercial para la empresa afiliada.
colors:
  primary: "#235ad1"
  visits: "#087e80"
  contacts: "#a66808"
  social: "#7960ad"
  ground: "#f3f6fa"
  surface: "#ffffff"
  soft: "#edf2f8"
  ink: "#172a42"
  muted: "#59697d"
  border: "#dbe3ec"
  company: "#e7eef8"
  on-action: "#ffffff"
  dark-primary: "#85b4ff"
  dark-visits: "#59d5cb"
  dark-contacts: "#efbb65"
  dark-social: "#beacef"
  dark-ground: "#101820"
  dark-surface: "#17232e"
  dark-soft: "#1e2d3b"
  dark-ink: "#ecf2f8"
  dark-muted: "#a8b9ca"
  dark-border: "#314355"
  dark-company: "#1c3043"
  dark-on-action: "#132b4b"
typography:
  headline:
    fontFamily: "Inter, sans-serif"
    fontSize: "1.875rem"
    fontWeight: 650
    lineHeight: 1.2
    letterSpacing: "-.035em"
  title:
    fontFamily: "Inter, sans-serif"
    fontSize: "1rem"
    fontWeight: 650
    lineHeight: 1.35
    letterSpacing: "-.015em"
  body:
    fontFamily: "Inter, sans-serif"
    fontSize: ".875rem"
    lineHeight: 1.5
  label:
    fontFamily: "Inter, sans-serif"
    fontSize: ".75rem"
  metric:
    fontFamily: "Inter, sans-serif"
    fontSize: "2rem"
    fontWeight: 600
    lineHeight: 1.2
    letterSpacing: "-.035em"
rounded:
  bar: ".25rem"
  control: ".5rem"
  mark: ".75rem"
  panel: "1rem"
spacing:
  inline: ".5rem"
  group: "1rem"
  grid: "1.25rem"
  panel: "1.5rem"
  section: "1.75rem"
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-action}"
    rounded: "{rounded.control}"
    padding: ".65rem 1rem"
  button-quiet:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.ink}"
    rounded: "{rounded.control}"
    padding: ".65rem 1rem"
  panel:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.ink}"
    rounded: "{rounded.panel}"
    padding: "{spacing.panel}"
  company:
    backgroundColor: "{colors.company}"
    rounded: "{rounded.panel}"
    padding: "{spacing.section}"
  inspector:
    backgroundColor: "{colors.soft}"
    rounded: "{rounded.control}"
    padding: ".8rem 1rem"
---

# Design System: CANACO Card — Inicio

## Overview

**Creative North Star: "Informe visual de actividad comercial"**

Inicio presenta la actividad de la empresa como un informe legible: la tendencia diaria ocupa el espacio principal, seguida por la comparación de canales y el mantenimiento de la información comercial. Superficies de tinta y papel, Inter y cifras tabulares sostienen la lectura sin depender de ilustraciones.

Este documento describe únicamente el diseño implementado de Inicio. El documento raíz conserva su autoridad para las otras superficies. La dirección procede del contrato emitido en `vistas/plantilla.php` y de `vistas/css/inicio.css`, `vistas/modulos/inicio.php` y `vistas/js/inicio.js`; no establece una sustitución global de identidad.

**Key Characteristics:**

- Tendencia diaria y comparación de canales como contenido principal.
- Azul para apariciones, turquesa para visitas y ámbar para contactos.
- Superficies planas en temas claro y oscuro.
- Tabla diaria disponible sin JavaScript y exploración progresiva con teclado.

Evidencia de revisión: capturas `inicio-*.png` en `.impeccable/review/`. La validación visual e interactiva utiliza fixtures sintéticos; no representa métricas reales de empresas. La corrupción existente de tablas locales impide validar la carga normal contra esa base de datos y queda fuera de este trabajo. Las tablas originales no se modificaron. Este documento registra el diseño y ese límite, no certifica una reparación de la base de datos.

## Colors

La paleta mantiene una lectura institucional azul con colores de datos constantes entre temas. El frontmatter contiene los valores normativos extraídos; los nombres `dark-*` corresponden a las sustituciones activadas por `html.dark`.

### Primary

Azul de actividad: apariciones, enlaces, acción principal, foco y Teléfono en la comparación de canales.

### Secondary

Turquesa de visitas: serie de visitas y barra de WhatsApp. Ámbar de contacto: serie de contactos y barra de Sitio web. Violeta social: barra de Redes sociales.

### Neutral

El fondo general (`ground`), los paneles (`surface`) y las zonas auxiliares (`soft`) separan niveles por tono. `ink` y `muted` distinguen cifras y explicación; `border` estructura paneles y divisores. `company` da identidad al monograma y al resumen de empresa. `on-action` cambia también en oscuro para mantener legible el texto sobre el azul claro.

**The Series Identity Rule.** Las series conservan color, etiqueta y trazo: apariciones continuo, visitas discontinuo, contactos punteado.

## Typography

Inter, con fallback sans-serif, es la familia existente. El CSS solicita titulares de peso 650; la carga compartida de Inter declara 400, 500, 600 y 700. Se documenta la petición CSS sin afirmar que exista un archivo de peso 650 independiente.

La jerarquía distingue encabezado, títulos de panel, explicación, etiquetas y cifras. Las cifras de métricas usan números tabulares. El total de contactos sube a (2.5rem); los hechos de empresa usan (1.75rem). Las descripciones del encabezado tienen un máximo de (65ch), y las de empresa (60ch).

El título principal baja a (1.625rem) hasta 1200px y a (1.5rem) hasta 600px. En ese último ancho las métricas principales usan (1.65rem) y los hechos de empresa (1.5rem).

## Layout

El encabezado combina saludo y periodo de los últimos 30 días. Debajo, la empresa y sus acciones preceden a una cuadrícula de tendencia y canales: `minmax(0, 1.9fr) minmax(17rem, 1fr)`, con separación de (1.25rem). Búsquedas y promociones forman una segunda cuadrícula de dos columnas iguales. El bloque de empresa combina texto y tres hechos.

- Hasta 1200px: la cuadrícula principal pasa a `minmax(0, 1.5fr) minmax(16rem, 1fr)` y los paneles reducen el relleno a (1.25rem).
- Entre 1024px y 1050px, y hasta 760px: tendencia, canales y detalles se apilan; el bloque de empresa también pasa a una columna. La franja intermedia contempla el ancho ocupado por el sidebar del shell.
- Hasta 1023px: el contenedor usa (1rem) de relleno horizontal.
- Hasta 600px: encabezado vertical, periodo a todo el ancho, paneles con (1.1rem) de relleno y acciones de empresa adaptadas al ancho disponible. El selector permite crecer y usa texto de (1rem).

La gráfica mide (14rem) de alto en escritorio y (12.5rem) hasta 600px. La tabla tiene desplazamiento interno y altura máxima de (20rem). Los textos de empresas, promociones y búsquedas permiten cortes para evitar desbordamientos.

## Elevation & Depth

Inicio no añade sombras a los paneles. Fondo, superficies, bordes finos y el bloque tonal de empresa crean profundidad. El foco visible usa un contorno azul de (3px) separado (4px), sin glow.

## Shapes

Paneles y bloque de empresa comparten esquinas amplias; controles e inspector usan esquinas más pequeñas. El monograma cuadrado tiene (2.75rem) por lado. Las barras son delgadas y redondeadas: canales (0.45rem), búsquedas (0.3rem). Las líneas de datos no escalan su grosor con el SVG.

## Components

### Buttons

La acción principal abre la ficha pública de una empresa activa en otra pestaña, con aviso accesible. La variante discreta confirma el selector de empresa mediante formulario GET. Ambos tienen altura mínima de (2.75rem), estado presionado con escala (.97) y hover de opacidad (.88) solo en punteros precisos. Los enlaces secundarios subrayan al pasar el cursor.

### Activity chart

Tres totales preceden un SVG generado en PHP, con cinco marcas verticales de escala y hasta cuatro fechas del eje horizontal. La escala parte de cero y calcula un techo común a las tres series; no hay datos de ejemplo en la vista de producción.

JavaScript revela botones de serie y el inspector diario solo cuando hay datos válidos. Cada botón usa `aria-pressed`; ocultar una serie modifica la línea y su punto, sin cambiar totales ni tabla. El estado oculto se distingue además con texto tachado. La inspección parte del último día y admite range nativo, teclado, clic o toque en el gráfico. Fecha y valores se actualizan en texto, con anuncio `aria-live="polite"`.

### Daily table

`details` permite consultar cifras exactas por fecha con encabezados de columna y fila. Está renderizada en el servidor y funciona sin JavaScript. El SVG tiene título y descripción que remiten a esta tabla.

### Channel and search comparisons

Cuatro barras muestran Teléfono, WhatsApp, Sitio web y Redes sociales. La mayor barra de cada grupo ocupa el ancho completo; las demás comparan cantidades contra ese máximo, no porcentajes de conversión. Búsquedas usa la misma comparación por máximo. Los valores siguen siendo texto visible y las barras son decorativas para lectores de pantalla.

Los clics en el mapa y las visitas a promociones aparecen como cifras separadas. El total de contactos suma los cuatro canales de contacto y no incluye esas dos acciones.

### Promotions and company facts

Las promociones conservan título, fin de vigencia y visitas del periodo, junto al acceso de administración. La empresa conserva nombre y descripción abreviada a 220 columnas mediante `mb_strimwidth`, acceso de edición y tres hechos: sucursales activas, canales publicados y promociones vigentes.

### Empty and error states

Cero actividad, búsquedas vacías y promociones vacías incluyen mensajes específicos y los accesos pertinentes. El error de carga muestra aviso y reintento. La nota final aclara que un clic no confirma una llamada, conversación o venta.

### Motion

Inicio reutiliza el sistema de transición de Afiliados y Promociones mediante `data-panel-motion`: opacidad (0 → 1), desplazamiento vertical (36px → 0) y escala (.95 → 1) durante (700ms), con una cascada de (70ms) entre grupos. Botones y conmutadores usan (160ms); las líneas cambian opacidad durante (180ms). La curva compartida es `cubic-bezier(.23, 1, .32, 1)`.

La activación de series por teclado cambia la línea inmediatamente. `prefers-reduced-motion: reduce` elimina animaciones, transiciones, desplazamiento de entrada y escala de presión. No hay reproducción animada de valores ni movimiento continuo.

## Do's and Don'ts

### Do

- Do conservar etiquetas, cifras y tabla como alternativas al color y a la gráfica.
- Do aplicar los tokens de Inicio dentro de su ámbito de ruta y conservar ambos temas.
- Do comparar canales y búsquedas contra el máximo de su propio grupo.
- Do respetar teclado, foco visible y movimiento reducido.

### Don't

- Don't presentar fixtures sintéticos como actividad real del negocio.
- Don't interpretar contactos como conversaciones o ventas confirmadas.
- Don't sustituir el documento de diseño raíz con las decisiones locales de Inicio.
- Don't introducir animación continua en la lectura de actividad.
