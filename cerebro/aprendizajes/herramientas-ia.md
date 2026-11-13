# Herramientas de IA vistas en redes

Publicaciones que Henry guardó. Revisadas el 2026-11-13.

## 7 sistemas aburridos (automatizar contenido)
- Fuente: Facebook, Juanbertorello.ia — https://www.facebook.com/share/p/1Quf8D4RYK/
- Qué es: guía de 7 "sistemas" para publicar contenido con Claude: 1 solo día de grabación,
  cascada de contenido (1 pieza → hasta 7 redes), bóveda de contenidos (tabla de piezas por estado),
  espacios de nutrición (Instagram, guías, mail) y otros 3.
- Guía completa: https://juanbertorello.com/r/7-sistemas-aburridos
- 2026-11-13 La guía pide registrar un correo para verla completa; sin registro solo se ve el sistema 01 → Henry debe registrarse y pasar el contenido, o usar el carrusel de Instagram @juanbertorello.ia.

## 500-AI-Agents-Projects (GitHub)
- Fuente: Facebook, Hardened Security GT — https://www.facebook.com/share/1CavULabEj/
- Repo: https://github.com/ashishpatel26/500-AI-Agents-Projects (licencia MIT, ~39k estrellas)
- Qué es: colección de 500+ casos de uso de agentes de IA por industria (salud, finanzas,
  educación, retail…) con enlaces a implementaciones open source y un curso de CrewAI + MCP.
- 2026-11-13 Sí está en GitHub (actualizado 2026-11). NO trae skills (ningún SKILL.md): la carpeta `agents/` tiene 21 agentes de ejemplo (investigación web, revisión de código, preguntas sobre PDF, SQL, correos, CV, ofertas de trabajo, redes sociales…) → sirve de inspiración para crear skills con `crear-skill`, no para instalar.
- 2026-11-13 Clonado en `Desktop/500-AI-Agents-Projects`, sin instalar. Los agentes usan la API de OpenAI (de pago) → Henry eligió no usarlos; pedirle a Claude el informe directamente.

## Buzzy + Claude Code (webs interactivas premium)
- Fuente: Facebook, Web by Varis (colaboración pagada con Buzzy Now) — https://www.facebook.com/share/v/1FBCNzHCax/
- Qué es: video que genera una web interactiva con animaciones que siguen el mouse,
  con un solo prompt usando el MCP de Buzzy (@buzzy_agent) + Claude Code. Hashtags: #seedance25 (video IA).
- 2026-11-13 `npx skills find buzzy` y GitHub no muestran ninguna skill ni MCP oficial de Buzzy → no instalar; si se quiere, conseguir el MCP desde la web oficial de Buzzy (requiere cuenta). Es publicidad pagada.

## Lote 2 (2026-11-13): ideas para sitios web y Claude Code
Henry quiere aplicarlas en sus sitios, **siempre gratis**.

### Para sitios web
- **Web 3D con scroll** (Brandon the Web Dev, "Websites after Claude Fable 5.2") — https://www.facebook.com/share/r/1DXuiJcCWt/
  Imagen o video que avanza al hacer scroll (rascacielos de noche, título gigante). Gratis: secuencia de imágenes en `<canvas>` + GSAP ScrollTrigger. Su "marco" se pide comentando HOW.
- **Web de constructora** (Ascenta) — https://www.facebook.com/share/r/1E4pqSGRfx/
  Hero a pantalla completa con foto o video de la obra y menú minimalista. Gratis: video de Pexels o foto propia + animaciones al hacer scroll.
- **Mejorar el diseño que hace Claude** (Migue.baena) — https://www.facebook.com/share/r/1E56qKYSar/
  4 herramientas (no se leyó la lista completa); una extrae el sistema de diseño de una web (colores, tipografía, animaciones) a `DESIGN.md` + una `.skill`. Ya tenemos parecido: `design-system`, `brand`, `design-taste-frontend`, `ui-ux-pro-max`.
- **Astryx, sistema de diseño de Meta** (naiker.codes) — https://www.facebook.com/share/p/19k5dAWY4Y/
  Verificado: https://github.com/meta/astryx (~27k estrellas). Gratis y open source: 150+ componentes React accesibles, 7 temas, modo oscuro, compatible con Tailwind, CLI pensada para agentes de IA.
- **10 estilos para que las imágenes/videos no parezcan IA** (Viral District) — https://www.facebook.com/share/p/19geUhXRGe/
  Escribir el nombre en inglés en el prompt: Woodblock Print, Pixel Art, Noir Comic, 1930s Cartoon, Brick Toy, Clay Diorama, CRT Vector, Knitted Puppet, PS2 Style, Sumi Ink. Útil para ilustraciones de los sitios.
- **Prueba de carga con Grafana k6** (Adriano) — https://www.facebook.com/share/r/19u6ymfRpj/
  Gratis y open source: simula muchos usuarios a la vez para ver si la web aguanta (p. ej. 1.000 reservas en Tauros) antes de lanzarla.

### Para Claude Code (no son de webs)
- **5 herramientas para Claude Code** (Manu Lizama) — https://www.facebook.com/share/r/18jiCfMcvs/
  1) Omni (descripción no legible) 2) Claude Mem, memoria entre sesiones (https://github.com/thedotmack/claude-mem) 3) Headroom, menos tokens 4) Claude Code Setup, plugin oficial que recomienda hooks, skills y MCP 5) Task Observer, aprende cómo trabajas y mejora tus skills. → revisar antes de instalar; Claude Mem se solapa con nuestro `cerebro`.
- **7 agentes de Claude en 10 min** (Juanbertorello.ia) — https://www.facebook.com/share/r/19rq87Soar/ → el prompt se pide comentando PROMPT.
- **Claude conectado a Meta Ads** (Felipe Vergara) — https://www.facebook.com/share/v/18ds2JFg8h/ → relacionado con las skills `claude-ads`.
