<?php
if (!empty($datosVista['error'])): ?>
<section class="inicio-dashboard inicio-error"><h1>Estadísticas</h1><div class="inicio-panel"><p role="alert"><?= e($datosVista['error']) ?></p><a class="inicio-button" href="<?= e(base_url('estadisticas')) ?>">Volver a estadísticas</a></div></section>
<?php return; endif;
if ($datosVista['empresa'] !== null) { require VIEWS_PATH.'modulos/inicio.php'; return; }
$f=$datosVista['filtros']; $totales=$datosVista['totales']; $p=$datosVista['paginacion'];
$url=static fn(array $cambios=[]):string=>base_url('estadisticas').'?'.http_build_query(array_merge($f,$cambios));
$exportar=static fn(string $formato):string=>base_url('estadisticas/exportar').'?'.http_build_query([...$f,'formato'=>$formato]);
$metricas=['apariciones'=>'Apariciones','visitas'=>'Visitas a ficha','telefono'=>'Teléfono','whatsapp'=>'WhatsApp','web'=>'Sitio web','redes'=>'Redes sociales','mapa'=>'Mapa','promociones'=>'Visitas a promociones'];
?>
<section class="inicio-dashboard estadisticas-admin" aria-labelledby="estadisticasTitulo">
    <header class="inicio-heading">
        <div><h1 id="estadisticasTitulo">Estadísticas de afiliados</h1><p><?= tieneRol('ADMIN_CAMARA')?'Consulta la actividad de las empresas de tu cámara.':'Consulta la actividad del directorio completo o filtra por cámara.' ?></p></div>
        <div class="inicio-period"><i class="ki-filled ki-calendar" aria-hidden="true"></i><div><strong>Últimos 30 días</strong><span><?= e(date('d/m/Y',strtotime($datosVista['periodo']['desde']))) ?> al <?= e(date('d/m/Y',strtotime($datosVista['periodo']['hasta']))) ?> · UTC</span></div></div>
    </header>
    <form class="estadisticas-filtros" method="get" action="<?= e(base_url('estadisticas')) ?>" role="search" aria-label="Filtrar estadísticas">
        <label>Afiliado<input type="search" name="q" value="<?= e($f['q']) ?>" maxlength="100" placeholder="Buscar por nombre comercial"></label>
        <?php if(tieneRol('ADMIN_GENERAL')): ?><label>Cámara<select name="camara"><option value="0">Todas las cámaras</option><?php foreach($datosVista['camaras'] as $c): ?><option value="<?= (int)$c['idCamara'] ?>" <?= $f['camara']===(int)$c['idCamara']?'selected':'' ?>><?= e($c['nombre']) ?></option><?php endforeach; ?></select></label><?php endif; ?>
        <button class="inicio-button" type="submit">Aplicar filtros</button><a class="inicio-text-link" href="<?= e(base_url('estadisticas')) ?>">Restablecer</a>
    </form>
    <div class="estadisticas-resultados-heading"><p><strong><?= number_format($p['total']) ?> afiliados</strong> · <?= e($datosVista['alcance']) ?></p><div class="estadisticas-descargas"><a class="inicio-button inicio-button-quiet" href="<?= e($exportar('xlsx')) ?>">Descargar Excel <i class="ki-filled ki-file-down" aria-hidden="true"></i></a><a class="inicio-button inicio-button-quiet" href="<?= e($exportar('pdf')) ?>">Descargar PDF <i class="ki-filled ki-file-down" aria-hidden="true"></i></a></div></div>
    <dl class="estadisticas-totales"><?php foreach(['apariciones'=>'Apariciones en búsquedas','visitas'=>'Visitas a fichas','contactos'=>'Clics de contacto'] as $k=>$label): ?><div><dt><?= e($label) ?></dt><dd><?= number_format($totales[$k]) ?></dd></div><?php endforeach; ?></dl>
    <?php if(!$p['total']): ?>
    <div class="inicio-panel inicio-empty"><h2>No encontramos afiliados</h2><p>Prueba con otro nombre o restablece los filtros.</p><a class="inicio-text-link" href="<?= e(base_url('estadisticas')) ?>">Restablecer filtros</a></div>
    <?php else: ?>
    <div class="estadisticas-tabla-scroll" role="region" aria-label="Actividad por afiliado" tabindex="0"><table class="estadisticas-tabla"><caption class="inicio-sr-only">Actividad registrada en el periodo por afiliado. Incluye empresas sin actividad e inactivas.</caption><thead><tr><th scope="col">Afiliado</th><?php foreach($metricas as $label): ?><th scope="col"><?= e($label) ?></th><?php endforeach; ?></tr></thead><tbody>
    <?php foreach($datosVista['listado'] as $fila): ?><tr><th scope="row"><a class="inicio-text-link" href="<?= e($url(['afiliado'=>(int)$fila['idAfiliado']])) ?>"><?= e($fila['nombre_comercial']) ?><i class="ki-filled ki-arrow-right" aria-hidden="true"></i></a><span><?= e($fila['camara']) ?><?= (int)$fila['activo']!==1?' · Inactivo':'' ?></span><small>Ver detalle y actividad diaria</small></th><?php foreach($metricas as $k=>$label): ?><td data-label="<?= e($label) ?>"><?= number_format($fila[$k]) ?></td><?php endforeach; ?></tr><?php endforeach; ?>
    </tbody></table></div>
    <?php if($p['paginas']>1): ?><nav class="estadisticas-paginacion" aria-label="Páginas de estadísticas"><?php if($p['pagina']>1): ?><a class="inicio-button inicio-button-quiet" href="<?= e($url(['pagina'=>$p['pagina']-1])) ?>">Anterior</a><?php endif; ?><span>Página <?= $p['pagina'] ?> de <?= $p['paginas'] ?></span><?php if($p['pagina']<$p['paginas']): ?><a class="inicio-button inicio-button-quiet" href="<?= e($url(['pagina'=>$p['pagina']+1])) ?>">Siguiente</a><?php endif; ?></nav><?php endif; ?>
    <?php endif; ?>
    <p class="inicio-footnote">Las descargas incluyen todos los afiliados que coinciden con los filtros. Un clic no confirma una llamada, conversación o venta.</p>
</section>
