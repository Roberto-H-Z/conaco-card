-- Alta masiva generada para REVISIÓN desde la hoja depurado; no ejecutada.
-- Cámara: CANACO Orizaba. Localidad matriz: Orizaba.
-- Los correos del Excel contienen el valor de ejemplo repetido; se insertan como NULL.
-- No se crean promociones, archivos, galerías ni logo. El logo se podrá cargar al editar manualmente.
-- RFC provisionales asignados: 8. Sustituirlos por RFC fiscales posteriormente.

START TRANSACTION;
SET @camara_id = (SELECT idCamara FROM camaras WHERE clave = 'CANACO-ORIZABA' AND activo = 1 LIMIT 1);
SET @localidad_id = (SELECT idLocalidad FROM localidades WHERE nombre = 'Orizaba' AND activo = 1 LIMIT 1);

-- 01. ARI ADMINISTRACION DE RIESGO INTEGRALES | Categoría: Servicios Profesionales
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'AAR1702022Y3', 'ARI ADMINISTRACION DE RIESGO INTEGRALES', 'ari-administracion-de-riesgo-integrales', 'Empresa especializada en servicios de proteccion y custodia.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Arturo Lino Prado', NULL, NULL, '2727246069', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Oriente 6', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727246069', '2727246069', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721069240', '2721069240', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Servicios Profesionales' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'servicios profesionales', 'servicios profesionales');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'asesoría', 'asesoría');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'empresas', 'empresas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'ari', 'ari');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'administracion', 'administracion');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'riesgo', 'riesgo');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'integrales', 'integrales');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'SITIO_WEB', 'https://www.arimexico.com.mx', 1);

-- 02. BADO´S JOYERIA | Categoría: Joyerías
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'SACI520617UF5', 'BADO´S JOYERIA', 'bados-joyeria', 'Empresa especializada en taller de joyería y relojeria.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Jose Ismael Librado Sanchez Chavez', NULL, NULL, '2727257644', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Sur 3', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727257644', '2727257644', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721817350', '2721817350', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Joyerías' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'joyería', 'joyería');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'joyas', 'joyas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'relojería', 'relojería');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'bado', 'bado');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Bados%20Joyeria/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/Bados%20Joyeria/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'SITIO_WEB', 'https://badosjoyeria.com.mx', 1);

-- 03. FUNWASH LIMPIEZA PROFESIONAL | Categoría: Autolavados
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'WAMG770502HA9', 'FUNWASH LIMPIEZA PROFESIONAL', 'funwash-limpieza-profesional', 'Empresa especializada en autolavado.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Guillermo Wappler Martinez', NULL, NULL, '2721038086', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Oriente 9', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2721038086', '2721038086', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721038086', '2721038086', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Autolavados' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'autolavado', 'autolavado');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'limpieza', 'limpieza');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'vehículos', 'vehículos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'funwash', 'funwash');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'profesional', 'profesional');

-- 04. INEVED | Categoría: Consultoría y Capacitación
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'FECL841228M93', 'INEVED', 'ineved', 'Empresa especializada en capacitación, talleres, conferencias, programas de evaluacion educativa, asesoría juridica preventiva y derecho deportivo.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Liliana Fernandez Contreras', NULL, NULL, '2727221969', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Camerino Z. Mendoza', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727221969', '2727221969', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2727221969', '2727221969', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Consultoría y Capacitación' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'capacitación', 'capacitación');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'consultoría', 'consultoría');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'educación', 'educación');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'ineved', 'ineved');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Inevedmx/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/Inevedmx/', 1);

-- 05. X PET "LA IMAGEN DE TU MASCOTA" | Categoría: Imagenología Veterinaria
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'SARP891212GU2', 'X PET "LA IMAGEN DE TU MASCOTA"', 'x-pet-la-imagen-de-tu-mascota', 'Empresa especializada en servicios veterinarios (IMAGENOLOGIA).', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Publio Alberto Saldaña Romero', NULL, NULL, '2722044489', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Norte 12', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2722044489', '2722044489', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2722044489', '2722044489', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Imagenología Veterinaria' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'veterinaria', 'veterinaria');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'imagenología', 'imagenología');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'mascotas', 'mascotas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'pet', 'pet');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'imagen', 'imagen');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'mascota', 'mascota');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/X_Pet/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/X_PET_ORIZABA/', 1);

-- 06. ORIGINALES DALI | Categoría: Uniformes
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'CARD420403CQA', 'ORIGINALES DALI', 'originales-dali', 'Empresa especializada en venta de uniformes escolares y deportivos.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Dalia Gonzalez Castro', NULL, NULL, '2727258383', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Norte 7 "A"', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727258383', '2727258383', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2722040561', '2722040561', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Uniformes' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'uniformes', 'uniformes');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'ropa escolar', 'ropa escolar');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'deportivo', 'deportivo');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'originales', 'originales');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'dali', 'dali');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/originalesdali/', 1);

-- 07. MEDIA PLANNING PUBLICIDAD | Categoría: Servicios Audiovisuales
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'PEMJ820827A88', 'MEDIA PLANNING PUBLICIDAD', 'media-planning-publicidad', 'Empresa especializada en agencia de Publicidad.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Jorge R. Pelaez Muñoz', NULL, NULL, '2722130972', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Sur 25', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2722130972', '2722130972', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2722130972', '2722130972', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Servicios Audiovisuales' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'publicidad', 'publicidad');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'audiovisual', 'audiovisual');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'diseño', 'diseño');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'media', 'media');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'planning', 'planning');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Media%20Planning%20Publicidad/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/m_ppublicidad/', 1);

-- 08. VEOPTIX OPTICA | Categoría: Ópticas
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'AUSB890919M66', 'VEOPTIX OPTICA', 'veoptix-optica', 'Empresa especializada en vENTA AL POR MENOR DE LENTES.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'BERENICE ABURTO SÁNCHEZ', NULL, NULL, '2727266134', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'NORTE 3', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727266134', '2727266134', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2722051589', '2722051589', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Ópticas' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'óptica', 'óptica');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'lentes', 'lentes');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'salud visual', 'salud visual');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'veoptix', 'veoptix');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Optica%20Veoptix%20Orizaba/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/Optica%20Veoptix%20Orizaba/', 1);

-- 09. VILLAS PICO DE ORIZABA | Categoría: Turismo y Hospedaje
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'MORM700610I47', 'VILLAS PICO DE ORIZABA', 'villas-pico-de-orizaba', 'Empresa especializada en hospedaje, Alimentos y Bebidas.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Martin Moreno Rojas', NULL, NULL, '2727221953', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Panda, Predio Las Lomas, 94152, La Perla, Ver', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727221953', '2727221953', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2727221953', '2727221953', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Turismo y Hospedaje' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'turismo', 'turismo');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'viajes', 'viajes');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'hospedaje', 'hospedaje');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'villas', 'villas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'pico', 'pico');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'orizaba', 'orizaba');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Villas%20Pico%20De%20Orizaba/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/VILLASPICODEORIZABA/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'SITIO_WEB', 'https://villaspico.com', 1);

