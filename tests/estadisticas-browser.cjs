const { chromium } = require('C:/Users/herre/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const { execFileSync } = require('node:child_process');
const fs = require('node:fs');
const path = require('node:path');
const php = 'C:/xampp/php/php.exe';
const base = 'http://localhost/canaco-card/';
const out = path.resolve('tmp/estadisticas-qa');
fs.mkdirSync(out,{recursive:true});
(async()=>{
 const sesiones=JSON.parse(execFileSync(php,['tests/estadisticas-sesiones.php'],{encoding:'utf8'}));
 const browser=await chromium.launch({headless:true,executablePath:'C:/Users/herre/.cache/puppeteer/chrome/win64-148.0.7778.97/chrome-win64/chrome.exe'});
 const errores=[]; const resumen=[];
 try {
  const publico=await browser.newContext(); const p=await publico.newPage(); p.on('pageerror',e=>errores.push(e.message));
  for(const width of [320,390,768,1440]) {
   await p.setViewportSize({width,height:900}); await p.goto(base+'portada');
   await p.locator('#cpHeroSearch').waitFor();
   const posicion=await p.evaluate(()=>{const s=document.querySelector('.cp-hero-search').getBoundingClientRect(),t=document.querySelector('.cp-hero-title').getBoundingClientRect();return {s:s.top,t:t.top,overflow:document.documentElement.scrollWidth>innerWidth};});
   if(posicion.overflow) throw Error('Portada desborda en '+width);
   if(width<768 && (posicion.s>=posicion.t || posicion.s>100)) throw Error('Buscador no está arriba en móvil');
   if(width>=768 && posicion.s<=posicion.t) throw Error('Jerarquía de escritorio alterada');
   if(process.env.CANACO_QA_CAPTURE!=='0' && [390,1440].includes(width)) await p.screenshot({path:path.join(out,'portada-'+width+'.png'),fullPage:false});
   await p.goto(base+'buscar?q=cafe');
   if(await p.evaluate(()=>document.documentElement.scrollWidth>innerWidth)) throw Error('Búsqueda desborda en '+width);
  }
  await p.setViewportSize({width:390,height:844}); await p.goto(base+'portada'); await p.fill('#cpHeroSearch','cafe'); await Promise.all([p.waitForURL('**/buscar?q=cafe'),p.click('#cpHeroSearchBtn')]);
  const ficha=await p.locator('.cp-search-company').first().getAttribute('href');
  if(ficha) { await p.goto(new URL(ficha,base).href); if(await p.evaluate(()=>document.documentElement.scrollWidth>innerWidth)) throw Error('Ficha móvil desborda'); }
  resumen.push('Portada, buscador y ficha: móvil sin desbordamiento; escritorio conserva orden');
  for(const rol of ['ADMIN_GENERAL','ADMIN_CAMARA','AFILIADO']) {
   if(!sesiones[rol]) throw Error('Falta usuario local del perfil '+rol);
   const ctx=await browser.newContext(); await ctx.addCookies([{name:'PHPSESSID',value:sesiones[rol].sid,url:'http://localhost'}]);
   const page=await ctx.newPage(); page.on('pageerror',e=>errores.push(rol+': '+e.message));
   const ruta=rol==='AFILIADO'?'inicio':'estadisticas';
   for(const width of [320,390,768,1440]) {
    await page.setViewportSize({width,height:900}); const respuesta=await page.goto(base+ruta);
    if(respuesta.status()!==200 || await page.locator('[role=alert]').count()) throw Error('No cargó '+rol+' '+respuesta.status());
    if(await page.evaluate(()=>document.documentElement.scrollWidth>innerWidth)) throw Error(rol+' desborda en '+width);
    if(process.env.CANACO_QA_CAPTURE!=='0' && [390,1440].includes(width)) {
     await page.evaluate(()=>Promise.all(document.getAnimations().filter(a=>a.effect.getComputedTiming().iterations!==Infinity).map(a=>a.finished.catch(()=>{}))));
     await page.screenshot({path:path.join(out,rol+'-'+width+'.png'),fullPage:false});
    }
   }
   if(rol!=='AFILIADO') {
    for(const formato of ['xlsx','pdf']) {
     const reporte=await ctx.request.get(base+'estadisticas/exportar?formato='+formato);
     if(reporte.status()!==200) throw Error('No descarga resumen '+rol);
     fs.writeFileSync(path.join(out,rol+'-resumen.'+formato),await reporte.body());
    }
    const href=await page.locator('.estadisticas-tabla tbody .inicio-text-link').first().getAttribute('href');
    if(href) {
     const r=await page.goto(new URL(href,base).href); if(r.status()!==200 || !(await page.locator('[data-inicio-dashboard]').count())) throw Error('No carga detalle '+rol);
     await page.setViewportSize({width:390,height:844});
     await page.waitForFunction(()=>document.querySelector('.inicio-dashboard').getBoundingClientRect().width>innerWidth*.8);
     if(process.env.CANACO_QA_CAPTURE!=='0') await page.screenshot({path:path.join(out,rol+'-detalle-390.png'),fullPage:false});
    }
   }
   for(const formato of ['Excel','PDF']) {
    const [descarga]=await Promise.all([page.waitForEvent('download'),page.getByRole('link',{name:'Descargar '+formato}).click()]);
    await descarga.saveAs(path.join(out,rol+'-descarga.'+(formato==='Excel'?'xlsx':'pdf')));
   }
   if(rol==='ADMIN_CAMARA') {
    await page.goto(base+'estadisticas');
    const ajena=sesiones[rol].camara===1?2:1;
    for(const formato of ['xlsx','pdf']) { const r=await ctx.request.get(base+'estadisticas/exportar?camara='+ajena+'&formato='+formato); if(r.status()!==403) throw Error('Exportación permite cámara ajena'); }
   }
   if(rol==='AFILIADO') {
    const r=await page.goto(base+'estadisticas'); if(r.status()!==403) throw Error('Afiliado accede al resumen administrativo');
   }
   resumen.push(rol+': consulta y descarga de Excel/PDF verificadas'); await ctx.close();
  }
  const anon=await publico.request.get(base+'estadisticas/exportar?formato=pdf'); if(anon.status()!==401) throw Error('Descarga anónima no bloqueada');
  if(errores.length) throw Error(errores.join('\n'));
  console.log(JSON.stringify({checks:resumen,erroresJavaScript:errores}));
 } finally {
  await browser.close(); execFileSync(php,['tests/estadisticas-sesiones.php','limpiar'],{input:JSON.stringify(sesiones)});
 }
})().catch(e=>{console.error(e);process.exitCode=1;});
