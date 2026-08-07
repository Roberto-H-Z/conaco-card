<?php
/**
 * CANACO Card — Vista genérica "En Construcción"
 */
?>
<div class="flex items-center justify-center h-[60vh]">
 <div class="flex flex-col items-center text-center max-w-[400px]">
  <div class="mb-10">
   <img src="<?= asset('media/illustrations/1.svg') ?>" class="dark:hidden max-h-[150px]" alt="En construcción" />
   <img src="<?= asset('media/illustrations/1-dark.svg') ?>" class="hidden dark:block max-h-[150px]" alt="En construcción" />
  </div>
  <h3 class="text-2xl font-semibold text-foreground mb-4">Módulo en Desarrollo</h3>
  <p class="text-base text-muted-foreground mb-8">
   <?= e($datosVista['mensaje'] ?? 'Este módulo está actualmente en desarrollo y estará disponible próximamente.') ?>
  </p>
  <a href="<?= base_url('inicio') ?>" class="kt-btn kt-btn-primary">Volver al Dashboard</a>
 </div>
</div>
