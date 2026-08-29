---
name: "CANACO Card Login"
description: "Acceso administrativo institucional con composición operativa de dos paneles."
colors:
  navy: "#26318c"
  blue: "#1778bd"
  sky: "#39a8dd"
  green: "#92c83e"
  ink: "#162255"
  paper: "#f5f8fc"
typography:
  display:
    fontFamily: "Inter, sans-serif"
    fontSize: "clamp(2.3rem, 4.1vw, 4.55rem)"
    fontWeight: 700
    lineHeight: 0.98
    letterSpacing: "-.035em"
  body:
    fontFamily: "Inter, sans-serif"
rounded:
  shell: "1.75rem"
  card: "1.25rem"
  field: ".75rem"
spacing:
  stage: "clamp(1rem, 3vw, 3rem)"
  panel: "clamp(1.5rem, 4vw, 4.25rem)"
components:
  login-card:
    backgroundColor: "#fff"
    rounded: "{rounded.card}"
  login-input:
    backgroundColor: "#fff"
    rounded: "{rounded.field}"
    height: "3.25rem"
  login-submit:
    backgroundColor: "{colors.navy}"
    textColor: "#fff"
    rounded: "{rounded.field}"
    height: "3.3rem"
---

# Design System: CANACO Card Login

## Overview

**Creative North Star: "De la montaña al mar"**

La pantalla de acceso usa el logo CANACO Card como fuente de su identidad visual: un panel narrativo marino combina una escena de montañas, olas y verde; el panel opuesto mantiene el ingreso como una tarea clara y contenida. La composición implementada es operativa, no promocional: prioriza el formulario y reserva la expresión gráfica para el contexto institucional.

**Key Characteristics:**

- Shell centrado de dos paneles para escritorio.
- Historia de marca a la izquierda y tarjeta de acceso a la derecha.
- Componentes Metronic conservados y personalizados para el contexto CANACO Card.

## Colors

La paleta toma el marino, azul, celeste y verde visibles en el logo y los reparte entre identidad, foco y acentos informativos.

### Primary

- **Marino institucional:** color de la acción principal, la historia de marca y el texto de alto contraste.
- **Azul de foco:** color reservado para contornos de interacción y sus anillos de foco.

### Secondary

- **Celeste atmosférico:** halo suave dentro del panel narrativo y el fondo de la página.

### Tertiary

- **Verde de la marca:** detalles de CANACO Card, silueta del paisaje e iconos de apoyo.

### Neutral

- **Tinta profunda:** texto de encabezados del formulario.
- **Papel frío:** fondo claro de la escena de acceso.
- **Blanco:** superficie del shell, campos y tarjeta de credenciales.

**The Logo Palette Rule.** Los acentos del acceso proceden de la identidad gráfica CANACO Card; el verde acompaña y el marino mantiene la jerarquía de la acción primaria.

## Typography

**Display Font:** Inter, sans-serif.

**Body Font:** Inter, sans-serif.

**Character:** La misma familia ya cargada por la vista mantiene una lectura directa: encabezado institucional compacto y etiquetas de formulario legibles.

### Hierarchy

- **Display:** Inter 700; titular narrativo de la historia de marca, con composición compacta y equilibrada.
- **Title:** Inter 700; saludo de acceso y nombre de la pantalla.
- **Body:** Inter 400; instrucciones, texto descriptivo y ayuda.
- **Label:** Inter 700; rótulos de campos y leyenda de la plataforma.

## Layout

En escritorio, el escenario ocupa al menos el alto del viewport y centra un shell de ancho máximo 76rem. El shell distribuye una narrativa de marca ligeramente mayor que la región del formulario. La región de formulario centra verticalmente una utilidad de tema y una tarjeta que contiene logo, encabezado y credenciales.

A 900px o menos, la composición se apila en una sola columna y el shell se limita a 39rem. La historia conserva una altura mínima propia y oculta su párrafo descriptivo para concentrar el contenido. A 480px o menos, el shell pierde borde, radio y sombra; la escena comienza arriba, el panel narrativo y la región de formulario reducen su relleno, y la tarjeta permanece como contenedor de la tarea.

