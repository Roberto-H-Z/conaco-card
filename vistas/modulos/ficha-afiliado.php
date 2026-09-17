<?php
/** @var array<string, mixed>|null $afiliado */
$afiliado = $datosVista['afiliado'] ?? null;

function cpFichaIniciales(string $nombre): string
{
    $palabras = preg_split('/\s+/', trim($nombre)) ?: [];
    $iniciales = '';
    foreach (array_slice($palabras, 0, 2) as $palabra) {
        $iniciales .= mb_strtoupper(mb_substr($palabra, 0, 1));
    }
    return $iniciales ?: 'CC';
}

function cpFichaUrlExterna(?string $url): ?string
{
    $url = trim((string) $url);
    if ($url === '') {
        return null;
    }
    $esquema = strtolower((string) parse_url($url, PHP_URL_SCHEME));
    return in_array($esquema, ['http', 'https'], true) ? $url : null;
}

function cpFichaTelefono(?string $numero): string
{
    return preg_replace('/[^0-9+]/', '', (string) $numero) ?? '';
}

function cpFichaDireccion(array $sucursal): string
{
    $linea = trim(implode(' ', array_filter([
        $sucursal['calle'] ?? null,
        $sucursal['numero_exterior'] ?? null,
        $sucursal['numero_interior'] ? 'Int. ' . $sucursal['numero_interior'] : null,
    ])));
    return implode(', ', array_filter([
        $linea,
        $sucursal['colonia'] ?? null,
        $sucursal['localidad'] ?? null,
        $sucursal['municipio'] ?? null,
        $sucursal['estado'] ?? null,
        $sucursal['codigo_postal'] ? 'C.P. ' . $sucursal['codigo_postal'] : null,
    ]));
}

function cpFichaMapaUrl(array $sucursal): ?string
{
    $latitud = $sucursal['latitud'] ?? null;
    $longitud = $sucursal['longitud'] ?? null;
    if ($latitud !== null && $longitud !== null) {
        return 'https://www.google.com/maps/search/?api=1&query=' . rawurlencode($latitud . ',' . $longitud);
    }
    $direccion = cpFichaDireccion($sucursal);
    return $direccion !== ''
        ? 'https://www.google.com/maps/search/?api=1&query=' . rawurlencode($direccion)
        : null;
}

function cpFichaIconoRed(string $tipo): string
{
    return match ($tipo) {
        'FACEBOOK' => 'ki-facebook',
        'INSTAGRAM' => 'ki-instagram',
        'WHATSAPP' => 'ki-whatsapp',
        'YOUTUBE' => 'ki-youtube',
        'TIKTOK' => 'ki-tiktok',
        default => 'ki-global',
    };
}

if ($afiliado === null):
?>
<section class="cp-profile-not-found" aria-labelledby="cpFichaNoEncontrada">
    <div class="cp-profile-not-found__inner">
        <span class="cp-profile-not-found__icon" aria-hidden="true"><i class="ki-filled ki-search-list"></i></span>
        <p>Directorio CANACO Card</p>
        <h1 id="cpFichaNoEncontrada">Esta ficha no está disponible</h1>
        <p>Es posible que la empresa no exista, ya no esté activa o que la dirección compartida sea incorrecta.</p>
        <a class="cp-profile-action cp-profile-action--primary" href="<?= base_url('portada#empresas') ?>">
            <i class="ki-filled ki-arrow-left" aria-hidden="true"></i> Volver al directorio
        </a>
    </div>
</section>
<?php return; endif;

