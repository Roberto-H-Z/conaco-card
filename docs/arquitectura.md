# Arquitectura de CANACO Card

Este documento detalla el funcionamiento interno del framework MVC personalizado creado para CANACO Card.

## 1. Ciclo de Vida de una Petición

El flujo de cualquier petición en el sistema es el siguiente:

1. **`.htaccess`**: Apache intercepta la petición. Si no es un archivo físico (imagen, CSS, JS), la redirige a `index.php?ruta=X`.
2. **`index.php` (Front Controller)**:
   - Carga las configuraciones base.
   - Inicia la sesión PHP de forma segura.
   - Registra el autoloader.
   - Carga los helpers globales.
   - Analiza la URL solicitada y busca una coincidencia en `config/routes.php`.
3. **Manejo de la Ruta**:
   - Si la ruta requiere autenticación, verifica la sesión (`estaAutenticado()`). Si falla, redirige al login.
   - Si requiere roles específicos, los valida contra la sesión. Si falla, muestra un 403.
4. **Controlador**:
   - Instancia la clase del controlador definido para esa ruta.
   - Llama al método correspondiente, pasándole los segmentos adicionales de la URL como parámetros.
   - El controlador interactúa con los Modelos para obtener datos y retorna un array `$datosVista`.
5. **Renderizado (Vista)**:
   - `index.php` extrae la configuración de la ruta (layout, título, breadcrumbs).
   - Incluye el layout correspondiente (`vistas/plantilla.php` o vista directa para login).
   - El layout incluye las partes estructurales y finalmente hace un `require` del módulo en `vistas/modulos/X.php`.

## 2. Convenciones de Nomenclatura y Autoloading

El archivo `config/autoload.php` se encarga de cargar automáticamente las clases cuando se instancian, basándose en convenciones estrictas:

| Tipo | Nombre de Clase | Archivo esperado | Ubicación |
|---|---|---|---|
| Controlador | `ControladorInicio` | `inicio.controlador.php` | `controladores/` |
| Controlador (compuesto) | `ControladorUsuariosRoles` | `usuarios-roles.controlador.php` | `controladores/` |
| Modelo | `ModeloAfiliados` | `afiliados.modelo.php` | `modelos/` |
| Helper (clase opcional) | `ValidationHelper` | `validation.helper.php` | `helpers/` |
| Genérico | `Conexion` | `conexion.php` | `modelos/` (o global) |

## 3. Configuración de Rutas

Para agregar un nuevo módulo, se debe definir en `config/routes.php`. Ejemplo:

```php
'mi-ruta' => [
    'controlador' => 'ControladorMiRuta',
    'metodo'      => 'index',
    'vista'       => 'mi-ruta-vista',
    'auth'        => true,                   // Requiere sesión
    'roles'       => ['ADMIN_GENERAL'],      // Solo para este rol
    'titulo'      => 'Título de la Página',
    'breadcrumbs' => [
        ['titulo' => 'Categoría', 'url' => 'categoria'],
    ],
    'js'          => ['mi-ruta.js'],         // Carga vistas/js/mi-ruta.js
    'layout'      => 'admin',                // Usa la plantilla completa
]
```

## 4. Base de Datos (PDO)

Todas las interacciones con la base de datos deben hacerse a través de la clase `Conexion` (Singleton) usando **Prepared Statements** de PDO para prevenir Inyección SQL.

Ejemplo en un Modelo:
```php
class ModeloEjemplo {
    public static function obtenerPorId(int $id) {
        $stmt = Conexion::conectar()->prepare("SELECT * FROM tabla WHERE id = :id");
        $stmt->bindParam(':id', $id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch();
    }
}
```

## 5. Integración de Metronic

- **CSS/JS Core**: Copiados directamente a `vistas/assets/` desde `metronic-v9.5.0/metronic-tailwind-html-demos/dist/assets/`.
- **Estructura HTML**: Separada en `vistas/layouts/` (head, header, sidebar, toolbar, footer, scripts).
- **Sobrescritura**: Cualquier ajuste a estilos de Metronic se debe hacer en `vistas/css/canaco.css`, no en los archivos compilados de Metronic.
- **Componentes JS**: La inicialización de componentes como Modals o Dropdowns es gestionada automáticamente por `core.bundle.js` usando atributos `data-kt-*`.
