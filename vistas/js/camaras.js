'use strict';
document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('formCamara');
    if (!form) return;
    const modal = document.getElementById('modalCamara');
    const toast = document.getElementById('notificacionCamara');
    const guardar = document.getElementById('btnGuardarCamara');
    const filas = [...form.querySelectorAll('[data-ciudad]')];
    const buscador = document.getElementById('buscarCiudadCamara');
    let timer;
    const notice = (texto, error = false) => {
        clearTimeout(timer); toast.textContent = texto;
        toast.className = 'canaco-toast is-visible' + (error ? ' is-error' : ''); toast.hidden = false;
        timer = setTimeout(() => { toast.hidden = true; }, 4500);
    };
    const sync = fila => { fila.querySelector('select').disabled = !fila.querySelector('input').checked; };
    const filtrar = () => {
        const q = buscador.value.trim().toLocaleLowerCase('es');
        filas.forEach(fila => { fila.hidden = !fila.dataset.ciudad.includes(q); });
        document.getElementById('sinCiudadesCamara').hidden = filas.some(fila => !fila.hidden);
    };
    buscador.addEventListener('input', filtrar);
    filas.forEach(fila => fila.querySelector('input').addEventListener('change', () => sync(fila)));
    const clear = () => {
        form.querySelectorAll('[data-error]').forEach(el => { el.textContent = ''; });
        form.querySelectorAll('[aria-invalid]').forEach(el => el.removeAttribute('aria-invalid'));
    };
    const fresh = (datos = null) => {
        form.reset(); clear();
        form.elements.idCamara.value = datos?.idCamara || '';
        for (const campo of ['clave','nombre','nombre_corto','correo','telefono','idMunicipioSede','activo']) {
            if (datos) form.elements[campo].value = datos[campo] ?? '';
        }
        const seleccion = new Map((datos?.ciudades || []).map(c => [String(c.idMunicipio), c.tipo_cobertura]));
        filas.forEach(fila => {
            const check = fila.querySelector('input'), select = fila.querySelector('select');
            check.checked = seleccion.has(check.value);
            check.disabled = fila.dataset.activo !== '1' && !check.checked;
            select.value = seleccion.get(check.value) || 'DIRECTA'; sync(fila);
        });
        [...form.elements.idMunicipioSede.options].forEach(op => {
            op.disabled = op.dataset.activo === '0' && op.value !== String(datos?.idMunicipioSede || '');
        });
        document.getElementById('tituloModalCamara').textContent = datos ? 'Editar cámara y ciudades' : 'Registrar cámara';
        buscador.value = ''; filtrar();
        window.canacoMotion.open(modal);
    };
    document.getElementById('btnNuevaCamara').addEventListener('click', () => fresh());
    modal.querySelectorAll('[data-camara-close]').forEach(b => b.addEventListener('click', () => { if (!guardar.disabled) window.canacoMotion.close(modal); }));
    document.addEventListener('keydown', e => {
        if (e.key === 'Escape' && modal.classList.contains('is-open') && !guardar.disabled) window.canacoMotion.close(modal);
        if (e.key === 'Tab' && modal.classList.contains('is-open')) {
            const focusables = [...modal.querySelectorAll('button,input,select,a[href]')].filter(el => !el.disabled && el.type !== 'hidden' && el.getClientRects().length);
            const first = focusables[0], last = focusables.at(-1);
            if (e.shiftKey && (document.activeElement === first || document.activeElement === modal.querySelector('[role="dialog"]'))) { e.preventDefault(); last?.focus(); }
            else if (!e.shiftKey && document.activeElement === last) { e.preventDefault(); first?.focus(); }
        }
    });
    document.querySelectorAll('.btn-editar-camara').forEach(b => b.addEventListener('click', async () => {
        b.disabled = true;
        try { fresh((await canacoAjax('camaras/obtener', {id:b.dataset.id}, 'GET')).data); }
        catch (e) { notice(e.message, true); } finally { b.disabled = false; }
    }));
    const reload = mensaje => { sessionStorage.setItem('canaco_camara_mensaje', mensaje); location.reload(); };
    form.addEventListener('submit', async e => {
        e.preventDefault(); clear(); guardar.disabled = true;
        try { reload((await canacoAjax('camaras/guardar', new FormData(form), 'POST')).message); }
        catch (error) {
            for (const [campo, mensaje] of Object.entries(error.errors || {})) {
                const destino = form.querySelector('[data-error="' + campo + '"]');
                if (destino) destino.textContent = mensaje;
                form.elements[campo]?.setAttribute?.('aria-invalid', 'true');
            }
            form.querySelector('[aria-invalid="true"]')?.focus(); notice(error.message, true);
        } finally { guardar.disabled = false; }
    });
    document.querySelectorAll('.btn-estado-camara').forEach(b => b.addEventListener('click', async () => {
        const activo = b.dataset.activo === '1';
        if (!confirm((activo ? 'Activar' : 'Desactivar') + ' la cámara “' + b.dataset.nombre + '”?')) return;
        b.disabled = true;
        try { reload((await canacoAjax('camaras/cambiar-estado', {idCamara:b.dataset.id, activo}, 'POST')).message); }
        catch (error) { notice(error.message, true); } finally { b.disabled = false; }
    }));
    const mensaje = sessionStorage.getItem('canaco_camara_mensaje');
    if (mensaje) { sessionStorage.removeItem('canaco_camara_mensaje'); notice(mensaje); }
});
