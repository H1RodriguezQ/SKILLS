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
  - CI hecho en la rama `mejoras-calidad` (`.github/workflows/ci.yml`, Flutter 3.41.4) → falta push + PR.
  - Pocas pruebas de la lógica central (validación de QR en `app_provider`) → agregar pruebas unitarias.
  - Dependencias con versiones mayores nuevas (go_router 13, mobile_scanner 5, fl_chart 0.68) → actualizar con cuidado, una por una.
- 2026-11-13 Copia local: `Desktop/Apolo_Udes` (clonada de GitHub). El código se ha trabajado sobre todo desde la app de Claude (chat); GitHub es la fuente de verdad.
- 2026-11-13 Los borrados de directivos SÍ muestran errores (los maneja `directivos_screen.dart`); el `catch (_) {}` del provider es redundante, no un bug.
- 2026-11-13 Estado verificado: `flutter analyze` sin avisos y 46 pruebas pasan (Flutter 3.41.4).
