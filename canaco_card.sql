-- ============================================================================
-- CANACO CARD
-- Script de creación de base de datos
-- Motor objetivo: MySQL 8.0+ / phpMyAdmin
-- Codificación: utf8mb4
--
-- IMPORTANTE:
-- 1) Para una instalación limpia, puede descomentar la línea DROP DATABASE.
-- 2) Importe este archivo desde phpMyAdmin > Importar.
-- 3) Las contraseñas deben generarse desde PHP con password_hash().
-- 4) La aplicación debe trabajar en UTC y convertir a la zona horaria del usuario.
-- ============================================================================

-- DROP DATABASE IF EXISTS canaco_card;

CREATE DATABASE IF NOT EXISTS canaco_card
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE canaco_card;

SET NAMES utf8mb4;
SET time_zone = '+00:00';

-- ============================================================================
-- 1. CATÁLOGOS GEOGRÁFICOS
-- ============================================================================

CREATE TABLE IF NOT EXISTS estados (
    idEstado            SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    clave_inegi         CHAR(2) NOT NULL,
    nombre              VARCHAR(100) NOT NULL,
    activo              TINYINT(1) NOT NULL DEFAULT 1,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    actualizado_at      DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                        ON UPDATE CURRENT_TIMESTAMP(6),
    CONSTRAINT uq_estado_clave UNIQUE (clave_inegi),
    CONSTRAINT uq_estado_nombre UNIQUE (nombre)
) ENGINE=InnoDB COMMENT='Estados de la República Mexicana';

CREATE TABLE IF NOT EXISTS municipios (
    idMunicipio         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    idEstado           SMALLINT UNSIGNED NOT NULL,
    clave_inegi         VARCHAR(5) NULL,
    nombre              VARCHAR(120) NOT NULL,
    activo              TINYINT(1) NOT NULL DEFAULT 1,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    actualizado_at      DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                        ON UPDATE CURRENT_TIMESTAMP(6),
    CONSTRAINT fk_municipio_estado
        FOREIGN KEY (idEstado) REFERENCES estados(idEstado)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_municipio_estado_nombre UNIQUE (idEstado, nombre),
    CONSTRAINT uq_municipio_clave UNIQUE (clave_inegi),
    INDEX ix_municipio_estado_activo (idEstado, activo, nombre)
) ENGINE=InnoDB COMMENT='Municipios por estado';

CREATE TABLE IF NOT EXISTS localidades (
    idLocalidad         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    idMunicipio        BIGINT UNSIGNED NOT NULL,
    nombre              VARCHAR(150) NOT NULL,
    tipo                VARCHAR(40) NULL,
    activo              TINYINT(1) NOT NULL DEFAULT 1,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    actualizado_at      DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                        ON UPDATE CURRENT_TIMESTAMP(6),
    CONSTRAINT fk_localidad_municipio
        FOREIGN KEY (idMunicipio) REFERENCES municipios(idMunicipio)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_localidad_municipio_nombre UNIQUE (idMunicipio, nombre),
    INDEX ix_localidad_municipio_activo (idMunicipio, activo, nombre)
) ENGINE=InnoDB COMMENT='Localidades pertenecientes a un municipio';

CREATE TABLE IF NOT EXISTS municipios_adyacencias (
    idMunicipioA      BIGINT UNSIGNED NOT NULL,
    idMunicipioB      BIGINT UNSIGNED NOT NULL,
    distancia_km        DECIMAL(8,2) NULL,
    activo              TINYINT(1) NOT NULL DEFAULT 1,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (idMunicipioA, idMunicipioB),
    CONSTRAINT fk_adyacencia_municipio_a
        FOREIGN KEY (idMunicipioA) REFERENCES municipios(idMunicipio)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_adyacencia_municipio_b
        FOREIGN KEY (idMunicipioB) REFERENCES municipios(idMunicipio)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT ck_adyacencia_distintos CHECK (idMunicipioA < idMunicipioB),
    CONSTRAINT ck_adyacencia_distancia CHECK (distancia_km IS NULL OR distancia_km >= 0)
) ENGINE=InnoDB COMMENT='Relación no duplicada entre municipios aledaños';

-- ============================================================================
-- 2. CÁMARAS Y CIRCUNSCRIPCIÓN
-- ============================================================================

CREATE TABLE IF NOT EXISTS camaras (
    idCamara            BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    clave               VARCHAR(30) NOT NULL,
    nombre              VARCHAR(180) NOT NULL,
    nombre_corto        VARCHAR(80) NULL,
    correo              VARCHAR(254) NULL,
    telefono            VARCHAR(20) NULL,
    idMunicipioSede   BIGINT UNSIGNED NULL,
    activo              TINYINT(1) NOT NULL DEFAULT 1,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    actualizado_at      DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                        ON UPDATE CURRENT_TIMESTAMP(6),
    CONSTRAINT uq_camara_clave UNIQUE (clave),
    CONSTRAINT fk_camara_municipio_sede
        FOREIGN KEY (idMunicipioSede) REFERENCES municipios(idMunicipio)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX ix_camara_activo (activo, nombre)
) ENGINE=InnoDB COMMENT='Cámaras que administran afiliados';

CREATE TABLE IF NOT EXISTS camaras_municipios (
    idCamara           BIGINT UNSIGNED NOT NULL,
    idMunicipio        BIGINT UNSIGNED NOT NULL,
    tipo_cobertura      VARCHAR(20) NOT NULL DEFAULT 'DIRECTA',
    activo              TINYINT(1) NOT NULL DEFAULT 1,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (idCamara, idMunicipio),
    CONSTRAINT fk_camara_municipio_camara
        FOREIGN KEY (idCamara) REFERENCES camaras(idCamara)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_camara_municipio_municipio
        FOREIGN KEY (idMunicipio) REFERENCES municipios(idMunicipio)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT ck_camara_municipio_tipo
        CHECK (tipo_cobertura IN ('DIRECTA', 'EXTENDIDA')),
    INDEX ix_camara_municipio_municipio (idMunicipio, activo)
) ENGINE=InnoDB COMMENT='Municipios incluidos en la circunscripción de una cámara';

-- ============================================================================
-- 3. SEGURIDAD, ROLES Y USUARIOS
-- ============================================================================

CREATE TABLE IF NOT EXISTS roles (
    idRol               SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    clave               VARCHAR(40) NOT NULL,
    nombre              VARCHAR(80) NOT NULL,
    descripcion         VARCHAR(255) NULL,
    activo              TINYINT(1) NOT NULL DEFAULT 1,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    CONSTRAINT uq_rol_clave UNIQUE (clave),
    CONSTRAINT uq_rol_nombre UNIQUE (nombre)
) ENGINE=InnoDB COMMENT='Roles de acceso del panel administrativo';

CREATE TABLE IF NOT EXISTS permisos (
    idPermiso           BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    clave               VARCHAR(100) NOT NULL,
    modulo              VARCHAR(60) NOT NULL,
    accion              VARCHAR(60) NOT NULL,
    descripcion         VARCHAR(255) NULL,
    activo              TINYINT(1) NOT NULL DEFAULT 1,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    CONSTRAINT uq_permiso_clave UNIQUE (clave),
    INDEX ix_permiso_modulo (modulo, activo)
) ENGINE=InnoDB COMMENT='Permisos atómicos utilizados por el sistema';

