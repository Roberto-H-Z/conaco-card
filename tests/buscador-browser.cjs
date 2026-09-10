const { chromium } = require('C:/Users/herre/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const fs = require('node:fs');
(async () => {
 const browser = await chromium.launch({headless:true, executablePath:'C:/Users/herre/.cache/puppeteer/chrome/win64-148.0.7778.97/chrome-win64/chrome.exe'});
 const page = await browser.newPage();
 const errors=[]; page.on('pageerror',e=>errors.push(e.message));
 fs.mkdirSync('.impeccable/review',{recursive:true});
 for (const width of [1440,375,768,1024]) {
  await page.setViewportSize({width,height:900});
  await page.goto('http://localhost/canaco-card/buscar',{waitUntil:'networkidle'});
  if (await page.evaluate(()=>document.documentElement.scrollWidth>innerWidth)) throw Error('Overflow '+width);
  await page.screenshot({path:'.impeccable/review/search-'+width+'.png',fullPage:true});
 }
 await page.setViewportSize({width:1440,height:900});
 await page.goto('http://localhost/canaco-card/portada');
 await page.locator('#cpHeroSearch').fill('cafe');
 await Promise.all([page.waitForURL('**/buscar?q=cafe'),page.locator('#cpHeroSearchBtn').click()]);
 const original=page.url();
 await page.locator('.cp-search-company').first().click();
 if (!page.url().includes('/empresa/')) throw Error('Ficha incorrecta');
 await page.locator('[data-profile-back]').click();
 await page.waitForURL(original);
 if (await page.locator('#busquedaTexto').inputValue()!=='cafe') throw Error('Filtros perdidos');
 await page.goto('http://localhost/canaco-card/buscar?q=zzzzsincoincidencia');
 if (!(await page.locator('.cp-search-empty').isVisible())) throw Error('Sin estado vacío');
 const invalid=await page.goto('http://localhost/canaco-card/buscar?ciudad=-1');
 if(invalid.status()!==400) throw Error('Sin validación HTTP');
 console.log(JSON.stringify({responsive:'375/768/1024/1440 sin overflow',navigation:'portada → buscar → ficha → regreso con filtros',errors}));
 await browser.close();
 if(errors.length) process.exitCode=1;
})();
