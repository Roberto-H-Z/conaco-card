# PROMPT MAESTRO — INICIALIZACIÓN DEL PROYECTO CANACO CARD

Quiero que actúes como arquitecto de software senior y desarrollador Full Stack especializado en:

- PHP 8+
- MVC personalizado sin framework
- MySQL 8 / MariaDB
- PDO
- Apache
- .htaccess y mod_rewrite
- HTML5
- JavaScript
- AJAX
- Metronic 9
- Tailwind CSS
- Responsive Design
- Arquitectura modular
- Seguridad web
- Diseño de sistemas administrativos empresariales

Vas a construir desde cero la base del proyecto **CANACO Card**.

IMPORTANTE:

No quiero que generes simplemente una página HTML aislada.

Quiero que construyas la estructura inicial REAL del proyecto sobre la cual posteriormente desarrollaremos todos los módulos del sistema.

Debes trabajar directamente sobre los archivos de este proyecto.

---

# 1. CONTEXTO GENERAL

El proyecto se llama:

CANACO Card

Es una plataforma web destinada a administrar y consultar empresas afiliadas a CANACO.

El sistema contará posteriormente con dos grandes componentes:

1. Panel administrativo privado.
2. Sitio web público.

En esta primera etapa nos concentraremos principalmente en dejar preparada la arquitectura del proyecto y en mostrar correctamente la primera pantalla del Panel Administrativo utilizando Metronic.

La aplicación será desarrollada con:

PHP + MVC personalizado + MySQL + PDO + AJAX + JavaScript + Metronic 9 Tailwind.

NO usar:

- Laravel
- Symfony
- CodeIgniter
- React
- Vue
- Angular
- Next.js
- Node.js como backend

El backend debe ser PHP tradicional organizado mediante MVC.

---

# 2. REVISA EL PROYECTO ANTES DE MODIFICAR NADA

ANTES de crear, mover, copiar, eliminar o modificar archivos, realiza una inspección completa de la raíz del proyecto.

Actualmente la raíz contiene, entre otras cosas:

```text
canaco-card/
│
├── metronic-v9.5.0/
│   ├── figma/
│   ├── metronic-tailwind-html-demos/
│   ├── metronic-tailwind-html-starter-kit/
│   ├── metronic-tailwind-nextjs-...
│   ├── metronic-tailwind-react-...
│   ├── README.md
│   ├── LICENSE-REMINDER.txt
│   └── ...
│
└── canaco_card.sql
```

Los nombres mostrados pueden aparecer abreviados visualmente en el IDE.

Tú debes revisar directamente el filesystem y determinar los nombres y rutas reales.

NO asumas rutas sin comprobarlas.

---

# 3. ARCHIVOS QUE DEBES ESTUDIAR OBLIGATORIAMENTE

Antes de programar debes analizar como mínimo:

## 3.1 Base de datos

Archivo:

```text
/canaco_card.sql
```

Este archivo está en la raíz del proyecto.

Debes leerlo COMPLETO antes de diseñar:

- modelos
- autenticación
- permisos
- afiliados
- usuarios
- promociones
- sucursales
- categorías
- auditoría
- buscador
- estadísticas
- recuperación de contraseña

Este SQL es la FUENTE DE VERDAD de la base de datos.

No debes inventar nombres de tablas o campos si ya están definidos ahí.

No debes modificar este archivo en esta etapa.

No debes cambiar arbitrariamente:

- nombres de tablas
- nombres de columnas
- PK
- FK
- índices
- constraints
- tipos de datos

Si el código PHP necesita consultar información, debe adaptarse al SQL y NO al contrario.

---

# 4. CONTEXTO IMPORTANTE DE LA BASE DE DATOS

La base se llama:

```text
canaco_card
```

Está diseñada para:

```text
MySQL 8+
utf8mb4
InnoDB
```

La aplicación deberá trabajar internamente en UTC.

Debes respetar especialmente las instrucciones que aparecen dentro del propio SQL.

Entre ellas:

- las contraseñas deben generarse desde PHP usando password_hash()
- la aplicación deberá utilizar password_verify()
- NO utilizar MD5
- NO utilizar SHA1 para contraseñas
- la aplicación deberá manejar adecuadamente UTC

Debes verificar personalmente todo esto leyendo el SQL.

---

# 5. ENTIDADES PRINCIPALES

El SQL contiene actualmente entidades relacionadas con:

```text
estados
municipios
localidades
municipios_adyacencias

camaras
camaras_municipios

roles
permisos
roles_permisos

usuarios
usuarios_camaras
usuarios_afiliados
tokens_recuperacion_password

afiliados
contactos_afiliados

sucursales
sucursales_telefonos

canales_digitales

categorias
afiliados_categorias
afiliados_palabras_clave

archivos
afiliados_archivos

promociones
promociones_archivos

notificaciones

secciones_portada
items_seccion_portada

configuraciones_sistema

sesiones_visitantes

busquedas
busquedas_resultados

interacciones_afiliados
estadisticas_diarias_afiliados
indices_busquedas_afiliados

auditorias_cambios

importaciones_lotes
importaciones_empresas_staging
```

