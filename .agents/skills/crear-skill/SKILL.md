---
name: crear-skill
description: Crea una skill nueva y funcional a partir de una tarea que Henry repite o de un proceso que explica. Úsala cuando diga "crea una skill", "hazme una skill para…", "convierte esto en skill", "quiero que siempre hagas X así", o cuando notes que la misma tarea se ha hecho 2 o más veces.
---

# Crear una skill nueva

## 1. Entender la tarea
Pregunta (o deduce de la conversación):
- ¿Qué hace la skill, en una frase?
- ¿Cuándo debe activarse? (frases que diría Henry)
- ¿Cuáles son los pasos exactos? ¿Hay comandos, archivos o plantillas?
- ¿Cómo se sabe que quedó bien?

Antes de crear, revisa que no exista ya: mira `cerebro/catalogo-skills.md` y ejecuta
`npx skills find <tema>`. Si existe una buena (1K+ instalaciones, autor confiable), mejor instálala.

## 2. Escribir la skill
1. Nombre en minúsculas con guiones: `generar-informe`, `deploy-vercel`.
2. Crea `.claude/skills/<nombre>/SKILL.md` partiendo de `plantillas/SKILL.md`.
3. La `description` es lo más importante: Claude la usa para decidir cuándo cargarla.
   Escribe qué hace + cuándo usarla + frases de ejemplo.
4. Pasos numerados, concretos, con comandos reales. Menos de ~300 líneas.
5. Si necesita scripts o plantillas, ponlos junto al SKILL.md (`scripts/`, `plantillas/`)
   y referéncialos con ruta relativa.
6. Copia la carpeta también a `.agents/skills/<nombre>/` para que funcione en otros agentes.

## 3. Probarla
- Pide a Claude una tarea que debería activarla y verifica que la use.
- Si no se activa, mejora la `description` con las palabras que realmente usa Henry.

## 4. Registrarla
- Agrégala a la tabla "Skills de este repo" en `cerebro/catalogo-skills.md`.
- Commit y push: `git add . && git commit -m "skill: <nombre>" && git push`

## Tip
Para skills complejas existe `skill-creator` de Anthropic (`npx skills add anthropics/skills@skill-creator`).
