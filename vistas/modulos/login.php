<?php
/**
 * CANACO Card — Vista de Login
 * Basado en Metronic authentication/classic/sign-in.html
 */
?>
<!DOCTYPE html>
<html class="h-full" data-kt-theme="true" data-kt-theme-mode="light" dir="ltr" lang="es">

<?php require VIEWS_PATH . 'layouts/head.php'; ?>

<body class="antialiased flex h-full text-base text-foreground bg-background">
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

 <div class="flex items-center justify-center grow bg-center bg-no-repeat page-bg">
  <style>
   .page-bg {
    background-image: url('<?= asset("media/illustrations/2.svg") ?>');
   }
   .dark .page-bg {
    background-image: url('<?= asset("media/illustrations/2-dark.svg") ?>');
   }
  </style>
  
  <div class="kt-card max-w-[390px] w-full mx-5">
   <div class="kt-card-body p-10">
    <div class="flex justify-center mb-10">
     <img class="max-h-[50px]" src="<?= asset('media/app/default-logo.svg') ?>" alt="CANACO Card" />
    </div>
    
    <div class="text-center mb-8">
     <h3 class="text-xl font-semibold text-foreground mb-2">Panel Administrativo</h3>
     <p class="text-sm font-medium text-muted-foreground">Inicie sesión para continuar</p>
    </div>

    <?php if (isset($datosVista['error'])): ?>
    <div class="mb-5 p-4 rounded-lg bg-danger-light text-danger text-sm font-medium">
        <?= e($datosVista['error']) ?>
    </div>
    <?php endif; ?>
    
    <form class="flex flex-col gap-5" action="<?= base_url('login/autenticar') ?>" method="POST">
     <?= campoCSRF() ?>
     
     <div class="flex flex-col gap-1">
      <label class="kt-form-label text-foreground">Correo electrónico</label>
      <input class="kt-input" name="correo" placeholder="usuario@canaco.com" type="email" required autofocus />
     </div>
     
     <div class="flex flex-col gap-1">
      <div class="flex items-center justify-between gap-1">
       <label class="kt-form-label text-foreground">Contraseña</label>
       <a class="text-2sm text-primary hover:text-primary-active font-medium" href="#">¿Olvidó su contraseña?</a>
      </div>
      <div class="kt-input-icon kt-input-icon-end">
       <input class="kt-input" name="password" placeholder="••••••••" type="password" required />
       <span class="kt-icon cursor-pointer" data-kt-password-meter-control="visibility">
        <i class="ki-filled ki-eye text-muted-foreground hidden"></i>
        <i class="ki-filled ki-eye-slash text-muted-foreground"></i>
       </span>
      </div>
     </div>
     
     <label class="kt-checkbox kt-checkbox-sm mt-2">
      <input name="remember" type="checkbox" value="1" />
      <span class="kt-checkbox-label">Recordarme en este equipo</span>
     </label>
     
     <button type="submit" class="kt-btn kt-btn-primary flex justify-center w-full mt-2">
      Iniciar sesión
     </button>
    </form>
   </div>
  </div>
 </div>

 <!-- Core Scripts -->
 <script src="<?= asset('js/core.bundle.js') ?>"></script>
 <script src="<?= asset('vendors/ktui/ktui.min.js') ?>"></script>
</body>
</html>