Esta lista es contexto inicial.

Aun así, DEBES revisar el SQL directamente para conocer:

- columnas
- relaciones
- tipos
- constraints
- índices
- obligatoriedad
- nullable
- FK
- reglas de integridad

No construyas modelos basándote únicamente en esta lista.

---

# 6. METRONIC

En la raíz también existe:

```text
metronic-v9.5.0/
```

Esta carpeta contiene la plantilla que ya fue comprada para el proyecto.

Es:

```text
Metronic 9.5
Tailwind
```

Para este proyecto PHP los paquetes importantes serán principalmente:

```text
metronic-tailwind-html-starter-kit
metronic-tailwind-html-demos
```

NO utilices las versiones:

```text
React
Next.js
```

para construir la aplicación.

Pueden permanecer en la carpeta original, pero no deben formar parte de la aplicación PHP.

---

# 7. REGLA CRÍTICA SOBRE METRONIC

La carpeta:

```text
metronic-v9.5.0/
```

es MATERIAL FUENTE.

NO debes convertirla en la carpeta principal de CANACO.

NO debes desarrollar el sistema dentro de ella.

NO debes eliminarla.

NO debes reorganizarla.

NO debes modificar los archivos originales de Metronic salvo que sea absolutamente necesario y se justifique claramente.

Nuestra aplicación estará FUERA de esa carpeta.

Metronic será utilizado como fuente para:

- layout
- HTML
- CSS
- JavaScript
- componentes
- iconos
- cards
- tablas
- formularios
- dropdowns
- sidebar
- header
- footer
- modales
- drawers
- tooltips
- responsive
- comportamiento visual

---

# 8. ESTUDIA METRONIC ANTES DE COPIAR

Antes de copiar cualquier recurso:

Inspecciona:

```text
metronic-v9.5.0/metronic-tailwind-html-starter-kit/
```

y:

```text
metronic-v9.5.0/metronic-tailwind-html-demos/
```

Busca principalmente sus carpetas:

```text
dist/
src/
```

si existen.

Debes identificar:

- archivos CSS compilados
- JavaScript compilado
- assets
- media
- fuentes
- iconos
- scripts de layout
- estructura de Demo 1
- HTML del sidebar
- HTML del header
- layout general
- comportamiento responsive

Por ejemplo, dentro del paquete HTML pueden existir archivos equivalentes a:

```text
dist/assets/css/core.bundle.css
dist/assets/css/styles.css

dist/assets/js/core.bundle.js
dist/assets/js/layouts/demo1.js
```

Debes comprobar las rutas reales antes de utilizarlas.

NO inventes nombres.

---

# 9. LAYOUT QUE QUIERO TOMAR COMO BASE

Utiliza preferentemente el layout administrativo estándar de Metronic equivalente a:

```text
Demo 1
```

o el layout del Starter Kit más similar.

Quiero un panel administrativo profesional con:

- sidebar izquierdo
- header superior
- contenido central
- footer
- diseño responsive
- menú colapsable
- menú móvil
- dropdown de usuario
- breadcrumbs
- soporte visual claro/oscuro si Metronic ya lo proporciona

No reconstruyas artificialmente estos componentes si Metronic ya los tiene.

Debes reutilizar correctamente el diseño proporcionado por Metronic.

---

# 10. ARQUITECTURA MVC

Quiero un MVC personalizado similar conceptualmente a aplicaciones PHP tradicionales.

El flujo principal deberá ser:

```text
Navegador
    ↓
.htaccess
    ↓
index.php
    ↓
Router
    ↓
Controlador
    ↓
Modelo
    ↓
PDO
    ↓
MySQL

Controlador
    ↓
Vista PHP
    ↓
Metronic
```

Las operaciones dinámicas posteriores podrán utilizar:

```text
JavaScript
    ↓
AJAX
    ↓
Controlador
    ↓
Modelo
    ↓
MySQL
```

---

# 11. NO COPIAR MALAS PRÁCTICAS DE PROYECTOS ANTIGUOS

Aunque la arquitectura está inspirada en un MVC PHP clásico, quiero mejorar varios aspectos.

NO quiero:

- un index.php con cientos de require_once manuales
- una plantilla.php con cientos de condiciones if para determinar rutas
- una whitelist duplicada para PHP y JavaScript
- credenciales de BD repartidas por todo el sistema
- SQL injection
- concatenación insegura de SQL
- MD5
- contraseñas en texto plano
- rutas inseguras
- includes construidos directamente con datos GET sin validar
- lógica SQL dentro de las vistas
- lógica HTML dentro de los modelos
- controladores gigantes sin separación de responsabilidades

---

# 12. ESTRUCTURA INICIAL DEL PROYECTO

Quiero una estructura similar a esta:

