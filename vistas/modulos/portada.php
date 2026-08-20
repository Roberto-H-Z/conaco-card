<?php
/**
 * CANACO Card — Vista de la Portada Pública
 *
 * Secciones:
 *   1. Hero full-width con buscador y contadores
 *   2. Últimas Promociones (dinámicas desde DB)
 *   3. Empresas Afiliadas  (dinámicas desde DB)
 */

$totalAfiliados   = (int) ($datosVista['total_afiliados']   ?? 0);
$totalPromociones = (int) ($datosVista['total_promociones'] ?? 0);
$totalCategorias  = (int) ($datosVista['total_categorias']  ?? 0);
$promociones      = $datosVista['promociones']     ?? [];
$afiliados        = $datosVista['afiliados']        ?? [];
$seccionPromos    = $datosVista['seccion_promos']   ?? [];
$seccionEmpresas  = $datosVista['seccion_empresas'] ?? [];

/**
 * Helper local: genera iniciales del nombre para el logo fallback.
 */
function cpInitials(string $nombre): string
{
    $palabras = preg_split('/\s+/', trim($nombre));
    $ini = '';
    foreach (array_slice($palabras, 0, 2) as $p) {
        $ini .= mb_strtoupper(mb_substr($p, 0, 1));
    }
    return $ini ?: '?';
}

/**
 * Helper local: truncar texto.
 */
function cpTruncate(string $texto, int $max = 120): string
{
    return mb_strlen($texto) > $max
        ? mb_substr($texto, 0, $max) . '…'
        : $texto;
}

/**
 * Helper: formatea fecha en español corto.
 */
function cpFechaCorta(string $fecha): string
{
    $meses = ['','ene','feb','mar','abr','may','jun','jul','ago','sep','oct','nov','dic'];
    $ts = strtotime($fecha);
    return date('d', $ts) . ' ' . $meses[(int)date('n', $ts)] . ' ' . date('Y', $ts);
}
?>

<!-- ═══════════════════════════════════════════════════════════════════════
     SECCIÓN 1 — HERO
     ═══════════════════════════════════════════════════════════════════════ -->
<section class="cp-hero" id="inicio" aria-label="Presentación principal">

    <!-- Fondo de imagen -->
    <div class="cp-hero-bg" role="img" aria-label="Vista de una zona comercial"></div>

    <!-- Overlay de color -->
    <div class="cp-hero-overlay" aria-hidden="true"></div>

    <!-- Contenido central -->
    <div class="cp-hero-content">

        <div class="cp-hero-badge" aria-label="Directorio oficial">
            <i class="ki-filled ki-verify" aria-hidden="true"></i>
            Directorio oficial de afiliados
        </div>

        <h1 class="cp-hero-title">
            Descubre las mejores<br>
            <span>empresas de tu región</span>
        </h1>

        <p class="cp-hero-subtitle">
            Accede al directorio completo de empresas afiliadas a la Cámara Nacional de
            Comercio, Servicios y Turismo. Encuentra productos, servicios y promociones exclusivas.
        </p>

        <!-- Buscador -->
        <div class="cp-hero-search" role="search" aria-label="Buscador de empresas y promociones">
            <span class="cp-hero-search-icon" aria-hidden="true">
                <i class="ki-filled ki-magnifier"></i>
            </span>
            <input
                type="search"
                id="cpHeroSearch"
                name="q"
                placeholder="Busca empresa, producto o categoría…"
                autocomplete="off"
                aria-label="Término de búsqueda"
            />
            <button class="cp-hero-search-btn" type="button" id="cpHeroSearchBtn" aria-label="Buscar">
                Buscar
            </button>
        </div>

        <!-- Contadores estadísticos -->
        <div class="cp-hero-stats" role="list" aria-label="Estadísticas del directorio">
            <div class="cp-hero-stat" role="listitem">
                <span class="cp-hero-stat-num" data-count="<?= $totalAfiliados ?>" id="statAfiliados">
                    <?= $totalAfiliados ?>
                </span>
                <span class="cp-hero-stat-label">Empresas afiliadas</span>
            </div>

            <div class="cp-hero-divider" aria-hidden="true"></div>

            <div class="cp-hero-stat" role="listitem">
                <span class="cp-hero-stat-num" data-count="<?= $totalPromociones ?>" id="statPromociones">
                    <?= $totalPromociones ?>
                </span>
                <span class="cp-hero-stat-label">Promociones activas</span>
            </div>

            <div class="cp-hero-divider" aria-hidden="true"></div>

            <div class="cp-hero-stat" role="listitem">
                <span class="cp-hero-stat-num" data-count="<?= $totalCategorias ?>" id="statCategorias">
                    <?= $totalCategorias ?>
                </span>
                <span class="cp-hero-stat-label">Categorías</span>
            </div>
        </div>

    </div>
