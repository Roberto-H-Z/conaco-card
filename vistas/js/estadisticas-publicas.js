/** Registra acciones de contacto sin bloquear enlaces ni requerir el rastreo para navegar. */
'use strict';
(() => {
    const pagina = document.querySelector('[data-estadisticas-afiliado]');
    if (!pagina) return;
    const base = document.body.dataset.baseUrl || '/';
    const endpoint = new URL('estadisticas/evento', location.origin + base);
    const clasificar = enlace => {
        const href = enlace.getAttribute('href') || '';
        if (/^tel:/i.test(href)) return 'CLIC_TELEFONO';
        let url;
        try { url = new URL(href, location.href); } catch (_) { return null; }
        if (!/^https?:$/.test(url.protocol) || url.origin === location.origin) return null;
        const host = url.hostname.toLowerCase().replace(/^www\./, '');
        if (host === 'wa.me' || host === 'api.whatsapp.com') return 'CLIC_WHATSAPP';
        if ((host === 'google.com' && url.pathname.startsWith('/maps')) || host === 'maps.google.com' || host === 'maps.app.goo.gl') return 'CLIC_MAPA';
        if (host === 'facebook.com' || host.endsWith('.facebook.com') || host === 'fb.com') return 'CLIC_FACEBOOK';
        if (host === 'instagram.com' || host.endsWith('.instagram.com')) return 'CLIC_INSTAGRAM';
        if (['tiktok.com','youtube.com','youtu.be','x.com','twitter.com','linkedin.com'].some(red => host === red || host.endsWith('.' + red))) return 'CLIC_RED_SOCIAL';
        return 'CLIC_SITIO_WEB';
    };
    document.addEventListener('click', event => {
        if (!event.isTrusted || event.defaultPrevented) return;
        const enlace = event.target.closest('a[href]');
        if (!enlace || !pagina.contains(enlace)) return;
        const tipo = clasificar(enlace);
        if (!tipo) return;
        const datos = new FormData();
        datos.set('csrf_token', pagina.dataset.estadisticasToken);
        datos.set('afiliado', pagina.dataset.estadisticasAfiliado);
        datos.set('tipo', tipo);
        if (pagina.dataset.estadisticasPromocion) datos.set('promocion', pagina.dataset.estadisticasPromocion);
        if (navigator.sendBeacon) navigator.sendBeacon(endpoint, datos);
        else fetch(endpoint, { method: 'POST', body: datos, credentials: 'same-origin', keepalive: true }).catch(() => {});
    }, { capture: true });
})();
