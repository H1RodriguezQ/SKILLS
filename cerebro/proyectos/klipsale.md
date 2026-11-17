# Klipsale

- **Repo:** (local en C:\proyectos\klipsale, sin commits aún)
- **Tipo:** app de Shopify embebida
- **Tecnologías:** React Router 7 + TypeScript, Polaris, Prisma + SQLite, Node >= 22.12, WhatsApp Cloud API
- **Estado:** en curso, Parte 1 (semanas 1-3)
- **Tienda de pruebas:** klipsale-pruebas.myshopify.com

## Qué es
Agentes por WhatsApp oficial para tiendas en Colombia: verifica pedidos contraentrega, hace seguimiento de entrega y recupera carritos.

## Marca
- Azul #1638A6. Voz cercana, español colombiano. Términos: "contraentrega", "flete prepago".

## Parte 1
1. [x] Webhook orders/create → guarda el pedido (tabla Order)
2. [x] HMAC: lo verifica `authenticate.webhook` de la librería de Shopify (401 si la firma falla)
3. [x] Mensaje de verificación + simulador de respuestas + etiqueta en Shopify (falta conectar WhatsApp real)
4. [x] orders/cancelled y webhooks de privacidad (compliance)
5. [ ] WhatsApp Cloud API (necesita Meta; Henry decide cuándo)

## Cómo correrlo
```bash
cd C:\proyectos\klipsale
npm run dev                              # shopify app dev
node --test app/orders.server.test.ts    # pruebas de la lógica de pedidos
```

## Decisiones y notas
- 2026-11-16 Solo pedidos contraentrega quedan "pendiente_verificacion"; los demás "sin_verificacion".
- 2026-11-16 Teléfono para WhatsApp: solo celulares CO (3xxxxxxxxx → 57...). Fijos quedan null.
- 2026-11-16 Upsert por (shop, shopifyOrderId) porque Shopify reenvía webhooks.
- 2026-11-16 orders/create exige pedir "datos protegidos de clientes" en el Dev Dashboard (nombre, teléfono, dirección).
- 2026-11-16 Nombre, teléfono y dirección se guardan cifrados (AES-256-GCM, clave KLIPSALE_DATA_KEY en .env) + phoneHash para buscar por teléfono. Ciudad/departamento en claro. Si se pierde la clave, esos datos no se recuperan.
- 2026-11-16 Riesgo por verificar antes de desplegar: Cloudflare Workers gratis (~10 ms CPU) puede no alcanzar para Prisma + auth de Shopify.
- 2026-11-16 Marca: "Klipsale" con K mayúscula en textos; el logo puede seguir en minúscula (es el logotipo).
- 2026-11-16 No usar `prisma migrate reset` (borra la sesión de la tienda); para rehacer una tabla propia, borrarla con `prisma db execute`.
- Resumen completo del negocio: lo mandó Henry el 2026-11-17 (planes, precios, equipo, competencia, marca).
- 2026-11-17 Manual de marca = Descargas/KLIPSALE.pdf (Henry lo llama "los figmas"; no hay enlace de Figma de Klipsale). Reglas clave: decir "confirmar", "pedido", "plata", "contraentrega"; nunca "COD", "orden", "checkout"; no cifras de ejemplo como resultados; rojo solo riesgo; amarillo nunca texto sobre blanco; Outfit títulos + Source Sans 3 texto.
- 2026-11-17 "Flete prepago" = solo el envío pagado antes (caso riesgoso). Pedidos pagados en línea se muestran como "Pago en línea", no "prepago", para no confundir.
- 2026-11-17 Plantilla WhatsApp de verificación: usar el texto del manual (pág. 9) tal cual, con [tienda], [número], [dirección], [nombre].
- 2026-11-17 Panel dentro de Shopify = Polaris (requisito de Shopify). La marca completa (colores, fuentes) va en el panel propio (Cloudflare Pages, sirve también para WooCommerce), ícono, landing y WhatsApp.
- 2026-11-17 Auditoría completa en C:\proyectos\klipsale\AUDITORIA.md (qué se probó contra la tienda, qué se corrigió, pendientes).
- 2026-11-17 Pruebas contra la tienda real: script con `shopify app env show` → process.env (sin imprimir el secreto) + SHOPIFY_APP_URL del túnel + vite ssrLoadModule + unauthenticated.admin.
- 2026-11-17 En Windows, `prisma generate` falla con EPERM si `shopify app dev` está corriendo: parar el servidor primero.
- 2026-11-17 Edge headless no baja de ~500 px de ancho: para ver en celular, meter la página en un iframe de 390 px.
- 2026-11-17 Detector de contraentrega (app/cod.server.ts): reglas + pregunta "¿Es contraentrega?" + aprende por tienda tras 3 respuestas iguales (tabla ShopSetting). Henry pidió "un modelo"; se eligió reglas+aprendizaje porque no hay datos para entrenar IA.
- 2026-11-17 Tiendas de desarrollo: Shopify limita orderCreate a pocos pedidos por minuto ("Too many attempts"); esperar ~65 s entre pedidos en pruebas.
