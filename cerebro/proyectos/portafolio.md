# Portafolio

- **Repo:** (por crear: H1RodriguezQ/portafolio) — mientras tanto, solo en la sesión de nube de Claude
- **Tipo:** sitio personal estático (HTML/CSS/JS), para hoja de vida y postulaciones
- **Tecnologías:** HTML, CSS, JavaScript; Three.js 0.160 + GSAP 3.12.5 ScrollTrigger (página 3D)
- **Estado:** hecho y probado en navegador (sin errores, sin scroll horizontal en celular); falta publicar en Vercel

## Qué es
- `index.html`: portafolio oscuro con dorado (Fraunces + Space Grotesk), tema claro/oscuro, 7 proyectos con capturas reales.
- `caps-3d/`: página de producto 3D de CAPS Store: gorra hecha con formas en Three.js (6 paneles, visera curva, ojales, logo) que gira, cambia de vista y de color al hacer scroll. Idea tomada de "Web 3D con scroll" (herramientas-ia.md). Gratis, sin modelos ni créditos.

## Decisiones y notas
- 2026-11-15 Hecho con Fable 5.2 disponible (promo hasta el 16). Henry eligió portafolio + página 3D.
- No se inventaron datos: Tauros se etiqueta "Aplicación web" (no se sabe si es cliente real). Contacto solo con GitHub hasta que Henry dé correo y LinkedIn.
- Respeta `prefers-reduced-motion`. Scripts de GSAP con integridad SRI.
- PENDIENTE: crear repo vacío `portafolio`, subir, importar en Vercel; agregar correo/LinkedIn; enlazar el portafolio desde la hoja de vida (`hoja-de-vida`).
