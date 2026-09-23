<?php
$error = $datosVista['error'] ?? null;
if ($error !== null): ?>
<section class="inicio-dashboard inicio-error" aria-labelledby="inicioTitulo">
    <h1 id="inicioTitulo" data-panel-motion="title">Inicio</h1>
    <div class="inicio-panel" data-panel-motion="results"><h2>No pudimos cargar el resumen</h2><p role="alert"><?= e($error) ?></p><a class="inicio-button" href="<?= e(base_url('inicio')) ?>">Volver a intentar <i class="ki-filled ki-arrows-circle" aria-hidden="true"></i></a></div>
</section>
<?php return; endif;
$empresa = $datosVista['empresa'];
$r = $datosVista['resumen'];
$perfil = $datosVista['perfil'];
$serie = $datosVista['serie'];
$contactos = (int)$r['telefono'] + (int)$r['whatsapp'] + (int)$r['web'] + (int)$r['redes'];
$numero = static fn($n) => number_format((int)$n, 0, ',', '.');
$numeroEje = static fn($n) => $n >= 1000000 ? round($n / 1000000, 1) . ' M' : ($n >= 1000 ? round($n / 1000, 1) . ' k' : (string)$n);
$fechaCorta = static fn($fecha) => date('d/m', strtotime($fecha));
$canales = [
    ['Teléfono', 'telefono', 'ki-phone', 'phone'],
    ['WhatsApp', 'whatsapp', 'ki-whatsapp', 'whatsapp'],
    ['Sitio web', 'web', 'ki-chrome', 'web'],
    ['Redes sociales', 'redes', 'ki-share', 'social'],
];
$maxCanal = max(1, ...array_map(static fn($c) => (int)$r[$c[1]], $canales));
$maxSerie = max([1, ...array_map(static fn($d) => max((int)$d['apariciones'], (int)$d['visitas'], (int)$d['contactos']), array_values($serie))]);
$pasoY = max(1, (int)ceil($maxSerie / 4));
$techoY = $pasoY * 4;
$dias = array_keys($serie);
$valores = array_values($serie);
$cantidadDias = count($dias);
$xDia = static fn($i) => 48 + ($i / max(1, $cantidadDias - 1)) * 700;
$yValor = static fn($n) => 226 - ((int)$n / $techoY) * 196;
$puntos = static function (string $campo) use ($valores, $xDia, $yValor): string {
    $lista = [];
    foreach ($valores as $i => $dia) $lista[] = round($xDia($i), 2) . ',' . round($yValor($dia[$campo]), 2);
    return implode(' ', $lista);
};
$seriesInfo = [['apariciones', 'Apariciones', (int)$r['apariciones']], ['visitas', 'Visitas a la ficha', (int)$r['visitas']], ['contactos', 'Clics de contacto', $contactos]];
$actividadTotal = array_sum(array_map(static fn($d) => array_sum($d), $valores));
$maxBusqueda = max([1, ...array_column($datosVista['busquedas'], 'apariciones')]);
$nombre = explode(' ', trim((string)(obtenerUsuarioSesion()['nombre'] ?? '')))[0] ?: 'afiliado';
?>
<section class="inicio-dashboard" aria-labelledby="inicioTitulo" data-inicio-dashboard>
    <header class="inicio-heading" data-panel-motion="title">
        <div><h1 id="inicioTitulo">Tu negocio, en perspectiva.</h1><p>Hola, <?= e($nombre) ?>. Descubre cómo encuentran y contactan a tu empresa.</p></div>
        <div class="inicio-period"><i class="ki-filled ki-calendar" aria-hidden="true"></i><div><strong>Últimos 30 días</strong><span><time datetime="<?= e($datosVista['periodo']['desde']) ?>"><?= e(date('d/m/Y', strtotime($datosVista['periodo']['desde']))) ?></time> — <time datetime="<?= e($datosVista['periodo']['hasta']) ?>"><?= e(date('d/m/Y', strtotime($datosVista['periodo']['hasta']))) ?></time></span></div></div>
    </header>
    <div class="inicio-business-bar" data-panel-motion="tools">
        <div class="inicio-business-name"><span class="inicio-business-mark" aria-hidden="true"><?= e(mb_strtoupper(mb_substr(trim($empresa['nombre_comercial']), 0, 1))) ?></span><div><strong><?= e($empresa['nombre_comercial']) ?></strong><span><?= e($empresa['camara']) ?></span></div></div>
        <div class="inicio-business-actions">
            <?php if (count($datosVista['empresas']) > 1): ?>
            <form method="get" action="<?= e(base_url('inicio')) ?>" class="inicio-selector">
                <label class="inicio-sr-only" for="inicioSelector">Empresa</label>
                <select id="inicioSelector" name="afiliado"><?php foreach ($datosVista['empresas'] as $opcion): ?><option value="<?= (int)$opcion['idAfiliado'] ?>" <?= (int)$opcion['idAfiliado'] === (int)$empresa['idAfiliado'] ? 'selected' : '' ?>><?= e($opcion['nombre_comercial']) ?></option><?php endforeach; ?></select>
                <button class="inicio-button inicio-button-quiet" type="submit">Ver</button>
            </form>
            <?php endif; ?>
            <?php if ((int)$empresa['activo'] === 1): ?><a class="inicio-button" href="<?= e(base_url('empresa/' . $empresa['slug'])) ?>" target="_blank" rel="noopener noreferrer">Ver ficha pública <i class="ki-filled ki-arrow-up-right" aria-hidden="true"></i><span class="inicio-sr-only"> (abre en otra pestaña)</span></a><?php endif; ?>
        </div>
    </div>
    <div class="inicio-analytics">
        <section class="inicio-panel inicio-trend" aria-labelledby="inicioTendencia" data-panel-motion="stat">
            <div class="inicio-panel-heading"><div><h2 id="inicioTendencia">Actividad de tu negocio</h2><p>Del descubrimiento al contacto, día a día.</p></div><span class="inicio-unit">Eventos / día</span></div>
            <dl class="inicio-totals"><?php foreach ($seriesInfo as [$clave, $etiqueta, $total]): ?><div class="inicio-total inicio-series-<?= e($clave) ?>"><dt><span class="inicio-line-key" aria-hidden="true"></span><?= e($etiqueta) ?></dt><dd><?= $numero($total) ?></dd></div><?php endforeach; ?></dl>
            <div class="inicio-chart-tools" hidden data-chart-tools><span>Mostrar</span><?php foreach ($seriesInfo as [$clave, $etiqueta]): ?><button type="button" class="inicio-series-toggle inicio-series-<?= e($clave) ?>" data-series-toggle="<?= e($clave) ?>" aria-pressed="true"><span class="inicio-line-key" aria-hidden="true"></span><?= e($clave === 'visitas' ? 'Visitas' : ($clave === 'contactos' ? 'Contactos' : $etiqueta)) ?></button><?php endforeach; ?></div>
            <figure class="inicio-chart-figure">
                <div class="inicio-chart-plot">
                <div class="inicio-y-axis" aria-hidden="true"><?php for ($j = 0; $j <= 4; $j++): ?><span><?= e($numeroEje($j * $pasoY)) ?></span><?php endfor; ?></div>
                <svg class="inicio-line-chart" viewBox="48 30 700 196" preserveAspectRatio="none" role="img" aria-labelledby="inicioChartTitle inicioChartDesc">
                    <title id="inicioChartTitle">Actividad diaria durante los últimos 30 días</title>
                    <desc id="inicioChartDesc">Apariciones en búsquedas, visitas a la ficha y clics de contacto. Las cifras exactas están disponibles en la tabla de datos diarios.</desc>
                    <?php for ($j = 0; $j <= 4; $j++): $y = $yValor($j * $pasoY); ?>
                    <line class="inicio-gridline" x1="48" y1="<?= $y ?>" x2="748" y2="<?= $y ?>"/>
                    <?php endfor; ?>
                    <?php foreach ($seriesInfo as [$clave]): ?><polyline class="inicio-data-line inicio-series-<?= e($clave) ?>" data-chart-series="<?= e($clave) ?>" points="<?= e($puntos($clave)) ?>"/><?php endforeach; ?>
                    <g class="inicio-chart-cursor" data-chart-cursor hidden><line x1="748" y1="30" x2="748" y2="226"/><circle class="inicio-series-apariciones" r="4"/><circle class="inicio-series-visitas" r="4"/><circle class="inicio-series-contactos" r="4"/></g>
                </svg>
                </div>
                <div class="inicio-x-axis" aria-hidden="true"><?php foreach (array_unique([0, (int)floor(($cantidadDias - 1) / 3), (int)floor(2 * ($cantidadDias - 1) / 3), max(0, $cantidadDias - 1)]) as $i): if (!isset($dias[$i])) continue; ?><span><?= e($fechaCorta($dias[$i])) ?></span><?php endforeach; ?></div>
                <?php if ($actividadTotal === 0): ?><figcaption class="inicio-empty-chart"><strong>Tu próxima visita empieza esta historia.</strong><span>Cuando las personas encuentren tu empresa o hagan clic en sus canales, verás aquí su actividad.</span></figcaption><?php endif; ?>
            </figure>
            <?php if ($cantidadDias > 0): ?><div class="inicio-chart-inspector" hidden data-chart-inspector><label for="inicioDia">Explorar un día <output id="inicioDiaFecha" for="inicioDia"><?= e($fechaCorta(end($dias))) ?></output></label><input type="range" id="inicioDia" min="0" max="<?= $cantidadDias - 1 ?>" value="<?= $cantidadDias - 1 ?>" step="1" aria-describedby="inicioDiaValores"><p id="inicioDiaValores" aria-live="polite" aria-atomic="true"></p></div><?php endif; ?>
            <details class="inicio-data-table"><summary>Ver datos diarios <i class="ki-filled ki-down" aria-hidden="true"></i></summary><div class="inicio-table-scroll"><table><caption>Eventos registrados por día</caption><thead><tr><th scope="col">Fecha</th><th scope="col">Apariciones</th><th scope="col">Visitas</th><th scope="col">Contactos</th></tr></thead><tbody><?php foreach ($serie as $fecha => $dia): ?><tr><th scope="row"><?= e(date('d/m/Y', strtotime($fecha))) ?></th><td><?= $numero($dia['apariciones']) ?></td><td><?= $numero($dia['visitas']) ?></td><td><?= $numero($dia['contactos']) ?></td></tr><?php endforeach; ?></tbody></table></div></details>
        </section>
        <section class="inicio-panel inicio-channels" aria-labelledby="inicioCanales" data-panel-motion="stat">
            <div class="inicio-panel-heading"><div><h2 id="inicioCanales">Cómo te contactan</h2><p>Clics hacia tus canales publicados.</p></div></div>
            <p class="inicio-contact-total"><strong><?= $numero($contactos) ?></strong><span>clics de contacto<br>durante el mes</span></p>
            <dl class="inicio-channel-list"><?php foreach ($canales as [$etiqueta, $campo, $icono, $clase]): ?><div class="inicio-channel inicio-channel-<?= e($clase) ?>"><dt><i class="ki-filled <?= e($icono) ?>" aria-hidden="true"></i><?= e($etiqueta) ?></dt><dd><?= $numero($r[$campo]) ?></dd><div class="inicio-bar-track" aria-hidden="true"><span style="width:<?= round((int)$r[$campo] / $maxCanal * 100, 2) ?>%"></span></div></div><?php endforeach; ?></dl>
            <?php if ($contactos === 0): ?><p class="inicio-empty-note">Todavía no se registran clics. Mantén tus canales de contacto actualizados.</p><?php else: ?><p class="inicio-chart-note">La longitud de cada barra compara los clics entre canales.</p><?php endif; ?>
            <dl class="inicio-other-actions"><div><dt><i class="ki-filled ki-geolocation" aria-hidden="true"></i>Clics en el mapa</dt><dd><?= $numero($r['mapa']) ?></dd></div><div><dt><i class="ki-filled ki-discount" aria-hidden="true"></i>Visitas a promociones</dt><dd><?= $numero($r['promociones']) ?></dd></div></dl>
        </section>
    </div>
    <div class="inicio-detail-grid">
        <section class="inicio-panel" aria-labelledby="inicioBusquedas" data-panel-motion="stat">
            <div class="inicio-panel-heading"><div><h2 id="inicioBusquedas">Así te encuentran</h2><p>Búsquedas que mostraron tu empresa.</p></div><i class="ki-filled ki-magnifier inicio-section-icon" aria-hidden="true"></i></div>
            <?php if ($datosVista['busquedas']): ?><div class="inicio-list-heading"><span>Término de búsqueda</span><span>Apariciones</span></div><ol class="inicio-search-list"><?php foreach ($datosVista['busquedas'] as $fila): ?><li><div><span><?= e($fila['termino']) ?></span><strong><?= $numero($fila['apariciones']) ?></strong></div><div class="inicio-bar-track" aria-hidden="true"><span style="width:<?= round((int)$fila['apariciones'] / $maxBusqueda * 100, 2) ?>%"></span></div></li><?php endforeach; ?></ol>
            <?php else: ?><div class="inicio-empty"><strong>Aún no hay búsquedas registradas.</strong><p>Las palabras que ayuden a descubrir tu negocio aparecerán aquí.</p><a class="inicio-text-link" href="<?= e(base_url('afiliados')) ?>">Revisar mi empresa <i class="ki-filled ki-arrow-right" aria-hidden="true"></i></a></div><?php endif; ?>
        </section>
        <section class="inicio-panel" aria-labelledby="inicioPromos" data-panel-motion="stat">
            <div class="inicio-panel-heading"><div><h2 id="inicioPromos">Promociones vigentes</h2><p>Tus ofertas disponibles hoy.</p></div><a class="inicio-text-link" href="<?= e(base_url('promociones')) ?>">Administrar <i class="ki-filled ki-arrow-right" aria-hidden="true"></i></a></div>
            <?php if ($datosVista['promociones']): ?><ul class="inicio-promo-list"><?php foreach ($datosVista['promociones'] as $promo): ?><li><div><strong><?= e($promo['titulo']) ?></strong><span>Hasta el <?= e(date('d/m/Y', strtotime($promo['fin_vigencia']))) ?></span></div><span class="inicio-promo-visits"><strong><?= $numero($promo['visitas']) ?></strong> visitas en el mes</span></li><?php endforeach; ?></ul>
            <?php else: ?><div class="inicio-empty"><strong>Tu próxima oferta puede destacar aquí.</strong><p>No tienes promociones vigentes. Publica una oferta para dar más motivos para visitar tu negocio.</p><a class="inicio-text-link" href="<?= e(base_url('promociones')) ?>">Ir a promociones <i class="ki-filled ki-arrow-right" aria-hidden="true"></i></a></div><?php endif; ?>
        </section>
    </div>
    <section class="inicio-company" aria-labelledby="inicioEmpresa" data-panel-motion="results">
        <div class="inicio-company-copy"><h2 id="inicioEmpresa">Tu empresa en CANACO Card</h2><strong><?= e($empresa['nombre_comercial']) ?></strong><p><?= e(mb_strimwidth((string)$empresa['descripcion'], 0, 220, '…')) ?></p><a class="inicio-text-link" href="<?= e(base_url('afiliados')) ?>">Editar mi empresa <i class="ki-filled ki-arrow-right" aria-hidden="true"></i></a></div>
        <dl class="inicio-company-facts"><div><dt>Sucursales activas</dt><dd><?= $numero($perfil['sucursales'] ?? 0) ?></dd></div><div><dt>Canales publicados</dt><dd><?= $numero($perfil['canales'] ?? 0) ?></dd></div><div><dt>Promociones vigentes</dt><dd><?= $numero($perfil['promociones'] ?? 0) ?></dd></div></dl>
    </section>
    <p class="inicio-footnote"><i class="ki-filled ki-information-2" aria-hidden="true"></i>Las cifras cuentan actividad registrada en el portal. Un clic no confirma una llamada, conversación o venta.</p>
    <script type="application/json" id="inicioChartData"><?= json_encode(['dias' => $dias, 'valores' => $valores, 'techo' => $techoY], JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT | JSON_THROW_ON_ERROR) ?></script>
</section>
