<?php
/**
 * CANACO Card — Vista de Error 404
 */
?>
<div class="flex items-center justify-center h-[60vh]">
 <div class="flex flex-col items-center text-center max-w-[400px]">
  <div class="mb-10 text-primary font-bold text-9xl">
   404
  </div>
  <h3 class="text-2xl font-semibold text-foreground mb-4">Página no encontrada</h3>
  <p class="text-base text-muted-foreground mb-8">
   <?= e($datosVista['mensaje'] ?? 'Lo sentimos, no pudimos encontrar la página que estás buscando.') ?>
  </p>
  <div class="flex gap-4">
   <a href="javascript:history.back()" class="kt-btn kt-btn-outline">Regresar</a>
   <a href="<?= base_url('inicio') ?>" class="kt-btn kt-btn-primary">Ir al Inicio</a>
  </div>
 </div>
</div>
