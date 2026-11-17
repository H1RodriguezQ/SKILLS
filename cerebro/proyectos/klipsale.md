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
3. [ ] Envío de la plantilla de verificación por WhatsApp Cloud API (claves en .env)

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
