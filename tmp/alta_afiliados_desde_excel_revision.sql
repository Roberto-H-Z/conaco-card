-- Alta de afiliados generada para REVISIÓN; no ejecutada.
-- Fuente: CANACOCAR_EMPRESAS_CORDOBA.xlsx
-- Cámara asignada: idCamara = 1 (CANACO Córdoba).
-- Solo se insertan columnas obligatorias de afiliados: idCamara, RFC, nombre comercial, slug y descripción.
-- No se insertan promociones, fotos, logo, contactos, sucursales, teléfonos, canales digitales, categorías ni palabras clave.
-- Los demás campos quedan en sus valores por defecto o NULL.
-- Filas de empresa sin RFC válido omitidas: 29.
-- Filas con RFC repetido en el Excel consolidadas a la primera aparición: 10.
-- Cada sentencia evita volver a insertar un RFC que ya exista en la BD.

START TRANSACTION;

-- D fila 1.0 | Giro: Joyeria
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'RAAA700316650', 'Joyería AR', 'joyeria-ar', 'Empresa afiliada dedicada a Joyeria.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'RAAA700316650');
-- D fila 2.0 | Giro: Joyeria
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'RARAY50112HQ8', 'Joyería AR', 'joyeria-ar-2', 'Empresa afiliada dedicada a Joyeria.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'RARAY50112HQ8');
-- D fila 3.0 | Giro: Joyeria
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'DOAES40925IQZ', 'Joyería Veracruz', 'joyeria-veracruz', 'Empresa afiliada dedicada a Joyeria.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'DOAES40925IQZ');
-- D fila 4.0 | Giro: Joyeria
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'JIDO770404TG7', 'Joyería Veracruz', 'joyeria-veracruz-2', 'Empresa afiliada dedicada a Joyeria.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'JIDO770404TG7');
-- D fila 5.0 | Giro: Jugos Naturales y Cafeteria
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'MARR58031973A', '100% Jugos California', '100-jugos-california', 'Empresa afiliada dedicada a Jugos Naturales y Cafeteria.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'MARR58031973A');
-- D fila 7.0 | Giro: Clinica Dental
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'IDE220810AW3', 'Dental Mas Córdoba', 'dental-mas-cordoba', 'Empresa afiliada dedicada a Clinica Dental.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'IDE220810AW3');
-- D fila 8.0 | Giro: Ropa
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'DIMI6905151Q0', 'Calcetilandia', 'calcetilandia', 'Empresa afiliada dedicada a Ropa.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'DIMI6905151Q0');
-- D fila 9.0 | Giro: Zapaterías
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'ZES980217JZ7', 'Zapatería Estylo', 'zapateria-estylo', 'Empresa afiliada dedicada a Zapaterías.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'ZES980217JZ7');
-- D fila 10.0 | Giro: Venta de equipo de Computo
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'GDEO812042J1', 'Grupo Decme', 'grupo-decme', 'Empresa afiliada dedicada a Venta de equipo de Computo.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'GDEO812042J1');
-- D fila 11.0 | Giro: ferreterías
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'NIGC720208K31', 'Casa Del Constructor', 'casa-del-constructor', 'Empresa afiliada dedicada a ferreterías.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'NIGC720208K31');
-- D fila 12.0 | Giro: Hospedaje Y Alimentos Y Bebidas; hotel
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'HCO130614CR5', 'Hotel HB', 'hotel-hb', 'Empresa afiliada dedicada a Hospedaje Y Alimentos Y Bebidas; hotel.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'HCO130614CR5');
-- D fila 13.0 | Giro: Lenceria
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'HEMM8205018E9', 'Shani Lecenria', 'shani-lecenria', 'Empresa afiliada dedicada a Lenceria.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'HEMM8205018E9');
-- D fila 19.0 | Giro: LIMPIEZA
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'DPB220222EG6', 'DIPBASA FEMA', 'dipbasa-fema', 'Empresa afiliada dedicada a LIMPIEZA.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'DPB220222EG6');
-- D fila 20.0 | Giro: RESTAURANTES Y CAFETERÍAS
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'SUF810227460', 'Restaurante Los Faroles', 'restaurante-los-faroles', 'Empresa afiliada dedicada a RESTAURANTES Y CAFETERÍAS.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'SUF810227460');
-- D fila 22.0 | Giro: Papeleria
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'RATS6712287SA', 'Papelería Korita', 'papeleria-korita', 'Empresa afiliada dedicada a Papeleria.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'RATS6712287SA');
-- D fila 25.0 | Giro: pinuras e impermeabilizantes
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'ARN2104082C3', 'Fester', 'fester', 'Empresa afiliada dedicada a pinuras e impermeabilizantes.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'ARN2104082C3');
-- D fila 26.0 | Giro: pinuras e impermeabilizantes
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'ARN2104082C4', 'Acuario', 'acuario', 'Empresa afiliada dedicada a pinuras e impermeabilizantes.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'ARN2104082C4');
-- D fila 27.0 | Giro: RESTAURANTES Y CAFETERÍAS
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'DOMR9208145V9', 'TASCA 18-21', 'tasca-18-21', 'Empresa afiliada dedicada a RESTAURANTES Y CAFETERÍAS.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'DOMR9208145V9');
-- D fila 28.0 | Giro: RESTAURANTES Y CAFETERÍAS
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'PJA0802269Y0', 'EL PORTAL DE LA JAIBA', 'el-portal-de-la-jaiba', 'Empresa afiliada dedicada a RESTAURANTES Y CAFETERÍAS.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'PJA0802269Y0');
-- D fila 29.0 | Giro: RESTAURANTES Y CAFETERÍAS
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'MJA071108H98', 'Mesón de la Jaiba Loca', 'meson-de-la-jaiba-loca', 'Empresa afiliada dedicada a RESTAURANTES Y CAFETERÍAS.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'MJA071108H98');
-- D fila 30.0 | Giro: RESTAURANTES Y CAFETERÍAS
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'ERC100820C55', 'La Jaiba Loca', 'la-jaiba-loca', 'Empresa afiliada dedicada a RESTAURANTES Y CAFETERÍAS.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'ERC100820C55');
-- D fila 32.0 | Giro: Motos
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'MOT100525JV8', 'ITALIKA MOTOCOOL', 'italika-motocool', 'Empresa afiliada dedicada a Motos.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'MOT100525JV8');
-- D fila 33.0 | Giro: Zapaterías
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'BZA861209U76', 'Zapaterías México', 'zapaterias-mexico', 'Empresa afiliada dedicada a Zapaterías.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'BZA861209U76');
-- D fila 34.0 | Giro: Zapaterías
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'BZA861209U77', 'Zapaterías México', 'zapaterias-mexico-2', 'Empresa afiliada dedicada a Zapaterías.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'BZA861209U77');
-- D fila 35.0 | Giro: Zapaterías
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'BZA861209U78', 'Zapaterías México', 'zapaterias-mexico-3', 'Empresa afiliada dedicada a Zapaterías.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'BZA861209U78');
-- D fila 36.0 | Giro: Zapaterías
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'BZA861209U79', 'Zapaterías México', 'zapaterias-mexico-4', 'Empresa afiliada dedicada a Zapaterías.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'BZA861209U79');
-- D fila 37.0 | Giro: paneles solares
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'BUTD700421R73', 'Vida y Energía Solar', 'vida-y-energia-solar', 'Empresa afiliada dedicada a paneles solares.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'BUTD700421R73');
-- D fila 38.0 | Giro: funeraria
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'GVC021220BE3', 'Grupo Vélez', 'grupo-velez', 'Empresa afiliada dedicada a funeraria.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'GVC021220BE3');
-- D fila 42.0 | Giro: Laboratorio de Analisis Clinico
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'FOGB710331UM8', 'Biolaboratorio Analisis Clínicos', 'biolaboratorio-analisis-clinicos', 'Empresa afiliada dedicada a Laboratorio de Analisis Clinico.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'FOGB710331UM8');
-- D fila 43.0 | Giro: hoteles
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'HRE601206SL6', 'Hotel y Restaurante Palacio', 'hotel-y-restaurante-palacio', 'Empresa afiliada dedicada a hoteles.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'HRE601206SL6');
-- D fila 44.0 | Giro: Ropa
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'SEC160205643', 'Vaqueros y Amazonas', 'vaqueros-y-amazonas', 'Empresa afiliada dedicada a Ropa.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'SEC160205643');
-- D fila 47.0 | Giro: electronica
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'HEGC950612TG2', 'Tera Trend', 'tera-trend', 'Empresa afiliada dedicada a electronica.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'HEGC950612TG2');
-- D fila 49.0 | Giro: llantas; otros servicios
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'PAI760518AX5', 'Paisa Llantas y Servicios', 'paisa-llantas-y-servicios', 'Empresa afiliada dedicada a llantas; otros servicios.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'PAI760518AX5');
-- D fila 50.0 | Giro: ferreterías; mat. Construccion
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'MET7803156J5', 'Metalurve', 'metalurve', 'Empresa afiliada dedicada a ferreterías; mat. Construccion.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'MET7803156J5');
-- D fila 57.0 | Giro: refaccionaria
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'IDS130201F32', 'Insumos Diesel del Sur', 'insumos-diesel-del-sur', 'Empresa afiliada dedicada a refaccionaria.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'IDS130201F32');
-- D fila 58.0 | Giro: Óptica
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'URHS740112CC3', 'Óptica profesional', 'optica-profesional', 'Empresa afiliada dedicada a Óptica.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'URHS740112CC3');
-- ORI fila 1 | Giro: Compra y venta de equipo y desarrollo de sistemas; consultorias y capacitaiones
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'GSA030826MI9', 'Grupo Sorom Asesores', 'grupo-sorom-asesores-2', 'Empresa afiliada dedicada a Compra y venta de equipo y desarrollo de sistemas; consultorias y capacitaiones.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'GSA030826MI9');
-- ORI fila 2 | Giro: Café y tienda impulsora artesanal; cafeterias
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'RICE840316MK2', 'By Cafétia', 'by-cafetia-2', 'Empresa afiliada dedicada a Café y tienda impulsora artesanal; cafeterias.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'RICE840316MK2');
-- ORI fila 3 | Giro: Servicios educativos, de consultoría y capacitación del capital humano.; consultorias y capacitaiones
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'GCE2212141K5', 'CEVPRO', 'cevpro-2', 'Empresa afiliada dedicada a Servicios educativos, de consultoría y capacitación del capital humano.; consultorias y capacitaiones.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'GCE2212141K5');
-- ORI fila 4 | Giro: Laboratoria de analisis clinicas; laboratorios clínicos
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'CCM131203R32', 'CLIMERS LAB.', 'climers-lab-2', 'Empresa afiliada dedicada a Laboratoria de analisis clinicas; laboratorios clínicos.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'CCM131203R32');
-- ORI fila 5 | Giro: Servicios de proteccion y custodia; otros servicios
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'AAR1702022Y3', 'ARI ADMINISTRACION DE RIESGO INTEGRALES', 'ari-administracion-de-riesgo-integrales', 'Empresa afiliada dedicada a Servicios de proteccion y custodia; otros servicios.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'AAR1702022Y3');
-- ORI fila 6 | Giro: Taller de joyeria y relojeria; joyería
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'SACI520617UF5', 'BADO´S JOYERIA', 'bado-s-joyeria', 'Empresa afiliada dedicada a Taller de joyeria y relojeria; joyería.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'SACI520617UF5');
-- ORI fila 7 | Giro: Autolavado; LIMPIEZA
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'WAMG770502HA9', 'FUNWASH LIMPIEZA PROFESIONAL', 'funwash-limpieza-profesional', 'Empresa afiliada dedicada a Autolavado; LIMPIEZA.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'WAMG770502HA9');
-- ORI fila 8 | Giro: Capacitacion, talleres, conferencias, programas de evaluacion educativa, asesoria juridica preventiva y derecho deportivo; consultorias y capacitaiones
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'FECL841228M93', 'INEVED', 'ineved', 'Empresa afiliada dedicada a Capacitacion, talleres, conferencias, programas de evaluacion educativa, asesoria juridica preventiva y derecho deportivo; consultorias y capacitaiones.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'FECL841228M93');
-- ORI fila 9 | Giro: Servicios veterinarios (IMAGENOLOGIA); veterinaria
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'SARP891212GU2', 'X PET "La imagen de tu mascota"', 'x-pet-la-imagen-de-tu-mascota', 'Empresa afiliada dedicada a Servicios veterinarios (IMAGENOLOGIA); veterinaria.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'SARP891212GU2');
-- ORI fila 10 | Giro: Venta de uniformes escolares y deportivos.
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'CARD420403CQA', 'Originales Dali', 'originales-dali', 'Empresa afiliada dedicada a Venta de uniformes escolares y deportivos.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'CARD420403CQA');
-- ORI fila 11 | Giro: Agencia de Publicidad
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'PEMJ820827A88', 'Media Planning Publicidad', 'media-planning-publicidad', 'Empresa afiliada dedicada a Agencia de Publicidad.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'PEMJ820827A88');
-- ORI fila 12 | Giro: VENTA AL POR MENOR DE LENTES; optica
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'AUSB890919M66', 'VEOPTIX OPTICA', 'veoptix-optica', 'Empresa afiliada dedicada a VENTA AL POR MENOR DE LENTES; optica.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'AUSB890919M66');
-- ORI fila 13 | Giro: Hospedaje, Alimentos y Bebidas; Turismo
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'MORM700610I47', 'VILLAS PICO DE ORIZABA', 'villas-pico-de-orizaba', 'Empresa afiliada dedicada a Hospedaje, Alimentos y Bebidas; Turismo.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'MORM700610I47');
-- ORI fila 15 | Giro: Tintoreria; serv. Y productos de limpieza
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'LVE040708AYA', 'Tintorería Pressto', 'tintoreria-pressto', 'Empresa afiliada dedicada a Tintoreria; serv. Y productos de limpieza.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'LVE040708AYA');
-- ORI fila 16 | Giro: Óptica (Comercio al por menor de lentes); optica
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'OES210602QX8', 'Optica España', 'optica-espana', 'Empresa afiliada dedicada a Óptica (Comercio al por menor de lentes); optica.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'OES210602QX8');
-- ORI fila 17 | Giro: Spa/Servicios cometologicos; serv. Y productos de belleza
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'SARI860607QV6', 'Purana Spa', 'purana-spa', 'Empresa afiliada dedicada a Spa/Servicios cometologicos; serv. Y productos de belleza.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'SARI860607QV6');
-- ORI fila 18 | Giro: no indicado
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'BARB740427NY2', 'Organización Turistica Integral', 'organizacion-turistica-integral', 'Empresa afiliada al directorio comercial CANACO.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'BARB740427NY2');
-- ORI fila 19 | Giro: Capacitacion, talleres, conferencias, programas de evaluacion educativa, asesoria juridica preventiva y derecho deportivo
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'GAHR8409121I7', 'Decroly Jardín de Niños', 'decroly-jardin-de-ninos', 'Empresa afiliada dedicada a Capacitacion, talleres, conferencias, programas de evaluacion educativa, asesoria juridica preventiva y derecho deportivo.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'GAHR8409121I7');
-- ORI fila 20 | Giro: Capacitacion, talleres, conferencias, programas de evaluacion educativa, asesoria juridica preventiva y derecho deportivo
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'HEPL7210145T0', 'Colegio Jean Piaget y Viajes Gali', 'colegio-jean-piaget-y-viajes-gali', 'Empresa afiliada dedicada a Capacitacion, talleres, conferencias, programas de evaluacion educativa, asesoria juridica preventiva y derecho deportivo.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'HEPL7210145T0');
-- ORI fila 21 | Giro: Seguros
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'ZADR8303248SA', 'ZAC Leading Seguros y Finanzas', 'zac-leading-seguros-y-finanzas', 'Empresa afiliada dedicada a Seguros.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'ZADR8303248SA');
-- ORI fila 22 | Giro: Perfumeria
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'RIAM840502P46', 'ISPIRAZIONE Inspirando tu aroma', 'ispirazione-inspirando-tu-aroma', 'Empresa afiliada dedicada a Perfumeria.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'RIAM840502P46');
-- ORI fila 23 | Giro: Restaurantes y cafeterías
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'GUPM721218EK6', 'Restaurant Las Fuentes', 'restaurant-las-fuentes', 'Empresa afiliada dedicada a Restaurantes y cafeterías.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'GUPM721218EK6');
-- ORI fila 27 | Giro: Vinos y licores
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'CUPE9203053Q3', 'Los Patos Vinos y Licores', 'los-patos-vinos-y-licores', 'Empresa afiliada dedicada a Vinos y licores.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'CUPE9203053Q3');
-- ORI fila 28 | Giro: Audiovisual
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'LUCU760916PHA', 'Comervic', 'comervic', 'Empresa afiliada dedicada a Audiovisual.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'LUCU760916PHA');
-- ORI fila 29 | Giro: Restaurantes y cafeterías
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'FTG230405MI4', 'La Casona', 'la-casona', 'Empresa afiliada dedicada a Restaurantes y cafeterías.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'FTG230405MI4');
-- ORI fila 30 | Giro: Servicios Educativos
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'IEA900730CK1', 'Universidad de Oriente', 'universidad-de-oriente', 'Empresa afiliada dedicada a Servicios Educativos.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'IEA900730CK1');
-- ORI fila 31 | Giro: Seguros, Fianzas E Inversiones
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'BAPP800928HC4', 'ESEFI y Asociados', 'esefi-y-asociados', 'Empresa afiliada dedicada a Seguros, Fianzas E Inversiones.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'BAPP800928HC4');
-- ORI fila 33 | Giro: Material de construcción
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'HEAA7210188J8', 'REVER impermeabilizantes y recubrimientos Veracruz', 'rever-impermeabilizantes-y-recubrimientos-veracruz', 'Empresa afiliada dedicada a Material de construcción.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'HEAA7210188J8');
-- ORI fila 34 | Giro: Tortería
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'NAF58611018X9', 'Super Tortas Orizabeñas', 'super-tortas-orizabenas', 'Empresa afiliada dedicada a Tortería.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'NAF58611018X9');
-- ORI fila 35 | Giro: Agencia de viajes
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'VEMM7001096AA', 'Viajes Madi', 'viajes-madi', 'Empresa afiliada dedicada a Agencia de viajes.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'VEMM7001096AA');
-- ORI fila 36 | Giro: Papelería y regalos
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'HEGE680602RM6', 'Papelería TOBY', 'papeleria-toby', 'Empresa afiliada dedicada a Papelería y regalos.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'HEGE680602RM6');
-- ORI fila 37 | Giro: Servicios de limpieza
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'GAAD860919EU4', 'Lavado GARPE Orizaba', 'lavado-garpe-orizaba', 'Empresa afiliada dedicada a Servicios de limpieza.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'GAAD860919EU4');
-- ORI fila 38 | Giro: Belleza
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'PELS890728069', 'Perfumería Casa Azul', 'perfumeria-casa-azul', 'Empresa afiliada dedicada a Belleza.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'PELS890728069');
-- ORI fila 39 | Giro: Agencia de Viajes
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'RODR6008109P3', 'Turismo Aventura', 'turismo-aventura', 'Empresa afiliada dedicada a Agencia de Viajes.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'RODR6008109P3');
-- ORI fila 40 | Giro: Alimentos y bebiadas
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'CAJE8610256DA', 'Victoría Service', 'victoria-service', 'Empresa afiliada dedicada a Alimentos y bebiadas.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'CAJE8610256DA');
-- ORI fila 42 | Giro: Pastelería
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'RODA660825H22', 'Dulces Impresiones', 'dulces-impresiones', 'Empresa afiliada dedicada a Pastelería.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'RODA660825H22');
-- ORI fila 45 | Giro: Estética/Sala de belleza
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'AVLW8408096B7', 'Autentik Salon', 'autentik-salon', 'Empresa afiliada dedicada a Estética/Sala de belleza.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'AVLW8408096B7');
-- ORI fila 46 | Giro: no indicado
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'SOMG870113DN5', 'medicalpet', 'medicalpet', 'Empresa afiliada al directorio comercial CANACO.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'SOMG870113DN5');
-- ORI fila 47 | Giro: Restaurante
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'EICA8312255R6', 'La prosperidad', 'la-prosperidad', 'Empresa afiliada dedicada a Restaurante.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'EICA8312255R6');
-- ORI fila 48 | Giro: Comercio de Productos de Limpieza
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'FEGR890627AU4', 'Productos de limpieza FERSAL', 'productos-de-limpieza-fersal', 'Empresa afiliada dedicada a Comercio de Productos de Limpieza.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'FEGR890627AU4');
-- ORI fila 49 | Giro: Comercio de Productos de Limpieza
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'FEGR890627AU5', 'Productos de limpieza FERSAL', 'productos-de-limpieza-fersal-2', 'Empresa afiliada dedicada a Comercio de Productos de Limpieza.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'FEGR890627AU5');
-- ORI fila 50 | Giro: Librería
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'LPU2301103UA', 'Librería El Puente', 'libreria-el-puente', 'Empresa afiliada dedicada a Librería.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'LPU2301103UA');
-- ORI fila 51 | Giro: Cafetería /Bar
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'HEVM720823KG8', 'ANGEL''S CAFÉ & OCEAN''S DRINKS', 'angel-s-cafe-ocean-s-drinks', 'Empresa afiliada dedicada a Cafetería /Bar.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'HEVM720823KG8');
-- ORI fila 52 | Giro: Restaurante
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'HEMR7205012B4', 'ROMERO &MENTA', 'romero-menta', 'Empresa afiliada dedicada a Restaurante.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'HEMR7205012B4');
-- ORI fila 53 | Giro: Compra-venta de muebles para el hogar y línea blanca
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'VICR630909EL2', 'Casa marven', 'casa-marven', 'Empresa afiliada dedicada a Compra-venta de muebles para el hogar y línea blanca.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'VICR630909EL2');
-- ORI fila 54 | Giro: Rosticería (Comida para llevar)
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'SAMR740830ADA', 'El enchiladito', 'el-enchiladito', 'Empresa afiliada dedicada a Rosticería (Comida para llevar).' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'SAMR740830ADA');
-- ORI fila 55 | Giro: Cocina Galería
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'GMA130212M99', 'Gastronomica Marrón, s, de R.L. de C.V.', 'gastronomica-marron-s-de-r-l-de-c-v', 'Empresa afiliada dedicada a Cocina Galería.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'GMA130212M99');
-- ORI fila 57 | Giro: Diseño e impresión publicitaría
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'MECA730401991', 'C ecatto Publicidad', 'c-ecatto-publicidad', 'Empresa afiliada dedicada a Diseño e impresión publicitaría.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'MECA730401991');
-- ORI fila 58 | Giro: Compra y venta de articulos nacionaes y de impotación de los departamentos de Papelería, Juguetería, Regalos, Línea del Hogar, Fiestas, Eventos y Temporadas especiales. Manejamos precios de mayoreo y menudeo.
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'ZAHD900208BA6', 'Comercilalizadora La Victoria', 'comercilalizadora-la-victoria', 'Empresa afiliada dedicada a Compra y venta de articulos nacionaes y de impotación de los departamentos de Papelería, Juguetería, Regalos, Línea del Hogar, Fiestas, Eventos y Temporadas especiales. Manejamos precios de mayoreo y menudeo.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'ZAHD900208BA6');
-- ORI fila 59 | Giro: Bisutería
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'MAHA650715TV3', 'Enamórate', 'enamorate', 'Empresa afiliada dedicada a Bisutería.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'MAHA650715TV3');
-- ORI fila 62 | Giro: Papelería
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'ECE900430BW4', 'Esfera', 'esfera', 'Empresa afiliada dedicada a Papelería.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'ECE900430BW4');
-- ORI fila 63 | Giro: Hospital
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'CAM020504M14', 'Clinica Puerta grande', 'clinica-puerta-grande', 'Empresa afiliada dedicada a Hospital.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'CAM020504M14');
-- ORI fila 65 | Giro: Restaurante
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'SARL980731NI5', 'Benjamino´s Pizzas', 'benjamino-s-pizzas', 'Empresa afiliada dedicada a Restaurante.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'SARL980731NI5');
-- ORI fila 66 | Giro: Venta de Pintura, Decorativo, Industrial.
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'CERE880318E90', 'Alvemex', 'alvemex', 'Empresa afiliada dedicada a Venta de Pintura, Decorativo, Industrial.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'CERE880318E90');
-- ORI fila 67 | Giro: Venta de Pintura, Decorativo, Industrial.
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'CERE880318E91', 'Pinturas Alvemex Cero', 'pinturas-alvemex-cero', 'Empresa afiliada dedicada a Venta de Pintura, Decorativo, Industrial.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'CERE880318E91');
-- ORI fila 71 | Giro: Agencia de viajes
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'TTOO70913925', 'Mundo Joven travel shop', 'mundo-joven-travel-shop', 'Empresa afiliada dedicada a Agencia de viajes.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'TTOO70913925');
-- ORI fila 72 | Giro: Servicios. Cursos en ingles
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'LOSL660926LU2', 'IQ English Orizaba', 'iq-english-orizaba', 'Empresa afiliada dedicada a Servicios. Cursos en ingles.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'LOSL660926LU2');
-- ORI fila 74 | Giro: Clínica Veterinaria
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'HUFA3809276X6', 'Veterinaria "Dr. Huerta"', 'veterinaria-dr-huerta', 'Empresa afiliada dedicada a Clínica Veterinaria.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'HUFA3809276X6');
-- ORI fila 75 | Giro: Servicios de Control de Plaga
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'BEML901008PR6', 'Fulminex Control de Plagas', 'fulminex-control-de-plagas', 'Empresa afiliada dedicada a Servicios de Control de Plaga.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'BEML901008PR6');
-- ORI fila 76 | Giro: Clínica de Maternidad
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'DIOJ4811245I5', 'Clínica de Maternidad Pluviosilla', 'clinica-de-maternidad-pluviosilla', 'Empresa afiliada dedicada a Clínica de Maternidad.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'DIOJ4811245I5');
-- ORI fila 77 | Giro: Alimentos - Restaurante asiatico
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'OZA031022JQ4', 'Domu Sushi Bar', 'domu-sushi-bar', 'Empresa afiliada dedicada a Alimentos - Restaurante asiatico.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'OZA031022JQ4');
-- ORI fila 78 | Giro: Alimentos
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'OZA031022JQ5', 'La Parroquia de Veracruz', 'la-parroquia-de-veracruz', 'Empresa afiliada dedicada a Alimentos.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'OZA031022JQ5');
-- ORI fila 79 | Giro: Pizzería
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'OZA031022JQ6', 'Papa Johns', 'papa-johns', 'Empresa afiliada dedicada a Pizzería.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'OZA031022JQ6');
-- ORI fila 80 | Giro: Deportes- Gimnasio
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'OZA031022JQ7', 'ANYTIME FITNESS', 'anytime-fitness', 'Empresa afiliada dedicada a Deportes- Gimnasio.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'OZA031022JQ7');
-- ORI fila 80 | Giro: Mueblería y Colchones
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'DCD970609B38', 'Don Colchón y Doña Cama S.A. de C.V.', 'don-colchon-y-dona-cama-s-a-de-c-v', 'Empresa afiliada dedicada a Mueblería y Colchones.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'DCD970609B38');
-- ORI fila 81 | Giro: Mueblería Y Colchones
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'MOR770412EU2', 'Cia Mueblera de Orizaba S.A', 'cia-mueblera-de-orizaba-s-a', 'Empresa afiliada dedicada a Mueblería Y Colchones.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'MOR770412EU2');

-- Revisa el resultado antes de confirmar.
-- COMMIT;
-- Para descartar esta prueba: ROLLBACK;
