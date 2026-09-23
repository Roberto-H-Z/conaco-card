(() => {
    'use strict';
    const root = document.querySelector('[data-inicio-dashboard]');
    const source = document.getElementById('inicioChartData');
    if (!root || !source) return;
    let data;
    try { data = JSON.parse(source.textContent); } catch { return; }
    if (!Array.isArray(data.dias) || !data.dias.length || !Array.isArray(data.valores)) return;
    const fields = ['apariciones', 'visitas', 'contactos'];
    const number = new Intl.NumberFormat('es-MX');
    const date = new Intl.DateTimeFormat('es-MX', { day: 'numeric', month: 'short', timeZone: 'UTC' });
    const slider = root.querySelector('#inicioDia');
    const output = root.querySelector('#inicioDiaFecha');
    const values = root.querySelector('#inicioDiaValores');
    const cursor = root.querySelector('[data-chart-cursor]');
    const chart = root.querySelector('.inicio-line-chart');
    const toggleButtons = [...root.querySelectorAll('[data-series-toggle]')];
    const active = new Set(fields);
    function showDay(index) {
        index = Math.min(data.dias.length - 1, Math.max(0, index));
        const day = data.valores[index];
        const label = date.format(new Date(`${data.dias[index]}T00:00:00Z`));
        slider.value = String(index);
        slider.setAttribute('aria-valuetext', label);
        output.textContent = label;
        values.textContent = `${number.format(day.apariciones)} apariciones · ${number.format(day.visitas)} visitas · ${number.format(day.contactos)} contactos`;
        const x = 48 + index / Math.max(1, data.dias.length - 1) * 700;
        const line = cursor.querySelector('line');
        line.setAttribute('x1', x);
        line.setAttribute('x2', x);
        cursor.querySelectorAll('circle').forEach((point, i) => {
            point.setAttribute('cx', x);
            point.setAttribute('cy', 226 - Number(day[fields[i]]) / data.techo * 196);
            point.style.display = active.has(fields[i]) ? '' : 'none';
        });
    }
    root.querySelector('[data-chart-tools]').hidden = false;
    root.querySelector('[data-chart-inspector]').hidden = false;
    cursor.removeAttribute('hidden');
    showDay(data.dias.length - 1);
    slider.addEventListener('input', () => showDay(Number(slider.value)));
    // Clic o toque fija un día; el control nativo ofrece la misma acción por teclado.
    chart.addEventListener('click', event => {
        const point = chart.createSVGPoint();
        point.x = event.clientX;
        point.y = event.clientY;
        const matrix = chart.getScreenCTM();
        if (!matrix) return;
        const position = point.matrixTransform(matrix.inverse());
        showDay(Math.round((position.x - 48) / 700 * (data.dias.length - 1)));
    });
    toggleButtons.forEach(button => button.addEventListener('click', event => {
        const key = button.dataset.seriesToggle;
        if (active.has(key)) active.delete(key); else active.add(key);
        button.setAttribute('aria-pressed', String(active.has(key)));
        const line = root.querySelector(`[data-chart-series="${key}"]`);
        // El teclado cambia de estado inmediatamente, sin retrasar la navegación.
        line.style.transitionDuration = event.detail === 0 ? '0ms' : '';
        line.classList.toggle('is-hidden', !active.has(key));
        showDay(Number(slider.value));
    }));
})();
