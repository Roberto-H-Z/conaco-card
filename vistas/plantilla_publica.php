<?php
/**
 * CANACO Card — Plantilla del Sitio Público
 *
 * Layout master para el portal de visitantes.
 * NO incluye sidebar ni toolbar administrativos de Metronic.
 *
 * Variables disponibles:
 * - $vista        : nombre del módulo a renderizar (ej. 'portada')
 * - $tituloModulo : título de la página
 * - $datosVista   : datos del controlador
 * - $jsPublico    : array de archivos JS específicos del módulo público
 */
?>
<!DOCTYPE html>
<html lang="es" dir="ltr">

<?php require VIEWS_PATH . 'layouts/head_publico.php'; ?>

<body class="cp-body" data-base-url="<?= e(base_url()) ?>">

    <?php require VIEWS_PATH . 'layouts/nav_publica.php'; ?>

    <!-- Contenido Principal del Módulo -->
    <main id="cpMain" role="main">
        <?php
        $archivoVista = VIEWS_PATH . 'modulos/' . ($vista ?? '404') . '.php';
        if (file_exists($archivoVista)) {
            require $archivoVista;
        } else {
            echo '<div style="padding:6rem 2rem;text-align:center;font-family:sans-serif;color:#666;">
                    Vista no encontrada: <strong>' . e($vista ?? '') . '</strong>
                  </div>';
        }
        ?>
    </main>

    <?php require VIEWS_PATH . 'layouts/footer_publico.php'; ?>

    <?php require VIEWS_PATH . 'layouts/scripts_publico.php'; ?>

</body>
</html>
