<?php
/**
 * CANACO Card — Scripts
 * Carga de archivos JavaScript globales y específicos del módulo.
 */
?>
<!-- Core Metronic Global Javascript -->
<script src="<?= asset('js/core.bundle.js') ?>"></script>
<script src="<?= asset('vendors/ktui/ktui.min.js') ?>"></script>

<!-- Vendors Javascript -->
<script src="<?= asset('vendors/apexcharts/apexcharts.min.js') ?>"></script>

<!-- Layout Setup -->
<script src="<?= asset('js/layouts/demo1.js') ?>"></script>

<!-- CANACO Global Javascript -->
<script src="<?= canaco_js('app.js') ?>?v=<?= filemtime(VIEWS_PATH . 'js/app.js') ?>"></script>

<!-- Modulos Específicos Javascript -->
<?php if (!empty($jsModulo)): ?>
    <?php foreach ($jsModulo as $script): ?>
        <script src="<?= canaco_js($script) ?>?v=<?= filemtime(VIEWS_PATH . 'js/' . $script) ?>"></script>
    <?php endforeach; ?>
<?php endif; ?>
