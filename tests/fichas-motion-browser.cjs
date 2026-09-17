// Pruebas de solo lectura. BASE_URL, PLAYWRIGHT_PATH y CHROME_PATH son opcionales.
const assert = require('node:assert/strict');
const { chromium } = require(process.env.PLAYWRIGHT_PATH || 'C:/Users/herre/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const base = process.env.BASE_URL || 'http://localhost/canaco-card';
(async () => {
    const browser = await chromium.launch({ headless: true, executablePath: process.env.CHROME_PATH || 'C:/Users/herre/.cache/puppeteer/chrome/win64-148.0.7778.97/chrome-win64/chrome.exe' });
    try {
        const context = await browser.newContext({ viewport: { width: 1440, height: 900 } });
        await context.addInitScript(() => {
            window.motionResult = null;
            window.addEventListener('pagereveal', event => {
                if (!event.viewTransition) return;
                event.viewTransition.ready.then(() => {
                    window.motionResult = { ready: true, shared: !!document.querySelector('[data-motion-shared]'), animations: document.getAnimations().map(a => ({ duration: a.effect.getTiming().duration, frames: a.effect.getKeyframes() })) };
                }).catch(error => { window.motionResult = { skipped: error.name }; });
            });
        });
        const page = await context.newPage();
        const errors = [];
        page.on('pageerror', error => errors.push(error.message));
        await page.goto(base + '/portada');
        const company = page.locator('[data-affiliate-link]').first();
        const companyUrl = await company.evaluate(el => el.href);
        await company.click();
        await page.waitForURL(companyUrl);
        await page.waitForTimeout(750);
        let motion = await page.evaluate(() => window.motionResult);
        assert.equal(motion?.ready, true, JSON.stringify(motion));
        assert.equal(motion.shared, true, 'La tarjeta no comparte imagen con la ficha');
        assert(motion.animations.some(a => a.duration === 500));
        assert.equal(await page.locator('[data-motion-shared]').count(), 0, 'Nombre compartido sin limpiar');
        const firstMotion = motion;
        await page.goto(base + '/portada');
        const promotionUrl = await page.locator('[data-promotion-link]').first().evaluate(el => el.href);
        // El carrusel se detiene al usar el teclado, pero aquí probamos la navegación con puntero.
        await page.locator('[data-promotion-link]').first().evaluate(el => el.scrollIntoView({ block: 'center' }));
        await page.locator('[data-promotion-link]').first().click({ force: true });
        await page.waitForURL(promotionUrl);
        await page.waitForTimeout(750);
        motion = await page.evaluate(() => window.motionResult);
        assert.equal(motion?.ready, true, JSON.stringify(motion));
        assert.equal(motion.shared, true);
        const affiliateLink = page.locator('[data-affiliate-link]').first();
        const relatedUrl = await affiliateLink.evaluate(el => el.href);
        await affiliateLink.click();
        await page.waitForURL(relatedUrl);
        await page.waitForTimeout(650);
        assert.equal((await page.evaluate(() => window.motionResult))?.ready, true);
        await page.goBack();
        await page.waitForTimeout(650);
        assert.equal(page.url(), promotionUrl);
        await page.reload();
        for (const width of [375, 768, 1024, 1440]) {
            await page.setViewportSize({ width, height: 900 });
            for (const url of [companyUrl, promotionUrl]) {
                await page.goto(url);
                await page.waitForTimeout(750);
                assert.equal(await page.evaluate(() => document.documentElement.scrollWidth > innerWidth), false, 'Desbordamiento a ' + width);
            }
        }
        await page.goto(base + '/portada');
        await page.locator('[data-affiliate-link]').first().focus();
        await page.keyboard.press('Enter');
        await page.waitForURL(companyUrl);
        await page.waitForTimeout(200);
        assert.equal(await page.locator('html').evaluate(el => el.classList.contains('cp-motion-quiet')), true);
        await page.emulateMedia({ reducedMotion: 'reduce' });
        await page.goto(promotionUrl);
        assert.equal(await page.locator('.cp-promotion-reveal').first().evaluate(el => getComputedStyle(el).animationName), 'none');
        const noScript = await browser.newContext({ javaScriptEnabled: false });
        const plain = await noScript.newPage();
        await plain.goto(base + '/portada');
        await plain.locator('[data-affiliate-link]').first().click();
        await plain.waitForURL(companyUrl);
        assert.equal(await plain.locator('.cp-profile-identity').count(), 1);
        await noScript.close();
        if (process.env.CANACO_TEST_EMAIL && process.env.CANACO_TEST_PASSWORD) {
            await page.emulateMedia({ reducedMotion: 'no-preference' });
            await page.goto(base + '/login');
            await page.locator('#correo').fill(process.env.CANACO_TEST_EMAIL);
            await page.locator('#password').fill(process.env.CANACO_TEST_PASSWORD);
            await page.locator('button[type="submit"]').click();
            await page.waitForURL('**/afiliados');
            await page.locator('.btn-ver').first().click();
            await page.waitForTimeout(100);
            assert.equal(await page.locator('#modalInformacion .canaco-modal-dialog').evaluate(el => getComputedStyle(el).transitionDuration), '0.5s');
            await page.locator('#modalInformacion button[data-info-close]').first().click();
            await page.waitForTimeout(300);
            assert.equal(await page.locator('#modalInformacion').evaluate(el => el.hidden), true);
            await page.locator('.btn-editar').first().click();
            await page.locator('#modalAfiliado.is-open').waitFor();
            await page.evaluate(() => {
                const modal = document.getElementById('modalAfiliado');
                canacoMotion.close(modal);
                setTimeout(() => canacoMotion.open(modal), 80);
            });
            await page.waitForTimeout(600);
            assert.equal(await page.locator('#modalAfiliado').evaluate(el => el.hidden), false, 'Cierre obsoleto ocultó el modal reabierto');
            await page.keyboard.press('Escape');
            await page.waitForTimeout(50);
            assert.equal(await page.locator('#modalAfiliado').evaluate(el => el.hidden), true);
            await page.goto(base + '/promociones');
            await page.locator('.btn-editar-promocion').first().click();
            await page.locator('#modalPromocion.is-open').waitFor();
            assert.equal(await page.locator('#modalPromocion .canaco-modal-dialog').evaluate(el => getComputedStyle(el).transitionDuration), '0.5s');
            await page.locator('#modalPromocion button[data-promo-close]').first().click();
            await page.waitForTimeout(300);
            assert.equal(await page.locator('#modalPromocion').evaluate(el => el.hidden), true);
            console.log('Panel: consulta, editar afiliado/promoción, cierre y reapertura interrumpida OK. Sin guardar cambios.');
        }
        assert.deepEqual(errors, []);
        console.log(JSON.stringify({ public: 'entrada compartida 500 ms, cambio promoción/afiliado, historial y recarga OK', responsive: '375/768/1024/1440 OK', accessibility: 'teclado, movimiento reducido y sin JS OK', animationCount: firstMotion.animations.length, errors }));
    } finally { await browser.close(); }
})().catch(error => { console.error(error); process.exitCode = 1; });