</section>
<!-- Fin Hero -->


<!-- ═══════════════════════════════════════════════════════════════════════
     SECCIÓN 2 — ÚLTIMAS PROMOCIONES
     ═══════════════════════════════════════════════════════════════════════ -->
<section class="cp-section cp-promos-showcase" id="promociones" aria-labelledby="tituloSeccionPromos">
    <div class="cp-section-glow cp-section-glow--promos" aria-hidden="true"></div>
    <div class="cp-container">

        <!-- Encabezado de sección -->
        <div class="cp-section-heading cp-fade-in">
            <div class="cp-section-heading-copy">
                <span class="cp-section-eyebrow">
                    <span class="cp-eyebrow-icon" aria-hidden="true">
                        <i class="ki-filled ki-discount"></i>
                    </span>
                    Beneficios para ti
                </span>
                <h2 class="cp-section-title" id="tituloSeccionPromos">
                    <?= e($seccionPromos['titulo'] ?? 'Últimas Promociones') ?>
                </h2>
                <?php if (!empty($seccionPromos['subtitulo'])): ?>
                <p class="cp-section-subtitle">
                    <?= e($seccionPromos['subtitulo']) ?>
                </p>
                <?php endif; ?>
            </div>

            <?php if (count($promociones) > 1): ?>
            <div class="cp-carousel-tools" aria-label="Controles de promociones">
                <span class="cp-carousel-status" data-carousel-status aria-live="polite">
                    01 / <?= str_pad((string) count($promociones), 2, '0', STR_PAD_LEFT) ?>
                </span>
                <div class="cp-carousel-buttons">
                    <button class="cp-carousel-btn" type="button" data-carousel-prev
                            aria-label="Ver promoción anterior" aria-controls="cpPromoRail">
                        <i class="ki-filled ki-left" aria-hidden="true"></i>
                    </button>
                    <button class="cp-carousel-btn" type="button" data-carousel-next
                            aria-label="Ver siguiente promoción" aria-controls="cpPromoRail">
                        <i class="ki-filled ki-right" aria-hidden="true"></i>
                    </button>
                </div>
            </div>
            <?php endif; ?>
        </div>

        <!-- Carrusel de tarjetas -->
        <?php if (empty($promociones)): ?>
        <div class="cp-empty-state cp-fade-in">
            <i class="ki-filled ki-discount" aria-hidden="true"></i>
            <p>No hay promociones vigentes en este momento.<br>¡Vuelve pronto!</p>
        </div>

        <?php else: ?>
        <div class="cp-promo-rail cp-fade-in" id="cpPromoRail" data-carousel-track
             role="region" aria-label="Promociones destacadas" tabindex="0">

            <?php foreach ($promociones as $i => $promo): ?>
            <?php
                $ahora       = time();
                $finTs       = strtotime($promo['fin_vigencia']);
                $diasRestantes = max(0, (int) ceil(($finTs - $ahora) / 86400));
                $proxAVencer = $diasRestantes <= 3;
            ?>
            <article class="cp-promo-card" data-carousel-item
                     aria-label="Promoción: <?= e($promo['titulo']) ?>">

                <!-- Imagen -->
                <div class="cp-promo-img-wrap">
                    <?php if (!empty($promo['imagen_url'])): ?>
                        <img src="<?= e($promo['imagen_url']) ?>"
                             alt="Imagen de la promoción <?= e($promo['titulo']) ?>"
                             loading="lazy" decoding="async" />
                    <?php else: ?>
                        <div class="cp-promo-img-placeholder" aria-hidden="true">
                            <i class="ki-filled ki-discount"></i>
                        </div>
                    <?php endif; ?>

                    <!-- Badge de estado -->
                    <span class="cp-promo-badge <?= $proxAVencer ? 'cp-promo-badge--expira' : '' ?>"
                          aria-label="<?= $proxAVencer ? "Expira en $diasRestantes días" : 'Vigente' ?>">
                        <?= $proxAVencer
                            ? '<i class="ki-filled ki-time" aria-hidden="true"></i> Vence en ' . $diasRestantes . 'd'
                            : '<i class="ki-filled ki-verify" aria-hidden="true"></i> Vigente' ?>
                    </span>

                    <span class="cp-promo-index" aria-hidden="true">
                        <?= str_pad((string) ($i + 1), 2, '0', STR_PAD_LEFT) ?>
                    </span>
                </div>

                <!-- Cuerpo -->
                <div class="cp-promo-body">
                    <div class="cp-promo-empresa" aria-label="Empresa">
                        <span aria-hidden="true"></span>
                        <?= e($promo['nombre_comercial']) ?>
                    </div>
                    <h3 class="cp-promo-title">
                        <?= e($promo['titulo']) ?>
                    </h3>
                    <p class="cp-promo-desc">
                        <?= e(cpTruncate($promo['descripcion'], 110)) ?>
                    </p>

                    <div class="cp-promo-footer">
                        <span class="cp-promo-fecha" aria-label="Vigencia">
                            <i class="ki-filled ki-calendar" aria-hidden="true"></i>
                            <?= cpFechaCorta($promo['inicio_vigencia']) ?>
                            &ndash;
                            <?= cpFechaCorta($promo['fin_vigencia']) ?>
                        </span>
                        <span class="cp-promo-discover" aria-hidden="true">
                            Descubrir <i class="ki-filled ki-right"></i>
                        </span>
                    </div>
                </div>

            </article>
            <?php endforeach; ?>

        </div>

        <div class="cp-section-cta cp-fade-in">
            <a href="#empresas" class="cp-text-link" aria-label="Conocer las empresas afiliadas">
                Conoce las empresas que hacen posibles estos beneficios
                <span aria-hidden="true"><i class="ki-filled ki-arrow-down"></i></span>
            </a>
        </div>

        <?php endif; ?>

    </div>
