/** Comportamiento progresivo de la ficha pública de promoción. */
'use strict';

(function initNavScroll() {
    const nav = document.getElementById('cpNav');
    if (!nav) return;
    const updateNav = () => nav.classList.toggle('scrolled', window.scrollY > 40);
    window.addEventListener('scroll', updateNav, { passive: true });
    updateNav();
})();

(function initMobileNav() {
    const hamburger = document.getElementById('cpNavHamburger');
    const mobileNav = document.getElementById('cpNavMobile');
    const closeButton = document.getElementById('cpNavMobileClose');
    if (!hamburger || !mobileNav) return;
    let returnFocus = null;

    const focusableSelector = 'a[href], button:not([disabled]), [tabindex]:not([tabindex="-1"])';

    const close = (restoreFocus = true) => {
        mobileNav.classList.remove('open');
        mobileNav.setAttribute('aria-hidden', 'true');
        hamburger.setAttribute('aria-expanded', 'false');
        document.body.style.overflow = '';
        if (restoreFocus && returnFocus instanceof HTMLElement) returnFocus.focus();
    };
    window.closeMobileNav = close;
    hamburger.addEventListener('click', () => {
        returnFocus = document.activeElement;
        mobileNav.classList.add('open');
        mobileNav.setAttribute('aria-hidden', 'false');
        hamburger.setAttribute('aria-expanded', 'true');
        document.body.style.overflow = 'hidden';
        window.requestAnimationFrame(() => closeButton?.focus());
    });
    closeButton?.addEventListener('click', close);
    document.addEventListener('keydown', (event) => {
        if (event.key === 'Escape' && mobileNav.classList.contains('open')) close();
        if (event.key !== 'Tab' || !mobileNav.classList.contains('open')) return;

        const focusable = Array.from(mobileNav.querySelectorAll(focusableSelector)).filter((element) => element instanceof HTMLElement && element.offsetParent !== null);
        if (focusable.length === 0) return;
        const first = focusable[0];
        const last = focusable[focusable.length - 1];
        if (event.shiftKey && document.activeElement === first) {
            event.preventDefault();
            last.focus();
        } else if (!event.shiftKey && document.activeElement === last) {
            event.preventDefault();
            first.focus();
        }
    });
    mobileNav.setAttribute('aria-hidden', 'true');
})();

(function initPromotionBackLink() {
    const link = document.querySelector('[data-promotion-back]');
    if (!link) return;

    link.addEventListener('click', (event) => {
        if (event.defaultPrevented || event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return;
        try {
            const referrer = document.referrer ? new URL(document.referrer) : null;
            const samePortal = referrer && referrer.origin === window.location.origin && (/\/portada\/?$/.test(referrer.pathname) || /\/empresa\/[a-z0-9-]+\/?$/.test(referrer.pathname));
            if (samePortal && window.history.length > 1) {
                event.preventDefault();
                window.history.back();
            }
        } catch (_) {
            // El href conserva el regreso a promociones si no hay historial utilizable.
        }
    });
})();
