<?php
/**
 * CANACO Card — Vista de Dashboard
 */
?>
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-5 lg:gap-7.5">
    
    <?php foreach ($datosVista['tarjetas'] ?? [] as $tarjeta): ?>
    <div class="kt-card">
        <div class="kt-card-body p-5">
            <div class="flex flex-col gap-4">
                <div class="flex items-center justify-between gap-2">
                    <div class="flex flex-col gap-1">
                        <span class="text-sm font-medium text-muted-foreground"><?= e($tarjeta['titulo']) ?></span>
                        <span class="text-2xl font-semibold text-foreground"><?= e($tarjeta['valor']) ?></span>
                    </div>
                    <span class="flex items-center justify-center w-[40px] h-[40px] rounded-lg bg-<?= e($tarjeta['color']) ?>-light">
                        <i class="<?= e($tarjeta['icono']) ?> text-xl text-<?= e($tarjeta['color']) ?>"></i>
                    </span>
                </div>
                <div class="flex items-center gap-1.5">
                    <span class="text-xs font-medium text-muted-foreground"><?= e($tarjeta['descripcion']) ?></span>
                </div>
            </div>
        </div>
    </div>
    <?php endforeach; ?>

</div>

<div class="grid grid-cols-1 lg:grid-cols-2 gap-5 lg:gap-7.5 mt-5 lg:mt-7.5">
    <!-- Card de Actividad Reciente -->
    <div class="kt-card">
        <div class="kt-card-header">
            <h3 class="kt-card-title">Actividad Reciente</h3>
            <div class="kt-card-toolbar">
                <a href="<?= base_url('auditoria') ?>" class="kt-btn kt-btn-sm kt-btn-light">Ver todo</a>
            </div>
        </div>
        <div class="kt-card-body">
            <div class="flex flex-col gap-5">
                <!-- Placeholder de actividad -->
                <div class="flex items-center gap-3">
                    <div class="flex items-center justify-center w-8 h-8 rounded-full bg-primary-light">
                        <i class="ki-filled ki-shop text-primary text-sm"></i>
                    </div>
                    <div class="flex flex-col flex-grow">
                        <span class="text-sm font-medium text-foreground">Nuevo afiliado registrado</span>
                        <span class="text-xs text-muted-foreground">Hace 2 horas por Admin</span>
                    </div>
                </div>
                <div class="flex items-center gap-3">
                    <div class="flex items-center justify-center w-8 h-8 rounded-full bg-success-light">
                        <i class="ki-filled ki-discount text-success text-sm"></i>
                    </div>
                    <div class="flex flex-col flex-grow">
                        <span class="text-sm font-medium text-foreground">Promoción "Buen Fin" aprobada</span>
                        <span class="text-xs text-muted-foreground">Hace 5 horas</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Accesos Rápidos -->
    <div class="kt-card">
        <div class="kt-card-header">
            <h3 class="kt-card-title">Accesos Rápidos</h3>
        </div>
        <div class="kt-card-body p-0">
            <div class="grid grid-cols-2 border-t border-border">
                <a href="<?= base_url('afiliados') ?>" class="flex flex-col items-center justify-center gap-2 p-5 border-b border-e border-border hover:bg-accent/50 transition-colors">
                    <i class="ki-filled ki-plus-square text-3xl text-primary mb-1"></i>
                    <span class="text-sm font-medium text-foreground">Nuevo Afiliado</span>
                </a>
                <a href="<?= base_url('promociones') ?>" class="flex flex-col items-center justify-center gap-2 p-5 border-b border-border hover:bg-accent/50 transition-colors">
                    <i class="ki-filled ki-badge text-3xl text-success mb-1"></i>
                    <span class="text-sm font-medium text-foreground">Crear Promoción</span>
                </a>
                <a href="<?= base_url('usuarios') ?>" class="flex flex-col items-center justify-center gap-2 p-5 border-e border-border hover:bg-accent/50 transition-colors">
                    <i class="ki-filled ki-user-square text-3xl text-info mb-1"></i>
                    <span class="text-sm font-medium text-foreground">Gestión Usuarios</span>
                </a>
                <a href="<?= base_url('reportes') ?>" class="flex flex-col items-center justify-center gap-2 p-5 hover:bg-accent/50 transition-colors">
                    <i class="ki-filled ki-chart-pie-4 text-3xl text-warning mb-1"></i>
                    <span class="text-sm font-medium text-foreground">Ver Reportes</span>
                </a>
            </div>
        </div>
    </div>
</div>
