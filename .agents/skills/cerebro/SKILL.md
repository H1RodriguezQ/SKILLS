---
name: cerebro
description: Lee y escribe la memoria permanente de Henry (carpeta cerebro/ del repo skills). Úsala al empezar cualquier sesión o proyecto para recordar contexto, y cuando el usuario diga "recuerda", "guarda esto", "anota", "no olvides", "¿qué sabes de…?", o cuando se tome una decisión, se resuelva un error o se descubra un truco que valga la pena reutilizar.
---

# Cerebro: memoria permanente

La memoria vive en `cerebro/` dentro del repo `skills` (en el PC: `Escritorio/Claude/cerebro/`).
Si estás en otro proyecto, búscala en `~/Desktop/Claude/cerebro/` o `%USERPROFILE%\Desktop\Claude\cerebro\`.

## Al empezar (leer)
1. Lee `cerebro/INDICE.md` para ver el mapa.
2. Lee `cerebro/perfil.md` (preferencias de Henry).
3. Si trabajas en un proyecto, lee `cerebro/proyectos/<nombre>.md`. Si no existe, créalo con
   `plantillas/ficha-proyecto.md` y agrégalo a la tabla de `INDICE.md`.
4. Antes de resolver un error, busca en `cerebro/aprendizajes/` por si ya se resolvió:
   `grep -ri "<palabra clave>" cerebro/`

## Al aprender algo (escribir)
Elige el archivo correcto:

| Qué aprendiste | Dónde va |
|---|---|
| Preferencia de Henry ("siempre…", "no me gusta…") | `perfil.md` |
| Decisión o dato de un proyecto | `proyectos/<proyecto>.md`, sección "Decisiones y notas" |
| Error resuelto, truco, comando útil | `aprendizajes/<tema>.md` (crea uno por tema) |
| Skill nueva o recomendada | `catalogo-skills.md` |

Formato de cada nota: `- AAAA-MM-DD <qué pasó> → <qué hacer la próxima vez>`

## Reglas
- Una idea por línea, corta y accionable. Nada de copiar conversaciones enteras.
- Actualiza o borra notas que ya no son ciertas; no dupliques.
- Si creas un archivo nuevo, enlázalo en `INDICE.md`.
- **Nunca** guardes contraseñas, tokens, claves API ni datos personales de terceros.
- Al terminar, si el repo es git, haz commit: `git add cerebro && git commit -m "cerebro: <resumen>"`
  y `git push` para que la memoria quede en GitHub.
