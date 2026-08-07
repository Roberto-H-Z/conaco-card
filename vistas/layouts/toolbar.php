<?php
/**
 * CANACO Card — Toolbar
 * Renderiza el título de la página y los breadcrumbs.
 */
?>
<div class="flex flex-wrap items-center lg:items-end justify-between gap-5 pb-7.5">
 <div class="flex flex-col justify-center gap-2">
  <h1 class="text-xl font-medium leading-none text-foreground">
   <?= e($tituloModulo ?? 'Página') ?>
  </h1>
  
  <?php if (!empty($breadcrumbs)): ?>
  <div class="flex items-center gap-2 text-sm font-normal text-muted-foreground">
   <a class="hover:text-primary" href="<?= base_url('inicio') ?>">Inicio</a>
   
   <?php foreach ($breadcrumbs as $breadcrumb): ?>
    <span>/</span>
    <?php if (isset($breadcrumb['url']) && $breadcrumb['url'] !== '#'): ?>
     <a class="hover:text-primary" href="<?= base_url($breadcrumb['url']) ?>"><?= e($breadcrumb['titulo']) ?></a>
    <?php else: ?>
     <span class="text-foreground"><?= e($breadcrumb['titulo']) ?></span>
    <?php endif; ?>
   <?php endforeach; ?>
   
   <?php if (empty($breadcrumbs) || (end($breadcrumbs)['titulo'] !== $tituloModulo)): ?>
    <span>/</span>
    <span class="text-foreground"><?= e($tituloModulo) ?></span>
   <?php endif; ?>
  </div>
  <?php endif; ?>
 </div>
 
 <div class="flex items-center gap-2.5">
  <!-- Acciones globales del módulo pueden ir aquí -->
 </div>
</div>
