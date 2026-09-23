/** Movimiento progresivo compartido por fichas públicas y diálogos del panel. */
'use strict';
(() => {
    const root = document.documentElement;
    const reduced = matchMedia('(prefers-reduced-motion: reduce)');
    const ease = 'cubic-bezier(0.23, 1, 0.32, 1)';
    const key = 'canaco-ficha-motion';
    let keyboard = false;
    let source = null;
    const detail = url => /\/(empresa\/[^/]+|promocion\/[1-9][0-9]*)\/?$/.test(new URL(url, location.href).pathname);
    const quiet = () => reduced.matches || keyboard;
    const native = 'onpageswap' in window && 'onpagereveal' in window;
    const panelSection = url => /\/(inicio|afiliados|promociones)\/?$/.exec(new URL(url, location.href).pathname)?.[1];
    const isPanel = root.dataset.canacoPanel === 'true';
    let incomingPanel;
    try { incomingPanel = JSON.parse(sessionStorage.getItem(key)); } catch (_) {}
    if (isPanel && !reduced.matches) {
        const relevant = incomingPanel?.to === location.href && Date.now() - incomingPanel.time < 15000;
        const sameSection = document.referrer && panelSection(document.referrer) === panelSection(location.href);
        if ((relevant && incomingPanel.panel && !incomingPanel.quiet) || (!relevant && !sameSection && !location.search)) root.classList.add('canaco-panel-enter');
    }
    const panelNames = () => {
        let stat = 0;
        document.querySelectorAll('[data-panel-motion]').forEach(el => {
            const name = el.dataset.panelMotion === 'stat' ? 'stat-' + stat++ : el.dataset.panelMotion;
            el.style.viewTransitionName = 'canaco-panel-' + name;
            el.dataset.panelShared = '';
        });
    };
    const cleanPanel = () => {
        document.querySelectorAll('[data-panel-shared]').forEach(el => {
            el.style.removeProperty('view-transition-name');
            delete el.dataset.panelShared;
        });
    };
    document.addEventListener('keydown', () => { keyboard = true; }, true);
    document.addEventListener('pointerdown', () => { keyboard = false; }, true);
    const clean = () => {
        document.querySelectorAll('[data-motion-shared]').forEach(el => {
            el.style.removeProperty('view-transition-name');
            delete el.dataset.motionShared;
        });
        source = null;
    };
    const mark = el => {
        if (!el) return;
        el.style.viewTransitionName = 'cp-card-media';
        el.dataset.motionShared = '';
    };
    const save = data => { try { sessionStorage.setItem(key, JSON.stringify(data)); } catch (_) {} };
    const take = () => {
        try { const data = JSON.parse(sessionStorage.getItem(key)); sessionStorage.removeItem(key); return data; }
        catch (_) { return null; }
    };
    if (!native) {
        const incoming = take();
        if (incoming?.to === location.href && incoming.quiet && Date.now() - incoming.time < 15000) root.classList.add('cp-motion-quiet');
    }
    // No se interceptan enlaces: recarga, historial y abrir en otra pestaña siguen siendo nativos.
    document.addEventListener('click', event => {
        const link = event.target.closest('a[href]');
        if (!link || event.defaultPrevented || event.button !== 0 || event.ctrlKey || event.metaKey || event.shiftKey || event.altKey || link.download || (link.target && link.target !== '_self')) return;
        const url = new URL(link.href);
        if (url.origin !== location.origin) return;
        if (isPanel && panelSection(url.href)) {
            save({ to: url.href, time: Date.now(), quiet: quiet(), panel: panelSection(url.href) !== panelSection(location.href) });
            return;
        }
        if (!detail(url.href)) return;
        clean();
        save({ to: url.href, time: Date.now(), quiet: quiet(), rect: null });
        if (quiet()) return;
        // Solo la imagen viaja: el texto entra a tamaño natural, sin estirarse.
        source = link.querySelector('.cp-empresa-logo-wrap, img') || null;
        if (native) mark(source);
    });
    window.addEventListener('pageswap', event => {
        if (!event.viewTransition) return;
        const to = event.activation?.entry?.url;
        if (isPanel && to && panelSection(to) && panelSection(to) !== panelSection(location.href) && !quiet()) {
            root.classList.add('canaco-panel-transition');
            panelNames();
            event.viewTransition.finished.finally(cleanPanel);
            return;
        }
        if (quiet() || !to || (!detail(location.href) && !detail(to))) {
            event.viewTransition.skipTransition();
            return;
        }
        if (source && detail(to)) {
            const r = source.getBoundingClientRect();
            save({ to, time: Date.now(), quiet: false, rect: { x: r.x, y: r.y, width: r.width, height: r.height } });
        }
        event.viewTransition.finished.finally(clean);
    });
    window.addEventListener('pagereveal', event => {
        const data = take();
        const relevant = data && data.to === location.href && Date.now() - data.time < 15000;
        if (relevant && data.quiet) root.classList.add('cp-motion-quiet');
        const transition = event.viewTransition;
        if (!transition) return;
        const from = window.navigation?.activation?.from?.url;
        if (isPanel && from && panelSection(from) && panelSection(location.href)) {
            if (reduced.matches || (relevant && data.quiet) || panelSection(from) === panelSection(location.href)) {
                root.classList.remove('canaco-panel-enter');
                transition.skipTransition();
                return;
            }
            root.classList.add('canaco-panel-native', 'canaco-panel-transition');
            panelNames();
            transition.finished.finally(cleanPanel);
            return;
        }
        if (reduced.matches || (relevant && data.quiet) || (!detail(location.href) && !(from && detail(from)))) {
            transition.skipTransition();
            return;
        }
        root.classList.add('cp-native-entry');
        const target = relevant && data.rect ? document.querySelector('.cp-profile-logo, .cp-promotion-visual') : null;
        const rect = target?.getBoundingClientRect();
        if (rect && rect.width && rect.height) {
            mark(target);
            root.style.setProperty('--cp-shared-width', rect.width + 'px');
            root.style.setProperty('--cp-shared-height', rect.height + 'px');
            root.style.setProperty('--cp-shared-x', rect.x + 'px');
            root.style.setProperty('--cp-shared-y', rect.y + 'px');
            // FLIP: dimensión final fija; únicamente transform cambia entre fotogramas.
            const old = data.rect;
            root.style.setProperty('--cp-shared-from', `translate(${old.x}px, ${old.y}px) scale(${old.width / rect.width}, ${old.height / rect.height})`);
        }
        transition.finished.finally(clean);
    });
    window.addEventListener('pageshow', event => { clean(); if (event.persisted) { root.classList.add('cp-native-entry'); root.classList.remove('canaco-panel-enter'); } });

    // Los diálogos comparten duración y cierre cancelable; cerrar/reabrir nunca deja un timer obsoleto.
    const states = new WeakMap();
    const animateContent = el => {
        if (!el || quiet() || !el.animate) return;
        el.getAnimations().forEach(animation => animation.cancel());
        el.animate([{ opacity: .3, transform: 'translateY(12px)' }, { opacity: 1, transform: 'translateY(0)' }], { duration: 300, easing: ease });
    };
    window.canacoMotion = {
        content: animateContent,
        open(modal) {
            const previous = states.get(modal);
            clearTimeout(previous?.timer);
            const state = { focus: previous?.focus || document.activeElement, timer: null };
            states.set(modal, state);
            modal.hidden = false;
            modal.inert = false;
            modal.setAttribute('aria-hidden', 'false');
            modal.classList.toggle('canaco-motion-quiet', quiet());
            document.body.classList.add('overflow-hidden');
            // Establece el estado inicial antes de activar la transición CSS.
            void modal.offsetWidth;
            modal.classList.add('is-open');
            const dialog = modal.querySelector('[role="dialog"]');
            if (dialog) { dialog.tabIndex = -1; dialog.focus({ preventScroll: true }); }
        },
        close(modal) {
            const state = states.get(modal) || {};
            clearTimeout(state.timer);
            modal.classList.toggle('canaco-motion-quiet', quiet());
            modal.classList.remove('is-open');
            modal.inert = true;
            if (state.focus?.isConnected) state.focus.focus({ preventScroll: true });
            modal.setAttribute('aria-hidden', 'true');
            state.timer = setTimeout(() => {
                modal.hidden = true;
                states.delete(modal);
                if (!document.querySelector('.canaco-modal:not([hidden])')) document.body.classList.remove('overflow-hidden');
            }, reduced.matches || modal.classList.contains('canaco-motion-quiet') ? 0 : 250);
            states.set(modal, state);
        }
    };
})();
