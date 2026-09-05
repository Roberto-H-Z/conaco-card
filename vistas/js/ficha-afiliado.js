/**
 * Ficha pública de afiliado.
 * La navegación siempre es un enlace normal; esta mejora opcional solo marca
 * el soporte del navegador para las View Transitions entre documentos.
 */
'use strict';

(function initNavScroll() {
    const nav = document.getElementById('cpNav');
    if (!nav) return;

    const updateNav = () => nav.classList.toggle('scrolled', window.scrollY > 40);
    window.addEventListener('scroll', updateNav, { passive: true });
    updateNav();
})();

(function initDirectoryBackLink() {
    const backLink = document.querySelector('[data-profile-back]');
    if (!backLink) return;

    backLink.addEventListener('click', (event) => {
        if (event.defaultPrevented || event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return;

        try {
            const referrer = document.referrer ? new URL(document.referrer) : null;
            const fromDirectory = referrer && referrer.origin === window.location.origin && /\/portada\/?$/.test(referrer.pathname);
            const origin = sessionStorage.getItem('cp_profile_return_origin');
            sessionStorage.removeItem('cp_profile_return_origin');

            if (fromDirectory && origin === 'directory' && window.history.length > 1) {
                event.preventDefault();
                window.history.back();
            }
        } catch (_) {
            // El enlace normal mantiene el regreso al directorio como respaldo.
        }
    });
})();

(function initAffiliateProfileNavigation() {
    const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    const supportsViewTransitions = 'startViewTransition' in document;

    document.documentElement.dataset.viewTransitions = supportsViewTransitions ? 'native' : 'fallback';

    if (reduceMotion || !supportsViewTransitions) return;

    document.querySelectorAll('[data-affiliate-link]').forEach((link) => {
        link.addEventListener('click', (event) => {
            if (event.defaultPrevented || event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) {
                return;
            }
            const slug = link.dataset.affiliateSlug;
            const sharedElement = link.querySelector('.cp-empresa-card, .cp-promo-card') || link;
            if (slug && /^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(slug)) {
                sharedElement.style.viewTransitionName = `cp-ficha-${slug}`;
            }
            link.classList.add('is-navigating');
        });
    });

    window.addEventListener('pageshow', () => {
        document.querySelectorAll('[data-affiliate-link].is-navigating').forEach((link) => {
            link.classList.remove('is-navigating');
        });
    });
})();