</section>
<!-- Fin Sección Promociones -->


<!-- ═══════════════════════════════════════════════════════════════════════
     SECCIÓN 3 — EMPRESAS AFILIADAS
     ═══════════════════════════════════════════════════════════════════════ -->
<section class="cp-section cp-section--alt cp-companies-showcase" id="empresas" aria-labelledby="tituloSeccionEmpresas">
    <div class="cp-section-grid-pattern" aria-hidden="true"></div>
    <div class="cp-container">

        <!-- Encabezado de sección -->
        <div class="cp-section-heading cp-fade-in">
            <div class="cp-section-heading-copy">
                <span class="cp-section-eyebrow">
                    <span class="cp-eyebrow-icon" aria-hidden="true">
                        <i class="ki-filled ki-people"></i>
                    </span>
                    Comunidad empresarial
                </span>
                <h2 class="cp-section-title" id="tituloSeccionEmpresas">
                    <?= e($seccionEmpresas['titulo'] ?? 'Empresas Afiliadas') ?>
                </h2>
                <?php if (!empty($seccionEmpresas['subtitulo'])): ?>
                <p class="cp-section-subtitle">
                    <?= e($seccionEmpresas['subtitulo']) ?>
                </p>
                <?php endif; ?>
            </div>

            <div class="cp-section-proof" aria-label="Directorio verificado">
                <span class="cp-section-proof-icon" aria-hidden="true">
                    <i class="ki-filled ki-verify"></i>
                </span>
                <span>
                    <strong><?= count($afiliados) ?> empresas destacadas</strong>
                    <small>Información validada por CANACO</small>
                </span>
            </div>
        </div>

        <!-- Grid de tarjetas de empresa -->
        <?php if (empty($afiliados)): ?>
        <div class="cp-empty-state cp-fade-in">
            <i class="ki-filled ki-people" aria-hidden="true"></i>
            <p>Aún no hay empresas registradas en el directorio.</p>
        </div>

        <?php else: ?>
        <svg class="cp-company-clip-defs" width="0" height="0" aria-hidden="true" focusable="false">
            <defs>
                <clipPath id="cpCompanyCardClip" clipPathUnits="objectBoundingBox">
                    <path d="M0,0 H1 V.79 C1,.91 .89,1 .75,1 H0 Z" />
                </clipPath>
            </defs>
        </svg>
        <div class="cp-empresa-grid" aria-label="Listado de empresas afiliadas">

            <?php foreach ($afiliados as $i => $empresa): ?>
            <?php
                $delayClass   = 'cp-delay-' . min($i + 1, 4);
                $iniciales    = cpInitials($empresa['nombre_comercial']);
                $tienePromos  = (int)($empresa['promociones_activas'] ?? 0) > 0;
                $urlFicha     = base_url('empresa/' . $empresa['slug']);
            ?>
            <div class="cp-empresa-card-shell cp-fade-in <?= $delayClass ?>">
            <article class="cp-empresa-card" data-spotlight-card
                     role="article"
                     aria-label="Ficha de <?= e($empresa['nombre_comercial']) ?>">

                <div class="cp-empresa-card-top">
                    <span class="cp-empresa-number" aria-hidden="true">
                        <?= str_pad((string) ($i + 1), 2, '0', STR_PAD_LEFT) ?>
                    </span>
                    <span class="cp-empresa-verified">
                        <i class="ki-filled ki-verify" aria-hidden="true"></i>
                        Afiliada
                    </span>
                </div>

                <!-- Logo o iniciales -->
                <div class="cp-empresa-logo-wrap">
                    <?php if (!empty($empresa['logo_url'])): ?>
                        <img src="<?= e($empresa['logo_url']) ?>"
                             alt="Logotipo de <?= e($empresa['nombre_comercial']) ?>"
                             loading="lazy" decoding="async" />
                    <?php else: ?>
                        <span class="cp-empresa-initials" aria-hidden="true">
                            <?= e($iniciales) ?>
                        </span>
                    <?php endif; ?>
                </div>

                <!-- Nombre -->
                <h3 class="cp-empresa-name">
                    <?= e($empresa['nombre_comercial']) ?>
                </h3>

                <!-- Categoría principal -->
                <span class="cp-empresa-cat" aria-label="Categoría">
                    <i class="ki-filled ki-category" aria-hidden="true"></i>
                    <?= !empty($empresa['categoria_principal'])
                        ? e($empresa['categoria_principal'])
                        : 'Sin categoría' ?>
                </span>

                <?php if (!empty($empresa['descripcion'])): ?>
                <p class="cp-empresa-desc">
                    <?= e(cpTruncate($empresa['descripcion'], 92)) ?>
                </p>
                <?php endif; ?>

                <!-- Badge de promociones -->
                <div class="cp-empresa-card-footer">
                    <?php if ($tienePromos): ?>
                    <span class="cp-empresa-promos-badge"
                          aria-label="<?= (int)$empresa['promociones_activas'] ?> promociones activas">
                        <i class="ki-filled ki-discount" aria-hidden="true"></i>
                        <?= (int)$empresa['promociones_activas'] ?>
                        <?= (int)$empresa['promociones_activas'] === 1 ? 'promoción' : 'promociones' ?>
                    </span>
                    <?php else: ?>
                    <span class="cp-empresa-promos-badge no-promos" aria-label="Sin promociones activas">
                        Sin promociones activas
                    </span>
                    <?php endif; ?>

                </div>
            </article>
            <span class="cp-empresa-ver-ficha" aria-hidden="true">
                <i class="ki-filled ki-arrow-up-right"></i>
            </span>
            </div>
            <?php endforeach; ?>

        </div>

        <div class="cp-directory-banner cp-fade-in">
            <div class="cp-directory-banner-copy">
                <span class="cp-directory-banner-icon" aria-hidden="true">
                    <i class="ki-filled ki-geolocation"></i>
                </span>
                <span>
                    <strong>El comercio local está más cerca de lo que imaginas</strong>
                    <small>Explora negocios, servicios y beneficios dentro de una comunidad confiable.</small>
                </span>
            </div>
            <a href="#contacto" class="cp-btn-primary" aria-label="Contactar con CANACO">
                Contactar con CANACO
                <i class="ki-filled ki-right" aria-hidden="true"></i>
            </a>
        </div>

        <?php endif; ?>

    </div>
</section>
<!-- Fin Sección Empresas -->
