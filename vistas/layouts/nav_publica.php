<?php
/**
 * CANACO Card — Barra de Navegación del Sitio Público
 * Navbar sticky con glassmorphism en scroll, links de sección, y botón de acceso.
 */
?>
<?php $enPortada = ($rutaActual ?? '') === '' || ($rutaActual ?? '') === 'portada'; ?>
<!-- Navegación Pública -->
<nav class="cp-nav" id="cpNav" aria-label="Navegación principal del portal">
    <div class="cp-nav-inner">

        <!-- Logo -->
        <a class="cp-nav-logo" href="<?= base_url('portada') ?>" aria-label="CANACO Card — Ir al inicio">
            <img src="<?= asset('media/app/CANACOCARD_Logo.png') ?>" alt="CANACO Card" id="cpNavLogo" />
        </a>

        <!-- Links de navegación (desktop) -->
        <ul class="cp-nav-links" role="list">
            <li><a href="<?= base_url('portada') ?>" aria-label="Inicio">Inicio</a></li>
            <li><a href="<?= $enPortada ? '#promociones' : base_url('portada#promociones') ?>" aria-label="Promociones vigentes">Promociones</a></li>
            <li><a href="<?= $enPortada ? '#empresas' : base_url('portada#empresas') ?>" aria-label="Directorio de empresas">Empresas</a></li>
            <li><a href="<?= $enPortada ? '#contacto' : base_url('portada#contacto') ?>" aria-label="Contacto">Contacto</a></li>
        </ul>

        <!-- Acciones -->
        <div class="cp-nav-actions">
            <a href="<?= base_url('login') ?>" class="cp-btn-login" id="btnIniciarSesion" aria-label="Iniciar sesión en el panel de administración">
                <i class="ki-filled ki-entrance-right" aria-hidden="true"></i>
                Iniciar sesión
            </a>

            <!-- Hamburguesa (móvil) -->
            <button class="cp-nav-hamburger" id="cpNavHamburger" aria-label="Abrir menú de navegación" aria-expanded="false" aria-controls="cpNavMobile">
                <span></span>
                <span></span>
                <span></span>
            </button>
        </div>
    </div>
</nav>

<!-- Menú móvil overlay -->
<div class="cp-nav-mobile" id="cpNavMobile" role="dialog" aria-modal="true" aria-label="Menú de navegación móvil">
    <button class="cp-nav-mobile-close" id="cpNavMobileClose" aria-label="Cerrar menú">
        <i class="ki-filled ki-cross" aria-hidden="true"></i>
    </button>
    <a href="<?= base_url('portada') ?>" onclick="closeMobileNav()">Inicio</a>
    <a href="<?= $enPortada ? '#empresas' : base_url('portada#empresas') ?>" onclick="closeMobileNav()">Empresas</a>
    <a href="<?= $enPortada ? '#promociones' : base_url('portada#promociones') ?>" onclick="closeMobileNav()">Promociones</a>
    <a href="<?= $enPortada ? '#contacto' : base_url('portada#contacto') ?>" onclick="closeMobileNav()">Contacto</a>
    <a href="<?= base_url('login') ?>" class="cp-btn-login" style="margin-top:1rem;">
        <i class="ki-filled ki-entrance-right" aria-hidden="true"></i>
        Iniciar sesión
    </a>
</div>
