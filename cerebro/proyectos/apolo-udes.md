# Apolo Udes

- **Repo:** H1RodriguezQ/Apolo_Udes (público)
- **Tipo:** proyecto de grado, Ingeniería de Software (UDES, Bucaramanga)
- **Tecnologías:** Flutter (Android tablet + web), Firebase (Firestore, Auth, Hosting, App Check), Google Apps Script (correos), Node (admin-scripts, pruebas de carga)
- **Estado:** funcional y publicado en https://apolo-udes.web.app (último push 2026-11-10)

## Qué es
Control de acceso con QR para las ceremonias de grado de la UDES: el graduando registra invitados por un enlace,
cada invitado recibe un QR de un solo uso, y los operadores lo escanean en la entrada con una tablet.

## Lo que ya está bien hecho (no rehacer)
- Validación del QR con transacciones de Firestore (evita doble ingreso entre tablets).
- Reglas de Firestore que niegan todo por defecto + pruebas contra el emulador (`rules-tests/`).
- Pruebas de carga y modelo de colas (`pruebas-carga/`, Node contra el emulador).
- Análisis de seguridad STRIDE (`docs/seguridad/`), App Check, caché offline de Firestore.

## Decisiones y notas
- 2026-11-13 Revisión de mejoras (solo lectura). Pendientes sugeridos:
  - `applicationId` y `namespace` siguen en `com.example.apolo_udes` → cambiar a algo como `co.edu.udes.apolo` antes de distribuir el APK. Ojo: el paquete está registrado en Firebase (`google-services.json`); al cambiarlo hay que registrar la app Android nueva en la consola de Firebase y descargar el nuevo `google-services.json`.
  - `lib/providers/app_provider.dart` tiene 1.305 líneas y llama a Firestore directo aunque existe `firestore_service.dart` → separar por módulo (graduandos, invitados, directivos, control de acceso).
  - Conviven SQLite (`sqflite`) y Firestore → confirmar si SQLite aún hace falta; si no, quitarlo.
  - 2026-11-13 HECHO: CI en `main` (`.github/workflows/ci.yml`, Flutter 3.41.4); primera ejecución en verde.
  - 2026-11-13 HECHO: regla de uso único del QR extraída a `calcularCodigosUsados()` (app_provider.dart) con 5 pruebas en `test/codigos_usados_test.dart`; ahora 51 pruebas.
  - Dependencias con versiones mayores nuevas (go_router 13, mobile_scanner 5, fl_chart 0.68) → actualizar con cuidado, una por una.
- 2026-11-13 Copia local: `Desktop/Apolo_Udes` (clonada de GitHub). El código se ha trabajado sobre todo desde la app de Claude (chat); GitHub es la fuente de verdad.
- 2026-11-13 Los borrados de directivos SÍ muestran errores (los maneja `directivos_screen.dart`); el `catch (_) {}` del provider es redundante, no un bug.
- 2026-11-13 Estado verificado: `flutter analyze` sin avisos y 46 pruebas pasaban (antes de agregar las de uso único) (Flutter 3.41.4).
- 2026-11-13 Bug arreglado: pantalla Acceso en blanco y app lenta en pantallas ≥700 px. Causa: LayoutBuilder (barra de ocupación) dentro de IntrinsicHeight en ceremonia_screen.dart → nunca usar LayoutBuilder dentro de IntrinsicHeight; usar FractionallySizedBox/Align. Ojo: flutter analyze y las pruebas NO lo detectaban, solo se ve ejecutando la app.
- 2026-11-13 Revisión de diseño (sin cambios aún). Pendientes: horas en 3 formatos ("09:30 AM", "9:30 a. m.", "hh:mm a") → unificar a "9:30 a. m."; bitácora sin tildes ("Envio invitacion", "Elimino", "Edito", "Agrego", "Creo"); --dorado-texto distinto entre invitados.html (#8a6d3b) y confirmar/directivos (#7a5f2f), y restablecer.html con otra paleta; placeholders del invitado 2 parecen datos reales; "0" en rojo en Requiere atención; marca del 75 % en rojo (debería ser ámbar); código del QR se corta a mitad; texto gris claro del correo con poco contraste.
- 2026-11-13 HECHO revisión de diseño: tildes; hora "9:30 a. m." solo al mostrar (`AppConstants.horaLegible` y `horaLegible()` en las páginas); placeholders claros; dorado #7a5f2f y etiquetas 11 px; 0 en gris en Inicio; marca 75 % ámbar; código del QR corta en guiones; grises del correo más oscuros (Codigo.gs sincronizado con `node sincronizar-plantilla.js`); animación de entrada en confirmar.html. `restablecer.html` usa a propósito los colores de la app (es para el personal).
- PENDIENTE: test `apps-script/test/plantilla.test.js` #5 falla (ya fallaba): `esq_*_src` vacíos en los datos de prueba no están en MARCAS_OPCIONALES → salen como "Por confirmar". Decidir si son opcionales o si la prueba debe llenarlos. Antes de la sincronización fallaban 5 de 12 (Codigo.gs desactualizado).
- PENDIENTE: pegar Codigo.gs nuevo en Apps Script y publicar web (`flutter build web` + `firebase deploy`) para que los cambios lleguen a producción.
- 2026-11-13 Figma: archivo "Apolo UDES — Rediseño" https://www.figma.com/design/S7gTY7mlljtqW3vfcpJFTB con 4 pantallas web como capas editables (registro de invitados, invitación pendiente, invitación a directivo, mi código QR), con datos de ejemplo (no reales). Quedaron a 1280 px de ancho (vista de computador). Faltan las pantallas de la app Flutter (tablet) y la versión de celular (390 px).
  - Cómo se hizo: `cerebro/aprendizajes/scripts/apolo-capturar-pantallas.js` abre cada página en Chromium con Firebase simulado y la guarda como HTML estático → `html_to_figma`. Uso: `node apolo-capturar-pantallas.js <ruta>/apolo_udes/web <carpeta-salida>`.
  - Figma de Henry: plan Starter con asiento View → máx. 20 lecturas MCP al mes; crear archivos e importar no cuenta. Gastar lecturas solo para verificar.
- 2026-11-13 IDEA APROBADA (por hacer en el chat de Apolo): animaciones en las invitaciones. Primero una página de prueba con interruptores; tocar el código real solo después de que Henry elija.
  - SÍ: (1) brillo dorado que pasa una vez por "Lo esperamos" y el birrete al abrir; (2) al tocar "Sí, asistiré": confeti dorado/azul corto (≤1,5 s) y el QR aparece con un fundido suave.
  - DESPUÉS: GIF de sello/sobre en el correo (Higgsfield, gasta créditos).
  - NO: animar o retrasar el QR en mi-qr.html (se usa en la fila de entrada); animaciones en bucle; música o video.
  - Siempre respetar `prefers-reduced-motion`; sin librerías pesadas (CSS + un poco de JS); que funcione en celulares de gama baja.
