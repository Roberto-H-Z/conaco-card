<?php
$error = $datosVista['error'] ?? null;
if ($error !== null): ?>
<div class="kt-card"><div class="kt-card-body p-6"><p role="alert"><?= e($error) ?></p></div></div>
<?php return; endif;
$empresa = $datosVista['empresa'];
$r = $datosVista['resumen'];
$perfil = $datosVista['perfil'];
$serie = $datosVista['serie'];
$contactos = $r['telefono']+$r['whatsapp']+$r['web']+$r['redes'];
$maximo = max(1, ...array_map(static fn($d) => max($d['apariciones'],$d['visitas'],$d['contactos']), array_values($serie)));
$metricas = [
    ['Apariciones en búsquedas','apariciones','ki-magnifier','primary','Veces que tu empresa salió en resultados'],
    ['Visitas a la ficha','visitas','ki-eye','info','Consultas a tu ficha pública'],
    ['Clics en teléfono','telefono','ki-phone','success','Clics para llamar desde el portal'],
    ['Clics en WhatsApp','whatsapp','ki-whatsapp','success','Clics para abrir WhatsApp'],
    ['Clics en sitio web','web','ki-global','info','Salidas hacia tu sitio'],
    ['Clics en redes sociales','redes','ki-share','primary','Facebook, Instagram y otras redes'],
];
?>
<section class="canaco-inicio" aria-labelledby="inicioTitulo">
    <div data-panel-motion="title" class="canaco-inicio-intro mb-6">
        <div>
            <h2 id="inicioTitulo" class="text-2xl font-semibold text-foreground">Hola, <?= e(explode(' ', trim((string)(obtenerUsuarioSesion()['nombre'] ?? '')))[0] ?: 'afiliado') ?></h2>
            <p class="mt-1 text-sm text-muted-foreground">Así encontraron y contactaron a <?= e($empresa['nombre_comercial']) ?> durante el último mes.</p>
        </div>
        <?php if (count($datosVista['empresas']) > 1): ?>
        <form method="get" action="<?= base_url('inicio') ?>" class="canaco-inicio-selector">
            <label class="text-sm font-medium text-foreground" for="inicioSelector">Empresa</label>
            <select class="kt-select" id="inicioSelector" name="afiliado" onchange="this.form.submit()">
                <?php foreach ($datosVista['empresas'] as $opcion): ?>
                <option value="<?= (int)$opcion['idAfiliado'] ?>" <?= (int)$opcion['idAfiliado']===(int)$empresa['idAfiliado']?'selected':'' ?>><?= e($opcion['nombre_comercial']) ?></option>
                <?php endforeach; ?>
            </select>
            <button class="kt-btn kt-btn-light kt-btn-sm" type="submit">Ver</button>
        </form>
        <?php endif; ?>
    </div>

    <div data-panel-motion="tools" class="kt-card mb-6">
        <div class="kt-card-body p-5 canaco-inicio-periodo">
            <div><strong class="text-foreground"><?= e($empresa['nombre_comercial']) ?></strong><span class="text-sm text-muted-foreground"> · <?= e($empresa['camara']) ?></span></div>
            <p class="text-sm text-muted-foreground">Últimos 30 días: <time datetime="<?= e($datosVista['periodo']['desde']) ?>"><?= e(date('d/m/Y',strtotime($datosVista['periodo']['desde']))) ?></time> al <time datetime="<?= e($datosVista['periodo']['hasta']) ?>"><?= e(date('d/m/Y',strtotime($datosVista['periodo']['hasta']))) ?></time></p>
        </div>
    </div>

    <div class="grid grid-cols-2 xl:grid-cols-3 gap-4 mb-6" aria-label="Estadísticas del mes">
        <?php foreach ($metricas as [$titulo,$campo,$icono,$color,$detalle]): ?>
        <article data-panel-motion="stat" class="kt-card canaco-stat-card">
            <div class="kt-card-body p-5">
                <span class="text-sm text-muted-foreground"><?= e($titulo) ?></span>
                <div class="flex items-end justify-between mt-2"><strong class="text-3xl text-foreground tabular-nums"><?= number_format((int)$r[$campo],0,',','.') ?></strong><span class="canaco-stat-icon bg-<?= $color ?>/10 text-<?= $color ?>"><i class="ki-filled <?= $icono ?>" aria-hidden="true"></i></span></div>
                <p class="text-xs text-muted-foreground mt-3"><?= e($detalle) ?></p>
            </div>
        </article>
        <?php endforeach; ?>
    </div>

    <div class="grid grid-cols-1 xl:grid-cols-3 gap-5 mb-6">
        <section data-panel-motion="results" class="kt-card xl:col-span-2" aria-labelledby="inicioTendencia">
            <div class="kt-card-header"><div><h3 id="inicioTendencia" class="kt-card-title">Actividad diaria</h3><p class="text-sm text-muted-foreground mt-1">Búsquedas, visitas y contactos a lo largo del mes</p></div></div>
            <div class="kt-card-body p-5">
                <div class="canaco-inicio-leyenda text-xs text-muted-foreground"><span><i class="canaco-inicio-dot is-search"></i>Apariciones</span><span><i class="canaco-inicio-dot is-visit"></i>Visitas</span><span><i class="canaco-inicio-dot is-contact"></i>Contactos</span></div>
                <div class="canaco-inicio-chart" role="img" aria-label="Tendencia diaria de apariciones, visitas y contactos durante 30 días">
                    <?php foreach ($serie as $fecha=>$dia): ?>
                    <div class="canaco-inicio-chart-day" title="<?= e(date('d/m',strtotime($fecha))) ?>: <?= (int)$dia['apariciones'] ?> apariciones, <?= (int)$dia['visitas'] ?> visitas, <?= (int)$dia['contactos'] ?> contactos">
                        <span class="is-search" style="height:<?= max(2,round($dia['apariciones']/$maximo*100)) ?>%"></span><span class="is-visit" style="height:<?= max(2,round($dia['visitas']/$maximo*100)) ?>%"></span><span class="is-contact" style="height:<?= max(2,round($dia['contactos']/$maximo*100)) ?>%"></span>
                    </div>
                    <?php endforeach; ?>
                </div>
                <div class="canaco-inicio-chart-axis text-xs text-muted-foreground"><span><?= e(date('d M',strtotime($datosVista['periodo']['desde']))) ?></span><span><?= e(date('d M',strtotime($datosVista['periodo']['hasta']))) ?></span></div>
                <?php if (array_sum(array_column($serie,'apariciones'))+$r['visitas']+$contactos === 0): ?><p class="text-sm text-muted-foreground mt-4">Todavía no hay actividad registrada en este periodo.</p><?php endif; ?>
            </div>
        </section>
        <section data-panel-motion="results" class="kt-card" aria-labelledby="inicioAcciones">
            <div class="kt-card-header"><h3 id="inicioAcciones" class="kt-card-title">Acciones de visitantes</h3></div>
            <div class="kt-card-body p-5">
                <p class="text-3xl font-semibold text-foreground tabular-nums"><?= number_format($contactos,0,',','.') ?></p><p class="text-sm text-muted-foreground">clics para contactar o conocer tu negocio</p>
                <dl class="canaco-inicio-list mt-5">
                    <div><dt>Mapa</dt><dd><?= (int)$r['mapa'] ?></dd></div>
                    <div><dt>Visitas a promociones</dt><dd><?= (int)$r['promociones'] ?></dd></div>
                    <div><dt>Sucursales activas</dt><dd><?= (int)($perfil['sucursales']??0) ?></dd></div>
                    <div><dt>Canales publicados</dt><dd><?= (int)($perfil['canales']??0) ?></dd></div>
                </dl>
            </div>
        </section>
    </div>

    <div class="grid grid-cols-1 xl:grid-cols-2 gap-5 mb-6">
        <section data-panel-motion="results" class="kt-card" aria-labelledby="inicioTerminos">
            <div class="kt-card-header"><h3 id="inicioTerminos" class="kt-card-title">Búsquedas que mostraron tu empresa</h3></div>
            <div class="kt-card-body p-5">
                <?php if ($datosVista['busquedas']): ?><ol class="canaco-inicio-ranked">
                    <?php foreach ($datosVista['busquedas'] as $fila): ?><li><span><?= e($fila['termino']) ?></span><strong><?= (int)$fila['apariciones'] ?></strong></li><?php endforeach; ?>
                </ol><?php else: ?><p class="text-sm text-muted-foreground">Aún no hay términos de búsqueda registrados para esta empresa.</p><?php endif; ?>
            </div>
        </section>
        <section data-panel-motion="results" class="kt-card" aria-labelledby="inicioPromos">
            <div class="kt-card-header"><h3 id="inicioPromos" class="kt-card-title">Promociones vigentes</h3><a class="kt-btn kt-btn-sm kt-btn-light" href="<?= base_url('promociones') ?>">Administrar</a></div>
            <div class="kt-card-body p-5">
                <?php if ($datosVista['promociones']): ?><ul class="canaco-inicio-ranked">
                    <?php foreach ($datosVista['promociones'] as $promo): ?><li><span><?= e($promo['titulo']) ?><small class="block text-xs text-muted-foreground">Hasta <?= e(date('d/m/Y',strtotime($promo['fin_vigencia']))) ?></small></span><strong title="Visitas en el mes"><?= (int)$promo['visitas'] ?> visitas</strong></li><?php endforeach; ?>
                </ul><?php else: ?><p class="text-sm text-muted-foreground">No tienes promociones vigentes. Una oferta actualizada ayuda a destacar tu empresa.</p><?php endif; ?>
            </div>
        </section>
    </div>

    <section data-panel-motion="results" class="kt-card" aria-labelledby="inicioEmpresa">
        <div class="kt-card-header"><h3 id="inicioEmpresa" class="kt-card-title">Tu empresa en CANACO Card</h3></div>
        <div class="kt-card-body p-5 canaco-inicio-company">
            <div><strong class="text-foreground"><?= e($empresa['nombre_comercial']) ?></strong><p class="text-sm text-muted-foreground mt-1"><?= e(mb_strimwidth((string)$empresa['descripcion'],0,220,'…')) ?></p><p class="text-xs text-muted-foreground mt-3"><?= (int)($perfil['promociones']??0) ?> promociones vigentes · <?= (int)($perfil['sucursales']??0) ?> sucursales</p></div>
            <div class="flex flex-wrap gap-2"><a class="kt-btn kt-btn-light" href="<?= base_url('afiliados') ?>">Editar mi empresa</a><?php if ((int)$empresa['activo']===1): ?><a class="kt-btn kt-btn-primary" href="<?= base_url('empresa/'.$empresa['slug']) ?>" target="_blank" rel="noopener noreferrer">Ver ficha pública</a><?php endif; ?></div>
        </div>
    </section>
    <p class="text-xs text-muted-foreground mt-5">Las cifras cuentan actividad registrada en el portal; un clic de contacto no confirma una llamada, conversación o venta.</p>
</section>
