# Google Maps

La aplicación usa `Maps JavaScript API` y `Places API (New)`.

## Configuración

1. Copiar `.env.example` como `.env.local` en desarrollo, o definir `GOOGLE_MAPS_API_KEY` en el entorno del servidor.
2. Restringir la clave a las dos API anteriores.
3. Configurar restricciones HTTP para todos los recorridos donde se usa la clave:
   - `http://localhost/*`
   - `http://127.0.0.1/*`
   - `https://canacocard.com.mx/*`
   - `https://www.canacocard.com.mx/*`
   - `https://*.canacocard.com.mx/*`

Los navegadores modernos pueden enviar únicamente el origen en solicitudes a Google. Por eso no deben usarse solamente restricciones limitadas a `/canaco-card/*`.

`.env.local` está ignorado por Git y nunca debe publicarse en el repositorio.

## Comportamiento

- El panel solo acepta domicilios seleccionados en las sugerencias de Google Maps.
- La selección guarda dirección estructurada, `google_place_id`, latitud y longitud.
- Las fichas públicas muestran un mapa embebido. Los registros antiguos sin coordenadas usan su dirección guardada; al editarlos deben volver a seleccionar el domicilio para incorporar las coordenadas.
