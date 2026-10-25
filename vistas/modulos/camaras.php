<?php $filas=$datosVista['listado'];$f=$datosVista['filtros'];$ciudades=$datosVista['ciudades']; ?>
<section aria-labelledby="titulo-camaras">
 <div data-panel-motion="title"><h2 id="titulo-camaras" class="text-2xl font-semibold text-foreground">Gestión de cámaras</h2><p class="text-sm text-muted-foreground mt-1">Administra las cámaras, sus datos de contacto y las ciudades de su circunscripción.</p></div>
 <div class="kt-card">
  <div class="kt-card-header block py-4 min-h-0" data-panel-motion="tools">
   <div class="canaco-directory-heading"><h3 class="font-semibold">Cámaras registradas</h3><p class="text-sm text-muted-foreground">La desactivación conserva los afiliados, usuarios y ciudades vinculados.</p></div>
   <form class="canaco-filter-row" method="get" action="<?= e(base_url('camaras')) ?>" role="search">
    <label class="kt-input canaco-filter-search"><i class="ki-filled ki-magnifier" aria-hidden="true"></i><input name="q" value="<?= e($f['q']) ?>" placeholder="Nombre, clave o nombre corto" aria-label="Buscar cámaras"></label>
    <select class="kt-select" name="estado" aria-label="Filtrar por estado"><option value="">Todos los estados</option><option value="1" <?= $f['estado']==='1'?'selected':'' ?>>Activas</option><option value="0" <?= $f['estado']==='0'?'selected':'' ?>>Inactivas</option></select>
    <button class="kt-btn kt-btn-light" type="submit">Filtrar</button><button class="kt-btn kt-btn-primary" type="button" id="btnNuevaCamara"><i class="ki-filled ki-plus" aria-hidden="true"></i>Registrar cámara</button>
   </form>
  </div>
  <div class="overflow-x-auto" data-panel-motion="results"><table class="kt-table canaco-table"><thead><tr><th>Cámara</th><th>Contacto</th><th>Ciudad sede</th><th>Ciudades</th><th>Afiliados</th><th>Estado</th><th>Acciones</th></tr></thead><tbody>
   <?php foreach($filas as $c): ?><tr>
    <td><strong><?= e($c['nombre']) ?></strong><div class="text-xs text-muted-foreground"><?= e($c['clave']) ?><?= $c['nombre_corto']?' · '.e($c['nombre_corto']):'' ?></div></td>
    <td><div><?= e($c['correo'] ?: 'Sin correo') ?></div><div class="text-xs text-muted-foreground"><?= e($c['telefono'] ?: 'Sin teléfono') ?></div></td>
    <td><?= e($c['sede'] ? $c['sede'].', '.$c['estado_sede'] : 'Sin sede asignada') ?></td><td><?= (int)$c['ciudades'] ?></td><td><?= (int)$c['afiliados'] ?></td>
    <td><span class="kt-badge kt-badge-outline <?= (int)$c['activo']?'kt-badge-success':'kt-badge-danger' ?>"><?= (int)$c['activo']?'Activa':'Inactiva' ?></span></td>
    <td class="whitespace-nowrap"><button type="button" class="kt-btn kt-btn-icon kt-btn-ghost btn-editar-camara" data-id="<?= (int)$c['idCamara'] ?>" aria-label="Editar cámara y ciudades de <?= e($c['nombre']) ?>" title="Editar cámara y ciudades"><i class="ki-filled ki-pencil" aria-hidden="true"></i></button><button type="button" class="kt-btn kt-btn-icon kt-btn-ghost btn-estado-camara" data-id="<?= (int)$c['idCamara'] ?>" data-activo="<?= (int)$c['activo']?'0':'1' ?>" data-nombre="<?= e($c['nombre']) ?>" aria-label="<?= (int)$c['activo']?'Desactivar':'Activar' ?> cámara" title="Cambiar estado"><i class="ki-filled ki-toggle-on-circle" aria-hidden="true"></i></button></td>
   </tr><?php endforeach; ?>
   <?php if(!$filas): ?><tr><td colspan="7"><div class="canaco-empty"><strong>No hay cámaras coincidentes</strong><p>Prueba con otros filtros o registra una cámara.</p></div></td></tr><?php endif; ?>
  </tbody></table></div><div class="kt-card-footer py-4 text-sm text-muted-foreground"><?= count($filas) ?> cámaras</div>
 </div>
