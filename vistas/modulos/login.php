<?php
/**
 * CANACO Card — Vista de Login
 * Basado en Metronic authentication/classic/sign-in.html
 */
?>
<!DOCTYPE html>
<html class="h-full" data-kt-theme="true" data-kt-theme-mode="light" dir="ltr" lang="es">

<?php require VIEWS_PATH . 'layouts/head.php'; ?>

<body class="canaco-login-body antialiased min-h-dvh text-base text-foreground bg-background">
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

 <main class="canaco-auth-stage" id="contenido-principal">
  <div class="canaco-auth-shell">
   <section class="canaco-auth-story" aria-labelledby="canaco-auth-story-title">
    <div class="canaco-auth-story-content">
     <a class="canaco-auth-home" href="<?= base_url('portada') ?>" aria-label="Volver al portal público de CANACO Card">
      <span class="canaco-auth-home-mark" aria-hidden="true"><i class="ki-filled ki-arrow-left"></i></span>
      Volver al portal
     </a>

     <div class="canaco-auth-brand-copy">
      <p class="canaco-auth-brand-name">CANACO CARD</p>
      <h1 id="canaco-auth-story-title">La red comercial que acerca oportunidades.</h1>
      <p>Administre la presencia de su empresa, promociones e información comercial desde un solo lugar.</p>
     </div>

     <div class="canaco-auth-access" aria-label="Perfiles con acceso al panel">
      <span><i class="ki-filled ki-shield-tick" aria-hidden="true"></i> Administrador General</span>
      <span><i class="ki-filled ki-shop" aria-hidden="true"></i> Administrador de Cámara</span>
      <span><i class="ki-filled ki-briefcase" aria-hidden="true"></i> Afiliado</span>
     </div>
    </div>
   </section>

   <section class="canaco-auth-form-region" aria-labelledby="canaco-auth-title">
    <div class="canaco-auth-utility">
     <span>Plataforma CANACO Card</span>
     <button class="canaco-auth-theme-toggle" id="loginThemeToggle" type="button" aria-label="Cambiar tema de color" aria-pressed="false" title="Cambiar tema de color">
      <i class="ki-filled ki-sun" aria-hidden="true"></i>
      <i class="ki-filled ki-moon" aria-hidden="true"></i>
     </button>
    </div>

    <div class="kt-card canaco-auth-card">
     <div class="kt-card-content canaco-auth-card-content">
      <div class="canaco-auth-logo-wrap">
       <img src="<?= asset('media/app/CANACOCARD_Logo.png') ?>" alt="CANACO Card, de la montaña al mar" width="4167" height="2256" />
      </div>

      <div class="canaco-auth-heading">
       <h2 id="canaco-auth-title">Bienvenido de vuelta</h2>
       <p>Ingrese sus datos para continuar a CANACO Card.</p>
      </div>

      <?php $errorLogin = (string) ($_SESSION['login_error'] ?? ''); unset($_SESSION['login_error']); ?>
      <form class="canaco-auth-form" action="<?= base_url('login/autenticar') ?>" method="POST" novalidate>
       <?= campoCSRF() ?>
       <?php if ($errorLogin !== ''): ?><p class="canaco-auth-error" role="alert"><?= e($errorLogin) ?></p><?php endif; ?>
       <div class="canaco-auth-field">
        <label class="kt-form-label" for="correo">Correo electrónico</label>
        <div class="canaco-auth-input-wrap">
         <i class="ki-filled ki-sms" aria-hidden="true"></i>
         <input class="kt-input" id="correo" name="correo" placeholder="usuario@canaco.com" type="email" autocomplete="username" maxlength="254" required autofocus />
        </div>
       </div>

       <div class="canaco-auth-field">
        <div class="canaco-auth-label-row">
         <label class="kt-form-label" for="password">Contraseña</label>
         <span class="canaco-auth-visual-note">Acceso seguro</span>
        </div>
        <div class="kt-input canaco-auth-password" data-kt-toggle-password="true">
         <i class="ki-filled ki-lock-2" aria-hidden="true"></i>
         <input id="password" name="password" placeholder="••••••••" type="password" autocomplete="current-password" required />
         <button class="kt-btn kt-btn-sm kt-btn-ghost kt-btn-icon bg-transparent!" data-kt-toggle-password-trigger="true" type="button" aria-label="Mostrar u ocultar contraseña">
          <span class="kt-toggle-password-active:hidden"><i class="ki-filled ki-eye text-muted-foreground" aria-hidden="true"></i></span>
          <span class="hidden kt-toggle-password-active:block"><i class="ki-filled ki-eye-slash text-muted-foreground" aria-hidden="true"></i></span>
         </button>
        </div>
       </div>

       <label class="kt-label canaco-auth-remember" title="La sesión se mantiene únicamente durante esta visita.">
        <input class="kt-checkbox kt-checkbox-sm" name="remember" type="checkbox" value="1" />
        <span class="kt-checkbox-label">Mantener sesión durante esta visita</span>
       </label>

       <button type="submit" class="kt-btn kt-btn-primary canaco-auth-submit">
        <span>Continuar al panel</span>
        <i class="ki-filled ki-arrow-right" aria-hidden="true"></i>
       </button>
      </form>

      <p class="canaco-auth-help"><i class="ki-filled ki-information-2" aria-hidden="true"></i> Acceso protegido para usuarios autorizados.</p>
     </div>
    </div>
   </section>
  </div>
 </main>

 <!-- Core Scripts -->
 <script src="<?= asset('js/core.bundle.js') ?>"></script>
 <script src="<?= asset('vendors/ktui/ktui.min.js') ?>"></script>
 <script>
  (() => {
   const button = document.getElementById('loginThemeToggle');
   if (!button) return;

   const syncThemeButton = () => {
    const dark = document.documentElement.classList.contains('dark');
    button.setAttribute('aria-pressed', String(dark));
    button.setAttribute('title', dark ? 'Activar tema claro' : 'Activar tema oscuro');
    button.setAttribute('aria-label', dark ? 'Activar tema claro' : 'Activar tema oscuro');
   };

   syncThemeButton();
   button.addEventListener('click', () => {
    const dark = !document.documentElement.classList.contains('dark');
    document.documentElement.classList.toggle('dark', dark);
    document.documentElement.classList.toggle('light', !dark);
    document.documentElement.setAttribute('data-kt-theme-mode', dark ? 'dark' : 'light');
    document.documentElement.style.colorScheme = dark ? 'dark' : 'light';
    localStorage.setItem('kt-theme', dark ? 'dark' : 'light');
    localStorage.setItem('canaco-theme', dark ? 'dark' : 'light');
    syncThemeButton();
   });
  })();
 </script>
</body>
</html>
