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
<html class="h-full" data-kt-theme="true" data-kt-theme-mode="light" dir="ltr" lang="es">

<?php require VIEWS_PATH . 'layouts/head.php'; ?>

<body class="antialiased flex h-full text-base text-foreground bg-background demo1 kt-sidebar-fixed kt-header-fixed">
 <!-- Theme Mode -->
 <script>
  const defaultThemeMode = 'light';
  let themeMode;
  if (document.documentElement) {
   if (localStorage.getItem('kt-theme')) {
    themeMode = localStorage.getItem('kt-theme');
   } else if (document.documentElement.hasAttribute('data-kt-theme-mode')) {
    themeMode = document.documentElement.getAttribute('data-kt-theme-mode');
   } else {
    themeMode = defaultThemeMode;
   }
   if (themeMode === 'system') {
    themeMode = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
   }
   document.documentElement.classList.add(themeMode);
  }
 </script>
 <!-- End of Theme Mode -->

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

     <?php require VIEWS_PATH . 'layouts/toolbar.php'; ?>

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
