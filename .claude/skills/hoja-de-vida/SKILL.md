---
name: hoja-de-vida
description: Crea, mejora y adapta la hoja de vida (CV) de Henry y lo ayuda a postularse a ofertas de trabajo. Úsala cuando diga "mi hoja de vida", "mi CV", "actualiza mi CV", "mejora mi hoja de vida", "agrega este proyecto al CV", "busca ofertas", "postúlame a…", "aplica a esta oferta", "carta de presentación", o pegue el enlace o el texto de una oferta de empleo.
---

# Hoja de vida y postulaciones

Herramienta: **RenderCV** (YAML → PDF). Si no está instalada: `pip install "rendercv[full]"`.

## Dónde vive todo
`CEREBRO` = `~/Desktop/Claude/` (Windows: `%USERPROFILE%\Desktop\Claude\`).

```
CEREBRO/privado/hoja-de-vida/          ← NO se sube a GitHub (está en .gitignore)
├── cv-maestro.yaml                    ← la hoja de vida completa (fuente de verdad)
├── postulaciones.md                   ← registro de todas las postulaciones
└── postulaciones/AAAA-MM-DD-empresa-cargo/
    ├── oferta.md                      ← texto de la oferta
    ├── cv.yaml + PDF                  ← CV adaptado a esa oferta
    └── carta.md                       ← carta de presentación
```

Si `privado/hoja-de-vida/cv-maestro.yaml` no existe, cópialo de `plantillas/cv-maestro.yaml`
(junto a este SKILL.md) y pide a Henry los campos `(COMPLETAR)`.

**Privacidad:** el repo SKILLS es público. Teléfono, correo, documento y postulaciones van
SOLO en `privado/`. Antes de cualquier `git add`, verifica que `privado/` siga en `.gitignore`.

## Regla de oro
**Nunca inventes.** No agregues habilidades, empresas, cargos, fechas, títulos ni cifras que
no estén en el CV maestro o que Henry no haya confirmado. Si falta un dato, pregúntalo.
Adaptar = elegir, reordenar y redactar mejor lo que es verdad.

## Modo 1: Actualizar el CV maestro
Cuando Henry termina un proyecto, consigue un trabajo, un curso o un logro:
1. Agrégalo a `cv-maestro.yaml` en la sección correcta.
2. Si es un repo de GitHub, lee su README para sacar tecnologías y funciones reales.
3. Genera el PDF: `rendercv render cv-maestro.yaml` y revisa que no haya errores.

## Modo 2: Mejorar la hoja de vida
Revisa el CV con esta lista y propone cambios concretos (antes → después):
- [ ] Cada viñeta empieza con un verbo de acción (Desarrollé, Implementé, Automaticé, Diseñé).
- [ ] Cada viñeta dice **qué** hizo, **con qué** y **qué resultado** (cifra si Henry la tiene:
      usuarios, tiempo ahorrado, % de mejora). Si no hay cifra, pregúntala; no la inventes.
- [ ] Perfil de 2-3 líneas orientado al tipo de cargo que busca.
- [ ] Proyectos más fuertes primero; enlaces a la demo publicada.
- [ ] Habilidades agrupadas y coherentes con los proyectos (nada que no se pueda demostrar).
- [ ] Máximo 1 página para practicante/junior, 2 si hay experiencia.
- [ ] Compatible con ATS: tema `classic`, sin tablas ni imágenes, títulos estándar
      (Perfil, Educación, Experiencia, Proyectos, Habilidades).
- [ ] Sin errores de ortografía; fechas en el mismo formato.
Aplica solo los cambios que Henry apruebe.

## Modo 3: Buscar ofertas
1. Pregunta (o lee de `postulaciones.md`) qué busca: cargo, ciudad o remoto, práctica/junior.
2. Busca en la web ofertas recientes (LinkedIn, Computrabajo, elempleo, Magneto, Torre,
   Get on Board, páginas de empleo de empresas). Prioriza las de los últimos 15 días.
3. Muestra una tabla: empresa, cargo, ciudad/remoto, enlace, % de coincidencia con el CV,
   y qué requisito le falta. Henry elige a cuáles postular.

## Modo 4: Postular a una oferta
Para cada oferta elegida:
1. **Leer la oferta** (enlace o texto) y guardarla en `postulaciones/<fecha-empresa-cargo>/oferta.md`.
2. **Analizar coincidencia:** requisitos obligatorios vs. deseables; cuáles cumple Henry según
   el CV maestro; palabras clave que usa la oferta. Si no cumple lo obligatorio, díselo antes de seguir.
3. **CV adaptado:** copia `cv-maestro.yaml` a `cv.yaml` y:
   - ajusta `headline` y el perfil al cargo,
   - pon primero los proyectos y habilidades más relevantes; quita lo que no aporta,
   - usa las mismas palabras de la oferta **solo** donde describan algo real.
   Genera el PDF con `rendercv render cv.yaml`.
4. **Carta de presentación** (`carta.md`): 3 párrafos, máximo 250 palabras, nombrando la empresa
   y 2-3 proyectos concretos que encajan con la oferta.
5. **Enviar la postulación:**
   - Si el sitio permite enviarla, usa el navegador (skill `chrome-browser` o `built-in-browser`)
     para llenar el formulario y adjuntar el PDF.
   - **Detente antes de hacer clic en "Enviar/Postular"** y muestra a Henry lo que se va a enviar.
     Solo envía con su confirmación explícita para esa oferta.
   - Si pide iniciar sesión, captcha o preguntas personales (salario, documento), pásaselo a Henry.
   - No uses bots masivos ni postulaciones automáticas en serie: los portales los prohíben y
     pueden bloquear la cuenta.
6. **Registrar** en `postulaciones.md`:
   `| AAAA-MM-DD | Empresa | Cargo | Enlace | Coincidencia % | Estado | Próximo paso |`
   Estados: Preparada → Enviada → Entrevista → Oferta / Rechazada / Sin respuesta.

## Seguimiento
Cuando Henry pregunte "¿cómo van mis postulaciones?", lee `postulaciones.md`, resume por estado
y sugiere seguimiento para las que llevan más de 10 días en "Enviada" (correo corto de seguimiento).

## Extra: Resume Matcher (opcional)
Para un puntaje ATS más fino, Henry puede instalar Resume Matcher (Docker) y conectarlo a
Claude Code por MCP. Ver `CEREBRO/cerebro/aprendizajes/herramientas-cv.md`.