-- 10. VISAME CONSULTORES | Categoría: Turismo y Hospedaje
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'PENDIENTE1001', 'VISAME CONSULTORES', 'visame-consultores', 'Empresa especializada en asesoría en trámite de visas americanas y canadienes y pasaportes.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Liliana Fernández Contreras', NULL, NULL, '2727221969', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Camerino Z. Mendoza', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727221969', '2727221969', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2287533321', '2287533321', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Turismo y Hospedaje' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'turismo', 'turismo');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'viajes', 'viajes');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'hospedaje', 'hospedaje');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'visame', 'visame');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'consultores', 'consultores');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/visameconsultores/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/visameconsultores/', 1);

-- 11. TINTORERÍA PRESSTO | Categoría: Servicios Profesionales
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'LVE040708AYA', 'TINTORERÍA PRESSTO', 'tintoreria-pressto', 'Empresa especializada en tintorería.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Daniel Ventura Mendez', NULL, NULL, '2721061286', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Av. Oriente 6', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2721061286', '2721061286', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721802180', '2721802180', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Servicios Profesionales' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'servicios profesionales', 'servicios profesionales');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'asesoría', 'asesoría');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'empresas', 'empresas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'tintorería', 'tintorería');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'pressto', 'pressto');

-- 12. OPTICA ESPAÑA | Categoría: Ópticas
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'OES210602QX8', 'OPTICA ESPAÑA', 'optica-espana', 'Empresa especializada en óptica (Comercio al por menor de lentes).', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Alejandro Hernández Trueba', NULL, NULL, '2727259928', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Av. Oriente 4', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727259928', '2727259928', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2722345610', '2722345610', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Ópticas' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'óptica', 'óptica');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'lentes', 'lentes');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'salud visual', 'salud visual');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'españa', 'españa');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/opticaespana', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/optica_espana', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'SITIO_WEB', 'https://www.opticaespaña.com', 1);

-- 13. PURANA SPA | Categoría: Spa y Cosmetología
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'SARI860607QV6', 'PURANA SPA', 'purana-spa', 'Empresa especializada en spa/Servicios cosmetológicos.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Ihali Saldaña Romero', NULL, NULL, '27210004266', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Poniente 6A', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '27210004266', '27210004266', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721004266', '2721004266', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Spa y Cosmetología' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'spa', 'spa');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'belleza', 'belleza');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'cosmetología', 'cosmetología');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'purana', 'purana');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Purannaspa/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/Purannaspa/', 1);

-- 14. ORGANIZACIÓN TURISTICA INTEGRAL | Categoría: Turismo y Hospedaje
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'BARB740427NY2', 'ORGANIZACIÓN TURISTICA INTEGRAL', 'organizacion-turistica-integral', 'Agencia dedicada a organizar viajes y renta de transporte turístico.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Aldo Israel Romero Lezama', NULL, NULL, '2727273138', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Av. Morelos 103 Centro 94707', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727273138', '2727273138', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2727221492', '2727221492', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Turismo y Hospedaje' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'turismo', 'turismo');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'viajes', 'viajes');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'hospedaje', 'hospedaje');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'organización', 'organización');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'turistica', 'turistica');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'integral', 'integral');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Aldo%20Turistica/', 1);

-- 15. DECROLY JARDÍN DE NIÑOS | Categoría: Consultoría y Capacitación
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'GAHR8409121I7', 'DECROLY JARDÍN DE NIÑOS', 'decroly-jardin-de-ninos', 'Empresa especializada en capacitación, talleres, conferencias, programas de evaluacion educativa, asesoría juridica preventiva y derecho deportivo.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'María del Rayo García Hernández', NULL, NULL, '2721737808', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Callejón del Yute', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2721737808', '2721737808', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721737808', '2721737808', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Consultoría y Capacitación' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'capacitación', 'capacitación');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'consultoría', 'consultoría');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'educación', 'educación');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'decroly', 'decroly');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'jardín', 'jardín');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'niños', 'niños');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/JNDECROLY/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/Decroly%20Orizaba/', 1);

-- 16. COLEGIO JEAN PIAGET Y VIAJES GALI | Categoría: Consultoría y Capacitación
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'HEPL7210145T0', 'COLEGIO JEAN PIAGET Y VIAJES GALI', 'colegio-jean-piaget-y-viajes-gali', 'Empresa especializada en capacitación, talleres, conferencias, programas de evaluacion educativa, asesoría juridica preventiva y derecho deportivo.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Lilian Hernandez Plauchu', NULL, NULL, '0000000016', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Sol de Mayo', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '0000000016', '0000000016', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721064167', '2721064167', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Consultoría y Capacitación' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'capacitación', 'capacitación');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'consultoría', 'consultoría');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'educación', 'educación');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'colegio', 'colegio');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'jean', 'jean');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'piaget', 'piaget');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'viajes', 'viajes');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'gali', 'gali');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Colegio%20JeanPiaget%20Mendoza/', 1);

-- 17. ZAC LEADING SEGUROS Y FINANZAS | Categoría: Servicios Profesionales
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'ZADR8303248SA', 'ZAC LEADING SEGUROS Y FINANZAS', 'zac-leading-seguros-y-finanzas', 'Empresa especializada en seguros.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Rene Zacahula Domínguez', NULL, NULL, '2721008624', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Plaza Cerritos Interior 57 Poniente 32', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2721008624', '2721008624', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721008624', '2721008624', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Servicios Profesionales' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'servicios profesionales', 'servicios profesionales');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'asesoría', 'asesoría');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'empresas', 'empresas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'zac', 'zac');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'leading', 'leading');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'seguros', 'seguros');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'finanzas', 'finanzas');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/zacleading/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/zacleading/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'SITIO_WEB', 'https://www.zacleading.com.mx', 1);

-- 18. ISPIRAZIONE INSPIRANDO TU AROMA | Categoría: Perfumerías
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'RIAM840502P46', 'ISPIRAZIONE INSPIRANDO TU AROMA', 'ispirazione-inspirando-tu-aroma', 'Empresa especializada en perfumeria.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Marco Antonio Rivas Álvarez', NULL, NULL, '2724010836', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Oriente 4', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2724010836', '2724010836', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2722357592', '2722357592', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Perfumerías' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'perfumería', 'perfumería');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'aromas', 'aromas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'belleza', 'belleza');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'ispirazione', 'ispirazione');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'inspirando', 'inspirando');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'aroma', 'aroma');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Ispirazione.perfumes/', 1);