```text
canaco-card/
│
├── .htaccess
├── index.php
│
├── config/
│   ├── config.php
│   ├── database.php
│   └── routes.php
│
├── controladores/
│   ├── plantilla.controlador.php
│   └── ...
│
├── modelos/
│   ├── conexion.php
│   └── ...
│
├── vistas/
│   │
│   ├── plantilla.php
│   │
│   ├── layouts/
│   │   ├── head.php
│   │   ├── header.php
│   │   ├── sidebar.php
│   │   ├── toolbar.php
│   │   ├── footer.php
│   │   └── scripts.php
│   │
│   ├── modulos/
│   │   ├── inicio.php
│   │   ├── login.php
│   │   └── 404.php
│   │
│   ├── assets/
│   │   ├── css/
│   │   ├── js/
│   │   ├── media/
│   │   └── ...
│   │
│   ├── css/
│   │   └── canaco.css
│   │
│   └── js/
│       └── app.js
│
├── ajax/
│
├── helpers/
│   ├── funciones.php
│   ├── auth.helper.php
│   └── validation.helper.php
│
├── storage/
│   └── logs/
│
├── uploads/
│   ├── afiliados/
│   └── promociones/
│
├── metronic-v9.5.0/
│
└── canaco_card.sql
```

Esta estructura es una guía.

Puedes realizar pequeños ajustes SI realmente mejoran la arquitectura.

Pero:

NO cambies el concepto general.

NO conviertas el proyecto a otro framework.

Antes de realizar un cambio importante respecto a esta estructura debes justificarlo.

---

# 13. INDEX.PHP

`index.php` deberá actuar como Front Controller.

Debe ser pequeño.

Su responsabilidad principal será:

1. inicializar configuración
2. inicializar sesión si corresponde
3. cargar autoload/configuración necesaria
4. resolver la ruta
5. ejecutar el controlador adecuado
6. renderizar la aplicación

NO quiero que index.php termine cargando manualmente 50 modelos y 50 controladores.

Diseña una solución escalable.

Puedes implementar un autoloader PHP sencillo.

NO es obligatorio utilizar Composer en esta etapa.

---

# 14. AUTOLOADER

Crea un autoloader ligero usando:

```php
spl_autoload_register()
```

si consideras que ayuda a mantener limpia la arquitectura.

Debe poder localizar como mínimo:

```text
controladores/
modelos/
helpers/
```

No construyas un sistema excesivamente complejo.

Busco claridad.

---

# 15. ROUTING

Implementa routing centralizado.

NO quiero algo como:

```php
if ($_GET["ruta"] == "inicio" ||
    $_GET["ruta"] == "usuarios" ||
    $_GET["ruta"] == "afiliados" ||
    ...
)
```

Quiero algo más mantenible.

Por ejemplo:

```php
return [
    'inicio' => [
        'controlador' => '...',
        'vista' => 'inicio',
        'auth' => true
    ],

    'login' => [
        'controlador' => '...',
        'vista' => 'login',
        'auth' => false
    ]
];
```

No tienes que copiar exactamente este ejemplo.

Diseña una solución sencilla.

En el futuro necesitaremos poder definir:

```text
ruta
controlador
método
autenticación
roles permitidos
```

Por lo tanto deja el router preparado para crecer.

---

# 16. .HTACCESS

Configura URLs amigables.

Por ejemplo:

```text
http://localhost/canaco-card/
```

```text
http://localhost/canaco-card/inicio
```

```text
http://localhost/canaco-card/login
```

Posteriormente:

```text
/afiliados
/afiliados/nuevo
/afiliados/editar/15
/promociones
/usuarios
/categorias
```

Todo deberá terminar llegando al Front Controller.

La solución debe funcionar bajo Apache/XAMPP con:

```text
mod_rewrite
```

Evita reglas peligrosas.

No redirijas archivos físicos como:

```text
css
js
imagenes
fonts
svg
png
jpg
webp
```

al index.php.

---

# 17. CONFIGURACIÓN DE URL

NO hardcodees URLs repetidamente.

Implementa una configuración central para determinar:

```text
BASE_URL
APP_NAME
APP_ENV
```

Ejemplo:

```text
APP_NAME = CANACO Card
```

Debe ser posible cambiar posteriormente:

```text
http://localhost/canaco-card/
```

por un dominio real sin modificar cientos de archivos.

---

# 18. CONEXIÓN A LA BASE DE DATOS

Crea una clase:

```text
Conexion
```

basada en PDO.

Debe usar:

```php
PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
PDO::ATTR_EMULATE_PREPARES => false
```

y:

```text
utf8mb4
```

No pongas SQL dentro de `conexion.php`.

La clase solamente deberá administrar conexiones.

---

# 19. CONFIGURACIÓN DE BD

Separa la configuración de:

```text
host
database
username
password
charset
```

del resto de la aplicación.

Por ahora puede existir:

```text
config/database.php
```

pero la arquitectura deberá quedar preparada para utilizar posteriormente:

```text
.env
```

No agregues librerías innecesarias solamente para resolver esto.

---

# 20. QUERIES SEGURAS

