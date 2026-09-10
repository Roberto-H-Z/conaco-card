'use strict';
(function () {
    const form = document.querySelector('[data-search-form]');
    if (!form) return;
    const button = form.querySelector('button[type="submit"]');
    form.addEventListener('submit', () => {
        if (!form.checkValidity()) return;
        button.querySelector('span').textContent = 'Buscando…';
        form.setAttribute('aria-busy', 'true');
    });
    window.addEventListener('pageshow', () => {
        button.querySelector('span').textContent = 'Buscar empresas';
        form.removeAttribute('aria-busy');
    });
    // Una única entrada para orientar; los resultados quedan disponibles durante ella.
    const results = document.querySelector('.cp-search-results');
    if (results && !matchMedia('(prefers-reduced-motion: reduce)').matches) {
        results.animate([{opacity:.55, transform:'translateY(8px)'}, {opacity:1, transform:'translateY(0)'}], {duration:200, easing:'cubic-bezier(0.23, 1, 0.32, 1)'});
    }
})();
