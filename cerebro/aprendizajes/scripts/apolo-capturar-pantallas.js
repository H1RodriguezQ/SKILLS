// Renderiza las páginas web de Apolo con Firebase simulado (datos de ejemplo)
// y guarda cada una como HTML estático autocontenido para html_to_figma.
const { chromium } = require('playwright');
const fs = require('fs'), path = require('path');
const WEB = process.argv[2], OUT = process.argv[3];

const stub = `
const F = () => window.__FAKE;
export const initializeApp = () => ({});
export const initializeAppCheck = () => ({});
export class ReCaptchaV3Provider { constructor(){} }
export const getFirestore = () => ({});
export const doc = (db, ...p) => ({ path: p.join('/') });
export const collection = (db, ...p) => ({ path: p.join('/') });
export const serverTimestamp = () => ({});
export const updateDoc = async () => {};
export const setDoc = async () => {};
export const writeBatch = () => ({ set(){}, update(){}, delete(){}, commit: async () => { throw { code: 'permission-denied' }; } });
export const getDocs = async () => ({ empty: true, size: 0, docs: [], forEach(){} });
export const query = (...a) => a[0]; export const where = () => ({});
export const getDoc = async (ref) => { const d = F()[ref.path]; return { id: ref.path.split('/').pop(), exists: () => !!d, data: () => d }; };
`;

const fecha = (y,m,d,h=0,mi=0) => `({ toDate: () => new Date(${y},${m},${d},${h},${mi}) })`;
const baseFake = (extra='') => `window.__FAKE = {
  'graduandos_publico/g1': { nombreCompleto: 'Laura Martínez Gómez', programa: 'Ingeniería de Software', facultad: 'Facultad de Ingenierías', invitadosPermitidos: 2, cuposUsados: 0 },
  'configuracion/evento': { numeroCeremonia: 48, fechaCeremonia: ${fecha(2026,11,12,9,30)}, cierreRegistro: ${fecha(2027,0,30)},
     horasPorFacultad: { 'Facultad de Ingenierías': '9:30 a. m.' }, direccion: 'Calle 70 n.º 55-210', ciudad: 'Bucaramanga' },
  'invitados/i1': { nombreInvitado: 'Carlos Martínez Ruiz', graduandoId: 'g1', graduandoNombre: 'Laura Martínez Gómez', codigoQr: 'APL-7F3K-92QX-L4M8', confirmacion: 'pendiente', estado: 'activo', nombre: 'Carlos Martínez Ruiz' },
  'directivos/d1': { nombre: 'Dra. Ana Rodríguez Pérez', cargo: 'Decana', facultad: 'Facultad de Ingenierías', confirmacion: 'pendiente', codigoQr: 'DIR-4H8P-21ZT-Q9W3' },
}; ${extra}`;

const pantallas = [
  { nombre: '01-registro-invitados', url: 'invitados.html?id=g1', fake: baseFake() },
  { nombre: '02-invitacion-pendiente', url: 'confirmar.html?id=i1', fake: baseFake() },
  { nombre: '04-directivo-pendiente', url: 'directivos.html?id=d1', fake: baseFake() },
  { nombre: '05-mi-codigo-qr', url: 'mi-qr.html?id=i1', fake: baseFake("window.__FAKE['invitados/i1'].confirmacion='confirmado';") },
];

(async () => {
  const browser = await chromium.launch();
  const logo = 'data:image/png;base64,' + fs.readFileSync(path.join(WEB, 'assets/logos-udes-azul.png')).toString('base64');
  for (const p of pantallas) {
    const ctx = await browser.newContext({ viewport: { width: 390, height: 844 }, deviceScaleFactor: 1 });
    const page = await ctx.newPage();
    await page.addInitScript(p.fake);
    await page.route('https://www.gstatic.com/firebasejs/**', r => r.fulfill({ contentType: 'text/javascript', body: stub }));
    await page.route('https://www.google.com/recaptcha/**', r => r.abort());
    await page.route('http://apolo.local/**', r => {
      const f = path.join(WEB, new URL(r.request().url()).pathname);
      r.fulfill({ path: f });
    });
    const errores = [];
    page.on('pageerror', e => errores.push(e.message));
    await page.goto('http://apolo.local/' + p.url, { waitUntil: 'networkidle' });
    await page.waitForTimeout(2500); // animaciones de entrada
    const html = await page.evaluate((logo) => {
      document.querySelectorAll('canvas').forEach(c => { const i = document.createElement('img'); i.src = c.toDataURL(); i.width = c.width; i.height = c.height; i.style.cssText = c.style.cssText; c.replaceWith(i); });
      document.querySelectorAll('img').forEach(i => { if ((i.getAttribute('src')||'').includes('logos-udes')) i.src = logo; });
      document.querySelectorAll('script').forEach(s => s.remove());
      // Congela animaciones en su estado final
      const st = document.createElement('style'); st.textContent = '*,*::before,*::after{animation:none!important;transition:none!important;opacity:revert}';
      document.head.appendChild(st);
      return '<!doctype html>\n' + document.documentElement.outerHTML;
    }, logo);
    fs.writeFileSync(path.join(OUT, p.nombre + '.html'), html);
    await page.screenshot({ path: path.join(OUT, p.nombre + '.png'), fullPage: true });
    console.log(p.nombre, Math.round(html.length/1024) + ' KB', errores.length ? 'ERRORES: ' + errores.join(' | ') : 'ok');
    await ctx.close();
  }
  await browser.close();
})();
