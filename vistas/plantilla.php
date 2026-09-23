<?php
/**
 * CANACO Card — Plantilla administrativa principal
 * 
 * Layout master que compone: head + body(sidebar + header + toolbar + content + footer + scripts)
 * Basado en Metronic 9.5 Demo 1 (Light Sidebar).
 * 
 * Variables disponibles:
 * - $vista       : nombre del archivo de vista (sin extensión)
 * - $tituloModulo: título de la página actual
 * - $breadcrumbs : array de breadcrumbs
 * - $jsModulo    : array de archivos JS específicos
 * - $rutaActual  : slug de la ruta activa
 * - $datosVista  : datos pasados por el controlador
 */
?>
<!DOCTYPE html>
<html class="h-full" data-canaco-panel="true" data-kt-theme="true" data-kt-theme-mode="light" dir="ltr" lang="es">

<?php require VIEWS_PATH . 'layouts/head.php'; ?>

<body class="antialiased flex h-full text-base text-foreground bg-background demo1 kt-sidebar-fixed kt-header-fixed<?= $vista === 'inicio' ? ' canaco-home-page' : '' ?>" data-base-url="<?= e(base_url()) ?>">
 <?php if ($vista === 'inicio'): ?>
 <!-- THESIS: La actividad del negocio se entiende como un informe visual mensual.
 OWN-WORLD: Superficies tinta y papel, azul para alcance, turquesa para visitas, ámbar para contacto; Inter y cifras tabulares.
 STORY: Leer la tendencia, comparar canales y mantener vigente la información comercial.
 FIRST VIEWPORT: Encabezado y periodo; lienzo de tendencia de dos tercios junto a barras de contacto; acciones junto al nombre comercial.
 FORM: Informe de actividad comercial, dirección 4; seed 31ec0c8a. Interacción: inspección diaria por teclado y series conmutables.
 FINISH: unreviewed and undocumented is unfinished; this build ends with the finish review, the verdict, DESIGN.md, and every shipping raster carrying its provenance -->
 <?php endif; ?>
 <!-- Page -->
 <!-- Main -->
 <div class="flex grow">

  <?php require VIEWS_PATH . 'layouts/sidebar.php'; ?>

  <!-- Wrapper -->
  <div class="kt-wrapper flex grow flex-col">

   <?php require VIEWS_PATH . 'layouts/header.php'; ?>

   <!-- Main Content -->
   <main class="grow content pt-5" id="content" role="content">
    <!-- Container -->
    <div class="container-fixed" id="content_container">

     <?php if ($vista !== 'inicio') require VIEWS_PATH . 'layouts/toolbar.php'; ?>

     <!-- Vista del módulo -->
     <?php
     $archivoVista = VIEWS_PATH . 'modulos/' . $vista . '.php';
     if (file_exists($archivoVista)) {
         require $archivoVista;
     } else {
         echo '<div class="kt-card"><div class="kt-card-content p-10"><p class="text-muted-foreground">Vista no encontrada: ' . e($vista) . '</p></div></div>';
     }
     ?>
     <!-- End of Vista del módulo -->

    </div>
    <!-- End of Container -->
   </main>
   <!-- End of Main Content -->

   <?php require VIEWS_PATH . 'layouts/footer.php'; ?>

  </div>
  <!-- End of Wrapper -->

 </div>
 <!-- End of Main -->
 <!-- End of Page -->

 <?php require VIEWS_PATH . 'layouts/scripts.php'; ?>

</body>
</html>
