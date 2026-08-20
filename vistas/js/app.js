/** Utilidades globales del panel CANACO Card. */
document.addEventListener('DOMContentLoaded', () => {
    const contenido = document.getElementById('content_container');
    if (contenido) contenido.classList.add('canaco-module-enter');
    document.querySelectorAll('.canaco-nav-link').forEach(enlace => enlace.addEventListener('click', () => {
        document.body.classList.add('canaco-module-leaving');
    }));
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
    let cuerpo;
    try {
        cuerpo = await respuesta.json();
    } catch (_) {
        throw new Error('El servidor devolvió una respuesta inválida.');
    }

    if (!respuesta.ok) {
        const error = new Error(cuerpo.message || `Error HTTP ${respuesta.status}`);
        error.errors = cuerpo.errors || {};
        throw error;
    }

    return cuerpo;
}
