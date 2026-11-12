---
name: crear-skill
description: Crea una skill nueva y funcional a partir de una tarea que Henry repite o de un proceso que explica. Úsala cuando diga "crea una skill", "hazme una skill para…", "convierte esto en skill", "quiero que siempre hagas X así", o cuando notes que la misma tarea se ha hecho 2 o más veces.
---

# Crear una skill nueva

## Dónde está todo (funciona desde cualquier proyecto)
Las skills se crean SIEMPRE en el repo del cerebro, no en el proyecto actual:

- **Repo del cerebro (CEREBRO):** `~/Desktop/Claude/`
  (Windows: `%USERPROFILE%\Desktop\Claude\`, p. ej. `C:\Users\PC HENRY\Desktop\Claude\`).
  Si no está ahí, búscalo en la carpeta actual o pregunta a Henry.
- Plantilla: `CEREBRO/plantillas/SKILL.md`
- Catálogo: `CEREBRO/cerebro/catalogo-skills.md`
- Skills: `CEREBRO/.claude/skills/<nombre>/` y su copia en `CEREBRO/.agents/skills/<nombre>/`

Excepción: si la skill solo sirve para UN proyecto, créala en `<proyecto>/.claude/skills/<nombre>/`
y anótala en la ficha `CEREBRO/cerebro/proyectos/<proyecto>.md`.

## 1. Entender la tarea
Pregunta (o deduce de la conversación):
- ¿Qué hace la skill, en una frase?
- ¿Cuándo debe activarse? (frases que diría Henry)
- ¿Cuáles son los pasos exactos? ¿Hay comandos, archivos o plantillas?
- ¿Cómo se sabe que quedó bien?

Antes de crear, revisa que no exista ya: mira `CEREBRO/cerebro/catalogo-skills.md` y ejecuta
`npx skills find <tema>`. Si existe una buena (1K+ instalaciones, autor confiable), mejor instálala.

## 2. Escribir la skill
1. Nombre en minúsculas con guiones: `generar-informe`, `deploy-vercel`.
2. Crea `CEREBRO/.claude/skills/<nombre>/SKILL.md` partiendo de `CEREBRO/plantillas/SKILL.md`.
3. La `description` es lo más importante: Claude la usa para decidir cuándo cargarla.
   Escribe qué hace + cuándo usarla + frases de ejemplo.
4. Pasos numerados, concretos, con comandos reales. Menos de ~300 líneas.
5. Si necesita scripts o plantillas, ponlos junto al SKILL.md (`scripts/`, `plantillas/`)
   y referéncialos con ruta relativa.
6. Si la skill usa archivos del cerebro, escribe la ruta completa (`~/Desktop/Claude/...`),
   nunca una relativa, para que funcione desde cualquier proyecto.

## 3. Sincronizar y probar
1. Ejecuta el script de sincronización (copia todo a `.agents/skills/` y a la carpeta global):
   - Windows: `powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\Desktop\Claude\sincronizar-skills.ps1"`
   - Mac/Linux: `bash ~/Desktop/Claude/sincronizar-skills.sh`
2. Abre una sesión nueva de Claude Code y pide una tarea que debería activarla.
3. Si no se activa, mejora la `description` con las palabras que realmente usa Henry y sincroniza otra vez.

## 4. Registrarla
- Agrégala a la tabla "Skills de este repo" en `CEREBRO/cerebro/catalogo-skills.md`.
- Desde `CEREBRO`: `git add . && git commit -m "skill: <nombre>" && git push`

## Tip
Para skills complejas existe `skill-creator` de Anthropic (`npx skills add anthropics/skills@skill-creator`).
