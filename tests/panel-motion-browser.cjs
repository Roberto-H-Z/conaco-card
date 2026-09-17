// Solo lectura: no crea ni actualiza registros. Proporcionar credenciales de prueba por entorno.
const assert = require('node:assert/strict');
const { chromium } = require(process.env.PLAYWRIGHT_PATH || 'C:/Users/herre/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const base = process.env.BASE_URL || 'http://localhost/canaco-card';
(async () => {
    assert(process.env.CANACO_TEST_EMAIL && process.env.CANACO_TEST_PASSWORD, 'Faltan credenciales de prueba en entorno');
    const browser = await chromium.launch({ headless: true, executablePath: process.env.CHROME_PATH || 'C:/Users/herre/.cache/puppeteer/chrome/win64-148.0.7778.97/chrome-win64/chrome.exe' });
    try {
        const page = await browser.newPage({ viewport: { width: 1440, height: 900 } });
        const errors = [];
        page.on('pageerror', e => errors.push(e.stack));
        await page.addInitScript(() => {
            window.panelResult = null;
            window.addEventListener('pagereveal', event => {
                if (!event.viewTransition) return;
                event.viewTransition.ready.then(() => {
                    window.panelResult = document.getAnimations().filter(a => a.animationName === 'canaco-panel-in').map(a => ({ duration: a.effect.getTiming().duration, delay: a.effect.getTiming().delay, frames: a.effect.getKeyframes() }));
                }).catch(() => {});
            });
        });
        await page.goto(base + '/login');
        await page.locator('#correo').fill(process.env.CANACO_TEST_EMAIL);
        await page.locator('#password').fill(process.env.CANACO_TEST_PASSWORD);
        await page.locator('button[type=submit]').click();
        await page.waitForURL('**/afiliados');
        for (const route of ['promociones', 'afiliados', 'promociones']) {
            await page.locator('#sidebar a.canaco-nav-link[href$="/' + route + '"]').click();
            await page.waitForURL(base + '/' + route);
            await page.waitForTimeout(800);
            const result = await page.evaluate(() => window.panelResult);
            assert.equal(result?.length, 7, 'Faltan bloques de entrada: ' + JSON.stringify(result));
            assert.deepEqual([...new Set(result.map(a => a.delay))].sort((a,b) => a-b), [0,70,140,210,280]);
            assert(result.every(a => a.duration === 700));
            await page.waitForFunction(() => !document.querySelector('[data-panel-shared]'), { timeout: 5000 });
        }
        await page.goBack();
        await page.waitForTimeout(800);
        assert.equal(page.url(), base + '/afiliados');
        await page.locator('#sidebar a.canaco-nav-link[href$="/promociones"]').focus();
        await page.keyboard.press('Enter');
        await page.waitForURL(base + '/promociones');
        await page.waitForTimeout(100);
        assert.equal(await page.evaluate(() => document.getAnimations().filter(a => a.animationName === 'canaco-panel-in').length), 0);
        await page.locator('form[role=search] button[type=submit]').click();
        await page.waitForTimeout(200);
        assert.equal(await page.evaluate(() => document.getAnimations().filter(a => a.animationName === 'canaco-panel-in').length), 0, 'Filtrar no debe repetir entrada');
        await page.emulateMedia({ reducedMotion: 'reduce' });
        await page.goto(base + '/afiliados');
        assert.equal(await page.evaluate(() => document.getAnimations().filter(a => a.animationName === 'canaco-panel-in').length), 0);
        for (const width of [375,768,1024,1440]) {
            await page.setViewportSize({ width, height: 900 });
            for (const route of ['afiliados', 'promociones']) {
                await page.goto(base + '/' + route);
                assert.equal(await page.evaluate(() => document.documentElement.scrollWidth > innerWidth), false, 'Overflow ' + route + ' ' + width);
            }
        }
        assert.deepEqual(errors, []);
        console.log('OK: 7 bloques escalonados, 700 ms/70 ms, ambos sentidos, Atrás, teclado, filtros, movimiento reducido, 4 tamaños; sin escrituras.');
    } finally { await browser.close(); }
})().catch(e => { console.error(e); process.exitCode = 1; });