Todos los modelos deberán utilizar:

```text
PDO prepared statements
```

Nunca:

```php
$query = "SELECT * FROM usuarios WHERE correo = '$correo'";
```

Siempre parámetros preparados.

---

# 21. ORGANIZACIÓN DEL FRONTEND

Quiero separar claramente:

```text
Metronic
```

de:

```text
personalizaciones CANACO
```

Por ejemplo:

```text
vistas/assets/
```

para los assets de Metronic necesarios.

Y:

```text
vistas/css/canaco.css
vistas/js/app.js
```

para código personalizado.

No edites:

```text
core.bundle.css
core.bundle.js
```

para personalizar CANACO.

Los overrides deben estar separados.

---

# 22. NO COPIAR TODO METRONIC A CIEGAS

Metronic contiene una enorme cantidad de:

- imágenes
- iconos
- componentes
- ejemplos
- páginas
- assets

NO copies automáticamente toda la distribución si no hace falta.

Para la primera pantalla copia únicamente los recursos necesarios para que funcione correctamente el layout seleccionado.

Sin embargo:

Si varios componentes dependen de una carpeta común y separar archivos rompería Metronic, puedes copiar el bloque de assets necesario.

Prioridad:

1. funcionamiento correcto
2. mantenibilidad
3. tamaño razonable

No sacrifiques funcionamiento solamente por reducir algunos MB.

---

# 23. CONSERVAR METRONIC ORIGINAL

Después de terminar quiero que siga existiendo:

```text
metronic-v9.5.0/
```

completo.

Porque lo utilizaremos posteriormente como catálogo de:

- pantallas
- componentes
- cards
- tablas
- dashboards
- formularios

Por ejemplo, cuando construyamos el módulo de Afiliados podrás buscar componentes apropiados dentro de los demos.

---

# 24. IDENTIDAD CANACO CARD

La aplicación debe mostrar:

```text
CANACO Card
```

No:

```text
Metronic
KeenThemes
Demo 1
Dashboard Demo
```

en los elementos visibles principales.

Puedes conservar internamente las clases y componentes técnicos de Metronic.

Pero visualmente la aplicación debe comenzar a tener identidad CANACO.

En esta primera etapa sustituye donde corresponda:

- título del navegador
- nombre de aplicación
- nombre del sidebar
- nombre visible del dashboard
- branding principal

Si actualmente no existe un logo CANACO dentro del proyecto, usa temporalmente:

```text
CANACO Card
```

como logotipo tipográfico.

No inventes un logotipo definitivo.

---

# 25. PRIMERA PANTALLA

El primer objetivo visible será:

```text
/inicio
```

Debe mostrar el dashboard administrativo.

No quiero todavía estadísticas reales.

Para esta primera etapa puedes usar datos visuales de demostración claramente identificados como placeholder.

Por ejemplo:

```text
Afiliados activos
Promociones vigentes
Sucursales registradas
Búsquedas del mes
```

pero NO consultes todavía datos falsos de la base como si fueran reales.

Puedes mostrar:

```text
0
```

o datos de placeholder claramente separados.

La finalidad principal de esta pantalla es validar:

- MVC
- routing
- Metronic
- assets
- sidebar
- header
- contenido
- responsive
- navegación

---

# 26. DISEÑO DEL DASHBOARD

Quiero un dashboard limpio y corporativo.

Debe aprovechar los componentes de Metronic.

Layout aproximado:

```text
------------------------------------------------
HEADER
------------------------------------------------

SIDEBAR | Dashboard
        |
        | Bienvenido a CANACO Card
        |
        | [ Afiliados ] [ Promociones ]
        | [ Sucursales ] [ Búsquedas ]
        |
        | Área reservada para estadísticas
        |
        | Actividad reciente
        |
------------------------------------------------
FOOTER
------------------------------------------------
```

No copies obligatoriamente esta distribución exacta si Metronic ofrece una composición mejor.

Mantén apariencia profesional.

---

# 27. SIDEBAR INICIAL

Crea desde ahora una navegación visual preparada para CANACO.

Inicialmente puede contener:

```text
Inicio

Gestión
    Afiliados
    Promociones
    Sucursales

Administración
    Usuarios
    Cámaras
    Categorías
    Ubicaciones

Analítica
    Estadísticas
    Búsquedas
    Reportes

Contenido
    Portada

Sistema
    Configuración
    Auditoría
```

En esta primera fase SOLO:

```text
Inicio
```

necesita tener funcionalidad completa.

Las demás opciones pueden:

- aparecer deshabilitadas

o preferentemente:

- apuntar a una página temporal "Módulo en construcción"

pero NO generes todavía todos los CRUD.

No quiero aumentar innecesariamente el alcance de esta primera etapa.

---

# 28. ROLES FUTUROS

El sistema tendrá al menos:

```text
Administrador General
Administrador de Cámara
Afiliado
```

La BD contiene tablas de:

```text
roles
permisos
roles_permisos
```

Debes estudiar su estructura.