CREATE TABLE IF NOT EXISTS roles_permisos (
    idRol              SMALLINT UNSIGNED NOT NULL,
    idPermiso          BIGINT UNSIGNED NOT NULL,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (idRol, idPermiso),
    CONSTRAINT fk_rol_permiso_rol
        FOREIGN KEY (idRol) REFERENCES roles(idRol)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_rol_permiso_permiso
        FOREIGN KEY (idPermiso) REFERENCES permisos(idPermiso)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Permisos asignados a cada rol';

CREATE TABLE IF NOT EXISTS usuarios (
    idUsuario           BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    idRol                  SMALLINT UNSIGNED NOT NULL,
    nombre                  VARCHAR(150) NOT NULL,
    correo                  VARCHAR(254) NOT NULL,
    password_hash           VARCHAR(255) NOT NULL,
    ultimo_acceso_at        DATETIME(6) NULL,
    password_actualizado_at DATETIME(6) NULL,
    intentos_fallidos       SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    bloqueado_hasta         DATETIME(6) NULL,
    activo                  TINYINT(1) NOT NULL DEFAULT 1,
    creado_at               DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    actualizado_at          DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                            ON UPDATE CURRENT_TIMESTAMP(6),
    desactivado_at          DATETIME(6) NULL,
    CONSTRAINT fk_usuario_rol
        FOREIGN KEY (idRol) REFERENCES roles(idRol)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_usuario_correo UNIQUE (correo),
    INDEX ix_usuario_rol_activo (idRol, activo),
    INDEX ix_usuario_ultimo_acceso (ultimo_acceso_at)
) ENGINE=InnoDB COMMENT='Usuarios autorizados para acceder al panel';

CREATE TABLE IF NOT EXISTS usuarios_camaras (
    idUsuario          BIGINT UNSIGNED PRIMARY KEY,
    idCamara           BIGINT UNSIGNED NOT NULL,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    CONSTRAINT fk_usuario_camara_usuario
        FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_usuario_camara_camara
        FOREIGN KEY (idCamara) REFERENCES camaras(idCamara)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX ix_usuario_camara_camara (idCamara)
) ENGINE=InnoDB COMMENT='Asignación de administradores de cámara';

CREATE TABLE IF NOT EXISTS tokens_recuperacion_password (
    idTokenRecuperacionPassword BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    idUsuario          BIGINT UNSIGNED NOT NULL,
    token_hash          CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    expira_at           DATETIME(6) NOT NULL,
    utilizado_at        DATETIME(6) NULL,
    solicitado_at       DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    ip_solicitud_hash   CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL,
    CONSTRAINT fk_token_password_usuario
        FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT uq_token_password_hash UNIQUE (token_hash),
    INDEX ix_token_password_usuario_vigencia (idUsuario, expira_at, utilizado_at)
) ENGINE=InnoDB COMMENT='Tokens de recuperación de contraseña; solo se guarda el hash';

-- ============================================================================
-- 4. AFILIADOS, SUCURSALES, CONTACTOS Y CLASIFICACIÓN
-- ============================================================================

CREATE TABLE IF NOT EXISTS afiliados (
    idAfiliado          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    idCamara           BIGINT UNSIGNED NOT NULL,
    rfc                 VARCHAR(13) NOT NULL,
    razon_social        VARCHAR(180) NULL,
    nombre_comercial    VARCHAR(180) NOT NULL,
    alias               VARCHAR(120) NULL,
    slug                VARCHAR(200) NOT NULL,
    descripcion         TEXT NOT NULL,
    correo_general      VARCHAR(254) NULL,
    activo              TINYINT(1) NOT NULL DEFAULT 1,
    idUsuarioCreador          BIGINT UNSIGNED NULL,
    idUsuarioActualizador     BIGINT UNSIGNED NULL,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    actualizado_at      DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                        ON UPDATE CURRENT_TIMESTAMP(6),
    desactivado_at      DATETIME(6) NULL,
    idUsuarioDesactivador     BIGINT UNSIGNED NULL,
    motivo_desactivacion VARCHAR(500) NULL,
    CONSTRAINT fk_afiliado_camara
        FOREIGN KEY (idCamara) REFERENCES camaras(idCamara)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_afiliado_creado_por
        FOREIGN KEY (idUsuarioCreador) REFERENCES usuarios(idUsuario)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_afiliado_actualizado_por
        FOREIGN KEY (idUsuarioActualizador) REFERENCES usuarios(idUsuario)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_afiliado_desactivado_por
        FOREIGN KEY (idUsuarioDesactivador) REFERENCES usuarios(idUsuario)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT uq_afiliado_rfc UNIQUE (rfc),
    CONSTRAINT uq_afiliado_slug UNIQUE (slug),
    CONSTRAINT ck_afiliado_rfc_longitud CHECK (CHAR_LENGTH(rfc) IN (12, 13)),
    INDEX ix_afiliado_camara_activo (idCamara, activo, nombre_comercial),
    INDEX ix_afiliado_nombre (nombre_comercial),
    INDEX ix_afiliado_alias (alias)
) ENGINE=InnoDB COMMENT='Empresa afiliada; no representa una sucursal específica';

CREATE TABLE IF NOT EXISTS usuarios_afiliados (
    idUsuario          BIGINT UNSIGNED NOT NULL,
    idAfiliado         BIGINT UNSIGNED NOT NULL,
    es_principal        TINYINT(1) NOT NULL DEFAULT 0,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (idUsuario, idAfiliado),
    CONSTRAINT fk_usuario_afiliado_usuario
        FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_usuario_afiliado_afiliado
        FOREIGN KEY (idAfiliado) REFERENCES afiliados(idAfiliado)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX ix_usuario_afiliado_afiliado (idAfiliado, es_principal)
) ENGINE=InnoDB COMMENT='Usuarios autorizados para administrar un afiliado';

CREATE TABLE IF NOT EXISTS contactos_afiliados (
    idContactoAfiliado  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    idAfiliado         BIGINT UNSIGNED NOT NULL,
    nombre              VARCHAR(160) NOT NULL,
    cargo               VARCHAR(100) NULL,
    correo              VARCHAR(254) NULL,
    telefono            VARCHAR(20) NULL,
    es_principal        TINYINT(1) NOT NULL DEFAULT 0,
    es_publico          TINYINT(1) NOT NULL DEFAULT 0,
    activo              TINYINT(1) NOT NULL DEFAULT 1,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    actualizado_at      DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                        ON UPDATE CURRENT_TIMESTAMP(6),
    CONSTRAINT fk_contacto_afiliado
        FOREIGN KEY (idAfiliado) REFERENCES afiliados(idAfiliado)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX ix_contacto_afiliado_principal (idAfiliado, activo, es_principal)
) ENGINE=InnoDB COMMENT='Contactos administrativos o públicos de una empresa';

CREATE TABLE IF NOT EXISTS sucursales (
    idSucursal          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    idAfiliado         BIGINT UNSIGNED NOT NULL,
    idLocalidad        BIGINT UNSIGNED NOT NULL,
    nombre              VARCHAR(150) NULL,
    es_matriz           TINYINT(1) NOT NULL DEFAULT 0,
    calle               VARCHAR(160) NOT NULL,
    numero_exterior     VARCHAR(20) NULL,
    numero_interior     VARCHAR(20) NULL,
    colonia             VARCHAR(130) NULL,
    codigo_postal       CHAR(5) NULL,
    referencias         VARCHAR(500) NULL,
    latitud             DECIMAL(10,7) NULL,
    longitud            DECIMAL(10,7) NULL,
    google_place_id     VARCHAR(255) NULL,
    activo              TINYINT(1) NOT NULL DEFAULT 1,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    actualizado_at      DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                        ON UPDATE CURRENT_TIMESTAMP(6),
    matriz_activa_unica BIGINT UNSIGNED
        GENERATED ALWAYS AS (
            CASE WHEN es_matriz = 1 AND activo = 1 THEN idAfiliado ELSE NULL END
        ) STORED,
    CONSTRAINT fk_sucursal_afiliado
        FOREIGN KEY (idAfiliado) REFERENCES afiliados(idAfiliado)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_sucursal_localidad
        FOREIGN KEY (idLocalidad) REFERENCES localidades(idLocalidad)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_sucursal_matriz_activa UNIQUE (matriz_activa_unica),
    CONSTRAINT ck_sucursal_cp CHECK (codigo_postal IS NULL OR codigo_postal REGEXP '^[0-9]{5}$'),
    CONSTRAINT ck_sucursal_latitud CHECK (latitud IS NULL OR latitud BETWEEN -90 AND 90),
    CONSTRAINT ck_sucursal_longitud CHECK (longitud IS NULL OR longitud BETWEEN -180 AND 180),
    INDEX ix_sucursal_afiliado_activo (idAfiliado, activo),
    INDEX ix_sucursal_localidad_activo (idLocalidad, activo),
    INDEX ix_sucursal_geo (latitud, longitud)
) ENGINE=InnoDB COMMENT='Ubicaciones físicas de los afiliados';

CREATE TABLE IF NOT EXISTS sucursales_telefonos (
    idSucursalTelefono  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    idSucursal         BIGINT UNSIGNED NOT NULL,
    tipo                VARCHAR(20) NOT NULL,
    numero_original     VARCHAR(50) NOT NULL,
    numero_normalizado  VARCHAR(16) NOT NULL,
    extension_telefono  VARCHAR(10) NULL,
    etiqueta            VARCHAR(50) NULL,
    es_principal        TINYINT(1) NOT NULL DEFAULT 0,
    activo              TINYINT(1) NOT NULL DEFAULT 1,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    actualizado_at      DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                        ON UPDATE CURRENT_TIMESTAMP(6),
    CONSTRAINT fk_sucursal_telefono_sucursal
        FOREIGN KEY (idSucursal) REFERENCES sucursales(idSucursal)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT ck_sucursal_telefono_tipo CHECK (tipo IN ('TELEFONO', 'WHATSAPP')),
    CONSTRAINT uq_sucursal_telefono_numero UNIQUE (idSucursal, tipo, numero_normalizado),
    INDEX ix_sucursal_telefono_principal (idSucursal, tipo, activo, es_principal)
) ENGINE=InnoDB COMMENT='Teléfonos y números de WhatsApp por sucursal';

CREATE TABLE IF NOT EXISTS canales_digitales (
    idCanalDigital      BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    idAfiliado         BIGINT UNSIGNED NOT NULL,
    idSucursal         BIGINT UNSIGNED NULL,
    tipo                VARCHAR(30) NOT NULL,
    url                 VARCHAR(700) NOT NULL,
    nombre_usuario      VARCHAR(150) NULL,
    es_principal        TINYINT(1) NOT NULL DEFAULT 0,
    activo              TINYINT(1) NOT NULL DEFAULT 1,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    actualizado_at      DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                        ON UPDATE CURRENT_TIMESTAMP(6),
    CONSTRAINT fk_canal_digital_afiliado
        FOREIGN KEY (idAfiliado) REFERENCES afiliados(idAfiliado)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_canal_digital_sucursal
        FOREIGN KEY (idSucursal) REFERENCES sucursales(idSucursal)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT ck_canal_digital_tipo
        CHECK (tipo IN ('FACEBOOK', 'INSTAGRAM', 'SITIO_WEB', 'TIKTOK', 'YOUTUBE', 'OTRO')),
    CONSTRAINT uq_canal_digital_url UNIQUE (idAfiliado, tipo, url),
    INDEX ix_canal_digital_afiliado (idAfiliado, activo, tipo),
    INDEX ix_canal_digital_sucursal (idSucursal, activo)
) ENGINE=InnoDB COMMENT='Redes sociales y sitios web del afiliado o de una sucursal';

CREATE TABLE IF NOT EXISTS categorias (
    idCategoria         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    idCategoriaPadre  BIGINT UNSIGNED NULL,
    nombre              VARCHAR(120) NOT NULL,
    slug                VARCHAR(150) NOT NULL,
    descripcion         VARCHAR(500) NULL,
    activo              TINYINT(1) NOT NULL DEFAULT 1,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    actualizado_at      DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                        ON UPDATE CURRENT_TIMESTAMP(6),
    CONSTRAINT fk_categoria_padre
        FOREIGN KEY (idCategoriaPadre) REFERENCES categorias(idCategoria)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_categoria_slug UNIQUE (slug),
    CONSTRAINT uq_categoria_padre_nombre UNIQUE (idCategoriaPadre, nombre),
    INDEX ix_categoria_padre_activo (idCategoriaPadre, activo, nombre)
) ENGINE=InnoDB COMMENT='Categorías comerciales con jerarquía opcional';

CREATE TABLE IF NOT EXISTS afiliados_categorias (
    idAfiliado             BIGINT UNSIGNED NOT NULL,
    idCategoria            BIGINT UNSIGNED NOT NULL,
    es_principal            TINYINT(1) NOT NULL DEFAULT 0,
    orden                   SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    creado_at               DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    principal_unica         BIGINT UNSIGNED
        GENERATED ALWAYS AS (
            CASE WHEN es_principal = 1 THEN idAfiliado ELSE NULL END
        ) STORED,
    PRIMARY KEY (idAfiliado, idCategoria),
    CONSTRAINT fk_afiliado_categoria_afiliado
        FOREIGN KEY (idAfiliado) REFERENCES afiliados(idAfiliado)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_afiliado_categoria_categoria
        FOREIGN KEY (idCategoria) REFERENCES categorias(idCategoria)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_afiliado_categoria_principal UNIQUE (principal_unica),
    INDEX ix_afiliado_categoria_categoria (idCategoria, idAfiliado),
    INDEX ix_afiliado_categoria_orden (idAfiliado, orden)
) ENGINE=InnoDB COMMENT='Relación muchos a muchos entre afiliados y categorías';

CREATE TABLE IF NOT EXISTS afiliados_palabras_clave (
    idAfiliadoPalabraClave BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    idAfiliado         BIGINT UNSIGNED NOT NULL,
    palabra             VARCHAR(80) NOT NULL,
    palabra_normalizada VARCHAR(80) NOT NULL,
    activo              TINYINT(1) NOT NULL DEFAULT 1,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    actualizado_at      DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                        ON UPDATE CURRENT_TIMESTAMP(6),
    CONSTRAINT fk_palabra_clave_afiliado
        FOREIGN KEY (idAfiliado) REFERENCES afiliados(idAfiliado)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_palabra_clave_afiliado UNIQUE (idAfiliado, palabra_normalizada),
    INDEX ix_palabra_clave_busqueda (palabra_normalizada, activo)
) ENGINE=InnoDB COMMENT='Hasta diez términos de búsqueda por afiliado';

-- ============================================================================
-- 5. ARCHIVOS, LOGOTIPOS Y GALERÍAS
-- ============================================================================

CREATE TABLE IF NOT EXISTS archivos (
    idArchivo           BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre_original     VARCHAR(255) NOT NULL,
    storage_key         VARCHAR(500) NOT NULL,
    url_publica         VARCHAR(700) NULL,
    mime_type           VARCHAR(100) NOT NULL,
    peso_bytes          BIGINT UNSIGNED NOT NULL,
    ancho_px            INT UNSIGNED NULL,
    alto_px             INT UNSIGNED NULL,
    checksum_sha256     CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL,
    idUsuarioCreador          BIGINT UNSIGNED NULL,
    activo              TINYINT(1) NOT NULL DEFAULT 1,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    actualizado_at      DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                        ON UPDATE CURRENT_TIMESTAMP(6),
    CONSTRAINT fk_archivo_creado_por
        FOREIGN KEY (idUsuarioCreador) REFERENCES usuarios(idUsuario)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT uq_archivo_storage_key UNIQUE (storage_key),
    CONSTRAINT ck_archivo_peso CHECK (peso_bytes > 0),
    INDEX ix_archivo_checksum (checksum_sha256),
    INDEX ix_archivo_activo (activo, mime_type)
) ENGINE=InnoDB COMMENT='Metadatos de archivos; las imágenes no se almacenan como BLOB';

CREATE TABLE IF NOT EXISTS afiliados_archivos (
    idAfiliado         BIGINT UNSIGNED NOT NULL,
    idArchivo          BIGINT UNSIGNED NOT NULL,
    tipo                VARCHAR(20) NOT NULL,
    orden               SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    texto_alternativo   VARCHAR(255) NULL,
    activo              TINYINT(1) NOT NULL DEFAULT 1,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    logo_activo_unico   BIGINT UNSIGNED
        GENERATED ALWAYS AS (
            CASE WHEN tipo = 'LOGOTIPO' AND activo = 1 THEN idAfiliado ELSE NULL END
        ) STORED,
    PRIMARY KEY (idAfiliado, idArchivo),
    CONSTRAINT fk_afiliado_archivo_afiliado
        FOREIGN KEY (idAfiliado) REFERENCES afiliados(idAfiliado)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_afiliado_archivo_archivo
        FOREIGN KEY (idArchivo) REFERENCES archivos(idArchivo)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT ck_afiliado_archivo_tipo CHECK (tipo IN ('LOGOTIPO', 'GALERIA')),
    CONSTRAINT uq_afiliado_logo_activo UNIQUE (logo_activo_unico),
    CONSTRAINT uq_afiliado_archivo_orden UNIQUE (idAfiliado, tipo, orden),
    INDEX ix_afiliado_archivo_tipo (idAfiliado, tipo, activo, orden)
) ENGINE=InnoDB COMMENT='Logotipo y galería de imágenes de una empresa';

-- ============================================================================
-- 6. PROMOCIONES Y NOTIFICACIONES
-- ============================================================================

CREATE TABLE IF NOT EXISTS promociones (
    idPromocion         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    idAfiliado         BIGINT UNSIGNED NOT NULL,
    titulo              VARCHAR(180) NOT NULL,
    descripcion         TEXT NOT NULL,
    restricciones       TEXT NULL,
    inicio_vigencia     DATETIME(6) NOT NULL,
    fin_vigencia        DATETIME(6) NOT NULL,
    activo              TINYINT(1) NOT NULL DEFAULT 1,
    idUsuarioCreador          BIGINT UNSIGNED NULL,
    idUsuarioActualizador     BIGINT UNSIGNED NULL,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    actualizado_at      DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                        ON UPDATE CURRENT_TIMESTAMP(6),
    desactivado_at      DATETIME(6) NULL,
    CONSTRAINT fk_promocion_afiliado
        FOREIGN KEY (idAfiliado) REFERENCES afiliados(idAfiliado)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_promocion_creado_por
        FOREIGN KEY (idUsuarioCreador) REFERENCES usuarios(idUsuario)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_promocion_actualizado_por
        FOREIGN KEY (idUsuarioActualizador) REFERENCES usuarios(idUsuario)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT ck_promocion_fechas CHECK (fin_vigencia >= inicio_vigencia),
    INDEX ix_promocion_publicacion (idAfiliado, activo, inicio_vigencia, fin_vigencia),
    INDEX ix_promocion_inicio (inicio_vigencia),
    INDEX ix_promocion_fin (fin_vigencia)
) ENGINE=InnoDB COMMENT='Promociones publicadas directamente, sin flujo de autorización';

CREATE TABLE IF NOT EXISTS promociones_archivos (
    idPromocion        BIGINT UNSIGNED NOT NULL,
    idArchivo          BIGINT UNSIGNED NOT NULL,
    orden               SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    texto_alternativo   VARCHAR(255) NULL,
    activo              TINYINT(1) NOT NULL DEFAULT 1,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (idPromocion, idArchivo),
    CONSTRAINT fk_promocion_archivo_promocion
        FOREIGN KEY (idPromocion) REFERENCES promociones(idPromocion)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_promocion_archivo_archivo
        FOREIGN KEY (idArchivo) REFERENCES archivos(idArchivo)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_promocion_archivo_orden UNIQUE (idPromocion, orden),
    INDEX ix_promocion_archivo_activo (idPromocion, activo, orden)
) ENGINE=InnoDB COMMENT='Máximo cinco imágenes activas por promoción';

CREATE TABLE IF NOT EXISTS notificaciones (
    idNotificacion      BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    idUsuarioDestino  BIGINT UNSIGNED NOT NULL,
    idPromocion        BIGINT UNSIGNED NULL,
    tipo_evento         VARCHAR(60) NOT NULL,
    asunto              VARCHAR(200) NOT NULL,
    mensaje             TEXT NOT NULL,
    estado_envio        VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    intentos            SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    ultimo_error        TEXT NULL,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    enviado_at          DATETIME(6) NULL,
    CONSTRAINT fk_notificacion_usuario
        FOREIGN KEY (idUsuarioDestino) REFERENCES usuarios(idUsuario)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_notificacion_promocion
        FOREIGN KEY (idPromocion) REFERENCES promociones(idPromocion)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT ck_notificacion_estado
        CHECK (estado_envio IN ('PENDIENTE', 'EN_PROCESO', 'ENVIADA', 'FALLIDA')),
    INDEX ix_notificacion_pendiente (estado_envio, creado_at),
    INDEX ix_notificacion_usuario (idUsuarioDestino, creado_at)
) ENGINE=InnoDB COMMENT='Cola y bitácora de correos y avisos del sistema';

-- ============================================================================
-- 7. CONTENIDO DINÁMICO DEL SITIO
-- ============================================================================

CREATE TABLE IF NOT EXISTS secciones_portada (
    idSeccionPortada    BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    codigo              VARCHAR(60) NOT NULL,
    tipo                VARCHAR(50) NOT NULL,
    titulo              VARCHAR(200) NULL,
    subtitulo           VARCHAR(500) NULL,
    orden               SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    activo              TINYINT(1) NOT NULL DEFAULT 1,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    actualizado_at      DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                        ON UPDATE CURRENT_TIMESTAMP(6),
    CONSTRAINT uq_seccion_portada_codigo UNIQUE (codigo),
    CONSTRAINT uq_seccion_portada_orden UNIQUE (orden),
    INDEX ix_seccion_portada_activa (activo, orden)
) ENGINE=InnoDB COMMENT='Secciones configurables de la página de inicio';

CREATE TABLE IF NOT EXISTS items_seccion_portada (
    idItemSeccionPortada BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    idSeccionPortada          BIGINT UNSIGNED NOT NULL,
    titulo              VARCHAR(200) NULL,
    descripcion         TEXT NULL,
    idArchivo          BIGINT UNSIGNED NULL,
    texto_boton         VARCHAR(100) NULL,
    url_boton           VARCHAR(700) NULL,
    orden               SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    activo              TINYINT(1) NOT NULL DEFAULT 1,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    actualizado_at      DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                        ON UPDATE CURRENT_TIMESTAMP(6),
    CONSTRAINT fk_item_portada_seccion
        FOREIGN KEY (idSeccionPortada) REFERENCES secciones_portada(idSeccionPortada)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_item_portada_archivo
        FOREIGN KEY (idArchivo) REFERENCES archivos(idArchivo)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT uq_item_portada_orden UNIQUE (idSeccionPortada, orden),
    INDEX ix_item_portada_activo (idSeccionPortada, activo, orden)
) ENGINE=InnoDB COMMENT='Elementos contenidos dentro de una sección de portada';

CREATE TABLE IF NOT EXISTS configuraciones_sistema (
    clave               VARCHAR(100) PRIMARY KEY,
    valor               TEXT NULL,
    tipo_dato           VARCHAR(20) NOT NULL,
    descripcion         VARCHAR(500) NULL,
    idUsuarioActualizador     BIGINT UNSIGNED NULL,
    actualizado_at      DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                        ON UPDATE CURRENT_TIMESTAMP(6),
    CONSTRAINT fk_configuracion_actualizado_por
        FOREIGN KEY (idUsuarioActualizador) REFERENCES usuarios(idUsuario)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT ck_configuracion_tipo
        CHECK (tipo_dato IN ('STRING', 'INTEGER', 'DECIMAL', 'BOOLEAN', 'JSON'))
) ENGINE=InnoDB COMMENT='Parámetros globales; no sustituye las tablas operativas';

-- ============================================================================
-- 8. BÚSQUEDAS, INTERACCIONES Y ESTADÍSTICAS
-- ============================================================================

CREATE TABLE IF NOT EXISTS sesiones_visitantes (
    idSesionVisitante   BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    identificador_hash              CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    inicio_at                       DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    ultima_actividad_at             DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    consentimiento_geolocalizacion  TINYINT(1) NOT NULL DEFAULT 0,
    ip_hash                         CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL,
    user_agent_hash                 CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL,
    CONSTRAINT uq_sesion_visitante_hash UNIQUE (identificador_hash),
    INDEX ix_sesion_visitante_actividad (ultima_actividad_at)
) ENGINE=InnoDB COMMENT='Sesiones anónimas del portal público sin almacenar IP completa';

CREATE TABLE IF NOT EXISTS busquedas (
    idBusqueda          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    idSesionVisitante BIGINT UNSIGNED NULL,
    termino_original    VARCHAR(250) NOT NULL,
    termino_normalizado VARCHAR(250) NOT NULL,
    idMunicipio        BIGINT UNSIGNED NULL,
    idCategoria        BIGINT UNSIGNED NULL,
    latitud_visitante   DECIMAL(10,7) NULL,
    longitud_visitante  DECIMAL(10,7) NULL,
    cantidad_resultados INT UNSIGNED NOT NULL DEFAULT 0,
    duracion_ms         INT UNSIGNED NULL,
    buscado_at          DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    CONSTRAINT fk_busqueda_sesion
        FOREIGN KEY (idSesionVisitante) REFERENCES sesiones_visitantes(idSesionVisitante)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_busqueda_municipio
        FOREIGN KEY (idMunicipio) REFERENCES municipios(idMunicipio)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_busqueda_categoria
        FOREIGN KEY (idCategoria) REFERENCES categorias(idCategoria)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT ck_busqueda_latitud CHECK (latitud_visitante IS NULL OR latitud_visitante BETWEEN -90 AND 90),
    CONSTRAINT ck_busqueda_longitud CHECK (longitud_visitante IS NULL OR longitud_visitante BETWEEN -180 AND 180),
    INDEX ix_busqueda_fecha (buscado_at),
    INDEX ix_busqueda_termino (termino_normalizado),
    INDEX ix_busqueda_filtros (idMunicipio, idCategoria, buscado_at),
    INDEX ix_busqueda_sin_resultados (cantidad_resultados, buscado_at)
) ENGINE=InnoDB COMMENT='Búsquedas realizadas por visitantes';

CREATE TABLE IF NOT EXISTS busquedas_resultados (
    idBusqueda         BIGINT UNSIGNED NOT NULL,
    idAfiliado         BIGINT UNSIGNED NOT NULL,
    posicion            INT UNSIGNED NOT NULL,
    puntaje_relevancia  DECIMAL(12,6) NULL,
    mostrado_at         DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (idBusqueda, idAfiliado),
    CONSTRAINT fk_busqueda_resultado_busqueda
        FOREIGN KEY (idBusqueda) REFERENCES busquedas(idBusqueda)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_busqueda_resultado_afiliado
        FOREIGN KEY (idAfiliado) REFERENCES afiliados(idAfiliado)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_busqueda_resultado_posicion UNIQUE (idBusqueda, posicion),
    INDEX ix_resultado_afiliado_fecha (idAfiliado, mostrado_at)
) ENGINE=InnoDB COMMENT='Afiliados mostrados en cada búsqueda y su posición';

CREATE TABLE IF NOT EXISTS interacciones_afiliados (
    idInteraccionAfiliado BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    idSesionVisitante BIGINT UNSIGNED NULL,
    idBusqueda         BIGINT UNSIGNED NULL,
    idAfiliado         BIGINT UNSIGNED NOT NULL,
    idSucursal         BIGINT UNSIGNED NULL,
    idPromocion        BIGINT UNSIGNED NULL,
    idCanalDigital    BIGINT UNSIGNED NULL,
    tipo                VARCHAR(40) NOT NULL,
    ocurrido_at         DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    CONSTRAINT fk_interaccion_sesion
        FOREIGN KEY (idSesionVisitante) REFERENCES sesiones_visitantes(idSesionVisitante)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_interaccion_busqueda
        FOREIGN KEY (idBusqueda) REFERENCES busquedas(idBusqueda)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_interaccion_afiliado
        FOREIGN KEY (idAfiliado) REFERENCES afiliados(idAfiliado)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_interaccion_sucursal
        FOREIGN KEY (idSucursal) REFERENCES sucursales(idSucursal)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_interaccion_promocion
        FOREIGN KEY (idPromocion) REFERENCES promociones(idPromocion)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_interaccion_canal
        FOREIGN KEY (idCanalDigital) REFERENCES canales_digitales(idCanalDigital)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT ck_interaccion_tipo CHECK (
        tipo IN (
            'VISITA_FICHA',
            'CLIC_TELEFONO',
            'CLIC_WHATSAPP',
            'CLIC_SITIO_WEB',
            'CLIC_FACEBOOK',
            'CLIC_INSTAGRAM',
            'VISITA_PROMOCION',
            'CLIC_MAPA'
        )
    ),
    INDEX ix_interaccion_afiliado_fecha (idAfiliado, ocurrido_at),
    INDEX ix_interaccion_tipo_fecha (tipo, ocurrido_at),
    INDEX ix_interaccion_promocion (idPromocion, ocurrido_at)
) ENGINE=InnoDB COMMENT='Eventos utilizados para las estadísticas de cada afiliado';

CREATE TABLE IF NOT EXISTS estadisticas_diarias_afiliados (
    fecha                   DATE NOT NULL,
    idAfiliado             BIGINT UNSIGNED NOT NULL,
    apariciones_busqueda    INT UNSIGNED NOT NULL DEFAULT 0,
    visitas_ficha           INT UNSIGNED NOT NULL DEFAULT 0,
    clics_telefono          INT UNSIGNED NOT NULL DEFAULT 0,
    clics_whatsapp          INT UNSIGNED NOT NULL DEFAULT 0,
    clics_web               INT UNSIGNED NOT NULL DEFAULT 0,
    clics_redes             INT UNSIGNED NOT NULL DEFAULT 0,
    clics_mapa              INT UNSIGNED NOT NULL DEFAULT 0,
    visitas_promociones     INT UNSIGNED NOT NULL DEFAULT 0,
    actualizado_at          DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                            ON UPDATE CURRENT_TIMESTAMP(6),
    PRIMARY KEY (fecha, idAfiliado),
    CONSTRAINT fk_estadistica_diaria_afiliado
        FOREIGN KEY (idAfiliado) REFERENCES afiliados(idAfiliado)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX ix_estadistica_afiliado_fecha (idAfiliado, fecha)
) ENGINE=InnoDB COMMENT='Resumen derivado para acelerar dashboards y reportes';

CREATE TABLE IF NOT EXISTS indices_busquedas_afiliados (
    idAfiliado             BIGINT UNSIGNED PRIMARY KEY,
    nombre_alias            TEXT NOT NULL,
    categorias              TEXT NULL,
    palabras_clave          TEXT NULL,
    promociones_vigentes    TEXT NULL,
    descripcion             TEXT NULL,
    actualizado_at          DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                            ON UPDATE CURRENT_TIMESTAMP(6),
    CONSTRAINT fk_indice_busqueda_afiliado
        FOREIGN KEY (idAfiliado) REFERENCES afiliados(idAfiliado)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FULLTEXT INDEX ft_indice_busqueda (
        nombre_alias,
        categorias,
        palabras_clave,
        promociones_vigentes,
        descripcion
    )
) ENGINE=InnoDB COMMENT='Modelo de lectura desnormalizado para el buscador avanzado';

-- ============================================================================
-- 9. AUDITORÍA E IMPORTACIÓN CONTROLADA
-- ============================================================================

CREATE TABLE IF NOT EXISTS auditorias_cambios (
    idAuditoriaCambio   BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    idUsuario          BIGINT UNSIGNED NULL,
    entidad             VARCHAR(80) NOT NULL,
    idEntidad          BIGINT UNSIGNED NOT NULL,
    accion              VARCHAR(20) NOT NULL,
    datos_anteriores    JSON NULL,
    datos_nuevos        JSON NULL,
    ip_hash             CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    CONSTRAINT fk_auditoria_usuario
        FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT ck_auditoria_accion
        CHECK (accion IN ('CREAR', 'MODIFICAR', 'ACTIVAR', 'DESACTIVAR')),
    INDEX ix_auditoria_entidad (entidad, idEntidad, creado_at),
    INDEX ix_auditoria_usuario (idUsuario, creado_at)
) ENGINE=InnoDB COMMENT='Historial genérico de cambios relevantes';

CREATE TABLE IF NOT EXISTS importaciones_lotes (
    idImportacionLote   BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre_archivo      VARCHAR(255) NOT NULL,
    checksum_archivo    CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL,
    idUsuario          BIGINT UNSIGNED NULL,
    estado              VARCHAR(20) NOT NULL DEFAULT 'CARGADO',
    total_filas         INT UNSIGNED NOT NULL DEFAULT 0,
    filas_correctas     INT UNSIGNED NOT NULL DEFAULT 0,
    filas_error         INT UNSIGNED NOT NULL DEFAULT 0,
    creado_at           DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    actualizado_at      DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                        ON UPDATE CURRENT_TIMESTAMP(6),
    CONSTRAINT fk_importacion_lote_usuario
        FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT ck_importacion_lote_estado
        CHECK (estado IN ('CARGADO', 'VALIDANDO', 'VALIDADO', 'IMPORTADO', 'ERROR')),
    INDEX ix_importacion_lote_estado (estado, creado_at)
) ENGINE=InnoDB COMMENT='Control de cargas iniciales desde Excel o CSV';

CREATE TABLE IF NOT EXISTS importaciones_empresas_staging (
    idImportacionEmpresaStaging BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    idImportacionLote                 BIGINT UNSIGNED NOT NULL,
    hoja_origen             VARCHAR(100) NULL,
    numero_fila             INT UNSIGNED NOT NULL,
    numero_original         VARCHAR(50) NULL,
    empresa_original        TEXT NULL,
    rfc_original            TEXT NULL,
    encargado_original      TEXT NULL,
    direccion_original      TEXT NULL,
    promocion_original      TEXT NULL,
    telefono_original       TEXT NULL,
    whatsapp_original       TEXT NULL,
    facebook_original       TEXT NULL,
    instagram_original      TEXT NULL,
    pagina_web_original     TEXT NULL,
    logotipo_original       TEXT NULL,
    giro_original           TEXT NULL,
    categorias_adicionales  TEXT NULL,
    datos_extra             JSON NULL,
    estado_validacion       VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
    mensaje_error           TEXT NULL,
    idAfiliadoGenerado    BIGINT UNSIGNED NULL,
    idSucursalGenerada    BIGINT UNSIGNED NULL,
    procesado_at            DATETIME(6) NULL,
    creado_at               DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    CONSTRAINT fk_staging_lote
        FOREIGN KEY (idImportacionLote) REFERENCES importaciones_lotes(idImportacionLote)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_staging_afiliado
        FOREIGN KEY (idAfiliadoGenerado) REFERENCES afiliados(idAfiliado)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_staging_sucursal
        FOREIGN KEY (idSucursalGenerada) REFERENCES sucursales(idSucursal)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT ck_staging_estado
        CHECK (estado_validacion IN ('PENDIENTE', 'VALIDO', 'ERROR', 'IMPORTADO')),
    CONSTRAINT uq_staging_lote_fila UNIQUE (idImportacionLote, hoja_origen, numero_fila),
    INDEX ix_staging_estado (idImportacionLote, estado_validacion)
) ENGINE=InnoDB COMMENT='Área temporal para limpiar y validar los datos del Excel';

-- ============================================================================
-- 10. DATOS INICIALES
-- ============================================================================

INSERT IGNORE INTO estados (idEstado, clave_inegi, nombre, activo)
VALUES (30, '30', 'Veracruz de Ignacio de la Llave', 1);

INSERT IGNORE INTO camaras (clave, nombre, nombre_corto, activo)
VALUES ('CANACO-CORDOBA', 'CANACO Córdoba', 'CANACO Córdoba', 1);

INSERT IGNORE INTO roles (idRol, clave, nombre, descripcion, activo) VALUES
(1, 'ADMIN_GENERAL', 'Administrador General', 'Acceso total a la plataforma', 1),
(2, 'ADMIN_CAMARA',  'Administrador de Cámara', 'Administra los afiliados de su cámara', 1),
(3, 'AFILIADO',      'Afiliado', 'Administra únicamente la información de su empresa', 1);

INSERT IGNORE INTO permisos (clave, modulo, accion, descripcion) VALUES
('usuarios.ver',            'usuarios',       'ver',        'Consultar usuarios'),
('usuarios.crear',          'usuarios',       'crear',      'Registrar usuarios'),
('usuarios.editar',         'usuarios',       'editar',     'Modificar usuarios'),
('usuarios.activar',        'usuarios',       'activar',    'Activar o desactivar usuarios'),
('camaras.gestionar',       'camaras',        'gestionar',  'Administrar cámaras y circunscripciones'),
('afiliados.ver',           'afiliados',      'ver',        'Consultar afiliados'),
('afiliados.crear',         'afiliados',      'crear',      'Registrar afiliados'),
('afiliados.editar',        'afiliados',      'editar',     'Modificar afiliados autorizados'),
('afiliados.activar',       'afiliados',      'activar',    'Activar o desactivar afiliados'),
('sucursales.gestionar',    'sucursales',     'gestionar',  'Administrar sucursales'),
('categorias.gestionar',    'categorias',     'gestionar',  'Administrar categorías comerciales'),
('promociones.ver',         'promociones',    'ver',        'Consultar promociones'),
('promociones.crear',       'promociones',    'crear',      'Registrar promociones'),
('promociones.editar',      'promociones',    'editar',     'Modificar promociones autorizadas'),
('promociones.activar',     'promociones',    'activar',    'Activar o desactivar promociones'),
('reportes.ver',            'reportes',       'ver',        'Consultar reportes'),
('reportes.exportar',       'reportes',       'exportar',   'Exportar reportes a PDF o Excel'),
('estadisticas.ver',        'estadisticas',   'ver',        'Consultar estadísticas'),
('sitio.configurar',        'sitio',          'configurar', 'Administrar contenido del sitio público'),
('buscador.configurar',     'buscador',       'configurar', 'Administrar parámetros del buscador');

-- Administrador General: todos los permisos.
INSERT IGNORE INTO roles_permisos (idRol, idPermiso)
SELECT 1, idPermiso FROM permisos;

-- Administrador de Cámara.
INSERT IGNORE INTO roles_permisos (idRol, idPermiso)
SELECT 2, idPermiso
FROM permisos
WHERE clave IN (
    'afiliados.ver',
    'afiliados.crear',
    'afiliados.editar',
    'afiliados.activar',
    'sucursales.gestionar',
    'promociones.ver',
    'promociones.crear',
    'promociones.editar',
    'promociones.activar',
    'reportes.ver',
    'reportes.exportar',
    'estadisticas.ver'
);

-- Afiliado.
INSERT IGNORE INTO roles_permisos (idRol, idPermiso)
SELECT 3, idPermiso
FROM permisos
WHERE clave IN (
    'afiliados.ver',
    'afiliados.editar',
    'sucursales.gestionar',
    'promociones.ver',
    'promociones.crear',
    'promociones.editar',
    'promociones.activar',
    'estadisticas.ver'
);

INSERT INTO configuraciones_sistema (clave, valor, tipo_dato, descripcion)
VALUES
('recuperacion_password_habilitada', 'true', 'BOOLEAN',
 'Decisión confirmada: sí habrá recuperación de contraseña'),
('publicacion_promociones_requiere_autorizacion', 'false', 'BOOLEAN',
 'Decisión confirmada: las promociones se publican directamente'),
('max_palabras_clave_afiliado', '10', 'INTEGER',
 'Máximo permitido por los requerimientos'),
('max_imagenes_promocion', '5', 'INTEGER',
 'Máximo permitido por los requerimientos'),
('max_imagenes_galeria_afiliado', '10', 'INTEGER',
 'Valor propuesto y configurable; requiere validación final'),
('max_peso_imagen_bytes', '2097152', 'INTEGER',
 'Valor recomendado de 2 MB por imagen')
ON DUPLICATE KEY UPDATE
    valor = VALUES(valor),
    tipo_dato = VALUES(tipo_dato),
    descripcion = VALUES(descripcion);

-- ============================================================================
-- 11. VISTAS
-- ============================================================================

DROP VIEW IF EXISTS vw_promociones_vigentes;
CREATE VIEW vw_promociones_vigentes AS
SELECT
    p.idPromocion,
    p.idAfiliado,
    a.nombre_comercial,
    a.slug AS afiliado_slug,
    p.titulo,
    p.descripcion,
    p.restricciones,
    p.inicio_vigencia,
    p.fin_vigencia
FROM promociones p
INNER JOIN afiliados a ON a.idAfiliado = p.idAfiliado
INNER JOIN camaras c ON c.idCamara = a.idCamara
WHERE p.activo = 1
  AND a.activo = 1
  AND c.activo = 1
  AND CURRENT_TIMESTAMP(6) BETWEEN p.inicio_vigencia AND p.fin_vigencia;

DROP VIEW IF EXISTS vw_afiliados_publicos;
CREATE VIEW vw_afiliados_publicos AS
SELECT
    a.idAfiliado,
    a.idCamara,
    a.nombre_comercial,
    a.alias,
    a.slug,
    a.descripcion,
    a.correo_general,
    ac.idCategoria AS idCategoriaPrincipal,
    cat.nombre AS categoria_principal
FROM afiliados a
LEFT JOIN afiliados_categorias ac
       ON ac.idAfiliado = a.idAfiliado
      AND ac.es_principal = 1
LEFT JOIN categorias cat
       ON cat.idCategoria = ac.idCategoria
      AND cat.activo = 1
INNER JOIN camaras c
        ON c.idCamara = a.idCamara
WHERE a.activo = 1
  AND c.activo = 1;

DROP VIEW IF EXISTS vw_sucursales_publicas;
CREATE VIEW vw_sucursales_publicas AS
SELECT
    s.idSucursal,
    s.idAfiliado,
    s.nombre,
    s.es_matriz,
    s.calle,
    s.numero_exterior,
    s.numero_interior,
    s.colonia,
    s.codigo_postal,
    s.referencias,
    s.latitud,
    s.longitud,
    s.google_place_id,
    l.nombre AS localidad,
    m.idMunicipio AS idMunicipio,
    m.nombre AS municipio,
    e.idEstado AS idEstado,
    e.nombre AS estado
FROM sucursales s
INNER JOIN afiliados a ON a.idAfiliado = s.idAfiliado
INNER JOIN localidades l ON l.idLocalidad = s.idLocalidad
INNER JOIN municipios m ON m.idMunicipio = l.idMunicipio
INNER JOIN estados e ON e.idEstado = m.idEstado
WHERE s.activo = 1
  AND a.activo = 1
  AND l.activo = 1
  AND m.activo = 1
  AND e.activo = 1;

-- ============================================================================
-- 12. PROCEDIMIENTOS PARA EL ÍNDICE DE BÚSQUEDA
-- ============================================================================

DROP PROCEDURE IF EXISTS sp_reconstruir_indice_afiliado;
DROP PROCEDURE IF EXISTS sp_reconstruir_indice_todos;

DELIMITER $$

CREATE PROCEDURE sp_reconstruir_indice_afiliado(IN p_afiliado_id BIGINT UNSIGNED)
BEGIN
    INSERT INTO indices_busquedas_afiliados (
        idAfiliado,
        nombre_alias,
        categorias,
        palabras_clave,
        promociones_vigentes,
        descripcion
    )
    SELECT
        a.idAfiliado,
        TRIM(CONCAT_WS(' ', a.nombre_comercial, a.alias)),
        (
            SELECT GROUP_CONCAT(DISTINCT c.nombre ORDER BY ac.orden SEPARATOR ' ')
            FROM afiliados_categorias ac
            INNER JOIN categorias c ON c.idCategoria = ac.idCategoria
            WHERE ac.idAfiliado = a.idAfiliado
              AND c.activo = 1
        ),
        (
            SELECT GROUP_CONCAT(DISTINCT pc.palabra_normalizada ORDER BY pc.palabra_normalizada SEPARATOR ' ')
            FROM afiliados_palabras_clave pc
            WHERE pc.idAfiliado = a.idAfiliado
              AND pc.activo = 1
        ),
        (
            SELECT GROUP_CONCAT(DISTINCT CONCAT_WS(' ', p.titulo, p.descripcion) SEPARATOR ' ')
            FROM promociones p
            WHERE p.idAfiliado = a.idAfiliado
              AND p.activo = 1
              AND CURRENT_TIMESTAMP(6) BETWEEN p.inicio_vigencia AND p.fin_vigencia
        ),
        a.descripcion
    FROM afiliados a
    WHERE a.idAfiliado = p_afiliado_id
      AND a.activo = 1
    ON DUPLICATE KEY UPDATE
        nombre_alias = VALUES(nombre_alias),
        categorias = VALUES(categorias),
        palabras_clave = VALUES(palabras_clave),
        promociones_vigentes = VALUES(promociones_vigentes),
        descripcion = VALUES(descripcion),
        actualizado_at = CURRENT_TIMESTAMP(6);

    DELETE iba
    FROM indices_busquedas_afiliados iba
    LEFT JOIN afiliados a ON a.idAfiliado = iba.idAfiliado
    WHERE iba.idAfiliado = p_afiliado_id
      AND (a.idAfiliado IS NULL OR a.activo = 0);
END$$

CREATE PROCEDURE sp_reconstruir_indice_todos()
BEGIN
    DECLARE v_finalizado TINYINT DEFAULT 0;
    DECLARE v_afiliado_id BIGINT UNSIGNED;

    DECLARE cur_afiliados CURSOR FOR
        SELECT idAfiliado FROM afiliados WHERE activo = 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finalizado = 1;

    OPEN cur_afiliados;

    ciclo: LOOP
        FETCH cur_afiliados INTO v_afiliado_id;

        IF v_finalizado = 1 THEN
            LEAVE ciclo;
        END IF;

        CALL sp_reconstruir_indice_afiliado(v_afiliado_id);
    END LOOP;

    CLOSE cur_afiliados;

    DELETE iba
    FROM indices_busquedas_afiliados iba
    LEFT JOIN afiliados a ON a.idAfiliado = iba.idAfiliado
    WHERE a.idAfiliado IS NULL OR a.activo = 0;
END$$

DELIMITER ;

-- ============================================================================
-- 13. TRIGGERS DE INTEGRIDAD
-- ============================================================================

DROP TRIGGER IF EXISTS trg_usuario_bi;
DROP TRIGGER IF EXISTS trg_usuario_bu;
DROP TRIGGER IF EXISTS trg_afiliado_bi;
DROP TRIGGER IF EXISTS trg_afiliado_bu;
DROP TRIGGER IF EXISTS trg_palabra_clave_bi;
DROP TRIGGER IF EXISTS trg_palabra_clave_bu;
DROP TRIGGER IF EXISTS trg_promocion_archivo_bi;
DROP TRIGGER IF EXISTS trg_promocion_archivo_bu;
DROP TRIGGER IF EXISTS trg_canal_digital_bi;
DROP TRIGGER IF EXISTS trg_canal_digital_bu;
DROP TRIGGER IF EXISTS trg_interaccion_bi;
DROP TRIGGER IF EXISTS trg_interaccion_bu;

DELIMITER $$

CREATE TRIGGER trg_usuario_bi
BEFORE INSERT ON usuarios
FOR EACH ROW
BEGIN
    SET NEW.nombre = TRIM(NEW.nombre);
    SET NEW.correo = LOWER(TRIM(NEW.correo));
END$$

CREATE TRIGGER trg_usuario_bu
BEFORE UPDATE ON usuarios
FOR EACH ROW
BEGIN
    SET NEW.nombre = TRIM(NEW.nombre);
    SET NEW.correo = LOWER(TRIM(NEW.correo));
END$$

CREATE TRIGGER trg_afiliado_bi
BEFORE INSERT ON afiliados
FOR EACH ROW
BEGIN
    SET NEW.rfc = UPPER(REPLACE(TRIM(NEW.rfc), ' ', ''));
    SET NEW.nombre_comercial = TRIM(NEW.nombre_comercial);
    SET NEW.slug = LOWER(TRIM(NEW.slug));

    IF NEW.correo_general IS NOT NULL THEN
        SET NEW.correo_general = LOWER(TRIM(NEW.correo_general));
    END IF;
END$$

CREATE TRIGGER trg_afiliado_bu
BEFORE UPDATE ON afiliados
FOR EACH ROW
BEGIN
    SET NEW.rfc = UPPER(REPLACE(TRIM(NEW.rfc), ' ', ''));
    SET NEW.nombre_comercial = TRIM(NEW.nombre_comercial);
    SET NEW.slug = LOWER(TRIM(NEW.slug));

    IF NEW.correo_general IS NOT NULL THEN
        SET NEW.correo_general = LOWER(TRIM(NEW.correo_general));
    END IF;
END$$

CREATE TRIGGER trg_palabra_clave_bi
BEFORE INSERT ON afiliados_palabras_clave
FOR EACH ROW
BEGIN
    DECLARE v_total INT DEFAULT 0;

    SET NEW.palabra = TRIM(NEW.palabra);
    SET NEW.palabra_normalizada = LOWER(TRIM(NEW.palabra_normalizada));

    IF NEW.activo = 1 THEN
        SELECT COUNT(*)
          INTO v_total
          FROM afiliados_palabras_clave
         WHERE idAfiliado = NEW.idAfiliado
           AND activo = 1;

        IF v_total >= 10 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Un afiliado no puede tener más de 10 palabras clave activas';
        END IF;
    END IF;
END$$

CREATE TRIGGER trg_palabra_clave_bu
BEFORE UPDATE ON afiliados_palabras_clave
FOR EACH ROW
BEGIN
    DECLARE v_total INT DEFAULT 0;

    SET NEW.palabra = TRIM(NEW.palabra);
    SET NEW.palabra_normalizada = LOWER(TRIM(NEW.palabra_normalizada));

    IF NEW.activo = 1
       AND (OLD.activo = 0 OR OLD.idAfiliado <> NEW.idAfiliado) THEN

        SELECT COUNT(*)
          INTO v_total
          FROM afiliados_palabras_clave
         WHERE idAfiliado = NEW.idAfiliado
           AND activo = 1
           AND idAfiliadoPalabraClave <> OLD.idAfiliadoPalabraClave;

        IF v_total >= 10 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Un afiliado no puede tener más de 10 palabras clave activas';
        END IF;
    END IF;
END$$

CREATE TRIGGER trg_promocion_archivo_bi
BEFORE INSERT ON promociones_archivos
FOR EACH ROW
BEGIN
    DECLARE v_total INT DEFAULT 0;

    IF NEW.activo = 1 THEN
        SELECT COUNT(*)
          INTO v_total
          FROM promociones_archivos
         WHERE idPromocion = NEW.idPromocion
           AND activo = 1;

        IF v_total >= 5 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Una promoción no puede tener más de 5 imágenes activas';
        END IF;
    END IF;
END$$

CREATE TRIGGER trg_promocion_archivo_bu
BEFORE UPDATE ON promociones_archivos
FOR EACH ROW
BEGIN
    DECLARE v_total INT DEFAULT 0;

    IF NEW.activo = 1
       AND (OLD.activo = 0 OR OLD.idPromocion <> NEW.idPromocion) THEN

        SELECT COUNT(*)
          INTO v_total
          FROM promociones_archivos
         WHERE idPromocion = NEW.idPromocion
           AND activo = 1
           AND NOT (
               idPromocion = OLD.idPromocion
               AND idArchivo = OLD.idArchivo
           );

        IF v_total >= 5 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Una promoción no puede tener más de 5 imágenes activas';
        END IF;
    END IF;
END$$

CREATE TRIGGER trg_canal_digital_bi
BEFORE INSERT ON canales_digitales
FOR EACH ROW
BEGIN
    IF NEW.idSucursal IS NOT NULL AND NOT EXISTS (
        SELECT 1
          FROM sucursales
         WHERE idSucursal = NEW.idSucursal
           AND idAfiliado = NEW.idAfiliado
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La sucursal indicada no pertenece al afiliado';
    END IF;
END$$

CREATE TRIGGER trg_canal_digital_bu
BEFORE UPDATE ON canales_digitales
FOR EACH ROW
BEGIN
    IF NEW.idSucursal IS NOT NULL AND NOT EXISTS (
        SELECT 1
          FROM sucursales
         WHERE idSucursal = NEW.idSucursal
           AND idAfiliado = NEW.idAfiliado
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La sucursal indicada no pertenece al afiliado';
    END IF;
END$$

CREATE TRIGGER trg_interaccion_bi
BEFORE INSERT ON interacciones_afiliados
FOR EACH ROW
BEGIN
    IF NEW.idSucursal IS NOT NULL AND NOT EXISTS (
        SELECT 1
          FROM sucursales
         WHERE idSucursal = NEW.idSucursal
           AND idAfiliado = NEW.idAfiliado
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La sucursal de la interacción no pertenece al afiliado';
    END IF;

    IF NEW.idPromocion IS NOT NULL AND NOT EXISTS (
        SELECT 1
          FROM promociones
         WHERE idPromocion = NEW.idPromocion
           AND idAfiliado = NEW.idAfiliado
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La promoción de la interacción no pertenece al afiliado';
    END IF;
END$$

CREATE TRIGGER trg_interaccion_bu
BEFORE UPDATE ON interacciones_afiliados
FOR EACH ROW
BEGIN
    IF NEW.idSucursal IS NOT NULL AND NOT EXISTS (
        SELECT 1
          FROM sucursales
         WHERE idSucursal = NEW.idSucursal
           AND idAfiliado = NEW.idAfiliado
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La sucursal de la interacción no pertenece al afiliado';
    END IF;

    IF NEW.idPromocion IS NOT NULL AND NOT EXISTS (
        SELECT 1
          FROM promociones
         WHERE idPromocion = NEW.idPromocion
           AND idAfiliado = NEW.idAfiliado
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La promoción de la interacción no pertenece al afiliado';
    END IF;
END$$

DELIMITER ;

-- ============================================================================
-- 14. EJEMPLO PARA CREAR EL PRIMER ADMINISTRADOR
-- ============================================================================
-- Genere el hash en PHP:
--
--   echo password_hash('SuContraseñaSegura', PASSWORD_ARGON2ID);
--
-- Después ejecute, sustituyendo el hash:
--
-- INSERT INTO usuarios (idRol, nombre, correo, password_hash, password_actualizado_at)
-- VALUES (
--     1,
--     'Administrador General',
--     'admin@canacocard.mx',
--     '$argon2id$HASH_GENERADO_DESDE_PHP',
--     CURRENT_TIMESTAMP(6)
-- );

-- ============================================================================
-- FIN DEL SCRIPT
-- ============================================================================

SELECT
    'Base de datos CANACO Card creada correctamente' AS mensaje,
    DATABASE() AS base_de_datos,
    CURRENT_TIMESTAMP(6) AS fecha_utc;
