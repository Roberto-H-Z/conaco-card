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

            const fromSearch = referrer && referrer.origin === window.location.origin && /\/buscar\/?$/.test(referrer.pathname);
            if ((fromSearch || (fromDirectory && origin === 'directory')) && window.history.length > 1) {
                event.preventDefault();
                window.history.back();
            }
        } catch (_) {
            // El enlace normal mantiene el regreso al directorio como respaldo.
        }
    });
})();

(function initGoogleMaps() {
    const section = document.querySelector('[data-google-maps-key]');
    const containers = [...document.querySelectorAll('[data-google-map]')];
    if (!section || containers.length === 0) return;

    const key = section.dataset.googleMapsKey || '';
    if (!key) {
        containers.forEach(container => { container.textContent = 'Mapa no disponible.'; });
        return;
    }

    window.canacoPublicMapsReady = () => {
        containers.forEach(container => {
            const position = { lat: Number(container.dataset.lat), lng: Number(container.dataset.lng) };
            if (!Number.isFinite(position.lat) || !Number.isFinite(position.lng)) return;
            const map = new google.maps.Map(container, {
                center: position,
                zoom: 16,
                mapTypeControl: false,
                streetViewControl: false,
                fullscreenControl: true,
                gestureHandling: 'cooperative'
            });
            new google.maps.Marker({ map, position, title: container.dataset.title || 'Ubicación' });
        });
    };

    const script = document.createElement('script');
    script.src = 'https://maps.googleapis.com/maps/api/js?key=' + encodeURIComponent(key) + '&loading=async&language=es&region=MX&callback=canacoPublicMapsReady';
    script.async = true;
    script.onerror = () => containers.forEach(container => { container.textContent = 'No fue posible cargar el mapa.'; });
    document.head.append(script);
})();
