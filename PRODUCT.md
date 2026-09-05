# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

Personas que consultan públicamente el directorio CANACO Card para conocer empresas afiliadas, sus servicios, contacto, ubicación y promociones vigentes. Administradores y afiliados gestionan esos datos desde el panel interno.

## Product Purpose

CANACO Card conecta el directorio comercial de cámaras y sus empresas afiliadas con visitantes que necesitan información verificable para contactar, visitar o aprovechar promociones de un negocio.

## Positioning

Cada ficha pública reúne la información comercial, operativa y promocional vigente de una empresa afiliada dentro de la red CANACO Card.

## Operating Context

Los visitantes llegan desde la portada, un enlace compartido o una búsqueda. La ficha debe cargar directamente por URL, permitir volver al directorio y mostrar solo información pública disponible de afiliados activos.

## Capabilities and Constraints

- Proyecto PHP puro con MVC personalizado y helpers existentes.
- Las fichas usan afiliados activos y sus relaciones existentes; no se cambia la base de datos.
- Promociones únicamente activas y dentro de su vigencia.
- Las rutas administrativas y configuraciones de producción quedan fuera de alcance.

## Brand Commitments

CANACO Card conserva el lenguaje institucional “De la montaña al mar”, el logotipo oficial y la paleta marino, azul, celeste y verde existente.

## Evidence on Hand

- [CANACOCARD_Logo.png](vistas/assets/media/app/CANACOCARD_Logo.png)
- Datos de afiliados, archivos, sucursales, canales digitales y promociones en las tablas actuales.
- [DESIGN.md](DESIGN.md) documenta la identidad visual existente.

## Product Principles

1. La información de una empresa debe ser fácil de verificar y contactar.
2. Las URLs públicas deben ser estables, compartibles y funcionar sin JavaScript.
3. La identidad CANACO Card acompaña el contenido sin competir con él.

## Accessibility & Inclusion

La ficha mantiene navegación por teclado, foco visible, contraste suficiente, alternativas textuales y una versión sin movimiento para personas con preferencia de movimiento reducido.