El sidebar deberá quedar diseñado de manera que posteriormente podamos ocultar elementos según permisos.

NO hardcodees la arquitectura visual de tal forma que posteriormente sea imposible hacerlo.

---

# 29. LOGIN

Prepara la estructura para una ruta:

```text
/login
```

Puedes crear una pantalla base de login usando Metronic si el alcance no complica excesivamente esta inicialización.

El diseño debe contemplar posteriormente:

```text
Correo electrónico
Contraseña
Recordarme
¿Olvidaste tu contraseña?
```

La recuperación de contraseña SÍ formará parte del sistema.

Existe una tabla:

```text
tokens_recuperacion_password
```

en el SQL.

No implementes todavía el envío real de correos si no es necesario para completar esta primera etapa.

Si implementas autenticación inicial:

- usar password_verify()
- sesiones PHP seguras
- validar usuario activo
- prepared statements
- regenerar Session ID después del login

---

# 30. SESIONES

La aplicación utilizará sesiones PHP para autenticación.

Cuando posteriormente exista login:

```php
session_regenerate_id(true);
```

después de autenticar correctamente.

Prepara helpers para verificar:

```text
usuario autenticado
rol
permisos
afiliado asociado
cámara asociada
```

No implementes todavía una enorme capa RBAC si no hace falta para mostrar la primera pantalla.

Pero no bloquees esa futura implementación.

---

# 31. PLANTILLA.PHP

Quiero que:

```text
vistas/plantilla.php
```

represente el layout administrativo principal.

Debe organizar el contenido aproximadamente así:

```php
<!DOCTYPE html>
<html>

<head>
    ...
</head>

<body>

    header

    sidebar

    main
        vista correspondiente
    /main

    footer

    scripts

</body>
</html>
```

Pero separando componentes en:

```text
layouts/head.php
layouts/header.php
layouts/sidebar.php
layouts/footer.php
layouts/scripts.php
```

Evita duplicación.

---

# 32. LAYOUTS

Cada layout debe tener una responsabilidad clara.

## head.php

Debe contener principalmente:

- charset
- viewport
- title
- favicon
- CSS de Metronic
- CSS propio

## header.php

Debe contener:

- navbar/header Metronic
- botón responsive del sidebar
- usuario
- notificaciones placeholder si corresponde

## sidebar.php

Debe contener:

- branding CANACO Card
- menú
- control responsive
- futuras condiciones por permiso

## toolbar.php

Si el layout elegido usa toolbar:

- título
- breadcrumbs
- acciones opcionales

## footer.php

Debe incluir algo limpio como:

```text
CANACO Card © 2026
```

sin publicidad innecesaria.

## scripts.php

Debe cargar:

- JavaScript de Metronic
- JavaScript del layout
- JS global de CANACO
- JS específico del módulo cuando corresponda

---

# 33. JAVASCRIPT POR MÓDULO

Quiero conservar una estructura clara.

Por ejemplo:

```text
vistas/js/
    app.js
    login.js
    afiliados.js
    promociones.js
```

NO cargues posteriormente los 50 JavaScript de todos los módulos en todas las páginas.

Deja diseñada una forma de cargar solamente:

```text
globales
+
JS específico de la ruta actual
```

si existe.

---

# 34. AJAX

Crea la carpeta:

```text
ajax/
```

pero no es necesario llenarla de endpoints vacíos.

Posteriormente utilizaremos patrones como:

```text
vistas/js/afiliados.js
       ↓
ajax/afiliados.ajax.php
       ↓
ControladorAfiliados
       ↓
ModeloAfiliados
       ↓
PDO
```

Mantén esta arquitectura en mente.

---

# 35. MODELOS

Los modelos deberán responsabilizarse de:

- consultas SQL
- prepared statements
- persistencia
- obtención de datos

No deben:

- imprimir HTML
- acceder directamente al DOM
- contener componentes visuales
- hacer `echo` de vistas

Convención preferida:

```text
afiliados.modelo.php
promociones.modelo.php
usuarios.modelo.php
```

Clases:

```text
ModeloAfiliados
ModeloPromociones
ModeloUsuarios
```

Métodos pueden utilizar la convención:

```text
mdlMostrarAfiliados()
mdlRegistrarAfiliado()
```

si resulta conveniente.

---

# 36. CONTROLADORES

Los controladores deberán:

- recibir datos
- validar flujo
- invocar modelos
- preparar resultados
- gestionar acciones

Convención:

```text
afiliados.controlador.php
```

Clase:

```text
ControladorAfiliados
```

Métodos:

```text
ctrMostrarAfiliados()
ctrRegistrarAfiliado()
```

No mezcles consultas SQL directamente dentro del controlador.

---

# 37. VISTAS

Las vistas deben:

- mostrar información
- utilizar componentes Metronic
- mantener PHP de presentación razonable
- evitar consultas SQL directas

No ejecutar:

```php
PDO::prepare(...)
```

desde una vista.

---

# 38. ERRORES

Crea manejo básico para:

```text
404
500
```

Durante desarrollo puedes permitir mensajes técnicos útiles.

Pero la interfaz del usuario debe mostrar páginas limpias.

Nunca muestres credenciales de BD.

---

# 39. LOGS

Crea:

```text
storage/logs/
```

y deja una estructura preparada para guardar errores propios si posteriormente la utilizamos.

No necesitas crear un framework de logging completo.

---

# 40. SEGURIDAD

Desde el principio aplica:

- prepared statements
- escape de salida HTML
- validación server-side
- password_hash
- password_verify
- session_regenerate_id
- protección básica de sesiones
- validación de rutas
- evitar directory traversal
- evitar SQL injection
- evitar XSS
- evitar includes arbitrarios

Cuando muestres valores:

```php
htmlspecialchars()
```

cuando corresponda.

---

# 41. CSRF

Deja prevista una solución central para tokens CSRF en formularios POST.

Puedes implementar un helper ligero desde ahora.

Algo conceptualmente similar a:

```text
generarTokenCSRF()
validarTokenCSRF()
```

No agregues una dependencia gigante para esto.

---

# 42. ARCHIVOS SUBIDOS

Posteriormente manejaremos:

```text
uploads/afiliados/
uploads/promociones/
```

Las imágenes NO se guardarán dentro de la BD directamente.

La BD registra su metadata/ruta mediante las tablas correspondientes.

No implementes todavía el uploader completo.

Solo deja preparada una estructura razonable.

---

# 43. GITIGNORE

Crea un:

```text
.gitignore
```

adecuado.

Debe considerar cosas como:

```text
.env
logs
archivos temporales
cache
uploads privados si corresponde
configuración local del IDE
```

NO ignores:

```text
canaco_card.sql
```

si actualmente forma parte del proyecto y se utiliza como esquema oficial.

NO ignores la plantilla de Metronic sin antes evaluar cómo se manejará dentro del repositorio.

---

# 44. README DEL PROYECTO

Crea:

```text
README_CANACO.md
```

o actualiza un README específico del proyecto SIN sobrescribir el README original de Metronic.

Debe explicar:

- objetivo
- stack
- estructura
- instalación local
- configuración BD
- importar canaco_card.sql
- activar mod_rewrite
- URL local
- arquitectura MVC
- funcionamiento de rutas
- dónde están los assets de Metronic

---

# 45. NO MODIFICAR FUENTES DE REFERENCIA

Debes preservar:

```text
canaco_card.sql
```

y:

```text
metronic-v9.5.0/
```

No moverlos.

No eliminarlos.

No renombrarlos.

No sobrescribirlos.

En esta etapa son fuentes permanentes del proyecto.

---

# 46. IMPORTANTE SOBRE LA BD

No es necesario que la BD exista para que puedas construir la primera vista.

Pero la clase de conexión debe quedar preparada.

Si la BD no está disponible:

NO debes hacer que el dashboard entero colapse.

Muestra un error razonable únicamente cuando una funcionalidad realmente requiera conexión.

---

# 47. NO CREAR CRUD TODAVÍA

En esta primera implementación NO quiero que intentes desarrollar:

- CRUD completo de afiliados
- CRUD completo de promociones
- CRUD completo de usuarios
- CRUD completo de categorías
- reportes completos
- buscador completo
- estadísticas reales
- sitio público completo

Eso vendrá después.

PRIMERO necesitamos una base sólida.

---

# 48. OBJETIVO DE ESTA ITERACIÓN

Cuando termines ESTA primera fase debe existir:

```text
✔ estructura MVC
✔ Front Controller
✔ routing
✔ .htaccess
✔ configuración central
✔ clase PDO
✔ integración Metronic
✔ layout dividido
✔ sidebar
✔ header
✔ footer
✔ dashboard inicial
✔ responsive
✔ assets funcionando
✔ página 404
✔ estructura de login preparada
✔ estructura preparada para AJAX
✔ helpers básicos
✔ README
✔ código organizado
```

---

# 49. RESULTADO EN NAVEGADOR

Quiero poder abrir el proyecto en Apache y visualizar aproximadamente:

```text
http://localhost/canaco-card/
```

y que automáticamente resuelva:

```text
/inicio
```

o muestre la pantalla inicial correspondiente.

Debe verse:

```text
CANACO Card

Sidebar
Header

Dashboard
Bienvenido a CANACO Card
```

utilizando realmente Metronic.

No quiero una imitación CSS de Metronic.

Quiero que utilices los componentes y assets de la plantilla adquirida.

---

# 50. RESPONSIVE

Debes comprobar que:

- sidebar funcione en desktop
- sidebar pueda abrir/cerrar en móvil
- header sea responsive
- cards se adapten
- no exista scroll horizontal accidental
- Metronic inicialice correctamente sus componentes

No elimines atributos `data-*` necesarios para su JavaScript.

---

# 51. DARK MODE

Si el layout de Metronic elegido ya trae soporte oficial para modo oscuro:

Presérvalo.

