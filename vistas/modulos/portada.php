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
<section class="cp-section" id="promociones" aria-labelledby="tituloSeccionPromos">
    <div class="cp-container">

        <!-- Encabezado de sección -->
        <div class="cp-section-header cp-fade-in">
            <span class="cp-section-eyebrow">
                <i class="ki-filled ki-discount" aria-hidden="true"></i>
                Ofertas vigentes
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

        <!-- Grid de tarjetas -->
        <?php if (empty($promociones)): ?>
        <div class="cp-empty-state cp-fade-in">
            <i class="ki-filled ki-discount" aria-hidden="true"></i>
            <p>No hay promociones vigentes en este momento.<br>¡Vuelve pronto!</p>
        </div>

        <?php else: ?>
        <div class="cp-promo-grid" aria-label="Listado de promociones">

            <?php foreach ($promociones as $i => $promo): ?>
            <?php
                $delayClass  = 'cp-delay-' . min($i + 1, 4);
                $ahora       = time();
                $finTs       = strtotime($promo['fin_vigencia']);
                $diasRestantes = max(0, (int) ceil(($finTs - $ahora) / 86400));
                $proxAVencer = $diasRestantes <= 3;
            ?>
            <article class="cp-promo-card cp-fade-in <?= $delayClass ?>"
                     aria-label="Promoción: <?= e($promo['titulo']) ?>">

                <!-- Imagen -->
                <div class="cp-promo-img-wrap">
                    <?php if (!empty($promo['imagen_url'])): ?>
                        <img src="<?= e($promo['imagen_url']) ?>"
                             alt="Imagen de la promoción <?= e($promo['titulo']) ?>"
                             loading="lazy" />
                    <?php else: ?>
                        <div class="cp-promo-img-placeholder" aria-hidden="true">🏷️</div>
                    <?php endif; ?>

                    <!-- Badge de estado -->
                    <span class="cp-promo-badge <?= $proxAVencer ? 'cp-promo-badge--expira' : '' ?>"
                          aria-label="<?= $proxAVencer ? "Expira en $diasRestantes días" : 'Vigente' ?>">
                        <?= $proxAVencer
                            ? '⏳ Vence en ' . $diasRestantes . 'd'
                            : '✓ Vigente' ?>
                    </span>
                </div>

                <!-- Cuerpo -->
                <div class="cp-promo-body">
                    <div class="cp-promo-empresa" aria-label="Empresa">
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
                        <span style="font-size:0.8rem;color:var(--cp-verde);font-weight:600;">
                            Ver detalle →
                        </span>
                    </div>
                </div>

            </article>
            <?php endforeach; ?>

        </div>

        <!-- CTA -->
        <div class="cp-section-cta cp-fade-in">
            <a href="#" class="cp-btn-outline" aria-label="Ver todas las promociones disponibles">
                <i class="ki-filled ki-discount" aria-hidden="true"></i>
                Ver todas las promociones
            </a>
        </div>

        <?php endif; ?>

    </div>
</section>
<!-- Fin Sección Promociones -->


<!-- ═══════════════════════════════════════════════════════════════════════
     SECCIÓN 3 — EMPRESAS AFILIADAS
     ═══════════════════════════════════════════════════════════════════════ -->
<section class="cp-section cp-section--alt" id="empresas" aria-labelledby="tituloSeccionEmpresas">
    <div class="cp-container">

        <!-- Encabezado de sección -->
        <div class="cp-section-header cp-fade-in">
            <span class="cp-section-eyebrow">
                <i class="ki-filled ki-people" aria-hidden="true"></i>
                Directorio de empresas
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

        <!-- Grid de tarjetas de empresa -->
        <?php if (empty($afiliados)): ?>
        <div class="cp-empty-state cp-fade-in">
            <i class="ki-filled ki-people" aria-hidden="true"></i>
            <p>Aún no hay empresas registradas en el directorio.</p>
        </div>

        <?php else: ?>
        <div class="cp-empresa-grid" aria-label="Listado de empresas afiliadas">

            <?php foreach ($afiliados as $i => $empresa): ?>
            <?php
                $delayClass   = 'cp-delay-' . min($i + 1, 4);
                $iniciales    = cpInitials($empresa['nombre_comercial']);
                $tienePromos  = (int)($empresa['promociones_activas'] ?? 0) > 0;
                $urlFicha     = base_url('empresa/' . $empresa['slug']);
            ?>
            <article class="cp-empresa-card cp-fade-in <?= $delayClass ?>"
                     role="article"
                     aria-label="Ficha de <?= e($empresa['nombre_comercial']) ?>">

                <!-- Logo o iniciales -->
                <div class="cp-empresa-logo-wrap" aria-hidden="true">
                    <?php if (!empty($empresa['logo_url'])): ?>
                        <img src="<?= e($empresa['logo_url']) ?>"
                             alt="Logotipo de <?= e($empresa['nombre_comercial']) ?>"
                             loading="lazy" />
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
                    <?= !empty($empresa['categoria_principal'])
                        ? e($empresa['categoria_principal'])
                        : 'Sin categoría' ?>
                </span>

                <!-- Badge de promociones -->
                <?php if ($tienePromos): ?>
                <span class="cp-empresa-promos-badge"
                      aria-label="<?= (int)$empresa['promociones_activas'] ?> promociones activas">
                    <i class="ki-filled ki-discount" aria-hidden="true"></i>
                    <?= (int)$empresa['promociones_activas'] ?>
                    <?= (int)$empresa['promociones_activas'] === 1 ? 'promoción' : 'promociones' ?>
                </span>
                <?php else: ?>
                <span class="cp-empresa-promos-badge no-promos" aria-label="Sin promociones activas">
                    Sin promociones
                </span>
                <?php endif; ?>

                <span class="cp-empresa-ver-ficha">Ver ficha →</span>
            </article>
            <?php endforeach; ?>

        </div>

        <!-- CTA: Ver directorio completo -->
        <div class="cp-section-cta cp-fade-in">
            <a href="#" class="cp-btn-primary" aria-label="Ver directorio completo de empresas">
                <i class="ki-filled ki-people" aria-hidden="true"></i>
                Ver directorio completo
            </a>
        </div>

        <?php endif; ?>

    </div>
</section>
<!-- Fin Sección Empresas -->
