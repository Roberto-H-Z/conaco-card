<?php $usuarioMenu = obtenerUsuarioSesion(); $esAfiliadoMenu = ($usuarioMenu['rol'] ?? '') === 'AFILIADO'; $esAdminGeneralMenu = ($usuarioMenu['rol'] ?? '') === 'ADMIN_GENERAL'; ?>
<aside
    class="kt-sidebar bg-background border-e border-border fixed top-0 bottom-0 z-20 hidden lg:flex flex-col items-stretch shrink-0 [--kt-drawer-enable:true] lg:[--kt-drawer-enable:false]"
    data-kt-drawer="true" data-kt-drawer-class="kt-drawer kt-drawer-start flex top-0 bottom-0" id="sidebar">
    <div class="canaco-sidebar-brand flex items-center justify-between px-5 border-b border-border">
        <a class="canaco-brand" href="<?= base_url($esAfiliadoMenu ? 'inicio' : 'afiliados') ?>" aria-label="Ir al panel">
            <img src="<?= asset('media/app/CANACOCARD_Logo.png') ?>" alt="CANACO Card de la Montaña al Mar"
                class="canaco-brand-logo">
        </a>
        <button class="kt-btn kt-btn-icon kt-btn-ghost lg:hidden" data-kt-drawer-dismiss="true"
            aria-label="Cerrar menú"><i class="ki-filled ki-cross"></i></button>
    </div>
    <div class="flex flex-col pt-5 pb-5 overflow-y-auto">
        <nav class="kt-menu flex-col gap-2 px-5" data-kt-menu="true" aria-label="Navegación principal">
            <?php if($esAfiliadoMenu): ?>
            <div class="kt-menu-item <?= $rutaActual === 'inicio' ? 'active' : '' ?>">
                <a class="kt-menu-link canaco-nav-link flex items-center gap-3 px-3 py-2.5 rounded-lg hover:bg-accent/60 kt-menu-item-active:bg-accent/60 text-sm font-medium text-foreground kt-menu-item-active:text-primary" href="<?= base_url('inicio') ?>">
                    <span class="kt-menu-icon text-muted-foreground w-5"><i class="ki-filled ki-home-2 text-lg"></i></span>
                    <span class="kt-menu-title">Inicio</span>
                </a>
            </div>
            <?php endif; ?>
            <div class="kt-menu-item pt-2 pb-2"><span
                    class="text-xs font-semibold text-muted-foreground uppercase tracking-wider">Gestión</span></div>
            <div class="kt-menu-item <?= $rutaActual === 'afiliados' ? 'active' : '' ?>">
                <a class="kt-menu-link canaco-nav-link flex items-center gap-3 px-3 py-2.5 rounded-lg hover:bg-accent/60 kt-menu-item-active:bg-accent/60 text-sm font-medium text-foreground kt-menu-item-active:text-primary"
                    href="<?= base_url('afiliados') ?>">
                    <span class="kt-menu-icon text-muted-foreground w-5"><i
                            class="ki-filled ki-people text-lg"></i></span>
                    <span class="kt-menu-title"><?= $esAfiliadoMenu ? 'Mi empresa' : 'Afiliados' ?></span>
                </a>
            </div>
            <div class="kt-menu-item <?= $rutaActual === 'promociones' ? 'active' : '' ?>">
                <a class="kt-menu-link canaco-nav-link flex items-center gap-3 px-3 py-2.5 rounded-lg hover:bg-accent/60 text-sm font-medium text-foreground"
                    href="<?= base_url('promociones') ?>">
                    <span class="kt-menu-icon text-muted-foreground w-5">
                        <i class="ki-filled ki-discount text-lg"></i>
                    </span>
                    <span class="kt-menu-title">Promociones</span>
                </a>
            </div>
            <?php if($esAdminGeneralMenu): ?>
            <div class="kt-menu-item <?= $rutaActual === 'usuarios' ? 'active' : '' ?>">
                <a class="kt-menu-link canaco-nav-link flex items-center gap-3 px-3 py-2.5 rounded-lg hover:bg-accent/60 text-sm font-medium text-foreground" href="<?= base_url('usuarios') ?>">
                    <span class="kt-menu-icon text-muted-foreground w-5"><i class="ki-filled ki-user-square text-lg"></i></span>
                    <span class="kt-menu-title">Usuarios</span>
                </a>
            </div>
            <?php endif; ?>
            <div class="kt-menu-item mt-6">
                <form method="post" action="<?= base_url('logout') ?>">
                    <?= campoCSRF() ?>
                    <button class="kt-menu-link canaco-nav-link flex w-full items-center gap-3 px-3 py-2.5 rounded-lg hover:bg-accent/60 text-sm font-medium text-foreground" type="submit">
                    <span class="kt-menu-icon text-muted-foreground w-5">
                        <i class="ki-filled ki-exit-left text-lg"></i>
                    </span>
                    <span class="kt-menu-title">Cerrar sesión</span>
                    </button>
                </form>
            </div>
        </nav>
    </div>
    <div class="px-5 py-4 border-t border-border text-xs text-muted-foreground">Sesión activa · <?= e($usuarioMenu['correo'] ?? '') ?></div>
</aside>
