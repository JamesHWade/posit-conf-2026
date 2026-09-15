import {createRequire} from 'node:module';
import fs from 'node:fs/promises';
const require=createRequire(import.meta.url);
const {chromium}=require(process.env.PLAYWRIGHT_MODULE || 'playwright');
const browser=await chromium.launch({headless:true,executablePath:process.env.CHROME_PATH || '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'});
const page=await browser.newPage({viewport:{width:1600,height:900},deviceScaleFactor:1});
const errors=[];
const failures=[];
page.on('pageerror',e=>errors.push(e.message));
page.on('response',r=>{if(r.status()>=400&&!r.url().endsWith('/favicon.ico'))failures.push({url:r.url(),status:r.status()});});
const ids=['ode-to-shinychat','shinychat-history','shinychat-visuals','shinychat-commands','shinychat-drawer','shinychat'];
const output=process.env.SLIDE_REVIEW_DIR || '/private/tmp/shinychat-ode-review';
const baseUrl=process.env.SLIDE_BASE_URL || 'http://127.0.0.1:4349';
await fs.mkdir(output,{recursive:true});
try {
  await page.goto(`${baseUrl}/index.html#/ode-to-shinychat`);
  await page.waitForFunction(()=>window.Reveal?.isReady());
  await page.evaluate(()=>Reveal.configure({transition:'none',backgroundTransition:'none'}));
  await page.evaluate(()=>Promise.all([...document.images].map(i=>i.decode().catch(()=>{}))));
  const checks=[];
  for(const id of ids){
    await page.evaluate(id=>{const ss=[...document.querySelectorAll('.slides>section')];Reveal.slide(ss.findIndex(s=>s.id===id),0,-1);},id);
    await page.waitForTimeout(400);
    const check=await page.evaluate(()=>{
      const s=document.querySelector('section.present');const r=s.getBoundingClientRect();
      const overflow=[...s.querySelectorAll('h1,h3,p,img,figcaption,pre,.ode-capture-label,.ode-code-payoff,.ode-credit')].filter(e=>{
        if(e.closest('.notes'))return false;
        for(let n=e;n&&n!==s;n=n.parentElement){const c=getComputedStyle(n);if(c.visibility==='hidden'||c.display==='none'||Number(c.opacity)===0)return false;}
        const b=e.getBoundingClientRect();return b.width&&b.height&&(b.x<r.x-2||b.y<r.y-2||b.right>r.right+2||b.bottom>r.bottom+2);
      }).map(e=>({tag:e.tagName,class:e.className,text:e.innerText?.slice(0,90)}));
      return{id:s.id,overflow};
    });
    checks.push(check);
    await page.screenshot({path:`${output}/${id}.png`});
    if(id==='shinychat-visuals'){
      await page.evaluate(()=>Reveal.nextFragment());
      await page.waitForTimeout(400);
      await page.screenshot({path:`${output}/shinychat-tool.png`});
    }
  }
  const inventory=await page.evaluate(()=>({slides:document.querySelectorAll('.slides>section').length,missing:[...document.images].filter(i=>!i.naturalWidth).map(i=>i.src)}));
  const section=await page.evaluate(ids=>{
    const copy=document.documentElement.cloneNode(true);
    copy.querySelectorAll('.slides>section').forEach(s=>{if(!ids.includes(s.id))s.remove();});
    copy.querySelectorAll('.slides>section').forEach(s=>{s.classList.remove('present','past','future');s.removeAttribute('style');s.removeAttribute('aria-hidden');s.removeAttribute('hidden');});
    copy.querySelectorAll('.fragment').forEach(e=>e.classList.remove('visible','current-fragment'));
    copy.querySelectorAll('.slide-backgrounds,.backgrounds,.controls,.progress,.slide-number,.reveal-status').forEach(e=>e.remove());
    copy.querySelector('title').textContent='Ode to shinychat — AI Agents Deserve R';
    return '<!DOCTYPE html>\n'+copy.outerHTML.replace(/[ \t]+$/gm,'')+'\n';
  },ids);
  await fs.writeFile('shinychat-ode.html',section);
  await page.goto(`${baseUrl}/shinychat-ode.html#/ode-to-shinychat`);
  await page.waitForFunction(()=>window.Reveal?.isReady());
  const standaloneCount=await page.locator('.slides>section').count();
  await page.screenshot({path:`output/shinychat-ode.png`.replace('output',output)});
  const report={...inventory,standaloneCount,errors,failures,checks};
  await fs.writeFile(`${output}/verification.json`,JSON.stringify(report,null,2));
  console.log(JSON.stringify(report));
  if(errors.length||failures.length||inventory.missing.length||checks.some(c=>c.overflow.length)||standaloneCount!==6)process.exitCode=1;
} finally {await browser.close();}