-- 19. RESTAURANT LAS FUENTES | Categoría: Restaurantes
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'GUPM721218EK6', 'RESTAURANT LAS FUENTES', 'restaurant-las-fuentes', 'Empresa especializada en restaurantes y cafeterías.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Marisol Gutiérrez Pontón', NULL, NULL, '2727255833', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Av. Poniente 7', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727255833', '2727255833', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Restaurantes' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'restaurante', 'restaurante');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'alimentos', 'alimentos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'bebidas', 'bebidas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'restaurant', 'restaurant');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'fuentes', 'fuentes');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Hotel%20Pluviosilla%20Orizaba/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/hotelpluviosilla/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'SITIO_WEB', 'https://www.hotelpluviosilla.com', 1);

-- 20. CARPINTODO | Categoría: Ferreterías
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'PENDIENTE0001', 'CARPINTODO', 'carpintodo', 'Empresa especializada en ferreteria.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Rodolfo Andrade Vega', NULL, NULL, '2727257229', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Sur 2', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727257229', '2727257229', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721198092', '2721198092', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Ferreterías' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'ferretería', 'ferretería');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'herramientas', 'herramientas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'construcción', 'construcción');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'carpintodo', 'carpintodo');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Carpintodo/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/tiendascarpintodo/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'SITIO_WEB', 'https://www.tiendascarpintodo.com.mx', 1);

-- 21. CARPINTODO | Categoría: Ferreterías
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'PENDIENTE0002', 'CARPINTODO', 'carpintodo-2', 'Empresa especializada en ferreteria.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Rodolfo Andrade Vega', NULL, NULL, '2727268226', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Poniente 7', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727268226', '2727268226', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Ferreterías' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'ferretería', 'ferretería');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'herramientas', 'herramientas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'construcción', 'construcción');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'carpintodo', 'carpintodo');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Carpintodo/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/tiendascarpintodo/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'SITIO_WEB', 'https://www.tiendascarpintodo.com.mx', 1);

-- 22. CARPINTODO | Categoría: Ferreterías
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'PENDIENTE0003', 'CARPINTODO', 'carpintodo-3', 'Empresa especializada en ferreteria.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Rodolfo Andrade Vega', NULL, NULL, '2727251269', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Av. Juárez', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727251269', '2727251269', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Ferreterías' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'ferretería', 'ferretería');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'herramientas', 'herramientas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'construcción', 'construcción');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'carpintodo', 'carpintodo');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Carpintodo/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/tiendascarpintodo/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'SITIO_WEB', 'https://www.tiendascarpintodo.com.mx', 1);

-- 23. LOS PATOS VINOS Y LICORES | Categoría: Vinos y Licores
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'CUPE9203053Q3', 'LOS PATOS VINOS Y LICORES', 'los-patos-vinos-y-licores', 'Empresa especializada en vinos y licores.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Estefania Cruz Peña', NULL, NULL, '2727248383', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Oriente 6', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727248383', '2727248383', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721722409', '2721722409', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Vinos y Licores' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'vinos', 'vinos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'licores', 'licores');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'bebidas', 'bebidas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'patos', 'patos');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Vinos%20y%20Licores%20Los%20Patos/', 1);

-- 24. COMERVIC | Categoría: Servicios Audiovisuales
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'LUCU760916PHA', 'COMERVIC', 'comervic', 'Empresa especializada en audiovisual.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Victor Manuel Luna Cubillas', NULL, NULL, '0000000024', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Oriente 5', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '0000000024', '0000000024', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721302492', '2721302492', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Servicios Audiovisuales' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'publicidad', 'publicidad');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'audiovisual', 'audiovisual');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'diseño', 'diseño');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'comervic', 'comervic');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'SITIO_WEB', 'https://vimaluco@hotmail.com', 1);

-- 25. LA CASONA | Categoría: Restaurantes
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'FTG230405MI4', 'LA CASONA', 'la-casona', 'Empresa especializada en restaurantes y cafeterías.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Francisco Colina Trujillo', NULL, NULL, '0000000025', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Norte 3 S/n esq. Poniente 2', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '0000000025', '0000000025', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721722289', '2721722289', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Restaurantes' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'restaurante', 'restaurante');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'alimentos', 'alimentos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'bebidas', 'bebidas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'casona', 'casona');

-- 26. UNIVERSIDAD DE ORIENTE | Categoría: Consultoría y Capacitación
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'IEA900730CK1', 'UNIVERSIDAD DE ORIENTE', 'universidad-de-oriente', 'Empresa especializada en servicios Educativos.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Grabriela Pablo Urquia', NULL, NULL, '2727250007', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Poniente 5 Num.454', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727250007', '2727250007', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2712664115', '2712664115', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Consultoría y Capacitación' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'capacitación', 'capacitación');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'consultoría', 'consultoría');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'educación', 'educación');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'universidad', 'universidad');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'oriente', 'oriente');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/IDEA%20de%20Oriente/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/ideadeoriente/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'SITIO_WEB', 'https://www.ideadeoriente.edu.mx', 1);

-- 27. ESEFI Y ASOCIADOS | Categoría: Servicios Profesionales
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'BAPP800928HC4', 'ESEFI Y ASOCIADOS', 'esefi-y-asociados', 'Empresa especializada en seguros, Fianzas E Inversiones.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Lic.Paulina Alejandra Báoz Paz', NULL, NULL, '2721391844', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Oriente 8 Num. 1079-A', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2721391844', '2721391844', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721391844', '2721391844', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Servicios Profesionales' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'servicios profesionales', 'servicios profesionales');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'asesoría', 'asesoría');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'empresas', 'empresas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'esefi', 'esefi');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'asociados', 'asociados');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/FB%20ESEFI%20y%20Asociados%2C%20Especialistas%20en%20Seguros%20y%20Fianzas/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/ESEFISEGUROSyfianzas/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'SITIO_WEB', 'https://w.w.w.ESEFIyasociados.com', 1);

-- 28. TACO T | Categoría: Taquerías
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'PENDIENTE1002', 'TACO T', 'taco-t', 'Empresa especializada en taquería.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Victor Javier Durango Cabrera', NULL, NULL, '2721061049', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Oriente 4', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2721061049', '2721061049', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2294143104', '2294143104', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Taquerías' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'taquería', 'taquería');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'tacos', 'tacos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'comida', 'comida');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'taco', 'taco');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Taco%20T/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/tacoterizaba/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'SITIO_WEB', 'https://tacote.com.mx', 1);

-- 29. REVER IMPERMEABILIZANTES Y RECUBRIMIENTOS VERACRUZ | Categoría: Pinturas e Impermeabilizantes
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'HEAA7210188J8', 'REVER IMPERMEABILIZANTES Y RECUBRIMIENTOS VERACRUZ', 'rever-impermeabilizantes-y-recubrimientos-veracruz', 'Empresa especializada en material de construcción.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Ana Teresa Herrera Aguilar', NULL, NULL, '2721308899', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Calle Tulipan', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2721308899', '2721308899', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721308899', '2721308899', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Pinturas e Impermeabilizantes' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'pinturas', 'pinturas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'impermeabilizantes', 'impermeabilizantes');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'recubrimientos', 'recubrimientos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'rever', 'rever');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'veracruz', 'veracruz');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/REVERinpermeabiliantes%20y%20recubrimientos%20Vreacruz/', 1);

