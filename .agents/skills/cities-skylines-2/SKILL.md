---
name: cities-skylines-2
description: Hace que Cities Skylines 2 (CS2) corra rápido en el PC de Henry y diagnostica sus errores. Úsala cuando Henry diga "cities skylines va lento", "se traba", "pocos FPS", "optimiza el juego", "que corra bien", "el mapa sale plano", "qué error tira el juego", "se cierra / crashea", "no carga la partida", o mencione mods de CS2.
---

# Cities: Skylines II — rápido y sin errores

PC de Henry: Ryzen 7 7735HS con **Radeon 680M integrada** (4 GB de video compartido), 20 GB de RAM, SSD.
Es una gráfica integrada: el juego nunca va a ir en "Alto". La meta realista es 25–40 FPS en ciudad pequeña/media.

Carpeta del juego (datos): `%USERPROFILE%\AppData\LocalLow\Colossal Order\Cities Skylines II\`
- `Settings.coc` → configuración gráfica (texto, se puede editar con el juego **cerrado**)
- `Player.log` → registro de la última partida (`Player-prev.log` = la anterior)
- `Logs\` → registros de cada mod (`Modding.log` lista los mods cargados)

## 1. Si pide que corra mejor
1. Verifica que el juego esté cerrado: `Get-Process Cities2 -EA SilentlyContinue`. Si está abierto, pídele que lo cierre (el juego sobrescribe la configuración al salir).
2. Aplica la configuración rápida (hace copia de seguridad sola):
   ```powershell
   powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\Desktop\Claude\.claude\skills\cities-skylines-2\scripts\optimizar.ps1"
   ```
   Apaga: niebla volumétrica, SSAO, reflejos, SSGI, desenfoque de profundidad y de movimiento, nubes, flujo del agua, MSAA de contornos. Deja FXAA, resolución dinámica FSR al 50 %, sombras 512, detalle 0.25, máx. 512 luces.
   Para deshacer: el mismo comando con `-Restaurar`.
3. Dile a Henry estos pasos que tiene que hacer él (no se pueden por script):
   - **Portátil enchufado** y Windows en modo **Máximo rendimiento** (Configuración → Sistema → Energía).
   - **Cerrar todo** antes de jugar: navegador, Claude, Discord. Con 180+ mods el juego se come la RAM.
   - En el juego: Opciones → Gráficos → **Limitar FPS a 30** y **VSync apagado**. Un límite estable se siente mejor que saltos de 20 a 45.
   - Jugar en **Ventana sin bordes / Pantalla completa** a la resolución nativa (1920×1200); la resolución dinámica ya baja la carga.
4. **Mods = lo que más pesa.** Mira cuántos hay:
   ```powershell
   (Select-String "$env:USERPROFILE\AppData\LocalLow\Colossal Order\Cities Skylines II\Logs\Modding.log" -Pattern '^\s+- .* v[\d\.]+ \(\d+\)' | Select -Expand Line -Unique).Count
   ```
   Si son más de ~80, recomiéndale crear un **playset** liviano en Paradox Mods solo con lo que usa de verdad (mapas y edificios de assets pesan mucho más que los mods de herramientas). Nunca borres mods tú: él decide cuáles quita.
5. Si sigue lento con ciudad grande: es la CPU simulando (no la gráfica). Bajar la velocidad del juego a ▶ o ▶▶ ayuda más que cualquier gráfico.

## 2. Si pide "qué error tira" / el mapa sale raro / se cierra / pega un error
0. **Primero corre el diagnóstico automático** (agrupa errores por mod culpable, CRITICAL arriba, y avisa si el juego está desactualizado para los mods). `-Anterior` revisa la partida de antes:
   ```powershell
   powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\Desktop\Claude\.claude\skills\cities-skylines-2\scripts\diagnosticar.ps1"
   ```
   Si sale "Hay mods hechos para la versión X": esa es la causa raíz; los demás errores suelen ser en cadena.
   Si Henry pega un error a mano, busca en la traza el primer nombre que no sea `Game.`, `Unity`, `System.`, `Colossal.` → ese es el mod.
1. Si hace falta más detalle, busca errores en el último registro:
   ```powershell
   $p="$env:USERPROFILE\AppData\LocalLow\Colossal Order\Cities Skylines II\Player.log"
   Select-String $p -Pattern '\[CRITICAL\]|\[ERROR\]|Exception' | Select -Last 40 | % { $_.Line.Substring(0,[Math]::Min(260,$_.Line.Length)) }
   ```
2. Los `[CRITICAL]` son los que rompen la partida. En la traza busca el nombre del mod (p. ej. `Better_Bulldozer.Systems...`) — ese es el culpable.
3. Qué mapa o partida cargó: `Select-String "$env:USERPROFILE\AppData\LocalLow\Colossal Order\Cities Skylines II\Logs\SceneFlow.log" -Pattern 'Starting game from'`
4. `[ERROR] Error when initializing prefab: <nombre>` = un edificio/asset roto: solo no aparece, no es grave.
5. Explícale en palabras simples: qué mod falla, por qué, y que lo desactive en Paradox Mods → cierre el juego → vuelva a abrir y pruebe.

## Errores conocidos en este PC (nov 2026)
- **Causa raíz:** el juego instalado es la **1.6.0f1** (copia en `Documents\2026A\...`, no se actualiza sola) y los mods de Paradox Mods ya piden la **1.6.2f1**. Por eso fallan en cadena. Solución de fondo: tener el juego en la versión actual (la copia oficial de Steam se actualiza sola). No ayudes a conseguir copias no oficiales.
- **Mapa plano, sin relieve ni agua:** `Traffic v0.2.13` no carga en la 1.6.0 (`Error loading assembly Traffic`) → `Better Bulldozer` revienta (`Unknown Type: Traffic.Components.ModifiedConnections`) y corta la carga del mapa. Mientras el juego siga en 1.6.0: desactivar **Traffic** y **Better Bulldozer**.
- `Lumina` dice "Unsupported game version": desactivarlo hasta tener la 1.6.2.
- `Shibuya 109` (`ArgumentNullException ... key` en `IsUnlockable`): asset roto, solo no aparece. Quitarlo de suscripciones si molesta.
- `SimpleModCheckerPlus` (`ArgumentNullException ... path` en `ModCheckup.cs`): el verificador de mods no encuentra la ruta de un mod. Inofensivo; se puede desactivar.
- `JPSLEDVideoWall` (`TypeLoadException SettingsOverrides`): incompatible con la versión del juego, no rompe nada.

## Errores comunes
- Editar `Settings.coc` con el juego abierto → se pierde al cerrar.
- Subir la memoria de video en la BIOS: con 24 GB totales y tantos mods, le quita RAM al juego. No lo recomiendes.
- Prometer 60 FPS: con gráfica integrada no es realista.
