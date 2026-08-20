<head>
    <meta charset="utf-8" />
    <title><?= e($tituloModulo ?? APP_NAME) ?> | <?= e(APP_NAME) ?></title>
    <meta content="width=device-width, initial-scale=1, shrink-to-fit=no" name="viewport" />
    <meta name="csrf-token" content="<?= e(obtenerTokenCSRF()) ?>" />
    <script>
        (() => {
            const savedTheme = localStorage.getItem('canaco-theme') || localStorage.getItem('kt-theme');
            const theme = savedTheme === 'dark' ? 'dark' : 'light';
            document.documentElement.classList.remove('light', 'dark');
            document.documentElement.classList.add(theme);
            document.documentElement.setAttribute('data-kt-theme-mode', theme);
            document.documentElement.style.colorScheme = theme;
        })();
    </script>

    <!-- Metronic Favicons -->
    <link href="<?= asset('media/app/apple-touch-icon.png') ?>" rel="apple-touch-icon" sizes="180x180" />
    <link href="<?= asset('media/app/favicon-32x32.png') ?>" rel="icon" sizes="32x32" type="image/png" />
    <link href="<?= asset('media/app/favicon-16x16.png') ?>" rel="icon" sizes="16x16" type="image/png" />
    <link href="<?= asset('media/app/favicon.ico') ?>" rel="shortcut icon" />

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />

    <!-- Vendor CSS -->
    <link href="<?= asset('vendors/apexcharts/apexcharts.css') ?>" rel="stylesheet" />
    <link href="<?= asset('vendors/keenicons/styles.bundle.css') ?>" rel="stylesheet" />

    <!-- Metronic Global Styles -->
    <link href="<?= asset('css/styles.css') ?>" rel="stylesheet" />

    <!-- CANACO Custom Styles -->
    <link href="<?= canaco_css('canaco.css') ?>?v=<?= filemtime(VIEWS_PATH . 'css/canaco.css') ?>" rel="stylesheet" />
</head>