-- 30. SUPER TORTAS ORIZABEÑAS | Categoría: Torterías
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'NAF58611018X9', 'SUPER TORTAS ORIZABEÑAS', 'super-tortas-orizabenas', 'Empresa especializada en tortería.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Javier Adrian Nava Fernandez', NULL, NULL, '2721801273', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Oriente 5 Mercado Melchor Ocampo Sur: Colon Poniente', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2721801273', '2721801273', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Torterías' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'tortería', 'tortería');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'tortas', 'tortas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'comida', 'comida');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'super', 'super');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'orizabeñas', 'orizabeñas');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Super%20Tortas%20Orizabe%C3%B1as/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/Super%20Tortas%20orizabe%C3%B1as/', 1);

-- 31. VIAJES MADI | Categoría: Turismo y Hospedaje
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'VEMM7001096AA', 'VIAJES MADI', 'viajes-madi', 'Empresa especializada en agencia de viajes.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Mayra Velasco Morales', NULL, NULL, '2727243065', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Oriente 10 SSB', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727243065', '2727243065', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2727036019', '2727036019', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Turismo y Hospedaje' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'turismo', 'turismo');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'viajes', 'viajes');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'hospedaje', 'hospedaje');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'madi', 'madi');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.viajesmadi.exodus.mx', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/viajesmadi/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'SITIO_WEB', 'https://www.viajesmadi.com.mx', 1);

-- 32. PAPELERÍA TOBY | Categoría: Papelerías
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'HEGE680602RM6', 'PAPELERÍA TOBY', 'papeleria-toby', 'Empresa especializada en papelería y regalos.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'María Eugenia Hernández García', NULL, NULL, '2721020803', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Calle 3', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2721020803', '2721020803', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721020803', '2721020803', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Papelerías' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'papelería', 'papelería');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'útiles', 'útiles');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'regalos', 'regalos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'toby', 'toby');

-- 33. LAVADO GARPE ORIZABA | Categoría: Autolavados
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'GAAD860919EU4', 'LAVADO GARPE ORIZABA', 'lavado-garpe-orizaba', 'Empresa especializada en servicios de limpieza.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'David Sebastían García Arenas', NULL, NULL, '2221610357272176', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Andador 8', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2221610357272176', '2221610357272176', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2221610357272176', '2221610357272176', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Autolavados' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'autolavado', 'autolavado');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'limpieza', 'limpieza');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'vehículos', 'vehículos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'lavado', 'lavado');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'garpe', 'garpe');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'orizaba', 'orizaba');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Lavado%20de%20salas%20y%20vestiduras%20de%20auto%20Orizaba/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/lavadogarpe/', 1);

-- 34. PERFUMERÍA CASA AZUL | Categoría: Perfumerías
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'PELS890728069', 'PERFUMERÍA CASA AZUL', 'perfumeria-casa-azul', 'Empresa especializada en belleza.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Sigried Dayela Petterson Luna', NULL, NULL, '2727260851', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Poniente 5', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727260851', '2727260851', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2724176470', '2724176470', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Perfumerías' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'perfumería', 'perfumería');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'aromas', 'aromas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'belleza', 'belleza');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'casa', 'casa');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'azul', 'azul');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Perfumer%C3%ADa%20Casa%20Az%C3%BAl/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/perfumer%C3%ADacasasazul/', 1);

-- 35. TURISMO AVENTURA | Categoría: Turismo y Hospedaje
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'RODR6008109P3', 'TURISMO AVENTURA', 'turismo-aventura', 'Empresa especializada en agencia de Viajes.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Ricardo Rofríguez Deméneghi', NULL, NULL, '2727251491', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Poniente 9', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727251491', '2727251491', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2722456826', '2722456826', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Turismo y Hospedaje' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'turismo', 'turismo');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'viajes', 'viajes');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'hospedaje', 'hospedaje');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'aventura', 'aventura');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/SalvemosalPicodeOrizaba/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/salvemos_pico_orizaba/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'SITIO_WEB', 'https://turismoaventuraorizaba.com', 1);

-- 36. VICTORÍA SERVICE | Categoría: Alimentos y Bebidas
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'CAJE8610256DA', 'VICTORÍA SERVICE', 'victoria-service', 'Empresa especializada en alimentos y bebidas.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Erik G. Carmona De Jesús', NULL, NULL, '2722030447', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Pedios por whatsapp', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2722030447', '2722030447', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2722030447', '2722030447', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Alimentos y Bebidas' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'alimentos', 'alimentos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'bebidas', 'bebidas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'comercio', 'comercio');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'victoría', 'victoría');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'service', 'service');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Victor%C3%ADaService/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/Victor%C3%ADa.Service/', 1);

-- 37. SALÓN DE FIESTAS CONFETTIS | Categoría: Eventos
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'PENDIENTE1003', 'SALÓN DE FIESTAS CONFETTIS', 'salon-de-fiestas-confettis', 'Empresa especializada en salón de fiestas.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Elyana Cristina Palaéz Muñoz', NULL, NULL, '2722469092', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Sur 6', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2722469092', '2722469092', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2722374820', '2722374820', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Eventos' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'eventos', 'eventos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'fiestas', 'fiestas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'celebraciones', 'celebraciones');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'salón', 'salón');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'confettis', 'confettis');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Sal%C3%B3n%20Confettis/', 1);

-- 38. DULCES IMPRESIONES | Categoría: Panaderías y Pastelerías
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'RODA660825H22', 'DULCES IMPRESIONES', 'dulces-impresiones', 'Empresa especializada en pastelería.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Ana Genoveva Romero De Dios', NULL, NULL, '2721649260272206', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Oriente 5', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2721649260272206', '2721649260272206', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721649260272206', '2721649260272206', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Panaderías y Pastelerías' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'pastelería', 'pastelería');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'dulces', 'dulces');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'repostería', 'repostería');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'impresiones', 'impresiones');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Dulces%20Impresiones%20Orizaba/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/dulcesimpresionesorizaba/', 1);

-- 39. MINONI | Categoría: Pizzerías
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'PENDIENTE0004', 'MINONI', 'minoni', 'Restaurante de comida italiana con pizzas, alitas y servicio a domicilio.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Erique Israel Guillomen Maldonado', NULL, NULL, '0000000039', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'NO INFO', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '0000000039', '0000000039', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Pizzerías' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'pizzería', 'pizzería');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'pizza', 'pizza');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'comida', 'comida');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'minoni', 'minoni');