$nombre = (string) $afiliado['nombre_comercial'];
$slug = (string) $afiliado['slug'];
$categorias = $afiliado['categorias'] ?? [];
$galeria = $afiliado['galeria'] ?? [];
$sucursales = $afiliado['sucursales'] ?? [];
$redes = $afiliado['redes'] ?? [];
$promociones = $afiliado['promociones'] ?? [];
$relacionadas = $afiliado['relacionadas'] ?? [];
$correo = filter_var((string) ($afiliado['correo_general'] ?? ''), FILTER_VALIDATE_EMAIL) ?: null;
$sitioWeb = cpFichaUrlExterna($afiliado['sitio_web']['url'] ?? null);
$telefonoPrincipal = null;
$whatsApp = null;
foreach ($sucursales as $sucursal) {
    foreach ($sucursal['telefonos'] as $telefono) {
        $numero = cpFichaTelefono($telefono['numero_normalizado'] ?: $telefono['numero_original']);
        if ($numero === '') {
            continue;
        }
        if ($telefonoPrincipal === null) {
            $telefonoPrincipal = ['numero' => $numero, 'texto' => $telefono['numero_original']];
        }
        if ($whatsApp === null && strtoupper((string) $telefono['tipo']) === 'WHATSAPP') {
            $whatsApp = ['numero' => $numero, 'texto' => $telefono['numero_original']];
        }
    }
}
?>

