# CANACO Card

Sistema de gestión para afiliados, sucursales y promociones de la CANACO.

## Requisitos del Sistema
- Servidor web (Apache/Nginx) con soporte para URL rewriting
- PHP 8.0 o superior
- Extensiones PHP: PDO, pdo_mysql, mbstring, json
- MySQL 8.0 o superior

## Instalación
1. Clonar el repositorio en el directorio raíz del servidor web o en una subcarpeta (ej. `htdocs/canaco-card`).
2. Configurar la base de datos:
   - Importar `canaco_card.sql` en MySQL.
   - Editar `config/database.php` con las credenciales de conexión.
3. Configurar la URL base:
   - Editar `config/config.php` y ajustar `BASE_URL` según la ruta de instalación (ej. `/canaco-card/`).
   - Si se usa Apache, verificar que `RewriteBase` en `.htaccess` coincida con `BASE_URL`.
4. Dar permisos de escritura a las carpetas:
   - `storage/logs/`
   - `uploads/afiliados/`
   - `uploads/promociones/`

## Estructura del Proyecto (MVC Personalizado)
El proyecto utiliza una arquitectura MVC personalizada y ligera en PHP puro:

- `ajax/`: Endpoints para peticiones asíncronas desde el frontend.
- `config/`: Archivos de configuración (BD, rutas, autoloader).
- `controladores/`: Clases controlador (lógica de negocio).
- `docs/`: Documentación técnica del proyecto.
- `helpers/`: Funciones auxiliares globales.
- `modelos/`: Clases para interactuar con la base de datos (PDO).
- `storage/logs/`: Archivos de registro de errores.
- `uploads/`: Almacenamiento de archivos subidos por usuarios.
- `vistas/`: Archivos de presentación (HTML/PHP).
  - `assets/`: Archivos estáticos originales de Metronic.
  - `css/` & `js/`: Código frontend personalizado de CANACO.
  - `layouts/`: Componentes estructurales de Metronic (header, sidebar, footer).
  - `modulos/`: Vistas específicas para cada ruta/módulo.

## Metronic 9.5 Tailwind
El panel administrativo utiliza el template Metronic 9.5 basado en Tailwind CSS.
- **Layout:** Demo 1 (Light Sidebar).
- **Sobrescritura de estilos:** No editar los archivos dentro de `vistas/assets/`. Usar `vistas/css/canaco.css` para estilos personalizados.
