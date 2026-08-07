/**
 * CANACO Card — Global Javascript
 * 
 * Lógica general de la aplicación compartida en todos los módulos.
 */

document.addEventListener('DOMContentLoaded', () => {
    // Inicialización global
    console.log('CANACO Card - App Inicializada');

    // Aquí se pueden inicializar componentes que no sean cubiertos 
    // automáticamente por KTComponents de Metronic.
});

/**
 * Función auxiliar para realizar peticiones AJAX a la API interna.
 * 
 * @param {string} url Ruta relativa (ej: 'afiliados/lista')
 * @param {object} data Datos a enviar
 * @param {string} method GET o POST
 * @returns {Promise} 
 */
async function canacoAjax(url, data = {}, method = 'POST') {
    const fullUrl = window.location.pathname.replace(/\/+$/, '') + '/' + url.replace(/^\/+/, '');
    
    // Configuración base
    const options = {
        method: method,
        headers: {
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest'
        }
    };

    // Agregar CSRF Token si existe en el DOM (para métodos que modifican)
    const csrfInput = document.querySelector('input[name="csrf_token"]');
    if (csrfInput && method !== 'GET') {
        options.headers['X-CSRF-TOKEN'] = csrfInput.value;
    }

    if (method === 'GET') {
        const queryParams = new URLSearchParams(data).toString();
        if (queryParams) {
            fullUrl += '?' + queryParams;
        }
    } else {
        options.body = JSON.stringify(data);
    }

    try {
        const response = await fetch(fullUrl, options);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return await response.json();
    } catch (error) {
        console.error('CANACO AJAX Error:', error);
        throw error;
    }
}
