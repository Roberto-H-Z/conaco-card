-- Alta de afiliados generada para REVISIÓN; no ejecutada.
-- Fuente: CANACOCAR_EMPRESAS_CORDOBA.xlsx
-- Hoja procesada: ORI (Orizaba).
-- Cámara asignada: idCamara = 1 (CANACO Córdoba).
-- Solo se insertan columnas obligatorias de afiliados: idCamara, RFC, nombre comercial, slug y descripción.
-- No se insertan promociones, fotos, logo, contactos, sucursales, teléfonos, canales digitales, categorías ni palabras clave.
-- Los demás campos quedan en sus valores por defecto o NULL.
-- RFC provisionales asignados: 16; incluyen RFC ausentes/inválidos y RFC repetidos entre empresas distintas.
-- Cada sentencia evita volver a insertar un RFC que ya exista en la BD.

START TRANSACTION;

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
-- ORI fila 14 | Giro: Asesoría en trámite de visas americanas y canadienes y pasaportes.; consultorias y capacitaiones
-- RFC PROVISIONAL: PENDIENTE0001 (RFC repetido en otra empresa del mismo Excel); sustituir por el RFC fiscal antes de operación formal.
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'PENDIENTE0001', 'VISAME Consultores', 'visame-consultores', 'Empresa afiliada dedicada a Asesoría en trámite de visas americanas y canadienes y pasaportes.; consultorias y capacitaiones.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'PENDIENTE0001');
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
-- ORI fila 24 | Giro: ferreteria
-- RFC PROVISIONAL: PENDIENTE0002 (RFC ausente o con formato inválido); sustituir por el RFC fiscal antes de operación formal.
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'PENDIENTE0002', 'Carpintodo', 'carpintodo', 'Empresa afiliada dedicada a ferreteria.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'PENDIENTE0002');
-- ORI fila 25 | Giro: ferreteria
-- RFC PROVISIONAL: PENDIENTE0003 (RFC ausente o con formato inválido); sustituir por el RFC fiscal antes de operación formal.
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'PENDIENTE0003', 'Carpintodo', 'carpintodo-2', 'Empresa afiliada dedicada a ferreteria.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'PENDIENTE0003');
-- ORI fila 26 | Giro: ferreteria
-- RFC PROVISIONAL: PENDIENTE0004 (RFC ausente o con formato inválido); sustituir por el RFC fiscal antes de operación formal.
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'PENDIENTE0004', 'Carpintodo', 'carpintodo-3', 'Empresa afiliada dedicada a ferreteria.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'PENDIENTE0004');
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
-- ORI fila 32 | Giro: Taquería
-- RFC PROVISIONAL: PENDIENTE0005 (RFC ausente o con formato inválido); sustituir por el RFC fiscal antes de operación formal.
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'PENDIENTE0005', 'Taco T', 'taco-t', 'Empresa afiliada dedicada a Taquería.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'PENDIENTE0005');
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
-- ORI fila 41 | Giro: Salón de fiestas
-- RFC PROVISIONAL: PENDIENTE0006 (RFC ausente o con formato inválido); sustituir por el RFC fiscal antes de operación formal.
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'PENDIENTE0006', 'Salón de Fiestas Confettis', 'salon-de-fiestas-confettis', 'Empresa afiliada dedicada a Salón de fiestas.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'PENDIENTE0006');
-- ORI fila 42 | Giro: Pastelería
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'RODA660825H22', 'Dulces Impresiones', 'dulces-impresiones', 'Empresa afiliada dedicada a Pastelería.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'RODA660825H22');
-- ORI fila 43 | Giro: no indicado
-- RFC PROVISIONAL: PENDIENTE0007 (RFC ausente o con formato inválido); sustituir por el RFC fiscal antes de operación formal.
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'PENDIENTE0007', 'Minoni', 'minoni', 'Empresa afiliada al directorio comercial CANACO.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'PENDIENTE0007');
-- ORI fila 44 | Giro: no indicado
-- RFC PROVISIONAL: PENDIENTE0008 (RFC ausente o con formato inválido); sustituir por el RFC fiscal antes de operación formal.
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'PENDIENTE0008', 'Corazón de Amaranto', 'corazon-de-amaranto', 'Empresa afiliada al directorio comercial CANACO.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'PENDIENTE0008');
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
-- ORI fila 56 | Giro: Servicios ambientales, de seguridad e higiene. Protección civil, matenimiento, venta y recarga de extintores.
-- RFC PROVISIONAL: PENDIENTE0009 (RFC ausente o con formato inválido); sustituir por el RFC fiscal antes de operación formal.
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'PENDIENTE0009', 'SEI- MG', 'sei-mg', 'Empresa afiliada dedicada a Servicios ambientales, de seguridad e higiene. Protección civil, matenimiento, venta y recarga de extintores.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'PENDIENTE0009');
-- ORI fila 57 | Giro: Diseño e impresión publicitaría
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'MECA730401991', 'C ecatto Publicidad', 'c-ecatto-publicidad', 'Empresa afiliada dedicada a Diseño e impresión publicitaría.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'MECA730401991');
-- ORI fila 58 | Giro: Compra y venta de articulos nacionaes y de impotación de los departamentos de Papelería, Juguetería, Regalos, Línea del Hogar, Fiestas, Eventos y Temporadas especiales. Manejamos precios de mayoreo y menudeo.
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'ZAHD900208BA6', 'Comercilalizadora La Victoria', 'comercilalizadora-la-victoria', 'Empresa afiliada dedicada a Compra y venta de articulos nacionaes y de impotación de los departamentos de Papelería, Juguetería, Regalos, Línea del Hogar, Fiestas, Eventos y Temporadas especiales. Manejamos precios de mayoreo y menudeo.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'ZAHD900208BA6');
-- ORI fila 59 | Giro: Bisutería
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'MAHA650715TV3', 'Enamórate', 'enamorate', 'Empresa afiliada dedicada a Bisutería.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'MAHA650715TV3');
-- ORI fila 60 | Giro: no indicado
-- RFC PROVISIONAL: PENDIENTE0010 (RFC ausente o con formato inválido); sustituir por el RFC fiscal antes de operación formal.
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'PENDIENTE0010', 'Arrasa', 'arrasa', 'Empresa afiliada al directorio comercial CANACO.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'PENDIENTE0010');
-- ORI fila 61 | Giro: Restaurat
-- RFC PROVISIONAL: PENDIENTE0011 (RFC ausente o con formato inválido); sustituir por el RFC fiscal antes de operación formal.
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'PENDIENTE0011', 'Madison Grill', 'madison-grill', 'Empresa afiliada dedicada a Restaurat.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'PENDIENTE0011');
-- ORI fila 62 | Giro: Papelería
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'ECE900430BW4', 'Esfera', 'esfera', 'Empresa afiliada dedicada a Papelería.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'ECE900430BW4');
-- ORI fila 63 | Giro: Hospital
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'CAM020504M14', 'Clinica Puerta grande', 'clinica-puerta-grande', 'Empresa afiliada dedicada a Hospital.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'CAM020504M14');
-- ORI fila 64 | Giro: no indicado
-- RFC PROVISIONAL: PENDIENTE0012 (RFC ausente o con formato inválido); sustituir por el RFC fiscal antes de operación formal.
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'PENDIENTE0012', 'Siete veinticuatro 7/24', 'siete-veinticuatro-7-24', 'Empresa afiliada al directorio comercial CANACO.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'PENDIENTE0012');
-- ORI fila 65 | Giro: Restaurante
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'SARL980731NI5', 'Benjamino´s Pizzas', 'benjamino-s-pizzas', 'Empresa afiliada dedicada a Restaurante.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'SARL980731NI5');
-- ORI fila 66 | Giro: Venta de Pintura, Decorativo, Industrial.
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'CERE880318E90', 'Alvemex', 'alvemex', 'Empresa afiliada dedicada a Venta de Pintura, Decorativo, Industrial.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'CERE880318E90');
-- ORI fila 67 | Giro: Venta de Pintura, Decorativo, Industrial.
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'CERE880318E91', 'Pinturas Alvemex Cero', 'pinturas-alvemex-cero', 'Empresa afiliada dedicada a Venta de Pintura, Decorativo, Industrial.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'CERE880318E91');
-- ORI fila 68 | Giro: joyería
-- RFC PROVISIONAL: PENDIENTE0013 (RFC ausente o con formato inválido); sustituir por el RFC fiscal antes de operación formal.
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'PENDIENTE0013', 'Wappler Joyería', 'wappler-joyeria', 'Empresa afiliada dedicada a joyería.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'PENDIENTE0013');
-- ORI fila 69 | Giro: Pinturas e impermeabilizantes
-- RFC PROVISIONAL: PENDIENTE0014 (RFC repetido en otra empresa del mismo Excel); sustituir por el RFC fiscal antes de operación formal.
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'PENDIENTE0014', 'Sherwin williams', 'sherwin-williams', 'Empresa afiliada dedicada a Pinturas e impermeabilizantes.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'PENDIENTE0014');
-- ORI fila 70 | Giro: Accesorios Textiles.
-- RFC PROVISIONAL: PENDIENTE0015 (RFC ausente o con formato inválido); sustituir por el RFC fiscal antes de operación formal.
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'PENDIENTE0015', 'oh my bows!', 'oh-my-bows', 'Empresa afiliada dedicada a Accesorios Textiles.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'PENDIENTE0015');
-- ORI fila 71 | Giro: Agencia de viajes
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'TTOO70913925', 'Mundo Joven travel shop', 'mundo-joven-travel-shop', 'Empresa afiliada dedicada a Agencia de viajes.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'TTOO70913925');
-- ORI fila 72 | Giro: Servicios. Cursos en ingles
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'LOSL660926LU2', 'IQ English Orizaba', 'iq-english-orizaba', 'Empresa afiliada dedicada a Servicios. Cursos en ingles.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'LOSL660926LU2');
-- ORI fila 73 | Giro: Venta de Vinos y Licores.
-- RFC PROVISIONAL: PENDIENTE0016 (RFC ausente o con formato inválido); sustituir por el RFC fiscal antes de operación formal.
INSERT INTO afiliados (idCamara, rfc, nombre_comercial, slug, descripcion) SELECT 1, 'PENDIENTE0016', 'Vinos y Licores "El gavilan"', 'vinos-y-licores-el-gavilan', 'Empresa afiliada dedicada a Venta de Vinos y Licores.' WHERE NOT EXISTS (SELECT 1 FROM afiliados WHERE rfc = 'PENDIENTE0016');
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
