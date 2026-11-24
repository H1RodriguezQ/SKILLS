---
name: reel-texto-detras
description: Edita reels verticales estilo institucional/educativo con el efecto "texto detrás de la persona". Palabras gigantes verde neón entran con eco y quedan detrás de la cabeza del presentador (recorte con IA local). Lleva también una palabra vertical gigante, subtítulos pequeños, b-roll con voz en off, logo de marca de agua y cierre con logo. Úsala cuando Henry diga "haz un reel tipo así" con esa referencia, "texto detrás de la persona", "letras detrás de la cabeza", "estilo IAC", "reel de clase/evento/institución", "palabras grandes neón", o pida un gancho con títulos gigantes sobre alguien hablando a cámara.
---

# Reel con texto detrás de la persona

Referencia: reel de imctbga (IAC Bucaramanga, nov 2026), de 52 s. Así está armado:

| Tramo | Qué se ve |
|---|---|
| 0–8 s · gancho | El presentador habla a cámara en plano americano. Palabras gigantes verde neón (#C8FF00, fuente ancha y negra) entran deslizándose con eco y quedan **detrás de su cabeza**: «¿SABÍAS QUE», «TECNOLOGÍA / CREATIVIDAD». Después, una palabra **vertical** blanca gigante sube por el borde: «APRENDIZAJE». |
| 8–40 s · b-roll | Cortes de 1 a 3 s del lugar (computadores, gafas VR, impresora 3D, pendón) mientras sigue la voz del presentador (corte J). En medio, entrevistas cortas a cámara (un niño, un profesor). |
| 40–50 s · cierre | El presentador vuelve con una frase final y otra persona da el remate. |
| 50–52 s | Tarjeta blanca con el logo animado. |
| Todo el video | Subtítulos **pequeños** blancos con sombra, a media altura (no los grandes de TikTok). Logo de la institución arriba a la derecha. |

## El estilo depende del video (pedido de Henry, 24 nov 2026)

Antes de escribir el plan, mira qué muestra el video y qué se quiere transmitir. Con eso eliges `"estilo"`, y con `"ajustes"` cambias lo que haga falta: color de la marca, `ancho`, `fuente`, `eco` (de 0 a 1) o `sub` (`pequenos` o `grandes`).

| Estilo | Para qué videos | Cómo se ve |
|---|---|---|
| `neon` | Tecnología, clases, instituciones, lanzamientos | Verde neón #C8FF00, letra negra ancha que ocupa toda la pantalla, eco fuerte y subtítulos pequeños (como el reel IAC) |
| `noticia` | Crisis, miedo, datos, el canal Sabías Que | Impact roja, sacudón al llegar y subtítulos grandes amarillos estilo TikTok |
| `campo` | Vlogs, animales, prácticas, naturaleza (Cenfer) | Arial Black crema, 80 % del ancho, eco suave y subtítulos pequeños |
| `elegante` | Cultura, eventos, arte, graduaciones | Gill Sans Ultra blanca, 70 % del ancho, casi sin eco |

- Si hay una marca (una universidad, una empresa), cambia el `color` por el de su logo.
- Si el fondo es claro, usa colores fuertes u oscuros. Si es oscuro, neón o blanco.
- La palabra **vertical** va solo cuando el borde de la pantalla está libre de personas.
- Si no estás seguro, saca una hoja con 2 o 3 estilos (paso 6) y deja que Henry elija.

## Pasos

1. **Elegir el gancho:** de 3 a 8 s del presentador hablando, en vertical y con aire arriba de la cabeza. Mientras más corto, mejor: el recorte con IA corre en CPU a unos 1,3 cuadros por segundo, o sea unos 3 min por cada 5 s de video.
2. **Recortarlo** a 1080×1920:
   `ffmpeg -ss <inicio> -t <dur> -i original.mp4 -vf "scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920" -r 30 -c:v libx264 -crf 18 -c:a aac host.mp4`
3. **Escribir `plan.json`** junto al clip, con el `estilo` que le corresponda al video (ver la tabla de arriba). El formato está en la cabecera de `scripts/texto_detras.py`.
   - Títulos de 1 a 2 palabras por línea, en mayúsculas. Cada uno dura de 1,5 a 2 s y debe coincidir con el momento en que el presentador **dice** esa palabra (verlo en la transcripción).
   - `y` entre 0.2 y 0.4, para que el texto quede a la altura de la cabeza y ella lo tape.
   - Palabra vertical: solo si el borde (`x` 0.09 o 0.91) queda libre de personas. Si no, la tapan y se lee a medias.
   - `reemplazos` sirve para corregir nombres que Whisper oye mal (por ejemplo "Tim" → "Jen").
4. **Ejecutar:** `python ~/Desktop/Claude/.claude/skills/reel-texto-detras/scripts/texto_detras.py plan.json`
   - Si no existe `persona.webm`, el script lo crea con `hyperframes remove-background`.
   - Después transcribe con faster-whisper local y compone: fondo, luego el texto, luego la persona y encima subtítulos y logo.
5. **Armar el resto del reel:**
   - Corte J: la voz del presentador sigue sonando bajo el b-roll.
   - B-roll de 1 a 3 s por toma.
   - Unir con el concat de ffmpeg a 1080×1920 y 30 fps, todo con el mismo códec. Poner la música baja (-20 LUFS) y bajarla más donde alguien habla.
6. **Revisar antes de entregar:**
   - Sacar una hoja de cuadros: `ffmpeg -i gancho.mp4 -vf "select='not(mod(n\,20))',scale=270:480,tile=5x2" -frames:v 1 hoja.png`.
   - Mirar que el texto quede detrás de la cabeza sin cortarse, que los subtítulos digan lo correcto y que nada quede congelado: `freezedetect`.

## Ejemplo

`plan.json` probado con el intro del vlog de Cenfer (5 s, tres personas):

```json
{"video":"host.mp4","salida":"gancho.mp4",
 "titulos":[{"texto":"UN DÍA EN\nCENFER","t0":0.5,"t1":2.4,"y":0.27},
            {"texto":"VETERINARIA","t0":2.8,"t1":4.7,"vertical":true,"color":"#FFFFFF"}],
 "subtitulos":true,"reemplazos":{"Tim":"Jen","Pida":"Sofía"}}
```

Resultado: «CENFER» queda detrás de las gorras. El recorte tardó unos 3 min y la composición unos 40 s.

## Errores comunes
- **Clip demasiado largo para el recorte IA:** recortar solo el gancho, no todo el reel.
- **Texto que no se lee (pedido de Henry):** el script ya no deja que el texto se salga de la pantalla (máximo 88 % del ancho) y lo alarga si dura menos de 0,8 s + 0,3 s por palabra. Si la persona tapa más del 15 % de las letras, busca otra altura, y si no la encuentra pone el texto DELANTE. Para que se vea el efecto "detrás", elige tomas con una sola persona y espacio sobre la cabeza.
- **Palabra vertical sobre personas:** se esconde detrás de ellas. Moverla con `x` o quitarla.
- **Whisper `base` confunde nombres propios:** usar `reemplazos` o revisar la transcripción.
- **Fuente:** se usa Segoe UI Black estirada (`ancho=1.18`) para imitar la "extended" del reel. Para otra marca, cambiar `FUENTE` y `NEON` en el script.
- **Recorte con bordes raros:** pelo suelto y fondos del mismo color que la ropa ensucian el borde. Elegir tomas con contraste.