-- 40. CORAZÓN DE AMARANTO | Categoría: Restaurantes
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'PENDIENTE0005', 'CORAZÓN DE AMARANTO', 'corazon-de-amaranto', 'Restaurante de alimentos y bebidas con promociones para afiliados.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Erique Israel Guillomen Maldonado', NULL, NULL, '0000000040', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'NO INFO', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '0000000040', '0000000040', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Restaurantes' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'restaurante', 'restaurante');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'alimentos', 'alimentos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'bebidas', 'bebidas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'corazón', 'corazón');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'amaranto', 'amaranto');

-- 41. AUTENTIK SALON | Categoría: Estéticas y Salas de Belleza
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'AVLW8408096B7', 'AUTENTIK SALON', 'autentik-salon', 'Empresa especializada en estética/Sala de belleza.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Wendy Aguilar Longoria', NULL, NULL, '2721730517272289', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'NO INFO', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2721730517272289', '2721730517272289', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721730517', '2721730517', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Estéticas y Salas de Belleza' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'estética', 'estética');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'belleza', 'belleza');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'salón', 'salón');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'autentik', 'autentik');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Autentik%20Salon%20by%20Wendt%20Longoria/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/autentiksalon/', 1);

-- 42. MEDICALPET | Categoría: Clínicas Veterinarias
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'SOMG870113DN5', 'MEDICALPET', 'medicalpet', 'Clínica veterinaria con atención, estética y accesorios para mascotas.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Giselle Irais Solis Martinez', NULL, NULL, '2727250814', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Sur 16 Num. 110', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727250814', '2727250814', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721301673', '2721301673', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Clínicas Veterinarias' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'veterinaria', 'veterinaria');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'mascotas', 'mascotas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'salud animal', 'salud animal');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'medicalpet', 'medicalpet');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/medicalpet%20veterinaria%20y%20est%C3%A9tica%20canina%20y%20boutique/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/medicalpetveterinaria/', 1);

-- 43. LA PROSPERIDAD | Categoría: Restaurantes
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'EICA8312255R6', 'LA PROSPERIDAD', 'la-prosperidad', 'Empresa especializada en restaurante.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'José Alfonso Esprinoza Cabrerra', NULL, NULL, '2721900373', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Francisco I. Maero', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2721900373', '2721900373', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721900373', '2721900373', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Restaurantes' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'restaurante', 'restaurante');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'alimentos', 'alimentos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'bebidas', 'bebidas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'prosperidad', 'prosperidad');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/La%20Prosperidad/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/La%20prosperidad/', 1);

-- 44. PRODUCTOS DE LIMPIEZA FERSAL | Categoría: Comercio
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'FEGR890627AU4', 'PRODUCTOS DE LIMPIEZA FERSAL', 'productos-de-limpieza-fersal', 'Empresa especializada en comercio de Productos de Limpieza.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Rodolfo Fernández Garcia', NULL, NULL, '2722583188272167', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Sucursal Orizaba Ote 15 Num 799-1', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2722583188272167', '2722583188272167', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2722583188272167', '2722583188272167', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Comercio' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'comercio', 'comercio');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'productos', 'productos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'tienda', 'tienda');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'limpieza', 'limpieza');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'fersal', 'fersal');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Productos%20de%20limpieza%20Fersal/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/Productos%20de%20limpieza%20Fersal/', 1);

-- 45. PRODUCTOS DE LIMPIEZA FERSAL | Categoría: Comercio
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'FEGR890627AU5', 'PRODUCTOS DE LIMPIEZA FERSAL', 'productos-de-limpieza-fersal-2', 'Empresa especializada en comercio de Productos de Limpieza.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Rodolfo Fernández Garcia', NULL, NULL, '2722583188272167', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Sucursal Ixtac Ote 4 Num21 Esq con Sur 3', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2722583188272167', '2722583188272167', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2722583188272167', '2722583188272167', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Comercio' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'comercio', 'comercio');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'productos', 'productos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'tienda', 'tienda');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'limpieza', 'limpieza');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'fersal', 'fersal');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Productos%20de%20limpieza%20Fersal/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/Productos%20de%20limpieza%20Fersal/', 1);

-- 46. LIBRERÍA EL PUENTE | Categoría: Librerías
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'LPU2301103UA', 'LIBRERÍA EL PUENTE', 'libreria-el-puente', 'Empresa especializada en librería.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Ana Lady Godonez Juarez', NULL, NULL, '2727265232', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Sur 7', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727265232', '2727265232', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721348965', '2721348965', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Librerías' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'librería', 'librería');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'libros', 'libros');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'lectura', 'lectura');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'puente', 'puente');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/Librer%C3%ADa%20puente/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'SITIO_WEB', 'https://libreriapuente.com', 1);

-- 47. ANGEL'S CAFÉ & OCEAN'S DRINKS | Categoría: Cafeterías
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'HEVM720823KG8', 'ANGEL''S CAFÉ & OCEAN''S DRINKS', 'angels-cafe-oceans-drinks', 'Empresa especializada en cafetería /Bar.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Miguel Ángel Henández Vargas', NULL, NULL, '2726887734', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Note 30, 185', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2726887734', '2726887734', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721164622', '2721164622', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Cafeterías' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'cafetería', 'cafetería');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'café', 'café');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'bebidas', 'bebidas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'angel', 'angel');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'ocean', 'ocean');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'drinks', 'drinks');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Angel%27s%20Caf%C3%A9/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/Oceans.drinks/', 1);

-- 48. ROMERO &MENTA | Categoría: Restaurantes
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'HEMR7205012B4', 'ROMERO &MENTA', 'romero-menta', 'Empresa especializada en restaurante.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Miriam Guadalupe Hernández', NULL, NULL, '2723417905', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Francisco I. Madero Sur 391', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2723417905', '2723417905', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2722290829', '2722290829', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Restaurantes' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'restaurante', 'restaurante');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'alimentos', 'alimentos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'bebidas', 'bebidas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'romero', 'romero');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'menta', 'menta');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/ROMERO%26MENTA/', 1);

-- 49. CASA MARVEN | Categoría: Muebles y Colchones
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'VICR630909EL2', 'CASA MARVEN', 'casa-marven', 'Empresa especializada en compra-venta de muebles para el hogar y línea blanca.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Rosalba Villaseñor Cervantes', NULL, NULL, '2727252986', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Poniente 7', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727252986', '2727252986', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2711355358', '2711355358', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Muebles y Colchones' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'muebles', 'muebles');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'colchones', 'colchones');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'hogar', 'hogar');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'casa', 'casa');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'marven', 'marven');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/CASA%20MARVEN/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/CASA%20MARVEN/', 1);

