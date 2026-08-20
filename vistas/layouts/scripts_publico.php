<?php
/**
 * CANACO Card — Scripts del Sitio Público
 * Carga scripts base de Metronic (core + ktui) y JS específico de la portada.
 */
?>
<!-- Metronic Core JS (necesario para componentes como drawers) -->
<script src="<?= asset('js/core.bundle.js') ?>"></script>
<script src="<?= asset('vendors/ktui/ktui.min.js') ?>"></script>

<!-- CANACO Portada JS -->
<?php if (!empty($jsPublico)): ?>
    <?php foreach ($jsPublico as $script): ?>
        <script src="<?= canaco_js($script) ?>?v=<?= file_exists(VIEWS_PATH . 'js/' . $script) ? filemtime(VIEWS_PATH . 'js/' . $script) : '1' ?>"></script>
    <?php endforeach; ?>
<?php endif; ?>