<div class="cp-profile-page" data-profile-page>
    <section class="cp-profile-hero" aria-labelledby="cpFichaTitulo">
        <div class="cp-profile-container">
            <a class="cp-profile-back" href="<?= e($datosVista['retorno_directorio'] ?? base_url('portada#empresas')) ?>" data-profile-back>
                <i class="ki-filled ki-arrow-left" aria-hidden="true"></i>
                Volver al directorio
            </a>

            <div class="cp-profile-hero__grid">
                <div class="cp-profile-identity cp-profile-reveal" style="--cp-reveal-index: 0">
                    <div class="cp-profile-logo" aria-label="Logotipo de <?= e($nombre) ?>">
                        <?php if (!empty($afiliado['logo']['url_publica'])): ?>
                            <img src="<?= e($afiliado['logo']['url_publica']) ?>"
                                 alt="Logotipo de <?= e($nombre) ?>"
                                 width="<?= (int) ($afiliado['logo']['ancho_px'] ?? 160) ?>"
                                 height="<?= (int) ($afiliado['logo']['alto_px'] ?? 160) ?>"
                                 decoding="async" />
                        <?php else: ?>
                            <span aria-hidden="true"><?= e(cpFichaIniciales($nombre)) ?></span>
                        <?php endif; ?>
                    </div>

                    <div class="cp-profile-identity__copy">
                        <h1 id="cpFichaTitulo"><?= e($nombre) ?></h1>
                        <p class="cp-profile-membership"><i class="ki-filled ki-verify" aria-hidden="true"></i> Empresa afiliada a <?= e($afiliado['camara_nombre']) ?></p>
                        <?php if (!empty($afiliado['alias'])): ?>
                            <p class="cp-profile-alias"><?= e($afiliado['alias']) ?></p>
                        <?php endif; ?>
                        <?php if ($categorias !== []): ?>
                            <ul class="cp-profile-categories" aria-label="Categorías de <?= e($nombre) ?>">
                                <?php foreach ($categorias as $categoria): ?>
                                    <li><?= e($categoria['nombre']) ?></li>
                                <?php endforeach; ?>
                            </ul>
                        <?php endif; ?>
                        <?php if (!empty($afiliado['descripcion'])): ?>
                            <p class="cp-profile-summary"><?= nl2br(e($afiliado['descripcion'])) ?></p>
                        <?php else: ?>
                            <p class="cp-profile-summary cp-profile-summary--muted">Consulta los canales y ubicaciones disponibles de esta empresa afiliada.</p>
                        <?php endif; ?>
                    </div>
                </div>

                <aside class="cp-profile-contact cp-profile-reveal" style="--cp-reveal-index: 1" aria-label="Acciones de contacto">
                    <h2>Contacta a <?= e($nombre) ?></h2>
                    <div class="cp-profile-actions">
                        <?php if ($whatsApp !== null): ?>
                            <a class="cp-profile-action cp-profile-action--primary" href="https://wa.me/<?= e(ltrim($whatsApp['numero'], '+')) ?>" target="_blank" rel="noopener noreferrer">
                                <i class="ki-filled ki-whatsapp" aria-hidden="true"></i> WhatsApp
                            </a>
                        <?php elseif ($telefonoPrincipal !== null): ?>
                            <a class="cp-profile-action cp-profile-action--primary" href="tel:<?= e($telefonoPrincipal['numero']) ?>">
                                <i class="ki-filled ki-phone" aria-hidden="true"></i> Llamar
                            </a>
                        <?php endif; ?>
                        <?php if ($correo !== null): ?>
                            <a class="cp-profile-action" href="mailto:<?= e($correo) ?>">
                                <i class="ki-filled ki-sms" aria-hidden="true"></i> Correo
                            </a>
                        <?php endif; ?>
                        <?php if ($sitioWeb !== null): ?>
                            <a class="cp-profile-action" href="<?= e($sitioWeb) ?>" target="_blank" rel="noopener noreferrer">
                                <i class="ki-filled ki-global" aria-hidden="true"></i> Sitio web
                            </a>
                        <?php endif; ?>
                    </div>
                    <?php if ($redes !== []): ?>
                        <div class="cp-profile-social" aria-label="Redes sociales de <?= e($nombre) ?>">
                            <?php foreach ($redes as $red): $url = cpFichaUrlExterna($red['url']); if ($url === null) continue; ?>
                                <a href="<?= e($url) ?>" target="_blank" rel="noopener noreferrer" aria-label="<?= e(ucfirst(strtolower((string) $red['tipo']))) ?> de <?= e($nombre) ?>">
                                    <i class="ki-filled <?= e(cpFichaIconoRed((string) $red['tipo'])) ?>" aria-hidden="true"></i>
                                </a>
                            <?php endforeach; ?>
                        </div>
                    <?php endif; ?>
                    <?php if ($telefonoPrincipal === null && $correo === null && $sitioWeb === null && $redes === []): ?>
                        <p class="cp-profile-empty cp-profile-empty--compact"><i class="ki-filled ki-information-2" aria-hidden="true"></i> Esta empresa aún no publicó canales de contacto.</p>
                    <?php endif; ?>
                </aside>
            </div>

            <nav class="cp-profile-section-nav cp-profile-reveal" style="--cp-reveal-index: 2" aria-label="Explorar ficha de <?= e($nombre) ?>">
                <a href="#cpFichaUbicaciones"><i class="ki-filled ki-geolocation" aria-hidden="true"></i> Ubicaciones</a>
                <a href="#cpFichaPromociones"><i class="ki-filled ki-discount" aria-hidden="true"></i> Promociones</a>
                <?php if ($galeria !== []): ?><a href="#cpFichaGaleria"><i class="ki-filled ki-picture" aria-hidden="true"></i> Galería</a><?php endif; ?>
                <?php if ($relacionadas !== []): ?><a href="#cpFichaRelacionadas"><i class="ki-filled ki-people" aria-hidden="true"></i> Empresas relacionadas</a><?php endif; ?>
            </nav>
        </div>
    </section>

    <main class="cp-profile-main cp-profile-container">
        <?php if ($galeria !== []): ?>
            <section class="cp-profile-section cp-profile-reveal" style="--cp-reveal-index: 2" aria-labelledby="cpFichaGaleria">
                <div class="cp-profile-section__heading"><h2 id="cpFichaGaleria">Conoce el negocio</h2><span><?= count($galeria) ?> <?= count($galeria) === 1 ? 'imagen' : 'imágenes' ?></span></div>
                <div class="cp-profile-gallery">
                    <?php foreach ($galeria as $imagen): ?>
                        <figure>
                            <img src="<?= e($imagen['url_publica']) ?>"
                                 alt="<?= e($imagen['texto_alternativo'] ?: 'Imagen de ' . $nombre) ?>"
                                 loading="lazy" decoding="async"
                                 width="<?= (int) ($imagen['ancho_px'] ?? 960) ?>"
                                 height="<?= (int) ($imagen['alto_px'] ?? 640) ?>" />
                        </figure>
                    <?php endforeach; ?>
                </div>
            </section>
        <?php endif; ?>

        <div class="cp-profile-columns">
            <section class="cp-profile-section cp-profile-section--locations cp-profile-reveal" style="--cp-reveal-index: 3" aria-labelledby="cpFichaUbicaciones" data-google-maps-key="<?= e($datosVista['google_maps_key'] ?? '') ?>">
                <div class="cp-profile-section__heading"><h2 id="cpFichaUbicaciones">Ubicación y sucursales</h2><span><?= count($sucursales) ?> <?= count($sucursales) === 1 ? 'ubicación' : 'ubicaciones' ?></span></div>
                <?php if ($sucursales === []): ?>
                    <p class="cp-profile-empty"><i class="ki-filled ki-geolocation" aria-hidden="true"></i> Esta empresa aún no cuenta con una ubicación pública.</p>
                <?php else: ?>
                    <div class="cp-profile-location-list">
                        <?php foreach ($sucursales as $sucursal): $direccion = cpFichaDireccion($sucursal); $mapa = cpFichaMapaUrl($sucursal); ?>
                            <article class="cp-profile-location">
                                <div>
                                    <h3><?= e($sucursal['nombre'] ?: ($sucursal['es_matriz'] ? 'Sucursal matriz' : 'Sucursal')) ?></h3>
                                    <?php if ($sucursal['es_matriz']): ?><span>Matriz</span><?php endif; ?>
                                    <?php if ($direccion !== ''): ?><p><?= e($direccion) ?></p><?php endif; ?>
                                    <?php if (!empty($sucursal['referencias'])): ?><p class="cp-profile-location__reference"><?= e($sucursal['referencias']) ?></p><?php endif; ?>
                                    <?php foreach ($sucursal['telefonos'] as $telefono): $numero = cpFichaTelefono($telefono['numero_normalizado'] ?: $telefono['numero_original']); if ($numero === '') continue; ?>
                                        <a href="<?= strtoupper((string) $telefono['tipo']) === 'WHATSAPP' ? 'https://wa.me/' . e(ltrim($numero, '+')) : 'tel:' . e($numero) ?>"<?= strtoupper((string) $telefono['tipo']) === 'WHATSAPP' ? ' target="_blank" rel="noopener noreferrer"' : '' ?>>
                                            <i class="ki-filled <?= strtoupper((string) $telefono['tipo']) === 'WHATSAPP' ? 'ki-whatsapp' : 'ki-phone' ?>" aria-hidden="true"></i>
                                            <?= e($telefono['etiqueta'] ?: $telefono['numero_original']) ?>
                                        </a>
                                    <?php endforeach; ?>
                                </div>
                                <?php if ($mapa !== null): ?>
                                    <div class="cp-profile-map-panel">
                                        <?php if ($sucursal['latitud'] !== null && $sucursal['longitud'] !== null): ?>
                                            <div class="cp-profile-map" data-google-map data-lat="<?= e((string) $sucursal['latitud']) ?>" data-lng="<?= e((string) $sucursal['longitud']) ?>" data-title="<?= e($sucursal['nombre'] ?: ($sucursal['es_matriz'] ? 'Sucursal matriz' : 'Sucursal')) ?>" aria-label="Mapa de <?= e($sucursal['nombre'] ?: $afiliado['nombre_comercial']) ?>"></div>
                                        <?php elseif ($direccion !== ''): ?>
                                            <iframe class="cp-profile-map" title="Mapa de <?= e($sucursal['nombre'] ?: $afiliado['nombre_comercial']) ?>" src="https://www.google.com/maps?q=<?= rawurlencode($direccion) ?>&amp;output=embed" loading="lazy" referrerpolicy="no-referrer-when-downgrade" allowfullscreen></iframe>
                                        <?php endif; ?>
                                        <a class="cp-profile-map-link" href="<?= e($mapa) ?>" target="_blank" rel="noopener noreferrer"><i class="ki-filled ki-geolocation" aria-hidden="true"></i> Abrir en Google Maps</a>
                                    </div>
                                <?php endif; ?>
                            </article>
                        <?php endforeach; ?>
                    </div>
                <?php endif; ?>
            </section>

            <section class="cp-profile-section cp-profile-section--promotions cp-profile-reveal" style="--cp-reveal-index: 4" aria-labelledby="cpFichaPromociones">
                <div class="cp-profile-section__heading"><h2 id="cpFichaPromociones">Promociones vigentes</h2><span><?= count($promociones) ?> <?= count($promociones) === 1 ? 'beneficio activo' : 'beneficios activos' ?></span></div>
                <?php if ($promociones === []): ?>
                    <p class="cp-profile-empty"><i class="ki-filled ki-discount" aria-hidden="true"></i> Por ahora no hay promociones vigentes.</p>
                <?php else: ?>
                    <div class="cp-profile-promotion-list">
                        <?php foreach ($promociones as $promocion): ?>
                            <a class="cp-profile-promotion<?= empty($promocion['imagen_url']) ? ' cp-profile-promotion--no-image' : '' ?>" href="<?= base_url('promocion/' . $promocion['idPromocion']) ?>" data-promotion-link data-promotion-id="<?= (int) $promocion['idPromocion'] ?>" aria-label="Ver promoción <?= e($promocion['titulo']) ?>">
                                <?php if (!empty($promocion['imagen_url'])): ?>
                                    <img src="<?= e($promocion['imagen_url']) ?>" alt="<?= e($promocion['texto_alternativo'] ?: 'Promoción: ' . $promocion['titulo']) ?>" loading="lazy" decoding="async" />
                                <?php endif; ?>
                                <div>
                                    <p class="cp-profile-promotion__validity"><i class="ki-filled ki-calendar" aria-hidden="true"></i> Vigente hasta <?= e(date('d/m/Y', strtotime($promocion['fin_vigencia']))) ?></p>
                                    <h3><?= e($promocion['titulo']) ?></h3>
                                    <p><?= e($promocion['descripcion']) ?></p>
                                    <?php if (!empty($promocion['restricciones'])): ?><small>Condiciones: <?= e($promocion['restricciones']) ?></small><?php endif; ?>
                                </div>
                            </a>
                        <?php endforeach; ?>
                    </div>
                <?php endif; ?>
            </section>
        </div>

        <?php if ($relacionadas !== []): ?>
            <section class="cp-profile-section cp-profile-reveal" style="--cp-reveal-index: 5" aria-labelledby="cpFichaRelacionadas">
                <div class="cp-profile-section__heading"><h2 id="cpFichaRelacionadas">También te puede interesar</h2><span><?= count($relacionadas) ?> empresas</span></div>
                <div class="cp-profile-related-grid">
                    <?php foreach ($relacionadas as $relacionada): ?>
                        <a class="cp-profile-related" href="<?= base_url('empresa/' . $relacionada['slug']) ?>" data-affiliate-link data-affiliate-slug="<?= e($relacionada['slug']) ?>">
                            <span class="cp-profile-related__logo" aria-hidden="true">
                                <?php if (!empty($relacionada['logo_url'])): ?><img src="<?= e($relacionada['logo_url']) ?>" alt="" loading="lazy" decoding="async" /><?php else: ?><?= e(cpFichaIniciales($relacionada['nombre_comercial'])) ?><?php endif; ?>
                            </span>
                            <span><strong><?= e($relacionada['nombre_comercial']) ?></strong><small><?= e($relacionada['categoria_principal'] ?: 'Empresa afiliada') ?></small></span>
                            <i class="ki-filled ki-arrow-up-right" aria-hidden="true"></i>
                        </a>
                    <?php endforeach; ?>
                </div>
            </section>
        <?php endif; ?>
    </main>
</div>
