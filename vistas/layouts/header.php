<?php
/**
 * CANACO Card — Header (Topbar)
 * Basado en Metronic Demo 1
 */
$usuario = obtenerUsuarioSesion() ?? ['nombre' => 'Admin Test', 'correo' => 'admin@test.com', 'rol' => 'Administrador'];
?>
<header class="kt-header fixed top-0 z-10 start-0 end-0 flex items-stretch shrink-0 bg-background" data-kt-sticky="true" data-kt-sticky-class="border-b border-border" data-kt-sticky-name="header" id="header">
 <div class="kt-container-fixed flex justify-between items-stretch lg:gap-4" id="headerContainer">
  
  <!-- Mobile Logo -->
  <div class="flex gap-2.5 lg:hidden items-center -ms-1">
   <a class="shrink-0" href="<?= base_url() ?>">
    <img class="max-h-[25px] w-full" src="<?= asset('media/app/mini-logo.svg') ?>" />
   </a>
   <div class="flex items-center">
    <button class="kt-btn kt-btn-icon kt-btn-ghost" data-kt-drawer-toggle="#sidebar">
     <i class="ki-filled ki-menu"></i>
    </button>
   </div>
  </div>

  <div class="flex items-stretch" id="megaMenuContainer">
      <div class="flex items-center">
          <h2 class="text-lg font-medium text-gray-900 hidden lg:block">Panel de Administración</h2>
      </div>
  </div>

  <div class="flex items-center gap-2 lg:gap-3.5">
   
   <!-- Theme Toggle -->
   <button class="kt-btn kt-btn-icon kt-btn-ghost kt-btn-sm" data-kt-theme-toggle="true">
    <i class="ki-filled ki-moon theme-dark-show text-lg"></i>
    <i class="ki-filled ki-sun theme-light-show text-lg"></i>
   </button>

   <!-- User Dropdown -->
   <div class="kt-menu-item" data-kt-menu-item-placement="bottom-end" data-kt-menu-item-toggle="dropdown" data-kt-menu-item-trigger="click|lg:hover">
    <div class="kt-menu-link cursor-pointer" tabindex="0">
     <img class="size-8 rounded-full border border-border" src="<?= asset('media/avatars/blank.png') ?>" alt="Avatar" />
    </div>
    
    <div class="kt-menu-dropdown kt-menu-default kt-menu-fit flex-col w-[250px] p-5">
     <div class="flex items-center justify-between pb-4 border-b border-border">
      <div class="flex items-center gap-3">
       <img class="size-10 rounded-full border border-border" src="<?= asset('media/avatars/blank.png') ?>" alt="Avatar" />
       <div class="flex flex-col">
        <span class="text-sm font-medium text-foreground"><?= e($usuario['nombre']) ?></span>
        <span class="text-xs text-muted-foreground"><?= e($usuario['correo']) ?></span>
       </div>
      </div>
     </div>
     
     <div class="flex flex-col gap-1 py-4">
      <div class="kt-menu-item">
       <a class="kt-menu-link text-sm" href="#">Mi Perfil</a>
      </div>
      <div class="kt-menu-item">
       <a class="kt-menu-link text-sm" href="#">Configuración</a>
      </div>
     </div>
     
     <div class="border-t border-border pt-4">
      <a class="kt-btn kt-btn-sm kt-btn-light kt-btn-flex justify-center w-full" href="<?= base_url('login/cerrar') ?>">Cerrar sesión</a>
     </div>
    </div>
   </div>

  </div>
 </div>
</header>
