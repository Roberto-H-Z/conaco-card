<?php
/**
 * CANACO Card — <head> del Sitio Público
 * Usa recursos de Metronic (keenicons, core CSS) pero sin clases admin.
 */
$tituloMeta = $tituloModulo ?? 'Directorio de Empresas Afiliadas';
$descMeta = 'Descubre las empresas afiliadas a CANACO SERVYTUR. Encuentra promociones, sucursales y canales digitales de los mejores negocios de la región.';
?>

<head>
    <meta charset="utf-8" />
    <title><?= e($tituloMeta) ?> | CANACO Card</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="<?= e($descMeta) ?>" />
    <meta name="robots" content="index, follow" />

    <!-- Open Graph -->
    <meta property="og:type" content="website" />
    <meta property="og:title" content="<?= e($tituloMeta) ?> | CANACO Card" />
    <meta property="og:description" content="<?= e($descMeta) ?>" />
    <meta property="og:image" content="<?= asset('media/app/hero_portada.png') ?>" />
    <meta property="og:locale" content="es_MX" />

    <!-- Favicons -->
    <link href="<?= asset('media/app/apple-touch-icon.png') ?>" rel="apple-touch-icon" sizes="180x180" />
    <link href="<?= asset('media/app/favicon-32x32.png') ?>" rel="icon" sizes="32x32" type="image/png" />
    <link href="<?= asset('media/app/favicon-16x16.png') ?>" rel="icon" sizes="16x16" type="image/png" />
    <link href="<?= asset('media/app/favicon.ico') ?>" rel="shortcut icon" />

    <!-- Google Fonts: Inter + Outfit -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
        href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@700;800;900&display=swap"
        rel="stylesheet" />

    <!-- Keenicons (íconos de Metronic) -->
    <link href="<?= asset('vendors/keenicons/styles.bundle.css') ?>" rel="stylesheet" />

    <!-- CANACO Portal Público -->
    <link href="<?= canaco_css('canaco_publico.css') ?>?v=<?= filemtime(VIEWS_PATH . 'css/canaco_publico.css') ?>"
        rel="stylesheet" />
</head>