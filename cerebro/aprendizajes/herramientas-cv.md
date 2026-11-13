# Herramientas para hoja de vida (CV)

Tres proyectos open source que Henry guardó el 2026-11-13. Todos gratis.

| Herramienta | Qué es | Cómo se usa | Mejor para |
|---|---|---|---|
| [RenderCV](https://github.com/rendercv/rendercv) | Escribes el CV en un archivo YAML (texto) y genera un PDF con tipografía profesional | `pip install "rendercv[full]"` → `rendercv new "Henry Rodriguez"` → `rendercv render Henry_Rodriguez_CV.yaml` | Que Claude escriba/edite el CV como texto y lo guarde en git. Ideal para ingenieros y académicos |
| [Resume Matcher](https://github.com/srbhr/Resume-Matcher) | Adapta tu CV maestro a cada oferta de trabajo con IA, da puntaje ATS, carta de presentación y preparación de entrevista | Local con Docker (FastAPI + Next.js + SQLite). Tiene servidor MCP para que Claude Code lo maneje | Postular a muchas ofertas, adaptando el CV a cada una sin inventar experiencia |
| [Reactive Resume](https://github.com/reactive-resume/reactive-resume) | Editor visual de CV en el navegador, 18 plantillas, exporta PDF/Word, seguimiento de postulaciones | Directo en https://rxresu.me (cuenta gratis) o self-host con Docker | Diseñar el CV visualmente, sin terminal |

## Recomendación
- **CV base:** RenderCV (texto en git, Claude lo mantiene al día).
- **Postular a ofertas:** Resume Matcher (adapta el CV a cada oferta).
- **Si prefieres editar con el mouse:** Reactive Resume en rxresu.me.

## Skill creada
- 2026-11-13 Se creó la skill `hoja-de-vida` (RenderCV). Datos reales en `privado/hoja-de-vida/` (no se sube a GitHub).
- 2026-11-13 RenderCV 2.8 instalado en HENRY-PC (Python 3.14). Usar `python -m rendercv`, no `rendercv` solo → el comando suelto no está en el PATH.
