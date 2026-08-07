<?php
/**
 * CANACO Card — Sidebar
 */
?>
<div class="kt-sidebar fixed z-20 top-0 bottom-0 start-0 w-[250px] bg-background border-e border-border transition-all duration-300 transform -translate-x-full lg:translate-x-0" data-kt-drawer="true" data-kt-drawer-class="kt-drawer kt-drawer-start fixed z-10 top-0 bottom-0 w-full max-w-[250px] p-5 lg:p-0 overflow-auto" id="sidebar">
 
 <!-- Sidebar Header -->
 <div class="flex items-center justify-between h-[70px] px-5 border-b border-border">
  <a href="<?= base_url() ?>">
   <h1 class="text-2xl font-bold text-primary">CANACO <span class="text-foreground">Card</span></h1>
  </a>
  <button class="kt-btn kt-btn-icon kt-btn-ghost lg:hidden" data-kt-drawer-dismiss="true">
   <i class="ki-filled ki-cross"></i>
  </button>
 </div>

 <!-- Sidebar Menu -->
 <div class="flex flex-col grow pt-5 pb-5 overflow-y-auto kt-scroll">
  <div class="kt-menu flex-col gap-2 px-5" data-kt-menu="true">

   <!-- Dashboard -->
   <div class="kt-menu-item <?= claseActiva('inicio', $rutaActual) ?>">
    <a class="kt-menu-link flex items-center gap-3 px-3 py-2 rounded-lg hover:bg-accent/60 kt-menu-item-active:bg-accent/60 text-sm font-medium text-foreground kt-menu-item-active:text-primary" href="<?= base_url('inicio') ?>">
     <span class="kt-menu-icon text-muted-foreground w-5"><i class="ki-filled ki-element-11 text-lg"></i></span>
     <span class="kt-menu-title">Dashboard</span>
    </a>
   </div>

   <div class="kt-menu-item pt-5 pb-2">
    <span class="text-xs font-semibold text-muted-foreground uppercase tracking-wider">Gestión</span>
   </div>

   <!-- Afiliados -->
   <div class="kt-menu-item <?= claseActiva('afiliados', $rutaActual) ?>">
    <a class="kt-menu-link flex items-center gap-3 px-3 py-2 rounded-lg hover:bg-accent/60 kt-menu-item-active:bg-accent/60 text-sm font-medium text-foreground kt-menu-item-active:text-primary" href="<?= base_url('afiliados') ?>">
     <span class="kt-menu-icon text-muted-foreground w-5"><i class="ki-filled ki-shop text-lg"></i></span>
     <span class="kt-menu-title">Afiliados</span>
    </a>
   </div>

   <!-- Promociones -->
   <div class="kt-menu-item <?= claseActiva('promociones', $rutaActual) ?>">
    <a class="kt-menu-link flex items-center gap-3 px-3 py-2 rounded-lg hover:bg-accent/60 kt-menu-item-active:bg-accent/60 text-sm font-medium text-foreground kt-menu-item-active:text-primary" href="<?= base_url('promociones') ?>">
     <span class="kt-menu-icon text-muted-foreground w-5"><i class="ki-filled ki-discount text-lg"></i></span>
     <span class="kt-menu-title">Promociones</span>
    </a>
   </div>

   <!-- Sucursales -->
   <div class="kt-menu-item <?= claseActiva('sucursales', $rutaActual) ?>">
    <a class="kt-menu-link flex items-center gap-3 px-3 py-2 rounded-lg hover:bg-accent/60 kt-menu-item-active:bg-accent/60 text-sm font-medium text-foreground kt-menu-item-active:text-primary" href="<?= base_url('sucursales') ?>">
     <span class="kt-menu-icon text-muted-foreground w-5"><i class="ki-filled ki-geolocation text-lg"></i></span>
     <span class="kt-menu-title">Sucursales</span>
    </a>
   </div>

   <div class="kt-menu-item pt-5 pb-2">
    <span class="text-xs font-semibold text-muted-foreground uppercase tracking-wider">Administración</span>
   </div>

   <!-- Usuarios -->
   <div class="kt-menu-item <?= claseActiva('usuarios', $rutaActual) ?>">
    <a class="kt-menu-link flex items-center gap-3 px-3 py-2 rounded-lg hover:bg-accent/60 kt-menu-item-active:bg-accent/60 text-sm font-medium text-foreground kt-menu-item-active:text-primary" href="<?= base_url('usuarios') ?>">
     <span class="kt-menu-icon text-muted-foreground w-5"><i class="ki-filled ki-users text-lg"></i></span>
     <span class="kt-menu-title">Usuarios</span>
    </a>
   </div>

   <!-- Cámaras -->
   <div class="kt-menu-item <?= claseActiva('camaras', $rutaActual) ?>">
    <a class="kt-menu-link flex items-center gap-3 px-3 py-2 rounded-lg hover:bg-accent/60 kt-menu-item-active:bg-accent/60 text-sm font-medium text-foreground kt-menu-item-active:text-primary" href="<?= base_url('camaras') ?>">
     <span class="kt-menu-icon text-muted-foreground w-5"><i class="ki-filled ki-bank text-lg"></i></span>
     <span class="kt-menu-title">Cámaras</span>
    </a>
   </div>

   <div class="kt-menu-item pt-5 pb-2">
    <span class="text-xs font-semibold text-muted-foreground uppercase tracking-wider">Sistema</span>
   </div>

   <!-- Configuración -->
   <div class="kt-menu-item <?= claseActiva('configuracion', $rutaActual) ?>">
    <a class="kt-menu-link flex items-center gap-3 px-3 py-2 rounded-lg hover:bg-accent/60 kt-menu-item-active:bg-accent/60 text-sm font-medium text-foreground kt-menu-item-active:text-primary" href="<?= base_url('configuracion') ?>">
     <span class="kt-menu-icon text-muted-foreground w-5"><i class="ki-filled ki-setting-2 text-lg"></i></span>
     <span class="kt-menu-title">Configuración</span>
    </a>
   </div>

  </div>
 </div>
</div>
