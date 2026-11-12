# Proyecto `skills`: el cerebro de Claude

Este repositorio es la memoria central y la fábrica de skills de Henry.
Todo lo que se aprenda o se cree en Claude se guarda aquí, para reutilizarlo en cualquier proyecto.

## Reglas para Claude (léelas al empezar cada sesión)

1. **Primero lee el cerebro.** Al iniciar, lee `cerebro/INDICE.md` y `cerebro/perfil.md`.
   Si trabajas en un proyecto concreto, lee también `cerebro/proyectos/<proyecto>.md` si existe.
2. **Guarda lo que aprendas.** Usa la skill `cerebro` para anotar decisiones, preferencias,
   errores resueltos y comandos útiles. No guardes contraseñas, tokens ni datos personales sensibles.
3. **Antes de hacer algo a mano, busca una skill.** Revisa `cerebro/catalogo-skills.md`;
   si no hay ninguna, usa `find-skills` (`npx skills find <tema>`).
4. **Si una tarea se repite, conviértela en skill.** Usa la skill `crear-skill`.
5. **Aplica las skills al proyecto correcto.** Usa la skill `aplicar-skills` para copiar a cada
   proyecto solo las skills que le sirven.
6. Responde en español.

## Estructura

```
skills/
├── CLAUDE.md                  ← estas reglas
├── cerebro/                   ← la memoria
│   ├── INDICE.md              ← mapa del cerebro (empieza aquí)
│   ├── perfil.md              ← quién es Henry, cómo le gusta trabajar
│   ├── catalogo-skills.md     ← qué skill sirve para qué
│   ├── proyectos/             ← una ficha por proyecto
│   └── aprendizajes/          ← lecciones, errores resueltos, trucos
├── .claude/skills/            ← skills que Claude Code carga en este repo
│   ├── find-skills/           ← buscar e instalar skills (vercel-labs)
│   ├── cerebro/               ← leer y escribir en la memoria
│   ├── crear-skill/           ← crear skills nuevas
│   └── aplicar-skills/        ← instalar skills en otros proyectos
├── .agents/skills/            ← mismas skills, formato universal (Cursor, Codex…)
├── plantillas/                ← plantillas para fichas y skills
└── skills-lock.json           ← versiones de skills instaladas con `npx skills`
```

## Cómo usarlo en tu PC

```bash
cd ~/Desktop
git clone https://github.com/H1RodriguezQ/skills.git Claude
cd Claude
claude
```

Para tener las skills disponibles en **todos** tus proyectos, cópialas a tu carpeta global
(`~/.claude/skills/` en Mac/Linux, `%USERPROFILE%\.claude\skills\` en Windows).
La skill `aplicar-skills` explica cómo.
