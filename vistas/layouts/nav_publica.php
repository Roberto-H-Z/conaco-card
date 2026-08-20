<?php
/**
 * CANACO Card — Barra de Navegación del Sitio Público
 * Navbar sticky con glassmorphism en scroll, links de sección, y botón de acceso.
 */
?>
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
            <li><a href="#promociones" aria-label="Promociones vigentes">Promociones</a></li>
            <li><a href="#empresas" aria-label="Directorio de empresas">Empresas</a></li>
            <li><a href="#contacto" aria-label="Contacto">Contacto</a></li>
        </ul>

        <!-- Acciones -->
        <div class="cp-nav-actions">
            <!-- Botón Iniciar Sesión (por ahora va directo al panel) -->
            <a href="<?= base_url('afiliados') ?>" class="cp-btn-login" id="btnIniciarSesion" aria-label="Acceso al panel de administración">
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
    <a href="#empresas"   onclick="closeMobileNav()">Empresas</a>
    <a href="#promociones" onclick="closeMobileNav()">Promociones</a>
    <a href="#contacto"   onclick="closeMobileNav()">Contacto</a>
    <a href="<?= base_url('afiliados') ?>" class="cp-btn-login" style="margin-top:1rem;">
        <i class="ki-filled ki-entrance-right" aria-hidden="true"></i>
        Iniciar sesión
    </a>
</div>
