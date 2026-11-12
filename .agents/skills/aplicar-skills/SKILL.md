---
name: aplicar-skills
description: Instala en un proyecto solo las skills que le sirven, según su tipo y tecnologías. Úsala al abrir o crear un proyecto nuevo, o cuando Henry diga "aplica las skills", "configura las skills de este proyecto", "qué skills uso aquí", "pon el cerebro en este proyecto".
---

# Aplicar skills a un proyecto

## 1. Detectar el tipo de proyecto
Mira los archivos del proyecto:

| Si encuentras | Es | Skills sugeridas |
|---|---|---|
| `package.json` con `next` | Next.js | react-best-practices, web-design-guidelines |
| `package.json` con `react` | React | react-best-practices, frontend-design |
| `index.html` sin framework | Web estática | frontend-design, web-design-guidelines |
| `requirements.txt` / `pyproject.toml` | Python | testing (pytest) |
| `.docx` / `.xlsx` / `.pptx` / informes | Documentos | docx, xlsx, pptx, pdf |
| Proyecto académico / numérico | Ciencia | (buscar con find-skills) |

Revisa también `cerebro/catalogo-skills.md` y la ficha `cerebro/proyectos/<proyecto>.md`.

## 2. Proponer antes de instalar
Muestra a Henry la lista de skills con una línea de por qué sirve cada una, y pregunta cuáles quiere.

## 3. Instalar
- **Skills propias del cerebro** (`cerebro`, `crear-skill`, etc.): cópialas a `<proyecto>/.claude/skills/`.
  - Windows (PowerShell):
    `Copy-Item -Recurse "$env:USERPROFILE\Desktop\Claude\.claude\skills\cerebro" ".claude\skills\"`
  - Mac/Linux: `cp -r ~/Desktop/Claude/.claude/skills/cerebro .claude/skills/`
- **Skills del ecosistema:** `npx skills add <owner/repo@skill> -y` (dentro del proyecto).
- **Para todos los proyectos a la vez:** agrega `-g` (instala en `~/.claude/skills`).

## 4. Conectar el proyecto al cerebro
Agrega al `CLAUDE.md` del proyecto (créalo si no existe):

```markdown
## Cerebro
Antes de empezar, lee ~/Desktop/Claude/cerebro/INDICE.md y
~/Desktop/Claude/cerebro/proyectos/<proyecto>.md. Guarda lo aprendido con la skill `cerebro`.
```

## 5. Registrar
Actualiza `cerebro/proyectos/<proyecto>.md` (sección "Skills que aplican") y `INDICE.md`.
