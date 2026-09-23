-- Ejecutar una vez en instalaciones con el esquema anterior para registrar TikTok, YouTube y otros canales.
ALTER TABLE interacciones_afiliados DROP CONSTRAINT ck_interaccion_tipo;
ALTER TABLE interacciones_afiliados ADD CONSTRAINT ck_interaccion_tipo CHECK (
    tipo IN ('VISITA_FICHA','CLIC_TELEFONO','CLIC_WHATSAPP','CLIC_SITIO_WEB',
             'CLIC_FACEBOOK','CLIC_INSTAGRAM','CLIC_RED_SOCIAL','VISITA_PROMOCION','CLIC_MAPA')
);