-- 50. EL ENCHILADITO | Categoría: Rosticerías
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'SAMR740830ADA', 'EL ENCHILADITO', 'el-enchiladito', 'Empresa especializada en rosticería (Comida para llevar).', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Rosa Isela Sanpedro Miguel', NULL, NULL, '2721074687', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Norte 12', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2721074687', '2721074687', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2722057754', '2722057754', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Rosticerías' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'rosticería', 'rosticería');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'comida', 'comida');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'para llevar', 'para llevar');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'enchiladito', 'enchiladito');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/El%20enchiladito/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/El%20enchiladito/', 1);

-- 51. GASTRONOMICA MARRÓN, S, DE R.L. DE C.V. | Categoría: Restaurantes
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'GMA130212M99', 'GASTRONOMICA MARRÓN, S, DE R.L. DE C.V.', 'gastronomica-marron-s-de-r-l-de-c-v', 'Empresa especializada en cocina Galería.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Francisco Colina Trujillo', NULL, NULL, '2727240139', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Ote. 4', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727240139', '2727240139', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Restaurantes' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'restaurante', 'restaurante');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'alimentos', 'alimentos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'bebidas', 'bebidas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'gastronomica', 'gastronomica');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'marrón', 'marrón');

-- 52. SEI- MG | Categoría: Servicios Profesionales
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'PENDIENTE1004', 'SEI- MG', 'sei-mg', 'Empresa especializada en servicios ambientales, de seguridad e higiene. Protección civil, matenimiento, venta y recarga de extintores.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Paulina Guerrero Bravo', NULL, NULL, '2721700134', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Norte 5', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2721700134', '2721700134', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721700134', '2721700134', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Servicios Profesionales' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'servicios profesionales', 'servicios profesionales');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'asesoría', 'asesoría');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'empresas', 'empresas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'sei', 'sei');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/SEI%20Sistemas%20Ecol%C3%B3gicos%20Industriales/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/sei_sistemas_ecologicos/', 1);

-- 53. C ECATTO PUBLICIDAD | Categoría: Servicios Audiovisuales
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'MECA730401991', 'C ECATTO PUBLICIDAD', 'c-ecatto-publicidad', 'Empresa especializada en diseño e impresión publicitaría.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Atenea Merino Cicatto', NULL, NULL, '2727250937', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Sur 33', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727250937', '2727250937', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '272166041', '272166041', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Servicios Audiovisuales' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'publicidad', 'publicidad');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'audiovisual', 'audiovisual');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'diseño', 'diseño');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'ecatto', 'ecatto');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/CttoPublicidad/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'SITIO_WEB', 'https://Cecattopublicidad.com', 1);

-- 54. COMERCILALIZADORA LA VICTORIA | Categoría: Comercio
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'ZAHD900208BA6', 'COMERCILALIZADORA LA VICTORIA', 'comercilalizadora-la-victoria', 'Empresa especializada en compra y venta de articulos nacionaes y de impotación de los departamentos de Papelería, Juguetería, Regalos, Línea del Hogar, Fiestas, Eventos y Temporadas especiales. Manejamos precios de.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Dulce Carolina Zacarías Hernández', NULL, NULL, '2727214791', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Ponente 6', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727214791', '2727214791', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721851137', '2721851137', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Comercio' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'comercio', 'comercio');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'productos', 'productos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'tienda', 'tienda');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'comercilalizadora', 'comercilalizadora');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'victoria', 'victoria');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Comercializadora%20La%20Victoria/', 1);

-- 55. ENAMÓRATE | Categoría: Bisutería
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'MAHA650715TV3', 'ENAMÓRATE', 'enamorate', 'Empresa especializada en bisutería.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Alejandra Marenco Herrera', NULL, NULL, '2721473240', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Oriente 4', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2721473240', '2721473240', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721473240', '2721473240', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Bisutería' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'bisutería', 'bisutería');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'accesorios', 'accesorios');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'moda', 'moda');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'enamórate', 'enamórate');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/facebook.com%2Fenamorate.bisuteria/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/instagram.com%2Fenamorate.bisuteria/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'SITIO_WEB', 'https://enamorate.com.mx/', 1);

-- 56. MADISON GRILL | Categoría: Restaurantes
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'PENDIENTE1005', 'MADISON GRILL', 'madison-grill', 'Empresa especializada en restaurante.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Isaac manuel mendez Aldazaba', NULL, NULL, '2721243282', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Ote. 2 1158, Centro, 94300 Orizaba, Ver', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2721243282', '2721243282', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Restaurantes' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'restaurante', 'restaurante');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'alimentos', 'alimentos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'bebidas', 'bebidas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'madison', 'madison');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'grill', 'grill');

-- 57. ESFERA | Categoría: Papelerías
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'ECE900430BW4', 'ESFERA', 'esfera', 'Empresa especializada en papelería.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Roberto Sanz Guraieb', NULL, NULL, '272725437', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Fco.I.Madero Sur 227, Centro, 94300 Orizaba Ver', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '272725437', '272725437', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Papelerías' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'papelería', 'papelería');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'útiles', 'útiles');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'regalos', 'regalos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'esfera', 'esfera');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/LA%20ESFERA/', 1);

-- 58. CLINICA PUERTA GRANDE | Categoría: Hospitales
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'CAM020504M14', 'CLINICA PUERTA GRANDE', 'clinica-puerta-grande', 'Empresa especializada en hospital.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Francisco Hernández Toledo', NULL, NULL, '27261492', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Carretera a Santana Ana Núm.53', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '27261492', '27261492', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Hospitales' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'hospital', 'hospital');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'salud', 'salud');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'atención médica', 'atención médica');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'clinica', 'clinica');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'puerta', 'puerta');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'grande', 'grande');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Cpuertagrande', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/hospitalpuertagrande', 1);

-- 59. SIETE VEINTICUATRO 7/24 | Categoría: Comercio
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'PENDIENTE0006', 'SIETE VEINTICUATRO 7/24', 'siete-veinticuatro-7-24', 'Tienda de conveniencia con productos de consumo diario.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'NO INFO', NULL, NULL, '0000000059', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'NO INFO', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '0000000059', '0000000059', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Comercio' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'comercio', 'comercio');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'productos', 'productos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'tienda', 'tienda');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'siete', 'siete');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'veinticuatro', 'veinticuatro');

-- 60. BENJAMINO´S PIZZAS | Categoría: Pizzerías
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'SARL980731NI5', 'BENJAMINO´S PIZZAS', 'benjaminos-pizzas', 'Empresa especializada en restaurante.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Liliana Samantha Saab Ramírez', NULL, NULL, '2721063117', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Oriente 7', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2721063117', '2721063117', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721810672', '2721810672', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Pizzerías' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'pizzería', 'pizzería');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'pizza', 'pizza');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'comida', 'comida');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'benjamino', 'benjamino');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'pizzas', 'pizzas');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Benjamino%C2%B4s%20pizzas%20pizzas%20a%20la%20le%C3%B1a/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/Benjamino%C2%B4s%20pizzas/', 1);

