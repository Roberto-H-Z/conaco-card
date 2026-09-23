/** Utilidades globales del panel CANACO Card. */
// Las entradas por sección se coordinan en fichas-motion.js, sin retrasar los enlaces.
document.addEventListener('DOMContentLoaded', () => {
    // Son enlaces directos, no submenús. Enter conserva su navegación nativa;
    // evita que KTMenu intente abrir un submenú inexistente en estas dos opciones.
    document.querySelectorAll('#sidebar a.canaco-nav-link').forEach(link => {
        link.addEventListener('keydown', event => { if (event.key === 'Enter') event.stopPropagation(); });
    });
});

document.addEventListener('DOMContentLoaded', () => {
    const botonMenu = document.getElementById('sidebarToggle');
    if (!botonMenu) return;

    const aplicarMenu = (oculto, guardar = true) => {
        document.body.classList.toggle('canaco-sidebar-hidden', oculto);
        botonMenu.setAttribute('aria-expanded', oculto ? 'false' : 'true');
        botonMenu.setAttribute('aria-label', oculto ? 'Mostrar menú lateral' : 'Ocultar menú lateral');
        botonMenu.title = oculto ? 'Mostrar menú lateral' : 'Ocultar menú lateral';
        const icono = document.getElementById('sidebarToggleIcon');
        if (icono) {
            icono.classList.toggle('ki-menu', !oculto);
            icono.classList.toggle('ki-arrow-right', oculto);
        }
        if (guardar) localStorage.setItem('canaco-sidebar-hidden', oculto ? '1' : '0');
    };

    aplicarMenu(localStorage.getItem('canaco-sidebar-hidden') === '1', false);
    botonMenu.addEventListener('click', () => aplicarMenu(!document.body.classList.contains('canaco-sidebar-hidden')));
});

document.addEventListener('DOMContentLoaded', () => {
    const toggle = document.getElementById('themeToggle');
    if (!toggle) return;

    const aplicarTema = (tema, guardar = true) => {
        const oscuro = tema === 'dark';
        const root = document.documentElement;
        root.classList.toggle('dark', oscuro);
        root.classList.toggle('light', !oscuro);
        root.setAttribute('data-kt-theme-mode', tema);
        root.style.colorScheme = tema;
        toggle.setAttribute('aria-pressed', oscuro ? 'true' : 'false');
        toggle.setAttribute('aria-label', oscuro ? 'Activar tema claro' : 'Activar tema oscuro');
        toggle.title = oscuro ? 'Cambiar a tema claro' : 'Cambiar a tema oscuro';
        if (guardar) {
            localStorage.setItem('canaco-theme', tema);
            localStorage.setItem('kt-theme', tema);
        }
    };

    const temaInicial = document.documentElement.classList.contains('dark') ? 'dark' : 'light';
    aplicarTema(temaInicial, false);
    toggle.addEventListener('click', () => {
        aplicarTema(document.documentElement.classList.contains('dark') ? 'light' : 'dark');
    });
});

// Registra actividad real mientras se edita una página sin navegar por el panel.
document.addEventListener('DOMContentLoaded', () => {
    const csrf = document.querySelector('meta[name="csrf-token"]')?.content;
    if (!csrf) return;

    const url = new URL('sesion/actividad', window.location.origin + document.body.dataset.baseUrl);
    let ultimoEnvio = Date.now();
    let enviando = false;
    let vencida = false;

    const registrar = event => {
        if (!event.isTrusted || document.visibilityState !== 'visible' || enviando || vencida) return;
        const ahora = Date.now();
        if (ahora - ultimoEnvio < 60_000) return;
        ultimoEnvio = ahora;
        enviando = true;
        fetch(url, {
            method: 'POST',
            headers: { 'X-CSRF-TOKEN': csrf, Accept: 'application/json' },
            credentials: 'same-origin'
        }).then(respuesta => {
            if (respuesta.status === 401 || respuesta.status === 419) {
                vencida = true;
                window.alert('Tu sesión terminó. Copia los cambios que no hayas guardado e inicia sesión nuevamente.');
            }
        }).catch(() => {
            // Un fallo de red no debe crear una ráfaga de intentos por cada tecla.
            ultimoEnvio = Date.now() - 45_000;
        }).finally(() => { enviando = false; });
    };

    for (const tipo of ['pointerdown', 'keydown', 'wheel']) {
        document.addEventListener(tipo, registrar, { capture: true, passive: true });
    }
});

async function canacoAjax(ruta, datos = {}, metodo = 'POST') {
    const baseUrl = document.body.dataset.baseUrl || '/';
    const url = new URL(ruta.replace(/^\/+/, ''), window.location.origin + baseUrl);
    const method = metodo.toUpperCase();
    const opciones = {
        method,
        headers: {
            Accept: 'application/json',
            'X-Requested-With': 'XMLHttpRequest'
        }
    };

    if (method === 'GET') {
        Object.entries(datos).forEach(([clave, valor]) => {
            if (valor !== '' && valor !== null && valor !== undefined) {
                url.searchParams.set(clave, valor);
            }
        });
    } else if (datos instanceof FormData) {
        const csrf = document.querySelector('meta[name="csrf-token"]')?.content || '';
        opciones.headers['X-CSRF-TOKEN'] = csrf;
        if (!datos.has('csrf_token')) datos.set('csrf_token', csrf);
        opciones.body = datos;
    } else {
        opciones.headers['Content-Type'] = 'application/json';
        const csrf = document.querySelector('meta[name="csrf-token"]')?.content || '';
        opciones.headers['X-CSRF-TOKEN'] = csrf;
        opciones.body = JSON.stringify({ ...datos, csrf_token: csrf });
    }

    const respuesta = await fetch(url, opciones);
    const textoRespuesta = await respuesta.text();
    let cuerpo;
    try {
        cuerpo = textoRespuesta ? JSON.parse(textoRespuesta) : {};
    } catch (_) {
        const referencia = respuesta.headers.get('X-Request-ID') || '';
        console.error('Respuesta no JSON del servidor.', {
            url: url.toString(),
            status: respuesta.status,
            contentType: respuesta.headers.get('Content-Type') || '',
            referencia,
            respuesta: textoRespuesta.slice(0, 1000)
        });
        const sufijo = referencia ? ` Referencia: ${referencia}.` : '';
        throw new Error(`El servidor respondió con HTTP ${respuesta.status}, pero no entregó un mensaje válido.${sufijo}`);
    }

    if (!respuesta.ok) {
        const error = new Error(cuerpo.message || `Error HTTP ${respuesta.status}`);
        error.errors = cuerpo.errors || {};
        error.reference = cuerpo.reference || respuesta.headers.get('X-Request-ID') || '';
        error.httpStatus = respuesta.status;
        throw error;
    }

    return cuerpo;
}
