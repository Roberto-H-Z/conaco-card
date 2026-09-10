<?php
$f = $datosVista['filtros'];
$resultado = $datosVista['resultado'];
$catalogos = $datosVista['catalogos'];
$urlBusqueda = static function (array $cambios = []) use ($f): string {
    return base_url('buscar') . '?' . http_build_query(array_merge($f, $cambios));
};
?>
<div class="cp-search-page">
    <header class="cp-search-header">
        <div class="cp-profile-container">
            <a class="cp-search-back" href="<?= e(base_url('portada')) ?>"><i class="ki-filled ki-arrow-left" aria-hidden="true"></i> Volver al portal</a>
            <h1>Encuentra tu próximo aliado.</h1>
            <p>Explora empresas de la región y descubre sus promociones vigentes.</p>
        </div>
    </header>
    <div class="cp-profile-container cp-search-layout">
        <form class="cp-search-filters" action="<?= e(base_url('buscar')) ?>" method="get" role="search" aria-label="Búsqueda avanzada" data-search-form>
            <h2>Busca a tu manera</h2>
            <label for="busquedaTexto">¿Qué estás buscando?</label>
            <input id="busquedaTexto" type="search" name="q" maxlength="120" value="<?= e($f['q']) ?>" placeholder="Empresa, producto o servicio" aria-describedby="busquedaAyuda" />
            <p id="busquedaAyuda">Puedes escribir solo parte del nombre o buscar un beneficio.</p>
            <label for="busquedaCiudad">Ciudad / municipio</label>
            <select id="busquedaCiudad" name="ciudad">
                <option value="">Todas las ciudades</option>
                <?php foreach ($catalogos['ciudades'] as $opcion): ?><option value="<?= (int)$opcion['id'] ?>" <?= (int)$opcion['id'] === $f['ciudad'] ? 'selected' : '' ?>><?= e($opcion['nombre']) ?></option><?php endforeach; ?>
            </select>
            <label for="busquedaCategoria">Categoría comercial</label>
            <select id="busquedaCategoria" name="categoria">
                <option value="">Todas las categorías</option>
                <?php foreach ($catalogos['categorias'] as $opcion): ?><option value="<?= (int)$opcion['id'] ?>" <?= (int)$opcion['id'] === $f['categoria'] ? 'selected' : '' ?>><?= e($opcion['nombre']) ?></option><?php endforeach; ?>
            </select>
            <button type="submit"><i class="ki-filled ki-magnifier" aria-hidden="true"></i> <span>Buscar empresas</span></button>
            <a class="cp-search-clear" href="<?= e(base_url('buscar')) ?>">Limpiar búsqueda y filtros</a>
        </form>
        <section class="cp-search-results" aria-labelledby="busquedaResultados">
            <div class="cp-search-results-heading">
                <div><h2 id="busquedaResultados"><?= $f['q'] !== '' ? 'Resultados para “'.e($f['q']).'”' : 'Empresas afiliadas' ?></h2>
                <p><?= number_format($resultado['total']) ?> <?= $resultado['total'] === 1 ? 'empresa encontrada' : 'empresas encontradas' ?></p></div>
                <span><?= $f['q'] !== '' ? 'Por relevancia' : 'Orden alfabético' ?></span>
            </div>
            <?php if ($datosVista['error']): ?>
                <div class="cp-search-empty" role="alert"><h3>No pudimos completar la búsqueda</h3><p><?= e($datosVista['error']) ?></p><a href="<?= e(base_url('buscar')) ?>">Restablecer la búsqueda</a></div>
            <?php elseif (!$resultado['items']): ?>
                <div class="cp-search-empty"><i class="ki-filled ki-magnifier" aria-hidden="true"></i><h3>Aún no encontramos una coincidencia</h3><p>Prueba con un nombre más corto, un producto o una categoría. También puedes quitar los filtros para ampliar tu búsqueda.</p><a href="<?= e($urlBusqueda(['ciudad'=>0,'categoria'=>0,'pagina'=>1])) ?>">Buscar en todas las ciudades y categorías</a><a href="<?= e(base_url('buscar')) ?>">Explorar todas las empresas</a></div>
            <?php else: ?>
                <div class="cp-search-list">
                    <?php foreach ($resultado['items'] as $item):
                        $urlFicha = base_url('empresa/'.rawurlencode($item['slug']));
                        if ($datosVista['busqueda_token']) $urlFicha .= '?busqueda='.rawurlencode($datosVista['busqueda_token']);
                        $resumen = mb_strimwidth((string)$item['descripcion'], 0, 210, '…');
                    ?>
                        <article class="cp-search-result">
                            <a class="cp-search-company" href="<?= e($urlFicha) ?>" data-affiliate-link data-affiliate-slug="<?= e($item['slug']) ?>">
                                <span class="cp-search-logo"><?php if ($item['logo']): ?><img src="<?= e($item['logo']) ?>" alt="Logotipo de <?= e($item['nombre_comercial']) ?>" width="80" height="80" loading="lazy" decoding="async" /><?php else: ?><span aria-hidden="true"><?= e(mb_strtoupper(mb_substr($item['nombre_comercial'],0,2))) ?></span><?php endif; ?></span>
                                <span class="cp-search-company-copy"><span class="cp-search-category"><?= e($item['categoria']) ?></span><h3><?= e($item['nombre_comercial']) ?></h3><span class="cp-search-city"><i class="ki-filled ki-geolocation" aria-hidden="true"></i> <?= e($item['ciudad']) ?></span><span class="cp-search-description"><?= e($resumen) ?></span></span>
                                <i class="ki-filled ki-arrow-up-right cp-search-arrow" aria-hidden="true"></i>
                            </a>
                            <?php if ($item['promocion']): ?><a class="cp-search-promotion" href="<?= e(base_url('promocion/'.(int)$item['promocion']['idPromocion'])) ?>" data-promotion-link data-promotion-id="<?= (int)$item['promocion']['idPromocion'] ?>"><i class="ki-filled ki-discount" aria-hidden="true"></i><span><small>Promoción vigente</small><?= e($item['promocion']['titulo']) ?></span><i class="ki-filled ki-arrow-right" aria-hidden="true"></i></a><?php endif; ?>
                        </article>
                    <?php endforeach; ?>
                </div>
                <?php if ($resultado['paginas'] > 1): ?>
                    <nav class="cp-search-pagination" aria-label="Páginas de resultados">
                        <?php if ($resultado['pagina'] > 1): ?><a href="<?= e($urlBusqueda(['pagina'=>$resultado['pagina']-1])) ?>" rel="prev">Anterior</a><?php endif; ?>
                        <span>Página <?= $resultado['pagina'] ?> de <?= $resultado['paginas'] ?></span>
                        <?php if ($resultado['pagina'] < $resultado['paginas']): ?><a href="<?= e($urlBusqueda(['pagina'=>$resultado['pagina']+1])) ?>" rel="next">Siguiente</a><?php endif; ?>
                    </nav>
                <?php endif; ?>
            <?php endif; ?>
        </section>
    </div>
</div>