</section>
<div class="canaco-modal" id="modalCamara" hidden aria-hidden="true">
 <div class="canaco-modal-backdrop" data-camara-close></div>
 <div class="canaco-modal-dialog canaco-modal-xl" role="dialog" aria-modal="true" aria-labelledby="tituloModalCamara">
  <form id="formCamara" novalidate>
   <input type="hidden" name="csrf_token" value="<?= e(obtenerTokenCSRF()) ?>"><input type="hidden" name="idCamara">
   <div class="canaco-modal-header"><h3 id="tituloModalCamara" class="text-lg font-semibold">Registrar cámara</h3><button type="button" class="kt-btn kt-btn-icon kt-btn-ghost" data-camara-close aria-label="Cerrar"><i class="ki-filled ki-cross" aria-hidden="true"></i></button></div>
   <div class="canaco-modal-body">
    <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
     <?php foreach(['clave'=>['Clave *',30],'nombre'=>['Nombre *',180],'nombre_corto'=>['Nombre corto',80],'correo'=>['Correo',254],'telefono'=>['Teléfono',20]] as $campo=>[$label,$max]): ?>
     <div class="canaco-field"><label for="camara-<?= e($campo) ?>"><?= e($label) ?></label><input class="kt-input" id="camara-<?= e($campo) ?>" name="<?= e($campo) ?>" maxlength="<?= $max ?>" type="<?= $campo==='correo'?'email':($campo==='telefono'?'tel':'text') ?>" <?= in_array($campo,['clave','nombre'],true)?'required':'' ?>><span data-error="<?= e($campo) ?>"></span></div>
     <?php endforeach; ?>
     <div class="canaco-field"><label for="camara-activo">Estado</label><select class="kt-select" id="camara-activo" name="activo"><option value="1">Activa</option><option value="0">Inactiva</option></select><span data-error="activo"></span></div>
     <div class="canaco-field md:col-span-2"><label for="camara-sede">Ciudad sede</label><select class="kt-select" id="camara-sede" name="idMunicipioSede"><option value="">Sin sede asignada</option><?php foreach($ciudades as $c): ?><option value="<?= (int)$c['idMunicipio'] ?>" data-activo="<?= (int)$c['activo'] ?>"><?= e($c['nombre'].', '.$c['estado']) ?><?= (int)$c['activo']?'':' (inactiva)' ?></option><?php endforeach; ?></select><span data-error="idMunicipioSede"></span></div>
    </div>
    <fieldset class="canaco-camara-coverage"><legend class="font-semibold">Ciudades de cobertura</legend><p class="text-sm text-muted-foreground">Selecciona las ciudades vinculadas y su cobertura directa o extendida. La sede debe estar incluida. <a class="text-primary" href="<?= e(base_url('ciudades')) ?>">Gestionar catálogo de ciudades</a></p>
     <label class="kt-input mt-3"><i class="ki-filled ki-magnifier" aria-hidden="true"></i><input id="buscarCiudadCamara" type="search" placeholder="Buscar por ciudad o estado" aria-label="Buscar ciudades de cobertura"></label>
     <span data-error="ciudades" role="alert"></span>
     <div class="canaco-camara-cities">
      <?php foreach($ciudades as $c):$id=(int)$c['idMunicipio']; ?>
      <div class="canaco-camara-city" data-ciudad="<?= e(mb_strtolower($c['nombre'].' '.$c['estado'])) ?>" data-activo="<?= (int)$c['activo'] ?>">
       <label><input class="kt-checkbox" type="checkbox" name="ciudades[]" value="<?= $id ?>"><span><?= e($c['nombre']) ?><small class="text-muted-foreground"><?= e($c['estado']) ?><?= (int)$c['activo']?'':' · Inactiva' ?></small></span></label>
       <select class="kt-select" name="cobertura[<?= $id ?>]" aria-label="Cobertura de <?= e($c['nombre']) ?>" disabled><option value="DIRECTA">Directa</option><option value="EXTENDIDA">Extendida</option></select>
      </div><?php endforeach; ?>
     </div><p id="sinCiudadesCamara" class="text-sm text-muted-foreground" hidden>No hay ciudades coincidentes.</p>
    </fieldset>
   </div>
   <div class="canaco-modal-footer"><button type="button" class="kt-btn kt-btn-light" data-camara-close>Cancelar</button><button type="submit" class="kt-btn kt-btn-primary" id="btnGuardarCamara">Guardar cámara</button></div>
  </form>
 </div>
</div>
<div class="canaco-toast" id="notificacionCamara" role="status" aria-live="polite" hidden></div>