-- 61. ALVEMEX | Categoría: Pinturas e Impermeabilizantes
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'CERE880318E90', 'ALVEMEX', 'alvemex', 'Empresa especializada en venta de Pintura, Decorativo, Industrial.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Edgar Celisco Rodríguez', NULL, NULL, '2722129393', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Ote. 31 Núm. 176 A / Nort. 2 y 4', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2722129393', '2722129393', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2722129393', '2722129393', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Pinturas e Impermeabilizantes' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'pinturas', 'pinturas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'impermeabilizantes', 'impermeabilizantes');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'recubrimientos', 'recubrimientos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'alvemex', 'alvemex');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Cero_Pinturas_Alvamex/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/ceropinturasAlvamex/', 1);

-- 62. PINTURAS ALVEMEX CERO | Categoría: Pinturas e Impermeabilizantes
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'CERE880318E91', 'PINTURAS ALVEMEX CERO', 'pinturas-alvemex-cero', 'Empresa especializada en venta de Pintura, Decorativo, Industrial.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Edgar Celisco Rodríguez', NULL, NULL, '2722129393', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Ote. Esq. Sur.27. Orizaba Ver', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2722129393', '2722129393', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2722129393', '2722129393', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Pinturas e Impermeabilizantes' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'pinturas', 'pinturas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'impermeabilizantes', 'impermeabilizantes');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'recubrimientos', 'recubrimientos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'alvemex', 'alvemex');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'cero', 'cero');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Cero_Pinturas_Alvamex/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/ceropinturasAlvamex/', 1);

-- 63. WAPPLER JOYERÍA | Categoría: Joyerías
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'PENDIENTE0007', 'WAPPLER JOYERÍA', 'wappler-joyeria', 'Empresa especializada en joyería.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Brenda Wappler Barragán', NULL, NULL, '2727260811', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Oriente 2', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727260811', '2727260811', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Joyerías' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'joyería', 'joyería');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'joyas', 'joyas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'relojería', 'relojería');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'wappler', 'wappler');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/wapplerjoyeria/', 1);

-- 64. SHERWIN WILLIAMS | Categoría: Pinturas e Impermeabilizantes
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'PENDIENTE1006', 'SHERWIN WILLIAMS', 'sherwin-williams', 'Empresa especializada en pinturas e impermeabilizantes.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Brenda Barragán Romero', NULL, NULL, '2721063444', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Oriente 6', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2721063444', '2721063444', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721063444', '2721063444', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Pinturas e Impermeabilizantes' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'pinturas', 'pinturas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'impermeabilizantes', 'impermeabilizantes');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'recubrimientos', 'recubrimientos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'sherwin', 'sherwin');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'williams', 'williams');

-- 65. OH MY BOWS! | Categoría: Accesorios Textiles
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'PENDIENTE1007', 'OH MY BOWS!', 'oh-my-bows', 'Empresa especializada en accesorios Textiles.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Karla Abril Palacios Leynes', NULL, NULL, '2721839157', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Sam Alejandro Naúm. 73', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2721839157', '2721839157', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721839157', '2721839157', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Accesorios Textiles' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'accesorios textiles', 'accesorios textiles');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'moños', 'moños');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'moda', 'moda');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'bows', 'bows');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/oh%20my%20bows%21/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/oh%20my%20bows%21/', 1);

-- 66. MUNDO JOVEN TRAVEL SHOP | Categoría: Turismo y Hospedaje
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'TTOO70913925', 'MUNDO JOVEN TRAVEL SHOP', 'mundo-joven-travel-shop', 'Empresa especializada en agencia de viajes.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Juan Jose Cuna Vazquez', NULL, NULL, '2727253336272726', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Plaza Zora', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727253336272726', '2727253336272726', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '5585400994', '5585400994', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Turismo y Hospedaje' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'turismo', 'turismo');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'viajes', 'viajes');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'hospedaje', 'hospedaje');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'mundo', 'mundo');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'joven', 'joven');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'travel', 'travel');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'shop', 'shop');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Mundo%20J%C3%B3ven%20Orizaba/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/mundojovenorizaba/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'SITIO_WEB', 'https://www.mundojoven.com', 1);

-- 67. IQ ENGLISH ORIZABA | Categoría: Cursos de Inglés
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'LOSL660926LU2', 'IQ ENGLISH ORIZABA', 'iq-english-orizaba', 'Empresa especializada en servicios. Cursos en ingles.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Lourdes López Solis', NULL, NULL, '2727250414272725', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Av. Poniente 7 Núm. 417', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727250414272725', '2727250414272725', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2722159416', '2722159416', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Cursos de Inglés' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'inglés', 'inglés');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'cursos', 'cursos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'educación', 'educación');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'english', 'english');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'orizaba', 'orizaba');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/IQ%20English%20Orizaba/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/Iqenglishorizaba/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'SITIO_WEB', 'https://Iqenglishorizaba.com', 1);

-- 68. VINOS Y LICORES "EL GAVILAN" | Categoría: Vinos y Licores
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'PENDIENTE1008', 'VINOS Y LICORES "EL GAVILAN"', 'vinos-y-licores-el-gavilan', 'Empresa especializada en venta de Vinos y Licores.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Maria Teresa Guadalupe Lima Vallejo', NULL, NULL, '2727254109', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Oriente 7', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727254109', '2727254109', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721549324', '2721549324', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Vinos y Licores' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'vinos', 'vinos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'licores', 'licores');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'bebidas', 'bebidas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'gavilan', 'gavilan');

-- 69. VETERINARIA "DR. HUERTA" | Categoría: Clínicas Veterinarias
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'HUFA3809276X6', 'VETERINARIA "DR. HUERTA"', 'veterinaria-dr-huerta', 'Empresa especializada en clínica Veterinaria.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Adolfo Huerta Lozano', NULL, NULL, '2727256391', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Oriente 9', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727256391', '2727256391', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721220214', '2721220214', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Clínicas Veterinarias' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'veterinaria', 'veterinaria');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'mascotas', 'mascotas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'salud animal', 'salud animal');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'huerta', 'huerta');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/Clinica%20Veterinaria%20Dr.%20Huerta/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/drhuertaveterinaria/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'SITIO_WEB', 'https://www.drhuerta.com', 1);

-- 70. FULMINEX CONTROL DE PLAGAS | Categoría: Servicios Profesionales
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'BEML901008PR6', 'FULMINEX CONTROL DE PLAGAS', 'fulminex-control-de-plagas', 'Empresa especializada en servicios de Control de Plaga.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'C. Luis Berriell Merino', NULL, NULL, '2727260678', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Retorno 8', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727260678', '2727260678', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721171277', '2721171277', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Servicios Profesionales' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'servicios profesionales', 'servicios profesionales');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'asesoría', 'asesoría');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'empresas', 'empresas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'fulminex', 'fulminex');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'control', 'control');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'plagas', 'plagas');

