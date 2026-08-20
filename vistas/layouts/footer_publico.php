<?php
/**
 * CANACO Card — Pie de Página del Sitio Público
 * Footer institucional de 3 columnas con info de contacto de la Cámara.
 */
?>
<footer class="cp-footer" id="contacto" role="contentinfo" aria-label="Pie de página">
    <div class="cp-footer-watermark" aria-hidden="true">CANACO</div>

    <div class="cp-footer-cta-wrap cp-fade-in">
        <div class="cp-footer-cta">
            <div>
                <span class="cp-footer-cta-kicker">Impulsa tu presencia digital</span>
                <h2>Tu empresa también puede ser parte de esta comunidad.</h2>
                <p>Conecta con nuevos clientes y comparte beneficios exclusivos con la región.</p>
            </div>
            <a href="<?= base_url('afiliados') ?>" class="cp-footer-cta-button">
                Iniciar Sesión
                <i class="ki-filled ki-arrow-right" aria-hidden="true"></i>
            </a>
        </div>
    </div>

    <div class="cp-footer-grid">

        <!-- Col 1: Brand + Descripción -->
        <div class="cp-footer-brand">
            <img src="<?= asset('media/app/CANACOCARD_Logo.png') ?>"
                 alt="CANACO Card"
                 class="cp-footer-logo" />
            <p class="cp-footer-desc">
                CANACO Card es el directorio digital oficial de empresas afiliadas a la
                Cámara Nacional de Comercio, Servicios y Turismo.
                Conectamos negocios con clientes en toda la región.
            </p>
            <!-- Redes sociales de la Cámara -->
            <div class="cp-footer-social" aria-label="Redes sociales">
                <a href="#" class="cp-social-fb"  aria-label="Facebook de CANACO" title="Facebook">
                    <i class="ki-filled ki-facebook" aria-hidden="true"></i>
                </a>
                <a href="#" class="cp-social-ig"  aria-label="Instagram de CANACO" title="Instagram">
                    <i class="ki-filled ki-instagram" aria-hidden="true"></i>
                </a>
                <a href="#" class="cp-social-wa"  aria-label="WhatsApp de CANACO" title="WhatsApp">
                    <i class="ki-filled ki-whatsapp" aria-hidden="true"></i>
                </a>
            </div>
        </div>

        <!-- Col 2: Links rápidos -->
        <div class="cp-footer-column">
            <h3 class="cp-footer-col-title">Navegación</h3>
            <ul class="cp-footer-links" role="list">
                <li>
                    <a href="<?= base_url('portada') ?>">
                        <i class="ki-filled ki-home" aria-hidden="true"></i> Inicio
                    </a>
                </li>
                <li>
                    <a href="#empresas">
                        <i class="ki-filled ki-people" aria-hidden="true"></i> Directorio de Empresas
                    </a>
                </li>
                <li>
                    <a href="#promociones">
                        <i class="ki-filled ki-discount" aria-hidden="true"></i> Promociones
                    </a>
                </li>
                <li>
                    <a href="#contacto">
                        <i class="ki-filled ki-message-text" aria-hidden="true"></i> Contacto
                    </a>
                </li>
                <li>
                    <a href="<?= base_url('afiliados') ?>">
                        <i class="ki-filled ki-entrance-right" aria-hidden="true"></i> Acceso Panel
                    </a>
                </li>
            </ul>
        </div>

        <!-- Col 3: Contacto de la Cámara -->
        <div class="cp-footer-column">
            <h3 class="cp-footer-col-title">Contacto</h3>

            <div class="cp-footer-contact-item">
                <i class="ki-filled ki-geolocation" aria-hidden="true"></i>
                <span>
                    Cámara Nacional de Comercio,<br>
                    Servicios y Turismo<br>
                    Veracruz, México
                </span>
            </div>

            <div class="cp-footer-contact-item">
                <i class="ki-filled ki-sms" aria-hidden="true"></i>
                <a href="mailto:contacto@canacocard.mx">contacto@canacocard.mx</a>
            </div>
        </div>

    </div>

    <!-- Franja inferior copyright -->
    <div class="cp-footer-bottom">
        <span>© <?= date('Y') ?> CANACO Card · Todos los derechos reservados</span>
        <span>
            Desarrollado para
            <a href="#" aria-label="CANACO SERVYTUR">CANACO SERVYTUR</a>
        </span>
    </div>
</footer>
