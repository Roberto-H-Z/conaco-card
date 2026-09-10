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
    <?php if (($rutaActual ?? '') === 'buscar'): ?>
    <!-- THESIS: Encontrar una empresa con filtros visibles y resultados legibles.
    OWN-WORLD: Identidad del portal CANACO, marino, blanco, Inter/Outfit y Keenicons.
    STORY: Buscar, afinar por ciudad y categoría, abrir empresa o promoción y volver.
    FIRST VIEWPORT: Encabezado compacto, filtros a la izquierda y resultados a la derecha; móvil en una columna.
    FORM: Extensión operativa del directorio existente, inherit-search-20260909.
    FINISH: unreviewed and undocumented is unfinished; this build ends with the finish review, the verdict, DESIGN.md, and every shipping raster carrying its provenance -->
    <?php endif; ?>
    <?php if (($rutaActual ?? '') === 'promocion'): ?>
    <!--
    THESIS: La promoción es el contenido principal; su beneficio, vigencia e imagen dominan sin convertir la página en una cuadrícula de tarjetas.
    OWN-WORLD: Marino CANACO, celeste de acción, verde de vigencia, superficies blancas editoriales y Keenicons.
    STORY: La persona entiende la oferta, confirma cuándo aplica, revisa condiciones y contacta o conoce al afiliado.
    FIRST VIEWPORT: Imagen promocional amplia a la izquierda; título, empresa, vigencia y acción principal a la derecha.
    FORM: Extensión de la ficha pública de afiliado, modo lectura/persuasión, clave inherit-ficha-afiliado-20260904.
    FINISH: unreviewed and undocumented is unfinished; this build ends with the finish review, the verdict, DESIGN.md, and every shipping raster carrying its provenance
    -->
    <?php endif; ?>

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
