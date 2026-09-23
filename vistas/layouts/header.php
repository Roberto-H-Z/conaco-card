<?php
$usuarioBarra = obtenerUsuarioSesion();
$rolesTexto = ['ADMIN_GENERAL' => 'Administrador general', 'ADMIN_CAMARA' => 'Administrador de cámara', 'AFILIADO' => 'Afiliado'];
$rolUsuarioBarra = $rolesTexto[$usuarioBarra['rol'] ?? ''] ?? 'Usuario';
?>
<header class="kt-header fixed top-0 z-10 start-0 end-0 flex items-stretch shrink-0 bg-background" data-kt-sticky="true" data-kt-sticky-class="border-b border-border" data-kt-sticky-name="header" id="header">
 <div class="kt-container-fixed flex justify-between items-stretch lg:gap-4" id="headerContainer">
  <div class="flex gap-2.5 lg:hidden items-center -ms-1">
   <button class="kt-btn kt-btn-icon kt-btn-ghost" data-kt-drawer-toggle="#sidebar" aria-label="Abrir menú"><i class="ki-filled ki-menu"></i></button>
   <span class="font-semibold text-foreground">CANACO Card</span>
  </div>
  <div class="hidden lg:flex items-center gap-2"><button class="kt-btn kt-btn-icon canaco-sidebar-toggle" id="sidebarToggle" type="button" aria-controls="sidebar" aria-label="Ocultar menú lateral" aria-expanded="true" title="Ocultar menú lateral"><i class="ki-filled ki-double-left" id="sidebarToggleIcon" aria-hidden="true"></i></button><span class="text-sm text-muted-foreground"><?= e($rolUsuarioBarra) ?></span></div>
  <div class="flex items-center gap-2">
   <span class="hidden sm:inline text-xs text-muted-foreground"><?= e($usuarioBarra['nombre'] ?? '') ?></span>
   <button class="canaco-theme-switch" id="themeToggle" type="button" aria-label="Activar tema oscuro" aria-pressed="false" title="Cambiar a tema oscuro">
    <span class="canaco-theme-switch-thumb" aria-hidden="true"></span>
    <i class="ki-filled ki-sun canaco-theme-switch-icon canaco-theme-switch-sun" aria-hidden="true"></i>
    <i class="ki-filled ki-moon canaco-theme-switch-icon canaco-theme-switch-moon" aria-hidden="true"></i>
   </button>
  </div>
 </div>
</header>