-- 71. CLÍNICA DE MATERNIDAD PLUVIOSILLA | Categoría: Clínicas de Maternidad
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'DIOJ4811245I5', 'CLÍNICA DE MATERNIDAD PLUVIOSILLA', 'clinica-de-maternidad-pluviosilla', 'Empresa especializada en clínica de Maternidad.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Juan Edgar Diaz Ortega', NULL, NULL, '2727250940', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'clinica+H', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727250940', '2727250940', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2722605382', '2722605382', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Clínicas de Maternidad' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'maternidad', 'maternidad');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'clínica', 'clínica');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'salud', 'salud');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'pluviosilla', 'pluviosilla');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/clinica%20maternidad%20pluviosilla/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/clinica%20maternidad%20pluviosilla/', 1);

-- 72. DOMU SUSHI BAR | Categoría: Restaurantes
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'OZA031022JQ4', 'DOMU SUSHI BAR', 'domu-sushi-bar', 'Empresa especializada en alimentos - Restaurante asiatico.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Gabriela Rodríguez Aiza', NULL, NULL, '2722061452', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Orizaba - Ote . 6 1469, Centro, 94363 Orizaba, Ver. Córdoba- av. 9- bis calles 22 Calle, C. 22-A, San José, 94560 Córdoba, Ver', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2722061452', '2722061452', 1);
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'WHATSAPP', '2721670851', '2721670851', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Restaurantes' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'restaurante', 'restaurante');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'alimentos', 'alimentos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'bebidas', 'bebidas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'domu', 'domu');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'sushi', 'sushi');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'bar', 'bar');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/DomuSushiBarOrizaba/?locale=es', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'https://www.instagram.com/domosushibarmx/?hl=es', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'SITIO_WEB', 'https://www.domu.com.mx/', 1);

-- 73. LA PARROQUIA DE VERACRUZ | Categoría: Restaurantes
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'OZA031022JQ5', 'LA PARROQUIA DE VERACRUZ', 'la-parroquia-de-veracruz', 'Empresa especializada en alimentos.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Gabriela Rodríguez Aiza', NULL, NULL, '2721069212', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Orizaba', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2721069212', '2721069212', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Restaurantes' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'restaurante', 'restaurante');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'alimentos', 'alimentos');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'bebidas', 'bebidas');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'parroquia', 'parroquia');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'veracruz', 'veracruz');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com_/p/La-Parroquia-de-Veracruz-Orizaba-100066471173526/', 1);

-- 74. PAPA JOHNS | Categoría: Pizzerías
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'OZA031022JQ6', 'PAPA JOHNS', 'papa-johns', 'Empresa especializada en pizzería.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Gabriela Rodríguez Aiza', NULL, NULL, '2721069212', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Orizaba- Sur 33', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2721069212', '2721069212', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Pizzerías' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'pizzería', 'pizzería');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'pizza', 'pizza');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'comida', 'comida');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'papa', 'papa');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'johns', 'johns');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'SITIO_WEB', 'http://www.papajohns.com.mx/', 1);

-- 75. ANYTIME FITNESS | Categoría: Salud
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'OZA031022JQ7', 'ANYTIME FITNESS', 'anytime-fitness', 'Empresa especializada en deportes- Gimnasio.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Gabriela Rodríguez Aiza', NULL, NULL, '2721061329', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'Orizaba - Sur 33, Ote. 6 700', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2721061329', '2721061329', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Salud' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'salud', 'salud');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'bienestar', 'bienestar');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'gimnasio', 'gimnasio');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'anytime', 'anytime');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'fitness', 'fitness');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'http://www.facebook.com/AnytimeFitnessOrizaba/?locale=es', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'http://www.instagram.com/anytimefitnessorizaba/?hl=es', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'SITIO_WEB', 'http://anytimefitness.com.mx/', 1);

-- 76. DON COLCHÓN Y DOÑA CAMA S.A. DE C.V. | Categoría: Muebles y Colchones
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'DCD970609B38', 'DON COLCHÓN Y DOÑA CAMA S.A. DE C.V.', 'don-colchon-y-dona-cama-s-a-de-c-v', 'Empresa especializada en mueblería y Colchones.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Lino Ildefonso Carrillo Lopez', NULL, NULL, '2727266977', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'ORIZABA', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727266977', '2727266977', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Muebles y Colchones' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'muebles', 'muebles');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'colchones', 'colchones');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'hogar', 'hogar');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'don', 'don');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'colchón', 'colchón');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'doña', 'doña');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'cama', 'cama');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'https://www.facebook.com/donacamaydoncolchon/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'http://ww.instagram.com/donacamaydoncolchon/', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'SITIO_WEB', 'http://www.donacamaydoncolchon.com/', 1);

-- 77. CIA MUEBLERA DE ORIZABA S.A | Categoría: Muebles y Colchones
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion, correo_general) VALUES (@camara_id, 'MOR770412EU2', 'CIA MUEBLERA DE ORIZABA S.A', 'cia-mueblera-de-orizaba-s-a', 'Empresa especializada en mueblería Y Colchones.', NULL);
SET @afiliado_id = LAST_INSERT_ID();
INSERT INTO contactos_afiliados (idAfiliado, nombre, cargo, correo, telefono, es_principal, es_publico) VALUES (@afiliado_id, 'Lino Ildefonso Carrillo Lopez', NULL, NULL, '2727255275', 1, 0);
INSERT INTO sucursales (idAfiliado, idLocalidad, calle, es_matriz) VALUES (@afiliado_id, @localidad_id, 'ORIZABA Madero Sur', 1);
SET @sucursal_id = LAST_INSERT_ID();
INSERT INTO sucursales_telefonos (idSucursal, tipo, numero_original, numero_normalizado, es_principal) VALUES (@sucursal_id, 'TELEFONO', '2727255275', '2727255275', 1);
INSERT INTO afiliados_categorias (idAfiliado, idCategoria, es_principal, orden) SELECT @afiliado_id, idCategoria, 1, 1 FROM categorias WHERE nombre = 'Muebles y Colchones' AND activo = 1;
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'muebles', 'muebles');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'colchones', 'colchones');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'hogar', 'hogar');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'cia', 'cia');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'mueblera', 'mueblera');
INSERT INTO afiliados_palabras_clave (idAfiliado, palabra, palabra_normalizada) VALUES (@afiliado_id, 'orizaba', 'orizaba');
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'FACEBOOK', 'http://www.facebook.com/profile.php?id=100031961752423', 1);
INSERT INTO canales_digitales (idAfiliado, tipo, url, es_principal) VALUES (@afiliado_id, 'INSTAGRAM', 'http://www.instagram.com/muebleriadepositodefabricas/', 1);

-- Revisa antes de confirmar los cambios.
-- COMMIT;
-- Para descartar: ROLLBACK;
