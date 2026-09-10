<?php
/** @var array<string,mixed>|null $promocion */
$promocion = $datosVista['promocion'] ?? null;

function cpPromocionFecha(string $fecha): string
{
    $meses = [1 => 'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
    $marca = strtotime($fecha);
    if ($marca === false) {
        return '';
    }

    return date('j', $marca) . ' de ' . $meses[(int) date('n', $marca)] . ' de ' . date('Y', $marca);
}

function cpPromocionUrl(?string $url): ?string
{
    $url = trim((string) $url);
    if ($url === '') {
        return null;
    }
    if (!preg_match('#^https?://#i', $url)) {
        $url = 'https://' . ltrim($url, '/');
    }

    return filter_var($url, FILTER_VALIDATE_URL) ? $url : null;
}

function cpPromocionTelefono(array $telefono): string
{
    return trim((string) ($telefono['numero_normalizado'] ?: $telefono['numero_original']));
}

function cpPromocionIniciales(string $nombre): string
{
    $partes = preg_split('/\s+/u', trim($nombre), -1, PREG_SPLIT_NO_EMPTY) ?: [];
    $iniciales = '';
    foreach (array_slice($partes, 0, 2) as $parte) {
        $iniciales .= mb_strtoupper(mb_substr($parte, 0, 1));
    }

    return $iniciales !== '' ? $iniciales : 'CC';
}

if ($promocion === null):
?>
<section class="cp-promotion-not-found" aria-labelledby="cpPromocionNoEncontrada">
    <div class="cp-promotion-not-found__inner">
        <span class="cp-promotion-not-found__icon" aria-hidden="true"><i class="ki-filled ki-discount"></i></span>
        <p>Promociones CANACO Card</p>
        <h1 id="cpPromocionNoEncontrada">Esta promoción ya no está disponible</h1>
        <p>Es posible que haya terminado, se encuentre inactiva o que la dirección compartida sea incorrecta.</p>
        <a class="cp-promotion-button cp-promotion-button--primary" href="<?= base_url('portada#promociones') ?>">
            <i class="ki-filled ki-arrow-left" aria-hidden="true"></i> Ver promociones vigentes
        </a>
    </div>
</section>
<?php return; endif;

$idPromocion = (int) $promocion['idPromocion'];
$titulo = (string) $promocion['titulo'];
$empresa = (string) $promocion['nombre_comercial'];
$imagenes = $promocion['imagenes'] ?? [];
$imagenPrincipal = $imagenes[0] ?? null;
$otrasImagenes = array_slice($imagenes, 1);
$telefonos = $promocion['telefonos'] ?? [];
$whatsApp = null;
$telefono = null;
foreach ($telefonos as $canalTelefonico) {
    $tipo = strtoupper((string) $canalTelefonico['tipo']);
    if ($tipo === 'WHATSAPP' && $whatsApp === null) {
        $whatsApp = $canalTelefonico;
    }
    if ($tipo === 'TELEFONO' && $telefono === null) {
        $telefono = $canalTelefonico;
    }
}

$sitioWeb = null;
foreach (($promocion['canales'] ?? []) as $canal) {
    if ($canal['tipo'] === 'SITIO_WEB') {
        $sitioWeb = cpPromocionUrl($canal['url']);
        break;
    }
}

$fin = strtotime((string) $promocion['fin_vigencia']);
$diasRestantes = $fin === false ? 0 : max(0, (int) ceil(($fin - time()) / 86400));
$accionHref = base_url('empresa/' . $promocion['afiliado_slug']);
$accionTexto = 'Conocer la empresa';
$accionIcono = 'ki-arrow-up-right';
$accionExterna = false;
if ($whatsApp !== null) {
    $accionHref = 'https://wa.me/' . ltrim(cpPromocionTelefono($whatsApp), '+');
    $accionTexto = 'Consultar por WhatsApp';
    $accionIcono = 'ki-whatsapp';
    $accionExterna = true;
} elseif ($telefono !== null) {
    $accionHref = 'tel:' . cpPromocionTelefono($telefono);
    $accionTexto = 'Llamar al negocio';
    $accionIcono = 'ki-phone';
} elseif (!empty($promocion['correo_general'])) {
    $accionHref = 'mailto:' . $promocion['correo_general'];
    $accionTexto = 'Consultar por correo';
    $accionIcono = 'ki-sms';
}
?>

<div class="cp-promotion-page" data-promotion-page>
    <section class="cp-promotion-hero" aria-labelledby="cpPromocionTitulo">
        <div class="cp-profile-container">
            <a class="cp-promotion-back" href="<?= base_url('portada#promociones') ?>" data-promotion-back>
                <i class="ki-filled ki-arrow-left" aria-hidden="true"></i>
                Volver a promociones
            </a>

            <div class="cp-promotion-hero__grid">
                <figure class="cp-promotion-visual cp-promotion-reveal" style="--cp-promotion-delay: 0ms; view-transition-name: cp-promocion-<?= $idPromocion ?>">
                    <?php if ($imagenPrincipal !== null): ?>
                        <img src="<?= e($imagenPrincipal['url_publica']) ?>"
                             alt="<?= e($imagenPrincipal['texto_alternativo'] ?: 'Promoción ' . $titulo . ' de ' . $empresa) ?>"
                             width="<?= (int) ($imagenPrincipal['ancho_px'] ?? 1200) ?>"
                             height="<?= (int) ($imagenPrincipal['alto_px'] ?? 800) ?>"
                             fetchpriority="high"
                             decoding="async" />
                    <?php else: ?>
                        <div class="cp-promotion-visual__empty" aria-label="Promoción sin imagen publicada">
                            <i class="ki-filled ki-discount" aria-hidden="true"></i>
                            <span>Beneficio CANACO Card</span>
                        </div>
                    <?php endif; ?>
                    <span class="cp-promotion-visual__seal"><i class="ki-filled ki-verify" aria-hidden="true"></i> Vigente</span>
                </figure>

                <div class="cp-promotion-intro cp-promotion-reveal" style="--cp-promotion-delay: 40ms">
                    <a class="cp-promotion-company-link" href="<?= e(base_url('empresa/' . rawurlencode((string) $promocion['afiliado_slug']))) ?>" data-affiliate-link data-affiliate-slug="<?= e($promocion['afiliado_slug']) ?>">
                        <?php if (!empty($promocion['logo_url'])): ?>
                            <img src="<?= e($promocion['logo_url']) ?>" alt="" width="44" height="44" decoding="async" />
                        <?php else: ?>
                            <span aria-hidden="true"><?= e(cpPromocionIniciales($empresa)) ?></span>
                        <?php endif; ?>
                        <span><small>Promoción de</small><strong><?= e($empresa) ?></strong></span>
                        <i class="ki-filled ki-arrow-up-right" aria-hidden="true"></i>
                    </a>

                    <h1 id="cpPromocionTitulo"><?= e($titulo) ?></h1>
                    <?php if (trim((string) ($promocion['descripcion'] ?? '')) !== ''): ?>
                        <p class="cp-promotion-summary"><?= nl2br(e($promocion['descripcion'])) ?></p>
                    <?php endif; ?>

                    <div class="cp-promotion-deadline" aria-label="Vigencia de la promoción">
                        <i class="ki-filled ki-calendar" aria-hidden="true"></i>
                        <span><small>Disponible hasta</small><strong><?= e(cpPromocionFecha((string) $promocion['fin_vigencia'])) ?></strong></span>
                        <b><?= $diasRestantes === 0 ? 'Último día' : $diasRestantes . ' ' . ($diasRestantes === 1 ? 'día restante' : 'días restantes') ?></b>
                    </div>

                    <a class="cp-promotion-button cp-promotion-button--primary" href="<?= e($accionHref) ?>"<?= $accionExterna ? ' target="_blank" rel="noopener noreferrer"' : '' ?>>
                        <i class="ki-filled <?= e($accionIcono) ?>" aria-hidden="true"></i> <?= e($accionTexto) ?>
                    </a>
                </div>
            </div>
        </div>
    </section>

    <div class="cp-promotion-main cp-profile-container">
        <section class="cp-promotion-overview cp-promotion-reveal" style="--cp-promotion-delay: 80ms" aria-labelledby="cpPromocionVigencia">
            <div class="cp-promotion-overview__heading">
                <div>
                    <h2 id="cpPromocionVigencia">Vigencia</h2>
                    <p>Fechas y entidad que respaldan este beneficio.</p>
                </div>
                <span class="cp-promotion-overview__status"><i class="ki-filled ki-verify" aria-hidden="true"></i><?= $diasRestantes === 0 ? 'Último día' : $diasRestantes . ' ' . ($diasRestantes === 1 ? 'día restante' : 'días restantes') ?></span>
            </div>

            <dl class="cp-promotion-validity">
                <div class="cp-promotion-validity__date">
                    <span class="cp-promotion-validity__icon" aria-hidden="true"><i class="ki-filled ki-calendar-add"></i></span>
                    <dt>Inicia</dt><dd><time datetime="<?= e((string) $promocion['inicio_vigencia']) ?>"><?= e(cpPromocionFecha((string) $promocion['inicio_vigencia'])) ?></time></dd>
                </div>
                <div class="cp-promotion-validity__date">
                    <span class="cp-promotion-validity__icon" aria-hidden="true"><i class="ki-filled ki-calendar-tick"></i></span>
                    <dt>Termina</dt><dd><time datetime="<?= e((string) $promocion['fin_vigencia']) ?>"><?= e(cpPromocionFecha((string) $promocion['fin_vigencia'])) ?></time></dd>
                </div>
                <div class="cp-promotion-validity-camera">
                    <span class="cp-promotion-validity__icon" aria-hidden="true"><i class="ki-filled ki-bank"></i></span>
                    <dt>Cámara afiliada</dt><dd><?= e($promocion['camara_nombre']) ?></dd>
                </div>
            </dl>

            <?php if (trim((string) ($promocion['restricciones'] ?? '')) !== ''): ?>
                <div class="cp-promotion-terms" aria-labelledby="cpPromocionCondiciones">
                    <span class="cp-promotion-terms__icon" aria-hidden="true"><i class="ki-filled ki-information-2"></i></span>
                    <div>
                        <h2 id="cpPromocionCondiciones">Condiciones y restricciones</h2>
                        <p><?= nl2br(e($promocion['restricciones'])) ?></p>
                    </div>
                </div>
            <?php endif; ?>
        </section>

        <?php if ($otrasImagenes !== []): ?>
            <section class="cp-promotion-gallery cp-promotion-reveal" style="--cp-promotion-delay: 160ms" aria-labelledby="cpPromocionGaleria">
                <div class="cp-profile-section__heading"><h2 id="cpPromocionGaleria">Más imágenes</h2><span><?= count($otrasImagenes) ?> <?= count($otrasImagenes) === 1 ? 'imagen' : 'imágenes' ?></span></div>
                <div class="cp-promotion-gallery__grid">
                    <?php foreach ($otrasImagenes as $imagen): ?>
                        <figure><img src="<?= e($imagen['url_publica']) ?>" alt="<?= e($imagen['texto_alternativo'] ?: 'Detalle de la promoción ' . $titulo) ?>" loading="lazy" decoding="async" width="<?= (int) ($imagen['ancho_px'] ?? 900) ?>" height="<?= (int) ($imagen['alto_px'] ?? 600) ?>" /></figure>
                    <?php endforeach; ?>
                </div>
            </section>
        <?php endif; ?>

        <section class="cp-promotion-business cp-promotion-reveal" style="--cp-promotion-delay: 200ms" aria-labelledby="cpPromocionEmpresa">
            <div class="cp-promotion-business__identity">
                <span class="cp-promotion-business__logo" aria-hidden="true">
                    <?php if (!empty($promocion['logo_url'])): ?><img src="<?= e($promocion['logo_url']) ?>" alt="" loading="lazy" decoding="async" /><?php else: ?><?= e(cpPromocionIniciales($empresa)) ?><?php endif; ?>
                </span>
                <div>
                    <h2 id="cpPromocionEmpresa"><?= e($empresa) ?></h2>
                    <p><?= e($promocion['categoria_principal'] ?: 'Empresa afiliada') ?> · <?= e($promocion['camara_nombre']) ?></p>
                </div>
            </div>
            <div class="cp-promotion-business__actions">
                <?php if ($sitioWeb !== null): ?><a href="<?= e($sitioWeb) ?>" target="_blank" rel="noopener noreferrer"><i class="ki-filled ki-global" aria-hidden="true"></i> Sitio web</a><?php endif; ?>
                <a class="cp-promotion-button" href="<?= e(base_url('empresa/' . rawurlencode((string) $promocion['afiliado_slug']))) ?>" data-affiliate-link data-affiliate-slug="<?= e($promocion['afiliado_slug']) ?>">Ver ficha de la empresa <i class="ki-filled ki-arrow-up-right" aria-hidden="true"></i></a>
            </div>
        </section>

        <?php if (($promocion['otras_promociones'] ?? []) !== []): ?>
            <section class="cp-promotion-more cp-promotion-reveal" style="--cp-promotion-delay: 240ms" aria-labelledby="cpPromocionMas">
                <?php $cantidadOtras = count($promocion['otras_promociones']); ?>
                <div class="cp-profile-section__heading"><h2 id="cpPromocionMas">Más beneficios de esta empresa</h2><span><?= $cantidadOtras ?> <?= $cantidadOtras === 1 ? 'promoción' : 'promociones' ?></span></div>
                <div class="cp-promotion-more__grid">
                    <?php foreach ($promocion['otras_promociones'] as $otra): ?>
                        <a class="cp-promotion-more__item<?= empty($otra['imagen_url']) ? ' cp-promotion-more__item--no-image' : '' ?>" href="<?= base_url('promocion/' . $otra['idPromocion']) ?>" data-promotion-link data-promotion-id="<?= (int) $otra['idPromocion'] ?>">
                            <?php if (!empty($otra['imagen_url'])): ?><img src="<?= e($otra['imagen_url']) ?>" alt="<?= e($otra['texto_alternativo'] ?: 'Promoción ' . $otra['titulo']) ?>" loading="lazy" decoding="async" /><?php endif; ?>
                            <span><small>Vigente hasta <?= e(date('d/m/Y', strtotime($otra['fin_vigencia']))) ?></small><strong><?= e($otra['titulo']) ?></strong></span>
                            <i class="ki-filled ki-arrow-up-right" aria-hidden="true"></i>
                        </a>
                    <?php endforeach; ?>
                </div>
            </section>
        <?php endif; ?>
    </div>
</div>