## Elevation & Depth

La profundidad es ligera y estructural. La escena raster de montañas aportada por el usuario se extiende de forma continua por todo el shell: el panel narrativo la muestra con un velo azul de alto contraste, mientras el área de formulario la deja aparecer de forma muy tenue bajo una superficie clara. El mismo activo aparece, aún más velado, en el fondo de la página. La tarjeta de acceso se separa con un borde tenue y una sombra contenida; las olas SVG permanecen sobre la zona narrativa.

## Shapes

El shell adopta una curva amplia, la tarjeta un radio intermedio y los campos y botón una curva más cerrada. Las utilidades circulares —volver y cambiar tema— usan forma de píldora completa. En móvil muy estrecho, el shell se vuelve plano para aprovechar el ancho disponible, mientras la tarjeta conserva su separación visual.

## Components

### Metronic login composition

La estructura operativa usa `kt-card` y `kt-card-content` para la tarjeta, `kt-input` para correo y contraseña, `kt-checkbox` para “Recordarme” y `kt-btn`/`kt-btn-primary` para la acción de continuar. Los Keenicons aportan señales visuales para navegación, correo, contraseña, visibilidad, información y acción; los iconos decorativos se ocultan de tecnologías asistivas.

### Buttons

- **Primary:** el botón de continuar usa el marino institucional, texto blanco, icono de avance y una altura mínima propia.
- **Utility:** el selector de tema es circular y muestra sol/luna según el estado del tema.
- **Interaction:** los cambios de posición por hover solo se aplican a dispositivos con hover y puntero fino; foco visible conserva un contorno azul separado del control.

### Cards / Containers

- **Shell:** contenedor de dos paneles con una única escena continua, borde tenue y sombra ambiental.
- **Login card:** superficie blanca translúcida con borde claro; en tema oscuro cambia a una superficie azul profunda con borde propio.

### Inputs / Fields

- **Style:** los campos combinan icono previo, superficie blanca y borde claro dentro de una altura uniforme.
- **Focus:** el contenedor del campo —no el input aislado— cambia a azul y añade anillo de foco suave; los controles conservan foco visible para teclado.
- **Checkbox:** usa el componente Metronic pequeño junto a su etiqueta de recuerdo.

### Theme

El interruptor persiste y refleja tema claro u oscuro mediante el estado de `html`; las superficies, bordes, texto y foco del acceso tienen variantes oscuras implementadas.

### Motion

La historia y la tarjeta entran verticalmente al cargar; la tarjeta añade una escala inicial sutil y un retraso breve. La escena de montañas realiza un desplazamiento de cámara lento con `transform` y las olas SVG se desplazan horizontalmente en un ciclo lineal de 13 segundos. Con `prefers-reduced-motion: reduce`, las animaciones de entrada, escena y olas se desactivan y las transiciones de los controles se acortan.

### Activo de escena

`vistas/assets/media/app/login-montanas-canaco.png` proviene de la imagen proporcionada por el usuario para esta pantalla; no fue generada ni modificada por el proyecto.

## Do's and Don'ts

### Do:

- **Do** conservar la prioridad operativa: logo, saludo, campos, recuerdo y acción primaria dentro de la tarjeta.
- **Do** mantener el marino para la acción principal y el azul para foco y estados de interacción.
- **Do** conservar las etiquetas, nombres accesibles, autocompletado de credenciales y foco visible ya implementados.
- **Do** respetar el apilado móvil, incluido el shell plano en pantallas de hasta 480px.

### Don't:

- **Don't** sustituir los primitivos operativos Metronic por controles visuales sin las mismas affordances de formulario.
- **Don't** usar animación de entrada u olas cuando la persona haya pedido movimiento reducido.
- **Don't** usar iconos decorativos como única forma de comunicar una acción o estado.