No hace falta desarrollarlo manualmente.

Puedes agregar el selector si ya existe como componente reutilizable.

Pero no conviertas esto en una prioridad sobre la arquitectura.

---

# 52. NO ROMPER METRONIC AL SEPARAR HTML

Cuando dividas una página original en:

```text
head
header
sidebar
toolbar
contenido
footer
scripts
```

debes conservar:

- clases
- IDs
- data attributes
- jerarquía DOM necesaria
- scripts de inicialización
- atributos responsive

Si algún componente deja de funcionar después de dividirlo, revisa la estructura original de Metronic.

NO reemplaces inmediatamente el componente por código propio.

---

# 53. USA LOS DEMOS COMO DOCUMENTACIÓN

Si no sabes cómo construir una sección:

Busca primero dentro de:

```text
metronic-tailwind-html-demos
```

Antes de inventar un componente.

Los demos serán nuestra biblioteca visual.

Por ejemplo:

```text
datatable
profile
form
dashboard
users
settings
cards
modal
drawer
menu
```

Busca ejemplos existentes y adáptalos.

---

# 54. ESTILO DE CÓDIGO

Código:

- limpio
- indentado
- legible
- modular
- sin funciones de 500 líneas
- nombres descriptivos
- comentarios solo cuando aporten valor
- sin comentarios obvios

PHP:

preferentemente:

```php
declare(strict_types=1);
```

donde sea compatible con la estructura.

No compliques innecesariamente el proyecto con patrones enterprise que no aporten valor.

---

# 55. COMPATIBILIDAD

El proyecto deberá poder ejecutarse inicialmente en:

```text
Windows
XAMPP
Apache
PHP 8.2+
MySQL 8+
phpMyAdmin
```

Evita soluciones dependientes exclusivamente de Linux.

Evita scripts shell obligatorios para ejecutar la aplicación.

---

# 56. VALIDACIÓN ANTES DE FINALIZAR

Antes de decir que terminaste:

Revisa:

## PHP

Ejecuta validación sintáctica sobre todos los `.php` creados.

Por ejemplo:

```text
php -l
```

## rutas

Prueba:

```text
/
/inicio
/login
/ruta-inexistente
```

## assets

Comprueba:

```text
CSS carga
JS carga
imágenes cargan
fuentes/iconos cargan
```

## consola

Comprueba que no existan errores graves de JavaScript.

## red

Comprueba que no existan 404 de assets esenciales.

---

# 57. NO HAGAS SUPOSICIONES SILENCIOSAS

Si encuentras varias opciones posibles dentro de Metronic:

Analízalas.

Escoge la que mejor corresponda a un panel administrativo CANACO.

Documenta brevemente cuál elegiste.

No necesito que me preguntes por cada detalle visual menor.

Puedes tomar decisiones técnicas razonables.

Sin embargo:

NO cambies:

- PHP MVC
- SQL
- tecnología principal
- estructura conceptual
- Metronic HTML Tailwind

sin autorización.

---

# 58. TRABAJO AUTÓNOMO

Quiero que trabajes como agente.

No quiero que solamente me respondas:

"Puedes crear estas carpetas..."

Debes CREARLAS.

No quiero únicamente ejemplos de código.

Debes crear los archivos reales.

No quiero solamente explicar cómo integrar Metronic.

Debes integrarlo.

Usa las herramientas del IDE para:

- inspeccionar
- crear
- editar
- copiar
- comprobar

los archivos.

---

# 59. NO DETENERTE DESPUÉS DEL ANÁLISIS

Tu flujo debe ser:

```text
1. inspeccionar
2. analizar SQL
3. analizar Metronic
4. definir estructura
5. crear estructura
6. integrar Metronic
7. crear MVC
8. crear routing
9. crear primera vista
10. probar
11. corregir
12. documentar
```

No termines después del paso 3 diciéndome únicamente qué harías.

Debes implementar.

---

# 60. PERO NO TE EXCEDAS

También quiero que respetes el alcance.

No intentes terminar CANACO Card completo en una sola ejecución.

Esta iteración es:

```text
FUNDACIÓN DEL PROYECTO
+
PRIMERA PANTALLA FUNCIONAL
```

Los módulos empresariales los desarrollaremos después.

---

# 61. ARQUITECTURA PREPARADA PARA EL FUTURO

La estructura debe quedar lista para posteriormente desarrollar:

```text
Autenticación
Recuperación de contraseña

Usuarios
Roles
Permisos

Cámaras

Afiliados
Contactos
Sucursales
Teléfonos
Canales digitales
Categorías
Palabras clave
Galería

Promociones

Notificaciones

Portada pública

Configuraciones

Buscador avanzado

Estadísticas

Reportes

Auditoría
```

Sin tener que rehacer la arquitectura.

---

# 62. FUTURO MÓDULO AFILIADOS

Como referencia de arquitectura futura, un módulo podría terminar teniendo:

```text
controladores/
    afiliados.controlador.php

modelos/
    afiliados.modelo.php

vistas/
    modulos/
        afiliados/
            index.php
            nuevo.php
            editar.php

    js/
        afiliados.js

ajax/
    afiliados.ajax.php
```

No tienes que crear todo esto todavía.

Es únicamente la dirección arquitectónica.

---

# 63. NOMENCLATURA

Usaremos principalmente nombres en español.

Ejemplos:

```text
controladores
modelos
vistas
modulos
afiliados
promociones
usuarios
categorias
sucursales
```

Mantén coherencia.

No mezcles arbitrariamente:

```text
controllers
controladores
views
vistas
models
modelos
```

---

# 64. RUTAS DE ASSETS

Todas las URLs a assets deben funcionar independientemente de la ruta actual.

Por ejemplo, si estoy en:

```text
/afiliados/editar/5
```

NO debe intentar cargar:

```text
/afiliados/editar/assets/css/...
```

Utiliza BASE_URL o una función:

```text
asset()
```

para generar correctamente las rutas.

---

# 65. HELPER URL

Puedes crear helpers similares a:

```php
base_url()
asset()
route()
```

si mejoran la legibilidad.

Evita hardcodear:

```text
http://localhost/canaco-card/
```

en decenas de vistas.

---

# 66. PÁGINA 404

Si alguien entra a:

```text
/esto-no-existe
```

debe recibir:

- HTTP 404
- página visual apropiada
- layout consistente

No debe producir:

```text
Warning: include(...)
```

---

# 67. ESTADO INICIAL DEL SIDEBAR

Marca correctamente:

```text
Inicio
```

como activo cuando la ruta sea `/inicio`.

Posteriormente el sistema debe ser capaz de identificar dinámicamente el módulo activo.

No hardcodees permanentemente `active` sobre Inicio.

---

# 68. TÍTULO DINÁMICO

El `<title>` del navegador debe poder cambiar por módulo.

Ejemplos futuros:

```text
Inicio | CANACO Card
Afiliados | CANACO Card
Promociones | CANACO Card
```

Deja preparado el sistema desde ahora.

---

# 69. BREADCRUMBS

Los breadcrumbs deben poder generarse por módulo.

Inicial:

```text
Inicio
```

Futuro:

```text
Inicio / Afiliados / Nuevo
```

No es necesario crear un sistema complejo.

---

# 70. COMPONENTES REUTILIZABLES

Siempre que una estructura visual se repita:

- no copies 500 líneas innecesariamente
- crea partials cuando tenga sentido

Por ejemplo:

```text
layouts/
partials/
components/
```

Puedes crear `partials/` si es útil.

---

# 71. DOCUMENTA DECISIONES IMPORTANTES

Al finalizar crea:

```text
docs/arquitectura.md
```

Explicando brevemente:

```text
cómo funciona MVC
cómo funciona routing
cómo agregar un módulo
cómo agregar JS
cómo agregar una ruta
cómo usar la BD
cómo utilizar componentes de Metronic
```

Debe ser documentación práctica.

---

# 72. INSTRUCCIONES AL FINALIZAR

Después de realizar las modificaciones quiero que tu respuesta final sea BREVE pero concreta.

Incluye:

1. Qué analizaste.
2. Qué estructura creaste.
3. Qué layout de Metronic utilizaste.
4. Qué archivos principales creaste.
5. Cómo ejecutar CANACO.
6. Qué URL abrir.
7. Si detectaste algún problema.
8. Qué recomendarías como siguiente módulo.

No pegues todos los archivos completos en el chat si ya los modificaste directamente.

---

# 73. CRITERIO DE ÉXITO

La tarea solamente se considera completada si:

```text
El proyecto arranca
+
PHP MVC funciona
+
Metronic carga
+
Dashboard se visualiza
+
Routing funciona
+
estructura es escalable
+
SQL fue analizado
+
la plantilla original permanece intacta
```

---

# 74. PRIORIDAD DE FUENTES

Cuando exista una contradicción utiliza este orden:

## Base de datos

```text
1. canaco_card.sql
```

Es autoridad para estructura de datos.

## Diseño

```text
2. metronic-v9.5.0/metronic-tailwind-html-starter-kit
3. metronic-v9.5.0/metronic-tailwind-html-demos
```

Son autoridad para componentes visuales.

## Arquitectura

```text
4. instrucciones de este prompt
```

Son autoridad para organización del proyecto.

No inventes algo diferente sin una razón técnica importante.

---

# 75. COMIENZA AHORA

Empieza inspeccionando la raíz.

Después lee `canaco_card.sql` completo.

Después analiza específicamente el HTML Starter Kit y HTML Demos de Metronic.

Identifica el mejor layout administrativo para CANACO Card.

Después construye la estructura MVC.

Finalmente integra Metronic y deja funcionando la primera pantalla.

No modifiques todavía el esquema SQL.

No implementes todos los módulos.

La meta de esta iteración es:

# CANACO CARD — MVC BASE + METRONIC + DASHBOARD INICIAL FUNCIONAL
