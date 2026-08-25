-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 22-08-2026 a las 01:52:38
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `canaco_card`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE PROCEDURE `sp_reconstruir_indice_afiliado` (IN `p_afiliado_id` BIGINT UNSIGNED)   BEGIN
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

CREATE PROCEDURE `sp_reconstruir_indice_todos` ()   BEGIN
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `afiliados`
--

CREATE TABLE `afiliados` (
  `idAfiliado` bigint(20) UNSIGNED NOT NULL,
  `idCamara` bigint(20) UNSIGNED NOT NULL,
  `rfc` varchar(13) NOT NULL,
  `razon_social` varchar(180) DEFAULT NULL,
  `nombre_comercial` varchar(180) NOT NULL,
  `alias` varchar(120) DEFAULT NULL,
  `slug` varchar(200) NOT NULL,
  `descripcion` text NOT NULL,
  `correo_general` varchar(254) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `idUsuarioCreador` bigint(20) UNSIGNED DEFAULT NULL,
  `idUsuarioActualizador` bigint(20) UNSIGNED DEFAULT NULL,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `actualizado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `desactivado_at` datetime(6) DEFAULT NULL,
  `idUsuarioDesactivador` bigint(20) UNSIGNED DEFAULT NULL,
  `motivo_desactivacion` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `afiliados`
--

INSERT INTO `afiliados` (`idAfiliado`, `idCamara`, `rfc`, `razon_social`, `nombre_comercial`, `alias`, `slug`, `descripcion`, `correo_general`, `activo`, `idUsuarioCreador`, `idUsuarioActualizador`, `creado_at`, `actualizado_at`, `desactivado_at`, `idUsuarioDesactivador`, `motivo_desactivacion`) VALUES
(1, 1, 'PRUEBA1EFSDFA', 'Empresassss', 'Negocio 1', 'Negocio', 'negocio-1', 'Una prueba', 'test@test.com', 0, NULL, NULL, '2026-08-07 08:00:42.785463', '2026-08-18 18:28:35.089135', '2026-08-18 18:28:35.000000', NULL, 'Ufjdkd'),
(2, 1, 'SREVDSGFGADTH', 'fgsfdgfdg', 'Mi Negocio', 'Negocio', 'mi-negocio', 'gsdfgdfgdsf', 'herrerabeto501@gmail.com', 0, NULL, NULL, '2026-08-09 02:09:30.347409', '2026-08-10 20:36:46.903628', '2026-08-10 20:36:46.000000', NULL, NULL),
(3, 1, 'XXXX000000000', 'Empresa X', 'Abarrotes N', 'ABR N', 'abarrotes-n', 'Encuentra todo lo que necesitas para tu hogar', 'herrerabeto501@gmail.com', 0, NULL, NULL, '2026-08-10 19:58:41.604031', '2026-08-19 18:50:31.808790', '2026-08-19 18:50:31.000000', NULL, 'si'),
(5, 1, 'PRUEBA1EFSSDF', 'Empresasss', 'Zapateria XA', 'Zapateria x', 'zapateria-xa', 'Encuentra todo tipo de calzado', 'ejemplo@gmail.com', 0, NULL, NULL, '2026-08-18 22:50:22.304048', '2026-08-19 18:50:38.793716', '2026-08-19 18:50:38.000000', NULL, 'si'),
(6, 1, 'GSA030826MI9', NULL, 'Grupo Sorom Asesores', 'Grupo Sorom Asesores', 'grupo-sorom-asesores', 'Compra y venta de equipo y desarrollo de sistemas', 'ejemplo@gmail.com', 1, NULL, NULL, '2026-08-19 18:39:22.805887', '2026-08-19 18:39:22.805887', NULL, NULL, NULL),
(7, 1, 'RICE840316MK2', NULL, 'By Cafétia', NULL, 'by-caf-etia', 'Café y tienda impulsora artesanal', 'ejemplo@gmail.com', 1, NULL, NULL, '2026-08-19 18:58:22.584585', '2026-08-19 18:58:22.584585', NULL, NULL, NULL),
(8, 1, 'GCE2212141K5', NULL, 'CEVPRO', NULL, 'cevpro', 'Servicios educativos, de consultoría y capacitación del capital humano.', 'ejemplo@gmail.com', 1, NULL, NULL, '2026-08-19 19:02:47.237945', '2026-08-19 19:02:47.237945', NULL, NULL, NULL),
(9, 1, 'CCM131203R32', NULL, 'CLIMERS LAB.', NULL, 'climers-lab', 'Laboratoria de analisis clinicas', 'ejemplo@gmail.com', 1, NULL, NULL, '2026-08-19 19:13:33.212900', '2026-08-19 19:13:33.212900', NULL, NULL, NULL);

--
-- Disparadores `afiliados`
--
DELIMITER $$
CREATE TRIGGER `trg_afiliado_bi` BEFORE INSERT ON `afiliados` FOR EACH ROW BEGIN
    SET NEW.rfc = UPPER(REPLACE(TRIM(NEW.rfc), ' ', ''));
    SET NEW.nombre_comercial = TRIM(NEW.nombre_comercial);
    SET NEW.slug = LOWER(TRIM(NEW.slug));

    IF NEW.correo_general IS NOT NULL THEN
        SET NEW.correo_general = LOWER(TRIM(NEW.correo_general));
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_afiliado_bu` BEFORE UPDATE ON `afiliados` FOR EACH ROW BEGIN
    SET NEW.rfc = UPPER(REPLACE(TRIM(NEW.rfc), ' ', ''));
    SET NEW.nombre_comercial = TRIM(NEW.nombre_comercial);
    SET NEW.slug = LOWER(TRIM(NEW.slug));

    IF NEW.correo_general IS NOT NULL THEN
        SET NEW.correo_general = LOWER(TRIM(NEW.correo_general));
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `afiliados_archivos`
--

CREATE TABLE `afiliados_archivos` (
  `idAfiliado` bigint(20) UNSIGNED NOT NULL,
  `idArchivo` bigint(20) UNSIGNED NOT NULL,
  `tipo` varchar(20) NOT NULL,
  `orden` smallint(5) UNSIGNED NOT NULL DEFAULT 1,
  `texto_alternativo` varchar(255) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `logo_activo_unico` bigint(20) UNSIGNED GENERATED ALWAYS AS (case when `tipo` = 'LOGOTIPO' and `activo` = 1 then `idAfiliado` else NULL end) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `afiliados_archivos`
--

INSERT INTO `afiliados_archivos` (`idAfiliado`, `idArchivo`, `tipo`, `orden`, `texto_alternativo`, `activo`, `creado_at`) VALUES
(3, 1, 'LOGOTIPO', 1, 'Logotipo', 1, '2026-08-10 19:58:41.637203'),
(3, 2, 'GALERIA', 1, 'Galería', 1, '2026-08-10 19:58:41.643655'),
(5, 4, 'LOGOTIPO', 1, 'Logotipo', 1, '2026-08-18 22:50:22.327693'),
(6, 8, 'LOGOTIPO', 1, 'Logotipo', 1, '2026-08-19 18:39:22.830335'),
(7, 10, 'LOGOTIPO', 1, 'Logotipo', 1, '2026-08-19 18:58:22.610474'),
(8, 11, 'LOGOTIPO', 1, 'Logotipo', 1, '2026-08-19 19:02:47.249553'),
(9, 12, 'LOGOTIPO', 1, 'Logotipo', 1, '2026-08-19 19:13:33.229220');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `afiliados_categorias`
--

CREATE TABLE `afiliados_categorias` (
  `idAfiliado` bigint(20) UNSIGNED NOT NULL,
  `idCategoria` bigint(20) UNSIGNED NOT NULL,
  `es_principal` tinyint(1) NOT NULL DEFAULT 0,
  `orden` smallint(5) UNSIGNED NOT NULL DEFAULT 1,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `principal_unica` bigint(20) UNSIGNED GENERATED ALWAYS AS (case when `es_principal` = 1 then `idAfiliado` else NULL end) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Relación muchos a muchos entre afiliados y categorías';

--
-- Volcado de datos para la tabla `afiliados_categorias`
--

INSERT INTO `afiliados_categorias` (`idAfiliado`, `idCategoria`, `es_principal`, `orden`, `creado_at`) VALUES
(3, 2, 0, 2, '2026-08-18 22:48:38.608560'),
(3, 3, 1, 1, '2026-08-18 22:48:38.608341'),
(5, 2, 1, 1, '2026-08-18 22:50:22.312012'),
(6, 13, 0, 2, '2026-08-19 18:50:13.417561'),
(6, 49, 1, 1, '2026-08-19 18:50:13.417176'),
(7, 4, 1, 1, '2026-08-19 19:07:44.640362'),
(7, 18, 0, 2, '2026-08-19 19:07:44.642926'),
(7, 25, 0, 3, '2026-08-19 19:07:44.643054'),
(8, 64, 1, 1, '2026-08-19 19:02:47.245277'),
(9, 56, 1, 1, '2026-08-19 23:12:26.709443');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `afiliados_palabras_clave`
--

CREATE TABLE `afiliados_palabras_clave` (
  `idAfiliadoPalabraClave` bigint(20) UNSIGNED NOT NULL,
  `idAfiliado` bigint(20) UNSIGNED NOT NULL,
  `palabra` varchar(80) NOT NULL,
  `palabra_normalizada` varchar(80) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `actualizado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Hasta diez términos de búsqueda por afiliado';

--
-- Volcado de datos para la tabla `afiliados_palabras_clave`
--

INSERT INTO `afiliados_palabras_clave` (`idAfiliadoPalabraClave`, `idAfiliado`, `palabra`, `palabra_normalizada`, `activo`, `creado_at`, `actualizado_at`) VALUES
(1, 3, 'Ropa', 'ropa', 1, '2026-08-10 19:58:41.622054', '2026-08-18 22:48:38.614954'),
(2, 3, 'calzado', 'calzado', 1, '2026-08-10 19:58:41.623166', '2026-08-18 22:48:38.615726'),
(3, 3, 'Tenis', 'tenis', 1, '2026-08-10 19:58:41.624005', '2026-08-18 22:48:38.616416'),
(4, 3, 'Zapatos', 'zapatos', 1, '2026-08-10 19:58:41.626637', '2026-08-18 22:48:38.617120'),
(5, 5, 'Calzado', 'calzado', 1, '2026-08-18 22:50:22.314817', '2026-08-18 22:50:22.314817'),
(6, 5, 'Tenis', 'tenis', 1, '2026-08-18 22:50:22.315556', '2026-08-18 22:50:22.315556'),
(7, 5, 'Zapatos', 'zapatos', 1, '2026-08-18 22:50:22.318382', '2026-08-18 22:50:22.318382');

--
-- Disparadores `afiliados_palabras_clave`
--
DELIMITER $$
CREATE TRIGGER `trg_palabra_clave_bi` BEFORE INSERT ON `afiliados_palabras_clave` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_palabra_clave_bu` BEFORE UPDATE ON `afiliados_palabras_clave` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `archivos`
--

CREATE TABLE `archivos` (
  `idArchivo` bigint(20) UNSIGNED NOT NULL,
  `nombre_original` varchar(255) NOT NULL,
  `storage_key` varchar(500) NOT NULL,
  `url_publica` varchar(700) DEFAULT NULL,
  `mime_type` varchar(100) NOT NULL,
  `peso_bytes` bigint(20) UNSIGNED NOT NULL,
  `ancho_px` int(10) UNSIGNED DEFAULT NULL,
  `alto_px` int(10) UNSIGNED DEFAULT NULL,
  `checksum_sha256` char(64) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `idUsuarioCreador` bigint(20) UNSIGNED DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `actualizado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `archivos`
--

INSERT INTO `archivos` (`idArchivo`, `nombre_original`, `storage_key`, `url_publica`, `mime_type`, `peso_bytes`, `ancho_px`, `alto_px`, `checksum_sha256`, `idUsuarioCreador`, `activo`, `creado_at`, `actualizado_at`) VALUES
(1, 'firmaAbiel.png', 'afiliados/2026/08/bc9974c61425e0dc055209466198ef38.png', '/canaco-card/uploads/afiliados/2026/08/bc9974c61425e0dc055209466198ef38.png', 'image/png', 12172, 645, 390, '69867e40975be8f92a78148335c566f808b89140f18d3ce1fbf50b3e244cd2b9', NULL, 1, '2026-08-10 19:58:41.635418', '2026-08-18 15:40:02.876406'),
(2, 'WhatsApp Image 2026-08-06 at 12.12.40 AM.jpeg', 'afiliados/2026/08/57d28d89d38c7606e8d6cec45fba33a8.jpg', '/canaco-card/uploads/afiliados/2026/08/57d28d89d38c7606e8d6cec45fba33a8.jpg', 'image/jpeg', 131244, 937, 1467, 'd909d36890ff36b83a2bd94baa02616531bf093d537ffeb64a428eda5d5e01f7', NULL, 1, '2026-08-10 19:58:41.643185', '2026-08-18 15:40:02.876406'),
(3, 'firmaAbiel.png', 'promociones/2026/08/d983291e2b6174a478477049ac6493dd.png', '/canaco-card/uploads/promociones/2026/08/d983291e2b6174a478477049ac6493dd.png', 'image/png', 12172, 645, 390, '69867e40975be8f92a78148335c566f808b89140f18d3ce1fbf50b3e244cd2b9', NULL, 1, '2026-08-12 21:37:52.390765', '2026-08-18 15:40:02.876406'),
(4, 'images.png', 'afiliados/2026/08/cccbc3ccc39766972499d53ee4eee51f.png', '/canaco-card/uploads/afiliados/2026/08/cccbc3ccc39766972499d53ee4eee51f.png', 'image/png', 1678, 225, 225, 'bf8708f231b5eff325ec10a9168dfcc26fec54b5a9cf45138e34580990a2b908', NULL, 1, '2026-08-18 22:50:22.324144', '2026-08-18 22:50:22.324144'),
(5, 'images.jpeg', 'promociones/2026/08/b3bcf6fa3d427e373aab175bf99b2e4e.jpg', '/canaco-card/uploads/promociones/2026/08/b3bcf6fa3d427e373aab175bf99b2e4e.jpg', 'image/jpeg', 11166, 225, 225, '05f699535e3e8c1c34b1015bea78c79ba3317fbc0f3821d6dc0bde45bad5611d', NULL, 1, '2026-08-18 22:52:07.899134', '2026-08-18 22:52:07.899134'),
(6, 'images (1).jpeg', 'promociones/2026/08/03c8a6b3ba9fa56b13feaacbf54d451b.jpg', '/canaco-card/uploads/promociones/2026/08/03c8a6b3ba9fa56b13feaacbf54d451b.jpg', 'image/jpeg', 17035, 225, 225, '7a761ee1c2994a244d70a4d42a75a869bf35499eccbde54eea8cebf788675bb9', NULL, 1, '2026-08-18 22:53:25.953731', '2026-08-18 22:53:25.953731'),
(7, 'images (2).jpeg', 'promociones/2026/08/06ba7f4aa13424aa8d1225fe3cd39e21.jpg', '/canaco-card/uploads/promociones/2026/08/06ba7f4aa13424aa8d1225fe3cd39e21.jpg', 'image/jpeg', 16753, 225, 225, 'f0484e26558eeaa935faaa9450f1fd7c9742e19205368d6b02d9ea1a763cce20', NULL, 1, '2026-08-18 22:54:48.443192', '2026-08-18 22:54:48.443192'),
(8, 'CANACOCARD_Logo.png', 'afiliados/2026/08/f3e0a20da2307ed012b19d55ec46edff.png', '/canaco-card/uploads/afiliados/2026/08/f3e0a20da2307ed012b19d55ec46edff.png', 'image/png', 281001, 4167, 2256, '4bc81d857bd561ee1ec718aec3562baf50824ba9bcf192718ce11cc7e95c17f9', NULL, 1, '2026-08-19 18:39:22.828639', '2026-08-19 18:39:22.828639'),
(9, 'CANACOCARD_Logo.png', 'promociones/2026/08/85ab0ee33f08731e55527744ad4f9e1b.png', '/canaco-card/uploads/promociones/2026/08/85ab0ee33f08731e55527744ad4f9e1b.png', 'image/png', 281001, 4167, 2256, '4bc81d857bd561ee1ec718aec3562baf50824ba9bcf192718ce11cc7e95c17f9', NULL, 1, '2026-08-19 18:53:15.739207', '2026-08-19 18:53:15.739207'),
(10, 'CANACOCARD_Logo.png', 'afiliados/2026/08/e9d75174e8568c79663dc42e4275940b.png', '/canaco-card/uploads/afiliados/2026/08/e9d75174e8568c79663dc42e4275940b.png', 'image/png', 281001, 4167, 2256, '4bc81d857bd561ee1ec718aec3562baf50824ba9bcf192718ce11cc7e95c17f9', NULL, 1, '2026-08-19 18:58:22.609576', '2026-08-19 18:58:22.609576'),
(11, 'CANACOCARD_Logo.png', 'afiliados/2026/08/aa55ad9cb706d9257af84d94f9dd4f6e.png', '/canaco-card/uploads/afiliados/2026/08/aa55ad9cb706d9257af84d94f9dd4f6e.png', 'image/png', 281001, 4167, 2256, '4bc81d857bd561ee1ec718aec3562baf50824ba9bcf192718ce11cc7e95c17f9', NULL, 1, '2026-08-19 19:02:47.249071', '2026-08-19 19:02:47.249071'),
(12, 'CANACOCARD_Logo.png', 'afiliados/2026/08/9f5365c9d6e4241060edd73abdbbe56a.png', '/canaco-card/uploads/afiliados/2026/08/9f5365c9d6e4241060edd73abdbbe56a.png', 'image/png', 281001, 4167, 2256, '4bc81d857bd561ee1ec718aec3562baf50824ba9bcf192718ce11cc7e95c17f9', NULL, 1, '2026-08-19 19:13:33.226948', '2026-08-19 19:13:33.226948'),
(13, 'CANACOCARD_Logo.png', 'promociones/2026/08/7168866a2305832b625f77a0a73259ab.png', '/canaco-card/uploads/promociones/2026/08/7168866a2305832b625f77a0a73259ab.png', 'image/png', 281001, 4167, 2256, '4bc81d857bd561ee1ec718aec3562baf50824ba9bcf192718ce11cc7e95c17f9', NULL, 1, '2026-08-19 19:15:37.679678', '2026-08-19 19:15:37.679678'),
(14, 'CANACOCARD_Logo.png', 'promociones/2026/08/5e0fd9df260a5883a0c152cf8b6dc14a.png', '/canaco-card/uploads/promociones/2026/08/5e0fd9df260a5883a0c152cf8b6dc14a.png', 'image/png', 281001, 4167, 2256, '4bc81d857bd561ee1ec718aec3562baf50824ba9bcf192718ce11cc7e95c17f9', NULL, 1, '2026-08-19 19:18:43.261651', '2026-08-19 19:18:43.261651'),
(15, 'CANACOCARD_Logo.png', 'promociones/2026/08/3962d94283cc3ee0a5ca11c8cb9e0ede.png', '/canaco-card/uploads/promociones/2026/08/3962d94283cc3ee0a5ca11c8cb9e0ede.png', 'image/png', 281001, 4167, 2256, '4bc81d857bd561ee1ec718aec3562baf50824ba9bcf192718ce11cc7e95c17f9', NULL, 1, '2026-08-19 19:22:29.809034', '2026-08-19 19:22:29.809034');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditorias_cambios`
--

CREATE TABLE `auditorias_cambios` (
  `idAuditoriaCambio` bigint(20) UNSIGNED NOT NULL,
  `idUsuario` bigint(20) UNSIGNED DEFAULT NULL,
  `entidad` varchar(80) NOT NULL,
  `idEntidad` bigint(20) UNSIGNED NOT NULL,
  `accion` varchar(20) NOT NULL,
  `datos_anteriores` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`datos_anteriores`)),
  `datos_nuevos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`datos_nuevos`)),
  `ip_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `busquedas`
--

CREATE TABLE `busquedas` (
  `idBusqueda` bigint(20) UNSIGNED NOT NULL,
  `idSesionVisitante` bigint(20) UNSIGNED DEFAULT NULL,
  `termino_original` varchar(250) NOT NULL,
  `termino_normalizado` varchar(250) NOT NULL,
  `idMunicipio` bigint(20) UNSIGNED DEFAULT NULL,
  `idCategoria` bigint(20) UNSIGNED DEFAULT NULL,
  `latitud_visitante` decimal(10,7) DEFAULT NULL,
  `longitud_visitante` decimal(10,7) DEFAULT NULL,
  `cantidad_resultados` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `duracion_ms` int(10) UNSIGNED DEFAULT NULL,
  `buscado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `busquedas_resultados`
--

CREATE TABLE `busquedas_resultados` (
  `idBusqueda` bigint(20) UNSIGNED NOT NULL,
  `idAfiliado` bigint(20) UNSIGNED NOT NULL,
  `posicion` int(10) UNSIGNED NOT NULL,
  `puntaje_relevancia` decimal(12,6) DEFAULT NULL,
  `mostrado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Afiliados mostrados en cada búsqueda y su posición';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `camaras`
--

CREATE TABLE `camaras` (
  `idCamara` bigint(20) UNSIGNED NOT NULL,
  `clave` varchar(30) NOT NULL,
  `nombre` varchar(180) NOT NULL,
  `nombre_corto` varchar(80) DEFAULT NULL,
  `correo` varchar(254) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `idMunicipioSede` bigint(20) UNSIGNED DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `actualizado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Cámaras que administran afiliados';

--
-- Volcado de datos para la tabla `camaras`
--

INSERT INTO `camaras` (`idCamara`, `clave`, `nombre`, `nombre_corto`, `correo`, `telefono`, `idMunicipioSede`, `activo`, `creado_at`, `actualizado_at`) VALUES
(1, 'CANACO-CORDOBA', 'CANACO Córdoba', 'CANACO Córdoba', NULL, NULL, NULL, 1, '2026-08-06 21:03:07.136479', '2026-08-06 21:03:07.136479');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `camaras_municipios`
--

CREATE TABLE `camaras_municipios` (
  `idCamara` bigint(20) UNSIGNED NOT NULL,
  `idMunicipio` bigint(20) UNSIGNED NOT NULL,
  `tipo_cobertura` varchar(20) NOT NULL DEFAULT 'DIRECTA',
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `canales_digitales`
--

CREATE TABLE `canales_digitales` (
  `idCanalDigital` bigint(20) UNSIGNED NOT NULL,
  `idAfiliado` bigint(20) UNSIGNED NOT NULL,
  `idSucursal` bigint(20) UNSIGNED DEFAULT NULL,
  `tipo` varchar(30) NOT NULL,
  `url` varchar(700) NOT NULL,
  `nombre_usuario` varchar(150) DEFAULT NULL,
  `es_principal` tinyint(1) NOT NULL DEFAULT 0,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `actualizado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `canales_digitales`
--

INSERT INTO `canales_digitales` (`idCanalDigital`, `idAfiliado`, `idSucursal`, `tipo`, `url`, `nombre_usuario`, `es_principal`, `activo`, `creado_at`, `actualizado_at`) VALUES
(1, 6, NULL, 'FACEBOOK', 'https://www.facebook.com/gruposorom/?locale=es_LA', NULL, 1, 1, '2026-08-19 18:39:22.814795', '2026-08-19 18:39:22.814795'),
(2, 6, NULL, 'INSTAGRAM', 'https://www.instagram.com/gruposorom/', NULL, 1, 1, '2026-08-19 18:39:22.815373', '2026-08-19 18:39:22.815373'),
(3, 6, NULL, 'SITIO_WEB', 'https://www.sorom.com.mx/', NULL, 1, 1, '2026-08-19 18:39:22.817805', '2026-08-19 18:39:22.817805'),
(4, 7, NULL, 'INSTAGRAM', 'https://www.instagram.com/bycafetia/', NULL, 1, 1, '2026-08-19 18:58:22.599783', '2026-08-19 18:58:22.599783'),
(5, 8, NULL, 'FACEBOOK', 'https://www.facebook.com/p/Cevpro-Orizaba-100094634066830/', NULL, 1, 1, '2026-08-19 19:02:47.241717', '2026-08-19 19:02:47.241717'),
(6, 8, NULL, 'INSTAGRAM', 'https://www.instagram.com/cevproorizaba/', NULL, 1, 1, '2026-08-19 19:02:47.242271', '2026-08-19 19:02:47.242271'),
(7, 9, NULL, 'FACEBOOK', 'https://www.facebook.com/climerslab/?locale=es_LA', NULL, 1, 1, '2026-08-19 19:13:33.221865', '2026-08-19 19:13:33.221865');

--
-- Disparadores `canales_digitales`
--
DELIMITER $$
CREATE TRIGGER `trg_canal_digital_bi` BEFORE INSERT ON `canales_digitales` FOR EACH ROW BEGIN
    IF NEW.idSucursal IS NOT NULL AND NOT EXISTS (
        SELECT 1
          FROM sucursales
         WHERE idSucursal = NEW.idSucursal
           AND idAfiliado = NEW.idAfiliado
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La sucursal indicada no pertenece al afiliado';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_canal_digital_bu` BEFORE UPDATE ON `canales_digitales` FOR EACH ROW BEGIN
    IF NEW.idSucursal IS NOT NULL AND NOT EXISTS (
        SELECT 1
          FROM sucursales
         WHERE idSucursal = NEW.idSucursal
           AND idAfiliado = NEW.idAfiliado
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La sucursal indicada no pertenece al afiliado';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `idCategoria` bigint(20) UNSIGNED NOT NULL,
  `idCategoriaPadre` bigint(20) UNSIGNED DEFAULT NULL,
  `nombre` varchar(120) NOT NULL,
  `slug` varchar(150) NOT NULL,
  `descripcion` varchar(500) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `actualizado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Categorías comerciales con jerarquía opcional';

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`idCategoria`, `idCategoriaPadre`, `nombre`, `slug`, `descripcion`, `activo`, `creado_at`, `actualizado_at`) VALUES
(1, NULL, 'Electrónica', 'electronica', 'Dispositivos y aparatos electrónicos', 1, '2026-08-10 13:56:57.000000', '2026-08-10 13:56:57.000000'),
(2, NULL, 'Ropa y Calzado', 'ropa-y-calzado', 'Vestimenta general y calzado', 1, '2026-08-10 13:56:57.000000', '2026-08-10 13:56:57.000000'),
(3, NULL, 'Hogar y Jardín', 'hogar-y-jardin', 'Artículos para el hogar y jardinería', 1, '2026-08-10 13:56:57.000000', '2026-08-10 13:56:57.000000'),
(4, NULL, 'Alimentos y Bebidas', 'alimentos-y-bebidas', 'Empresas dedicadas a la preparación, venta y comercialización de alimentos y bebidas.', 1, '2026-08-19 12:47:39.217617', '2026-08-19 12:47:39.217617'),
(5, NULL, 'Comercio', 'comercio', 'Comercios dedicados a la venta de productos diversos.', 1, '2026-08-19 12:47:39.217617', '2026-08-19 12:47:39.217617'),
(6, NULL, 'Moda y Accesorios', 'moda-y-accesorios', 'Empresas dedicadas a la comercialización de ropa, calzado, joyería y accesorios.', 1, '2026-08-19 12:47:39.217617', '2026-08-19 12:47:39.217617'),
(7, NULL, 'Hogar y Construcción', 'hogar-y-construccion', 'Empresas relacionadas con construcción, ferretería, pinturas, muebles y productos para el hogar.', 1, '2026-08-19 12:47:39.217617', '2026-08-19 12:47:39.217617'),
(8, NULL, 'Tecnología y Electrónica', 'tecnologia-y-electronica', 'Empresas relacionadas con tecnología, electrónica, informática y servicios audiovisuales.', 1, '2026-08-19 12:47:39.217617', '2026-08-19 12:47:39.217617'),
(9, NULL, 'Automotriz', 'automotriz', 'Empresas relacionadas con vehículos, motocicletas, refacciones, llantas y servicios automotrices.', 1, '2026-08-19 12:47:39.217617', '2026-08-19 12:47:39.217617'),
(10, NULL, 'Salud', 'salud', 'Servicios relacionados con atención médica, odontológica, laboratorios y ópticas.', 1, '2026-08-19 12:47:39.217617', '2026-08-19 12:47:39.217617'),
(11, NULL, 'Veterinaria y Mascotas', 'veterinaria-y-mascotas', 'Servicios veterinarios y especializados para mascotas.', 1, '2026-08-19 12:47:39.217617', '2026-08-19 12:47:39.217617'),
(12, NULL, 'Belleza y Cuidado Personal', 'belleza-y-cuidado-personal', 'Servicios relacionados con belleza, estética y cuidado personal.', 1, '2026-08-19 12:47:39.217617', '2026-08-19 12:47:39.217617'),
(13, NULL, 'Servicios Profesionales', 'servicios-profesionales', 'Empresas dedicadas a servicios profesionales, consultoría, capacitación, seguridad y otros servicios especializados.', 1, '2026-08-19 12:47:39.217617', '2026-08-19 12:47:39.217617'),
(14, NULL, 'Turismo y Hospedaje', 'turismo-y-hospedaje', 'Empresas relacionadas con turismo, hospedaje y agencias de viajes.', 1, '2026-08-19 12:47:39.217617', '2026-08-19 12:47:39.217617'),
(15, NULL, 'Eventos', 'eventos', 'Empresas dedicadas a la organización y atención de eventos.', 1, '2026-08-19 12:47:39.217617', '2026-08-19 12:47:39.217617'),
(16, NULL, 'Servicios Funerarios', 'servicios-funerarios', 'Empresas dedicadas a servicios funerarios.', 1, '2026-08-19 12:47:39.217617', '2026-08-19 12:47:39.217617'),
(17, 4, 'Restaurantes', 'restaurantes', 'Restaurantes y establecimientos dedicados a la preparación de alimentos.', 1, '2026-08-19 12:47:39.232508', '2026-08-19 12:47:39.232508'),
(18, 4, 'Cafeterías', 'cafeterias', 'Cafeterías y establecimientos especializados en café y bebidas.', 1, '2026-08-19 12:47:39.234519', '2026-08-19 12:47:39.234519'),
(19, 4, 'Panaderías y Pastelerías', 'panaderias-y-pastelerias', 'Panaderías, pastelerías y negocios dedicados a la elaboración de productos de panificación.', 1, '2026-08-19 12:47:39.235511', '2026-08-19 12:47:39.235511'),
(20, 4, 'Comida rápida', 'comida-rapida', 'Establecimientos especializados en alimentos preparados y comida rápida.', 1, '2026-08-19 12:47:39.236574', '2026-08-19 12:47:39.236574'),
(21, 4, 'Taquerías', 'taquerias', 'Establecimientos especializados en tacos y comida mexicana.', 1, '2026-08-19 12:47:39.237630', '2026-08-19 12:47:39.237630'),
(22, 4, 'Torterías', 'torterias', 'Establecimientos especializados en tortas.', 1, '2026-08-19 12:47:39.238693', '2026-08-19 12:47:39.238693'),
(23, 4, 'Pizzerías', 'pizzerias', 'Establecimientos especializados en pizzas.', 1, '2026-08-19 12:47:39.239774', '2026-08-19 12:47:39.239774'),
(24, 4, 'Rosticerías', 'rosticerias', 'Negocios dedicados a la venta de pollo rostizado y comida para llevar.', 1, '2026-08-19 12:47:39.240937', '2026-08-19 12:47:39.240937'),
(25, 4, 'Jugos y Bebidas', 'jugos-y-bebidas', 'Negocios especializados en jugos naturales, bebidas y productos similares.', 1, '2026-08-19 12:47:39.242049', '2026-08-19 12:47:39.242049'),
(26, 4, 'Vinos y Licores', 'vinos-y-licores', 'Comercios dedicados a la venta de vinos y licores.', 1, '2026-08-19 12:47:39.243309', '2026-08-19 12:47:39.243309'),
(27, 4, 'Materias Primas para Alimentos', 'materias-primas-para-alimentos', 'Venta de materias primas para panadería, pastelería y elaboración de alimentos.', 1, '2026-08-19 12:47:39.244363', '2026-08-19 12:47:39.244363'),
(28, 5, 'Papelerías', 'papelerias', 'Comercios dedicados a papelería, útiles y artículos escolares.', 1, '2026-08-19 12:47:39.245256', '2026-08-19 12:47:39.245256'),
(29, 5, 'Librerías', 'librerias', 'Comercios dedicados a la venta de libros y material editorial.', 1, '2026-08-19 12:47:39.246464', '2026-08-19 12:47:39.246464'),
(30, 5, 'Jugueterías', 'jugueterias', 'Comercios dedicados a la venta de juguetes.', 1, '2026-08-19 12:47:39.247581', '2026-08-19 12:47:39.247581'),
(31, 5, 'Regalos y Artículos Diversos', 'regalos-y-articulos-diversos', 'Venta de regalos, artículos para fiestas, temporadas y productos diversos.', 1, '2026-08-19 12:47:39.248614', '2026-08-19 12:47:39.248614'),
(32, 5, 'Línea del Hogar', 'linea-del-hogar', 'Comercios de artículos y productos para el hogar.', 1, '2026-08-19 12:47:39.249611', '2026-08-19 12:47:39.249611'),
(33, 6, 'Ropa', 'ropa', 'Comercios dedicados a la venta de prendas de vestir.', 1, '2026-08-19 12:47:39.250665', '2026-08-19 12:47:39.250665'),
(34, 6, 'Lencería', 'lenceria', 'Comercios especializados en lencería y ropa interior.', 1, '2026-08-19 12:47:39.251761', '2026-08-19 12:47:39.251761'),
(35, 6, 'Uniformes', 'uniformes', 'Venta y elaboración de uniformes escolares y deportivos.', 1, '2026-08-19 12:47:39.252816', '2026-08-19 12:47:39.252816'),
(36, 6, 'Accesorios Textiles', 'accesorios-textiles', 'Venta de accesorios y productos relacionados con el sector textil.', 1, '2026-08-19 12:47:39.253737', '2026-08-19 12:47:39.253737'),
(37, 6, 'Zapaterías', 'zapaterias', 'Comercios dedicados a la venta de calzado.', 1, '2026-08-19 12:47:39.254797', '2026-08-19 12:47:39.254797'),
(38, 6, 'Joyerías', 'joyerias', 'Comercios y talleres dedicados a joyería y relojería.', 1, '2026-08-19 12:47:39.255780', '2026-08-19 12:47:39.255780'),
(39, 6, 'Bisutería', 'bisuteria', 'Comercios dedicados a bisutería y accesorios.', 1, '2026-08-19 12:47:39.256846', '2026-08-19 12:47:39.256846'),
(40, 6, 'Perfumerías', 'perfumerias', 'Comercios dedicados a perfumes y productos de cuidado personal.', 1, '2026-08-19 12:47:39.257917', '2026-08-19 12:47:39.257917'),
(41, 7, 'Ferreterías', 'ferreterias', 'Comercios de herramientas, materiales y artículos de ferretería.', 1, '2026-08-19 12:47:39.258957', '2026-08-19 12:47:39.258957'),
(42, 7, 'Materiales de Construcción', 'materiales-de-construccion', 'Venta de materiales y productos para construcción.', 1, '2026-08-19 12:47:39.260031', '2026-08-19 12:47:39.260031'),
(43, 7, 'Pinturas e Impermeabilizantes', 'pinturas-e-impermeabilizantes', 'Venta de pinturas, impermeabilizantes y productos decorativos o industriales.', 1, '2026-08-19 12:47:39.261063', '2026-08-19 12:47:39.261063'),
(44, 7, 'Muebles y Colchones', 'muebles-y-colchones', 'Comercios dedicados a muebles, colchones y artículos para el hogar.', 1, '2026-08-19 12:47:39.262057', '2026-08-19 12:47:39.262057'),
(45, 7, 'Línea Blanca', 'linea-blanca', 'Comercio de electrodomésticos y productos de línea blanca.', 1, '2026-08-19 12:47:39.263338', '2026-08-19 12:47:39.263338'),
(46, 7, 'Paneles Solares', 'paneles-solares', 'Empresas dedicadas a la comercialización e instalación de paneles solares.', 1, '2026-08-19 12:47:39.264404', '2026-08-19 12:47:39.264404'),
(47, 8, 'Equipo de Cómputo', 'equipo-de-computo', 'Venta y comercialización de computadoras y equipo informático.', 1, '2026-08-19 12:47:39.265585', '2026-08-19 12:47:39.265585'),
(49, 8, 'Desarrollo de Sistemas', 'desarrollo-de-sistemas', 'Desarrollo de software, sistemas y servicios informáticos.', 1, '2026-08-19 12:47:39.267937', '2026-08-19 12:47:39.267937'),
(50, 8, 'Servicios Audiovisuales', 'servicios-audiovisuales', 'Servicios relacionados con producción y soluciones audiovisuales.', 1, '2026-08-19 12:47:39.269000', '2026-08-19 12:47:39.269000'),
(51, 9, 'Refaccionarias', 'refaccionarias', 'Comercios dedicados a la venta de refacciones automotrices.', 1, '2026-08-19 12:47:39.270003', '2026-08-19 12:47:39.270003'),
(52, 9, 'Llantas', 'llantas', 'Venta de llantas y productos relacionados.', 1, '2026-08-19 12:47:39.271262', '2026-08-19 12:47:39.271262'),
(53, 9, 'Motocicletas', 'motocicletas', 'Venta y servicios relacionados con motocicletas.', 1, '2026-08-19 12:47:39.272383', '2026-08-19 12:47:39.272383'),
(54, 9, 'Autolavados', 'autolavados', 'Servicios profesionales de limpieza de vehículos.', 1, '2026-08-19 12:47:39.273424', '2026-08-19 12:47:39.273424'),
(55, 10, 'Clínicas Dentales', 'clinicas-dentales', 'Clínicas y consultorios especializados en atención dental.', 1, '2026-08-19 12:47:39.274501', '2026-08-19 12:47:39.274501'),
(56, 10, 'Laboratorios Clínicos', 'laboratorios-clinicos', 'Laboratorios dedicados a análisis clínicos.', 1, '2026-08-19 12:47:39.275591', '2026-08-19 12:47:39.275591'),
(57, 10, 'Hospitales', 'hospitales', 'Hospitales y establecimientos de atención médica.', 1, '2026-08-19 12:47:39.276651', '2026-08-19 12:47:39.276651'),
(58, 10, 'Clínicas de Maternidad', 'clinicas-de-maternidad', 'Clínicas especializadas en atención materno-infantil.', 1, '2026-08-19 12:47:39.277714', '2026-08-19 12:47:39.277714'),
(59, 10, 'Ópticas', 'opticas', 'Comercios y servicios relacionados con lentes y productos ópticos.', 1, '2026-08-19 12:47:39.278990', '2026-08-19 12:47:39.278990'),
(60, 11, 'Clínicas Veterinarias', 'clinicas-veterinarias', 'Clínicas y servicios de atención veterinaria.', 1, '2026-08-19 12:47:39.280172', '2026-08-19 12:47:39.280172'),
(61, 11, 'Imagenología Veterinaria', 'imagenologia-veterinaria', 'Servicios especializados de imagenología veterinaria.', 1, '2026-08-19 12:47:39.281292', '2026-08-19 12:47:39.281292'),
(62, 12, 'Estéticas y Salas de Belleza', 'esteticas-y-salas-de-belleza', 'Servicios de estética, peluquería y cuidado personal.', 1, '2026-08-19 12:47:39.282375', '2026-08-19 12:47:39.282375'),
(63, 12, 'Spa y Cosmetología', 'spa-y-cosmetologia', 'Servicios de spa, cosmetología y cuidado corporal.', 1, '2026-08-19 12:47:39.283508', '2026-08-19 12:47:39.283508'),
(64, 13, 'Consultoría y Capacitación', 'consultoria-y-capacitacion', 'Servicios de consultoría, capacitación, cursos y desarrollo profesional.', 1, '2026-08-19 12:47:39.284678', '2026-08-19 12:47:39.284678'),
(65, 13, 'Cursos de Inglés', 'cursos-de-ingles', 'Servicios educativos especializados en enseñanza del idioma inglés.', 1, '2026-08-19 12:47:39.285802', '2026-08-19 12:47:39.285802');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `configuraciones_sistema`
--

CREATE TABLE `configuraciones_sistema` (
  `clave` varchar(100) NOT NULL,
  `valor` text DEFAULT NULL,
  `tipo_dato` varchar(20) NOT NULL,
  `descripcion` varchar(500) DEFAULT NULL,
  `idUsuarioActualizador` bigint(20) UNSIGNED DEFAULT NULL,
  `actualizado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `configuraciones_sistema`
--

INSERT INTO `configuraciones_sistema` (`clave`, `valor`, `tipo_dato`, `descripcion`, `idUsuarioActualizador`, `actualizado_at`) VALUES
('max_imagenes_galeria_afiliado', '10', 'INTEGER', 'Valor propuesto y configurable; requiere validación final', NULL, '2026-08-06 21:03:07.168874'),
('max_imagenes_promocion', '5', 'INTEGER', 'Máximo permitido por los requerimientos', NULL, '2026-08-06 21:03:07.168874'),
('max_palabras_clave_afiliado', '10', 'INTEGER', 'Máximo permitido por los requerimientos', NULL, '2026-08-06 21:03:07.168874'),
('max_peso_imagen_bytes', '2097152', 'INTEGER', 'Valor recomendado de 2 MB por imagen', NULL, '2026-08-06 21:03:07.168874'),
('publicacion_promociones_requiere_autorizacion', 'false', 'BOOLEAN', 'Decisión confirmada: las promociones se publican directamente', NULL, '2026-08-06 21:03:07.168874'),
('recuperacion_password_habilitada', 'true', 'BOOLEAN', 'Decisión confirmada: sí habrá recuperación de contraseña', NULL, '2026-08-06 21:03:07.168874');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contactos_afiliados`
--

CREATE TABLE `contactos_afiliados` (
  `idContactoAfiliado` bigint(20) UNSIGNED NOT NULL,
  `idAfiliado` bigint(20) UNSIGNED NOT NULL,
  `nombre` varchar(160) NOT NULL,
  `cargo` varchar(100) DEFAULT NULL,
  `correo` varchar(254) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `es_principal` tinyint(1) NOT NULL DEFAULT 0,
  `es_publico` tinyint(1) NOT NULL DEFAULT 0,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `actualizado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Contactos administrativos o públicos de una empresa';

--
-- Volcado de datos para la tabla `contactos_afiliados`
--

INSERT INTO `contactos_afiliados` (`idContactoAfiliado`, `idAfiliado`, `nombre`, `cargo`, `correo`, `telefono`, `es_principal`, `es_publico`, `activo`, `creado_at`, `actualizado_at`) VALUES
(1, 3, 'Robert', 'Jefe', 'herrerabeto501@gmail.com', '2741119206', 1, 0, 1, '2026-08-10 19:58:41.609692', '2026-08-10 19:58:41.609692'),
(2, 5, 'Jose Rodrigo', 'Jefe', 'ejemplo@gmail.com', '312763981239', 1, 0, 1, '2026-08-18 22:50:22.305409', '2026-08-18 22:50:22.305409'),
(3, 6, 'Roberto C. Herrera Ceron', NULL, 'ejemplo@gmail.com', '2727248053', 1, 0, 1, '2026-08-19 18:39:22.809292', '2026-08-19 18:39:22.809292'),
(4, 7, 'Enrique Antonio Rivas Corona', NULL, 'ejemplo@gmail.com', '2721349864', 1, 0, 1, '2026-08-19 18:58:22.588516', '2026-08-19 18:58:22.588516'),
(5, 8, 'Mtra. Teresa Isabel Mancilla Segura', NULL, 'ejemplo@gmail.com', '2721565617', 1, 0, 1, '2026-08-19 19:02:47.239115', '2026-08-19 19:02:47.239115'),
(6, 9, 'Veronica Alducin Dector', NULL, 'ejemplo@gmail.com', '272370355152', 1, 0, 1, '2026-08-19 19:13:33.213811', '2026-08-19 19:13:33.213811');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estadisticas_diarias_afiliados`
--

CREATE TABLE `estadisticas_diarias_afiliados` (
  `fecha` date NOT NULL,
  `idAfiliado` bigint(20) UNSIGNED NOT NULL,
  `apariciones_busqueda` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `visitas_ficha` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `clics_telefono` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `clics_whatsapp` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `clics_web` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `clics_redes` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `clics_mapa` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `visitas_promociones` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `actualizado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Resumen derivado para acelerar dashboards y reportes';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estados`
--

CREATE TABLE `estados` (
  `idEstado` smallint(5) UNSIGNED NOT NULL,
  `clave_inegi` char(2) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `actualizado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Estados de la República Mexicana';

--
-- Volcado de datos para la tabla `estados`
--

INSERT INTO `estados` (`idEstado`, `clave_inegi`, `nombre`, `activo`, `creado_at`, `actualizado_at`) VALUES
(30, '30', 'Veracruz de Ignacio de la Llave', 1, '2026-08-06 21:03:07.104691', '2026-08-06 21:03:07.104691');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `importaciones_empresas_staging`
--

CREATE TABLE `importaciones_empresas_staging` (
  `idImportacionEmpresaStaging` bigint(20) UNSIGNED NOT NULL,
  `idImportacionLote` bigint(20) UNSIGNED NOT NULL,
  `hoja_origen` varchar(100) DEFAULT NULL,
  `numero_fila` int(10) UNSIGNED NOT NULL,
  `numero_original` varchar(50) DEFAULT NULL,
  `empresa_original` text DEFAULT NULL,
  `rfc_original` text DEFAULT NULL,
  `encargado_original` text DEFAULT NULL,
  `direccion_original` text DEFAULT NULL,
  `promocion_original` text DEFAULT NULL,
  `telefono_original` text DEFAULT NULL,
  `whatsapp_original` text DEFAULT NULL,
  `facebook_original` text DEFAULT NULL,
  `instagram_original` text DEFAULT NULL,
  `pagina_web_original` text DEFAULT NULL,
  `logotipo_original` text DEFAULT NULL,
  `giro_original` text DEFAULT NULL,
  `categorias_adicionales` text DEFAULT NULL,
  `datos_extra` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`datos_extra`)),
  `estado_validacion` varchar(20) NOT NULL DEFAULT 'PENDIENTE',
  `mensaje_error` text DEFAULT NULL,
  `idAfiliadoGenerado` bigint(20) UNSIGNED DEFAULT NULL,
  `idSucursalGenerada` bigint(20) UNSIGNED DEFAULT NULL,
  `procesado_at` datetime(6) DEFAULT NULL,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `importaciones_lotes`
--

CREATE TABLE `importaciones_lotes` (
  `idImportacionLote` bigint(20) UNSIGNED NOT NULL,
  `nombre_archivo` varchar(255) NOT NULL,
  `checksum_archivo` char(64) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `idUsuario` bigint(20) UNSIGNED DEFAULT NULL,
  `estado` varchar(20) NOT NULL DEFAULT 'CARGADO',
  `total_filas` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `filas_correctas` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `filas_error` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `actualizado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `indices_busquedas_afiliados`
--

CREATE TABLE `indices_busquedas_afiliados` (
  `idAfiliado` bigint(20) UNSIGNED NOT NULL,
  `nombre_alias` text NOT NULL,
  `categorias` text DEFAULT NULL,
  `palabras_clave` text DEFAULT NULL,
  `promociones_vigentes` text DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `actualizado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Modelo de lectura desnormalizado para el buscador avanzado';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `interacciones_afiliados`
--

CREATE TABLE `interacciones_afiliados` (
  `idInteraccionAfiliado` bigint(20) UNSIGNED NOT NULL,
  `idSesionVisitante` bigint(20) UNSIGNED DEFAULT NULL,
  `idBusqueda` bigint(20) UNSIGNED DEFAULT NULL,
  `idAfiliado` bigint(20) UNSIGNED NOT NULL,
  `idSucursal` bigint(20) UNSIGNED DEFAULT NULL,
  `idPromocion` bigint(20) UNSIGNED DEFAULT NULL,
  `idCanalDigital` bigint(20) UNSIGNED DEFAULT NULL,
  `tipo` varchar(40) NOT NULL,
  `ocurrido_at` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `interacciones_afiliados`
--
DELIMITER $$
CREATE TRIGGER `trg_interaccion_bi` BEFORE INSERT ON `interacciones_afiliados` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_interaccion_bu` BEFORE UPDATE ON `interacciones_afiliados` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `items_seccion_portada`
--

CREATE TABLE `items_seccion_portada` (
  `idItemSeccionPortada` bigint(20) UNSIGNED NOT NULL,
  `idSeccionPortada` bigint(20) UNSIGNED NOT NULL,
  `titulo` varchar(200) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `idArchivo` bigint(20) UNSIGNED DEFAULT NULL,
  `texto_boton` varchar(100) DEFAULT NULL,
  `url_boton` varchar(700) DEFAULT NULL,
  `orden` smallint(5) UNSIGNED NOT NULL DEFAULT 1,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `actualizado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Elementos contenidos dentro de una sección de portada';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `localidades`
--

CREATE TABLE `localidades` (
  `idLocalidad` bigint(20) UNSIGNED NOT NULL,
  `idMunicipio` bigint(20) UNSIGNED NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `tipo` varchar(40) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `actualizado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Localidades pertenecientes a un municipio';

--
-- Volcado de datos para la tabla `localidades`
--

INSERT INTO `localidades` (`idLocalidad`, `idMunicipio`, `nombre`, `tipo`, `activo`, `creado_at`, `actualizado_at`) VALUES
(1, 2, 'Xalapa-Enríquez', 'Urbana', 1, '2026-08-10 13:52:05.000000', '2026-08-10 13:52:05.000000'),
(2, 2, 'El Castillo', 'Rural', 1, '2026-08-10 13:52:05.000000', '2026-08-10 13:52:05.000000'),
(3, 3, 'Veracruz', 'Urbana', 1, '2026-08-10 13:52:05.000000', '2026-08-10 13:52:05.000000'),
(4, 3, 'Delfino Victoria (Santa Fe)', 'Rural', 1, '2026-08-10 13:52:05.000000', '2026-08-10 13:52:05.000000'),
(5, 4, 'Coatzacoalcos', 'Urbana', 1, '2026-08-10 13:52:05.000000', '2026-08-10 13:52:05.000000'),
(6, 4, 'Allende', 'Urbana', 1, '2026-08-10 13:52:05.000000', '2026-08-10 13:52:05.000000'),
(7, 5, 'Orizaba', 'Urbana', 1, '2026-08-19 12:33:42.491864', '2026-08-19 12:33:42.491864'),
(8, 5, 'Agrícola Librado Rivera', 'Rural', 1, '2026-08-19 12:33:42.491864', '2026-08-19 12:33:42.491864'),
(9, 5, 'Cerritos', 'Rural', 1, '2026-08-19 12:33:42.491864', '2026-08-19 12:33:42.491864'),
(10, 5, 'San Antonio Jalapilla', 'Rural', 1, '2026-08-19 12:33:42.491864', '2026-08-19 12:33:42.491864'),
(11, 5, 'Potrerillo', 'Rural', 1, '2026-08-19 12:33:42.491864', '2026-08-19 12:33:42.491864');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `municipios`
--

CREATE TABLE `municipios` (
  `idMunicipio` bigint(20) UNSIGNED NOT NULL,
  `idEstado` smallint(5) UNSIGNED NOT NULL,
  `clave_inegi` varchar(5) DEFAULT NULL,
  `nombre` varchar(120) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `actualizado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Municipios por estado';

--
-- Volcado de datos para la tabla `municipios`
--

INSERT INTO `municipios` (`idMunicipio`, `idEstado`, `clave_inegi`, `nombre`, `activo`, `creado_at`, `actualizado_at`) VALUES
(1, 30, '002', 'Cárdenas', 1, '2026-08-07 07:43:07.944448', '2026-08-07 07:43:07.944448'),
(2, 30, '087', 'Xalapa', 1, '2026-08-10 13:51:49.000000', '2026-08-10 13:51:49.000000'),
(3, 30, '193', 'Veracruz', 1, '2026-08-10 13:51:49.000000', '2026-08-10 13:51:49.000000'),
(4, 30, '039', 'Coatzacoalcos', 1, '2026-08-10 13:51:49.000000', '2026-08-10 13:51:49.000000'),
(5, 30, '118', 'Orizaba', 1, '2026-08-19 12:30:07.523515', '2026-08-19 12:30:07.523515');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `municipios_adyacencias`
--

CREATE TABLE `municipios_adyacencias` (
  `idMunicipioA` bigint(20) UNSIGNED NOT NULL,
  `idMunicipioB` bigint(20) UNSIGNED NOT NULL,
  `distancia_km` decimal(8,2) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificaciones`
--

CREATE TABLE `notificaciones` (
  `idNotificacion` bigint(20) UNSIGNED NOT NULL,
  `idUsuarioDestino` bigint(20) UNSIGNED NOT NULL,
  `idPromocion` bigint(20) UNSIGNED DEFAULT NULL,
  `tipo_evento` varchar(60) NOT NULL,
  `asunto` varchar(200) NOT NULL,
  `mensaje` text NOT NULL,
  `estado_envio` varchar(20) NOT NULL DEFAULT 'PENDIENTE',
  `intentos` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `ultimo_error` text DEFAULT NULL,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `enviado_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos`
--

CREATE TABLE `permisos` (
  `idPermiso` bigint(20) UNSIGNED NOT NULL,
  `clave` varchar(100) NOT NULL,
  `modulo` varchar(60) NOT NULL,
  `accion` varchar(60) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Permisos atómicos utilizados por el sistema';

--
-- Volcado de datos para la tabla `permisos`
--

INSERT INTO `permisos` (`idPermiso`, `clave`, `modulo`, `accion`, `descripcion`, `activo`, `creado_at`) VALUES
(1, 'usuarios.ver', 'usuarios', 'ver', 'Consultar usuarios', 1, '2026-08-06 21:03:07.147946'),
(2, 'usuarios.crear', 'usuarios', 'crear', 'Registrar usuarios', 1, '2026-08-06 21:03:07.147946'),
(3, 'usuarios.editar', 'usuarios', 'editar', 'Modificar usuarios', 1, '2026-08-06 21:03:07.147946'),
(4, 'usuarios.activar', 'usuarios', 'activar', 'Activar o desactivar usuarios', 1, '2026-08-06 21:03:07.147946'),
(5, 'camaras.gestionar', 'camaras', 'gestionar', 'Administrar cámaras y circunscripciones', 1, '2026-08-06 21:03:07.147946'),
(6, 'afiliados.ver', 'afiliados', 'ver', 'Consultar afiliados', 1, '2026-08-06 21:03:07.147946'),
(7, 'afiliados.crear', 'afiliados', 'crear', 'Registrar afiliados', 1, '2026-08-06 21:03:07.147946'),
(8, 'afiliados.editar', 'afiliados', 'editar', 'Modificar afiliados autorizados', 1, '2026-08-06 21:03:07.147946'),
(9, 'afiliados.activar', 'afiliados', 'activar', 'Activar o desactivar afiliados', 1, '2026-08-06 21:03:07.147946'),
(10, 'sucursales.gestionar', 'sucursales', 'gestionar', 'Administrar sucursales', 1, '2026-08-06 21:03:07.147946'),
(11, 'categorias.gestionar', 'categorias', 'gestionar', 'Administrar categorías comerciales', 1, '2026-08-06 21:03:07.147946'),
(12, 'promociones.ver', 'promociones', 'ver', 'Consultar promociones', 1, '2026-08-06 21:03:07.147946'),
(13, 'promociones.crear', 'promociones', 'crear', 'Registrar promociones', 1, '2026-08-06 21:03:07.147946'),
(14, 'promociones.editar', 'promociones', 'editar', 'Modificar promociones autorizadas', 1, '2026-08-06 21:03:07.147946'),
(15, 'promociones.activar', 'promociones', 'activar', 'Activar o desactivar promociones', 1, '2026-08-06 21:03:07.147946'),
(16, 'reportes.ver', 'reportes', 'ver', 'Consultar reportes', 1, '2026-08-06 21:03:07.147946'),
(17, 'reportes.exportar', 'reportes', 'exportar', 'Exportar reportes a PDF o Excel', 1, '2026-08-06 21:03:07.147946'),
(18, 'estadisticas.ver', 'estadisticas', 'ver', 'Consultar estadísticas', 1, '2026-08-06 21:03:07.147946'),
(19, 'sitio.configurar', 'sitio', 'configurar', 'Administrar contenido del sitio público', 1, '2026-08-06 21:03:07.147946'),
(20, 'buscador.configurar', 'buscador', 'configurar', 'Administrar parámetros del buscador', 1, '2026-08-06 21:03:07.147946');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `promociones`
--

CREATE TABLE `promociones` (
  `idPromocion` bigint(20) UNSIGNED NOT NULL,
  `idAfiliado` bigint(20) UNSIGNED NOT NULL,
  `titulo` varchar(180) NOT NULL,
  `descripcion` text NOT NULL,
  `restricciones` text DEFAULT NULL,
  `inicio_vigencia` datetime(6) NOT NULL,
  `fin_vigencia` datetime(6) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `idUsuarioCreador` bigint(20) UNSIGNED DEFAULT NULL,
  `idUsuarioActualizador` bigint(20) UNSIGNED DEFAULT NULL,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `actualizado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `desactivado_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `promociones`
--

INSERT INTO `promociones` (`idPromocion`, `idAfiliado`, `titulo`, `descripcion`, `restricciones`, `inicio_vigencia`, `fin_vigencia`, `activo`, `idUsuarioCreador`, `idUsuarioActualizador`, `creado_at`, `actualizado_at`, `desactivado_at`) VALUES
(2, 3, 'Promocion de calzado', 'puedes llevarte lo que quieras a un 30% de descuento...', 'Solo con pagos de mas de 5000 pesos', '2026-08-15 05:00:00.000000', '2026-08-31 20:00:00.000000', 0, NULL, NULL, '2026-08-12 21:37:52.378074', '2026-08-18 23:20:46.419870', '2026-08-18 23:20:46.000000'),
(3, 5, 'Promocion de calzado', 'Calzado al 20% de descuento', NULL, '2026-07-18 07:00:00.000000', '2026-09-29 20:00:00.000000', 0, NULL, NULL, '2026-08-18 22:52:07.893774', '2026-08-19 18:50:55.303112', '2026-08-19 18:50:55.000000'),
(4, 3, 'Promocion de frutas y verduras', 'Frutas y verduras 35% de descuento', NULL, '2026-08-01 16:53:00.000000', '2026-10-29 16:53:00.000000', 0, NULL, NULL, '2026-08-18 22:53:25.947194', '2026-08-19 18:50:57.406194', '2026-08-19 18:50:57.000000'),
(5, 5, 'Promocion 2x1', 'Llevate 2 pares de tenis por el precio de 1', NULL, '2026-07-16 16:54:00.000000', '2026-08-31 16:54:00.000000', 0, NULL, NULL, '2026-08-18 22:54:48.437905', '2026-08-19 18:50:52.277363', '2026-08-19 18:50:52.000000'),
(6, 6, 'Descuento en nuestros servicios', '15% de descuento en instalaciones, traducciones y migración de sistemas Aspel', NULL, '2026-08-11 12:53:00.000000', '2026-09-05 12:53:00.000000', 1, NULL, NULL, '2026-08-19 18:53:15.734537', '2026-08-19 18:53:15.734537', NULL),
(7, 7, 'Descuento en algunas de nuestras presentaciones', '10% de descuento en las presentaciones de 250 y 500 gramos de café orgánico; 10% de descuento en derivados del café: galleta, bombon y miel de café', NULL, '2026-08-01 13:15:00.000000', '2026-09-05 13:15:00.000000', 0, NULL, NULL, '2026-08-19 19:15:37.673915', '2026-08-19 19:23:11.084486', '2026-08-19 19:23:11.000000'),
(8, 8, 'Promoción en consultoria y mas...', '20% En consultoría.\r\n10% En procesos de alineación, evaluación y certificación en estándares de competencia ante CONOCER.\r\n10% En cursos de capacitación del capital humano.', 'No aplica con promociones vigentes.', '2026-08-04 13:18:00.000000', '2026-09-05 13:18:00.000000', 1, NULL, NULL, '2026-08-19 19:18:43.191835', '2026-08-19 19:18:43.191835', NULL),
(9, 9, 'Promoción en analisis', '5% en todos los analisis de laboratorio', NULL, '2026-08-15 13:22:00.000000', '2026-09-05 13:22:00.000000', 1, NULL, NULL, '2026-08-19 19:22:29.799486', '2026-08-19 19:22:29.799486', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `promociones_archivos`
--

CREATE TABLE `promociones_archivos` (
  `idPromocion` bigint(20) UNSIGNED NOT NULL,
  `idArchivo` bigint(20) UNSIGNED NOT NULL,
  `orden` smallint(5) UNSIGNED NOT NULL DEFAULT 1,
  `texto_alternativo` varchar(255) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Máximo cinco imágenes activas por promoción';

--
-- Volcado de datos para la tabla `promociones_archivos`
--

INSERT INTO `promociones_archivos` (`idPromocion`, `idArchivo`, `orden`, `texto_alternativo`, `activo`, `creado_at`) VALUES
(2, 3, 1, 'Imagen de promoción', 1, '2026-08-12 21:37:52.392529'),
(3, 5, 1, 'Imagen de promoción', 1, '2026-08-18 22:52:07.899798'),
(4, 6, 1, 'Imagen de promoción', 1, '2026-08-18 22:53:25.953998'),
(5, 7, 1, 'Imagen de promoción', 1, '2026-08-18 22:54:48.443476'),
(6, 9, 1, 'Imagen de promoción', 1, '2026-08-19 18:53:15.740684'),
(7, 13, 1, 'Imagen de promoción', 1, '2026-08-19 19:15:37.679921'),
(8, 14, 1, 'Imagen de promoción', 1, '2026-08-19 19:18:43.261855'),
(9, 15, 1, 'Imagen de promoción', 1, '2026-08-19 19:22:29.809337');

--
-- Disparadores `promociones_archivos`
--
DELIMITER $$
CREATE TRIGGER `trg_promocion_archivo_bi` BEFORE INSERT ON `promociones_archivos` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_promocion_archivo_bu` BEFORE UPDATE ON `promociones_archivos` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `idRol` smallint(5) UNSIGNED NOT NULL,
  `clave` varchar(40) NOT NULL,
  `nombre` varchar(80) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Roles de acceso del panel administrativo';

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`idRol`, `clave`, `nombre`, `descripcion`, `activo`, `creado_at`) VALUES
(1, 'ADMIN_GENERAL', 'Administrador General', 'Acceso total a la plataforma', 1, '2026-08-06 21:03:07.141387'),
(2, 'ADMIN_CAMARA', 'Administrador de Cámara', 'Administra los afiliados de su cámara', 1, '2026-08-06 21:03:07.141387'),
(3, 'AFILIADO', 'Afiliado', 'Administra únicamente la información de su empresa', 1, '2026-08-06 21:03:07.141387');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles_permisos`
--

CREATE TABLE `roles_permisos` (
  `idRol` smallint(5) UNSIGNED NOT NULL,
  `idPermiso` bigint(20) UNSIGNED NOT NULL,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Permisos asignados a cada rol';

--
-- Volcado de datos para la tabla `roles_permisos`
--

INSERT INTO `roles_permisos` (`idRol`, `idPermiso`, `creado_at`) VALUES
(1, 1, '2026-08-06 21:03:07.157855'),
(1, 2, '2026-08-06 21:03:07.157855'),
(1, 3, '2026-08-06 21:03:07.157855'),
(1, 4, '2026-08-06 21:03:07.157855'),
(1, 5, '2026-08-06 21:03:07.157855'),
(1, 6, '2026-08-06 21:03:07.157855'),
(1, 7, '2026-08-06 21:03:07.157855'),
(1, 8, '2026-08-06 21:03:07.157855'),
(1, 9, '2026-08-06 21:03:07.157855'),
(1, 10, '2026-08-06 21:03:07.157855'),
(1, 11, '2026-08-06 21:03:07.157855'),
(1, 12, '2026-08-06 21:03:07.157855'),
(1, 13, '2026-08-06 21:03:07.157855'),
(1, 14, '2026-08-06 21:03:07.157855'),
(1, 15, '2026-08-06 21:03:07.157855'),
(1, 16, '2026-08-06 21:03:07.157855'),
(1, 17, '2026-08-06 21:03:07.157855'),
(1, 18, '2026-08-06 21:03:07.157855'),
(1, 19, '2026-08-06 21:03:07.157855'),
(1, 20, '2026-08-06 21:03:07.157855'),
(2, 6, '2026-08-06 21:03:07.161493'),
(2, 7, '2026-08-06 21:03:07.161493'),
(2, 8, '2026-08-06 21:03:07.161493'),
(2, 9, '2026-08-06 21:03:07.161493'),
(2, 10, '2026-08-06 21:03:07.161493'),
(2, 12, '2026-08-06 21:03:07.161493'),
(2, 13, '2026-08-06 21:03:07.161493'),
(2, 14, '2026-08-06 21:03:07.161493'),
(2, 15, '2026-08-06 21:03:07.161493'),
(2, 16, '2026-08-06 21:03:07.161493'),
(2, 17, '2026-08-06 21:03:07.161493'),
(2, 18, '2026-08-06 21:03:07.161493'),
(3, 6, '2026-08-06 21:03:07.166017'),
(3, 8, '2026-08-06 21:03:07.166017'),
(3, 10, '2026-08-06 21:03:07.166017'),
(3, 12, '2026-08-06 21:03:07.166017'),
(3, 13, '2026-08-06 21:03:07.166017'),
(3, 14, '2026-08-06 21:03:07.166017'),
(3, 15, '2026-08-06 21:03:07.166017'),
(3, 18, '2026-08-06 21:03:07.166017');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `secciones_portada`
--

CREATE TABLE `secciones_portada` (
  `idSeccionPortada` bigint(20) UNSIGNED NOT NULL,
  `codigo` varchar(60) NOT NULL,
  `tipo` varchar(50) NOT NULL,
  `titulo` varchar(200) DEFAULT NULL,
  `subtitulo` varchar(500) DEFAULT NULL,
  `orden` smallint(5) UNSIGNED NOT NULL DEFAULT 1,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `actualizado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Secciones configurables de la página de inicio';

--
-- Volcado de datos para la tabla `secciones_portada`
--

INSERT INTO `secciones_portada` (`idSeccionPortada`, `codigo`, `tipo`, `titulo`, `subtitulo`, `orden`, `activo`, `creado_at`, `actualizado_at`) VALUES
(1, 'PROMOCIONES_DESTACADAS', 'PROMOCIONES', 'Últimas Promociones', 'Descubre las mejores ofertas de nuestros afiliados', 1, 1, '2026-08-18 15:12:59.619419', '2026-08-18 15:12:59.619419'),
(2, 'EMPRESAS_DESTACADAS', 'AFILIADOS', 'Empresas Afiliadas', 'Conoce el directorio de empresas de la Cámara', 2, 1, '2026-08-18 15:12:59.619419', '2026-08-18 15:12:59.619419');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sesiones_visitantes`
--

CREATE TABLE `sesiones_visitantes` (
  `idSesionVisitante` bigint(20) UNSIGNED NOT NULL,
  `identificador_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `inicio_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `ultima_actividad_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `consentimiento_geolocalizacion` tinyint(1) NOT NULL DEFAULT 0,
  `ip_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `user_agent_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Sesiones anónimas del portal público sin almacenar IP completa';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sucursales`
--

CREATE TABLE `sucursales` (
  `idSucursal` bigint(20) UNSIGNED NOT NULL,
  `idAfiliado` bigint(20) UNSIGNED NOT NULL,
  `idLocalidad` bigint(20) UNSIGNED NOT NULL,
  `nombre` varchar(150) DEFAULT NULL,
  `es_matriz` tinyint(1) NOT NULL DEFAULT 0,
  `calle` varchar(160) NOT NULL,
  `numero_exterior` varchar(20) DEFAULT NULL,
  `numero_interior` varchar(20) DEFAULT NULL,
  `colonia` varchar(130) DEFAULT NULL,
  `codigo_postal` char(5) DEFAULT NULL,
  `referencias` varchar(500) DEFAULT NULL,
  `latitud` decimal(10,7) DEFAULT NULL,
  `longitud` decimal(10,7) DEFAULT NULL,
  `google_place_id` varchar(255) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `actualizado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `matriz_activa_unica` bigint(20) UNSIGNED GENERATED ALWAYS AS (case when `es_matriz` = 1 and `activo` = 1 then `idAfiliado` else NULL end) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sucursales`
--

INSERT INTO `sucursales` (`idSucursal`, `idAfiliado`, `idLocalidad`, `nombre`, `es_matriz`, `calle`, `numero_exterior`, `numero_interior`, `colonia`, `codigo_postal`, `referencias`, `latitud`, `longitud`, `google_place_id`, `activo`, `creado_at`, `actualizado_at`) VALUES
(1, 3, 4, NULL, 1, 'Calle 3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2026-08-10 19:58:41.610831', '2026-08-10 19:58:41.610831'),
(2, 5, 3, NULL, 1, 'Calle 7', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2026-08-18 22:50:22.306014', '2026-08-18 22:50:22.306014'),
(3, 6, 7, NULL, 1, 'Calle norte 22', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2026-08-19 18:39:22.810042', '2026-08-19 18:39:22.810042'),
(4, 7, 2, NULL, 1, 'Calle ejemplo', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2026-08-19 18:58:22.591866', '2026-08-19 19:07:44.634517'),
(5, 8, 7, NULL, 1, 'Calle sur 21', NULL, NULL, 'Centro', '94300', NULL, NULL, NULL, NULL, 1, '2026-08-19 19:02:47.239626', '2026-08-19 19:02:47.239626'),
(6, 9, 7, NULL, 1, 'Calle sur 16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2026-08-19 19:13:33.218149', '2026-08-19 19:13:33.218149');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sucursales_telefonos`
--

CREATE TABLE `sucursales_telefonos` (
  `idSucursalTelefono` bigint(20) UNSIGNED NOT NULL,
  `idSucursal` bigint(20) UNSIGNED NOT NULL,
  `tipo` varchar(20) NOT NULL,
  `numero_original` varchar(50) NOT NULL,
  `numero_normalizado` varchar(16) NOT NULL,
  `extension_telefono` varchar(10) DEFAULT NULL,
  `etiqueta` varchar(50) DEFAULT NULL,
  `es_principal` tinyint(1) NOT NULL DEFAULT 0,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `actualizado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sucursales_telefonos`
--

INSERT INTO `sucursales_telefonos` (`idSucursalTelefono`, `idSucursal`, `tipo`, `numero_original`, `numero_normalizado`, `extension_telefono`, `etiqueta`, `es_principal`, `activo`, `creado_at`, `actualizado_at`) VALUES
(1, 1, 'TELEFONO', '2741119206', '2741119206', NULL, NULL, 1, 1, '2026-08-10 19:58:41.612271', '2026-08-10 19:58:41.612271'),
(2, 1, 'WHATSAPP', '2741119206', '2741119206', NULL, NULL, 1, 1, '2026-08-10 19:58:41.613438', '2026-08-10 19:58:41.613438'),
(3, 2, 'TELEFONO', '312763981239', '312763981239', NULL, NULL, 1, 1, '2026-08-18 22:50:22.307287', '2026-08-18 22:50:22.307287'),
(4, 2, 'WHATSAPP', '312763981239', '312763981239', NULL, NULL, 1, 1, '2026-08-18 22:50:22.307920', '2026-08-18 22:50:22.307920'),
(5, 3, 'TELEFONO', '2727248053', '2727248053', NULL, NULL, 1, 1, '2026-08-19 18:39:22.811542', '2026-08-19 18:39:22.811542'),
(6, 3, 'WHATSAPP', '2721031480', '2721031480', NULL, NULL, 1, 1, '2026-08-19 18:39:22.812059', '2026-08-19 18:39:22.812059'),
(7, 4, 'TELEFONO', '2721349864', '2721349864', NULL, NULL, 1, 1, '2026-08-19 18:58:22.595557', '2026-08-19 18:58:22.595557'),
(8, 4, 'WHATSAPP', '2721349864', '2721349864', NULL, NULL, 1, 1, '2026-08-19 18:58:22.596230', '2026-08-19 18:58:22.596230'),
(9, 5, 'TELEFONO', '2721565617', '2721565617', NULL, NULL, 1, 1, '2026-08-19 19:02:47.240695', '2026-08-19 19:02:47.240695'),
(10, 5, 'WHATSAPP', '2721565617', '2721565617', NULL, NULL, 1, 1, '2026-08-19 19:02:47.241188', '2026-08-19 19:02:47.241188'),
(11, 6, 'TELEFONO', '272370355152', '272370355152', NULL, NULL, 1, 1, '2026-08-19 19:13:33.218710', '2026-08-19 19:13:33.218710'),
(12, 6, 'WHATSAPP', '2722365881', '2722365881', NULL, NULL, 1, 1, '2026-08-19 19:13:33.221219', '2026-08-19 19:13:33.221219');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tokens_recuperacion_password`
--

CREATE TABLE `tokens_recuperacion_password` (
  `idTokenRecuperacionPassword` bigint(20) UNSIGNED NOT NULL,
  `idUsuario` bigint(20) UNSIGNED NOT NULL,
  `token_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `expira_at` datetime(6) NOT NULL,
  `utilizado_at` datetime(6) DEFAULT NULL,
  `solicitado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `ip_solicitud_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tokens de recuperación de contraseña; solo se guarda el hash';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `idUsuario` bigint(20) UNSIGNED NOT NULL,
  `idRol` smallint(5) UNSIGNED NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `correo` varchar(254) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `ultimo_acceso_at` datetime(6) DEFAULT NULL,
  `password_actualizado_at` datetime(6) DEFAULT NULL,
  `intentos_fallidos` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `bloqueado_hasta` datetime(6) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `actualizado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6),
  `desactivado_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Usuarios autorizados para acceder al panel';

--
-- Disparadores `usuarios`
--
DELIMITER $$
CREATE TRIGGER `trg_usuario_bi` BEFORE INSERT ON `usuarios` FOR EACH ROW BEGIN
    SET NEW.nombre = TRIM(NEW.nombre);
    SET NEW.correo = LOWER(TRIM(NEW.correo));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_usuario_bu` BEFORE UPDATE ON `usuarios` FOR EACH ROW BEGIN
    SET NEW.nombre = TRIM(NEW.nombre);
    SET NEW.correo = LOWER(TRIM(NEW.correo));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios_afiliados`
--

CREATE TABLE `usuarios_afiliados` (
  `idUsuario` bigint(20) UNSIGNED NOT NULL,
  `idAfiliado` bigint(20) UNSIGNED NOT NULL,
  `es_principal` tinyint(1) NOT NULL DEFAULT 0,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Usuarios autorizados para administrar un afiliado';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios_camaras`
--

CREATE TABLE `usuarios_camaras` (
  `idUsuario` bigint(20) UNSIGNED NOT NULL,
  `idCamara` bigint(20) UNSIGNED NOT NULL,
  `creado_at` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Asignación de administradores de cámara';

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_afiliados_publicos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_afiliados_publicos` (
`idAfiliado` bigint(20) unsigned
,`idCamara` bigint(20) unsigned
,`nombre_comercial` varchar(180)
,`alias` varchar(120)
,`slug` varchar(200)
,`descripcion` text
,`correo_general` varchar(254)
,`idCategoriaPrincipal` bigint(20) unsigned
,`categoria_principal` varchar(120)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_promociones_vigentes`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_promociones_vigentes` (
`idPromocion` bigint(20) unsigned
,`idAfiliado` bigint(20) unsigned
,`nombre_comercial` varchar(180)
,`afiliado_slug` varchar(200)
,`titulo` varchar(180)
,`descripcion` text
,`restricciones` text
,`inicio_vigencia` datetime(6)
,`fin_vigencia` datetime(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_sucursales_publicas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_sucursales_publicas` (
`idSucursal` bigint(20) unsigned
,`idAfiliado` bigint(20) unsigned
,`nombre` varchar(150)
,`es_matriz` tinyint(1)
,`calle` varchar(160)
,`numero_exterior` varchar(20)
,`numero_interior` varchar(20)
,`colonia` varchar(130)
,`codigo_postal` char(5)
,`referencias` varchar(500)
,`latitud` decimal(10,7)
,`longitud` decimal(10,7)
,`google_place_id` varchar(255)
,`localidad` varchar(150)
,`idMunicipio` bigint(20) unsigned
,`municipio` varchar(120)
,`idEstado` smallint(5) unsigned
,`estado` varchar(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_afiliados_publicos`
--
DROP TABLE IF EXISTS `vw_afiliados_publicos`;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vw_afiliados_publicos`  AS SELECT `a`.`idAfiliado` AS `idAfiliado`, `a`.`idCamara` AS `idCamara`, `a`.`nombre_comercial` AS `nombre_comercial`, `a`.`alias` AS `alias`, `a`.`slug` AS `slug`, `a`.`descripcion` AS `descripcion`, `a`.`correo_general` AS `correo_general`, `ac`.`idCategoria` AS `idCategoriaPrincipal`, `cat`.`nombre` AS `categoria_principal` FROM (((`afiliados` `a` left join `afiliados_categorias` `ac` on(`ac`.`idAfiliado` = `a`.`idAfiliado` and `ac`.`es_principal` = 1)) left join `categorias` `cat` on(`cat`.`idCategoria` = `ac`.`idCategoria` and `cat`.`activo` = 1)) join `camaras` `c` on(`c`.`idCamara` = `a`.`idCamara`)) WHERE `a`.`activo` = 1 AND `c`.`activo` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_promociones_vigentes`
--
DROP TABLE IF EXISTS `vw_promociones_vigentes`;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vw_promociones_vigentes`  AS SELECT `p`.`idPromocion` AS `idPromocion`, `p`.`idAfiliado` AS `idAfiliado`, `a`.`nombre_comercial` AS `nombre_comercial`, `a`.`slug` AS `afiliado_slug`, `p`.`titulo` AS `titulo`, `p`.`descripcion` AS `descripcion`, `p`.`restricciones` AS `restricciones`, `p`.`inicio_vigencia` AS `inicio_vigencia`, `p`.`fin_vigencia` AS `fin_vigencia` FROM ((`promociones` `p` join `afiliados` `a` on(`a`.`idAfiliado` = `p`.`idAfiliado`)) join `camaras` `c` on(`c`.`idCamara` = `a`.`idCamara`)) WHERE `p`.`activo` = 1 AND `a`.`activo` = 1 AND `c`.`activo` = 1 AND current_timestamp(6) between `p`.`inicio_vigencia` and `p`.`fin_vigencia` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_sucursales_publicas`
--
DROP TABLE IF EXISTS `vw_sucursales_publicas`;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vw_sucursales_publicas`  AS SELECT `s`.`idSucursal` AS `idSucursal`, `s`.`idAfiliado` AS `idAfiliado`, `s`.`nombre` AS `nombre`, `s`.`es_matriz` AS `es_matriz`, `s`.`calle` AS `calle`, `s`.`numero_exterior` AS `numero_exterior`, `s`.`numero_interior` AS `numero_interior`, `s`.`colonia` AS `colonia`, `s`.`codigo_postal` AS `codigo_postal`, `s`.`referencias` AS `referencias`, `s`.`latitud` AS `latitud`, `s`.`longitud` AS `longitud`, `s`.`google_place_id` AS `google_place_id`, `l`.`nombre` AS `localidad`, `m`.`idMunicipio` AS `idMunicipio`, `m`.`nombre` AS `municipio`, `e`.`idEstado` AS `idEstado`, `e`.`nombre` AS `estado` FROM ((((`sucursales` `s` join `afiliados` `a` on(`a`.`idAfiliado` = `s`.`idAfiliado`)) join `localidades` `l` on(`l`.`idLocalidad` = `s`.`idLocalidad`)) join `municipios` `m` on(`m`.`idMunicipio` = `l`.`idMunicipio`)) join `estados` `e` on(`e`.`idEstado` = `m`.`idEstado`)) WHERE `s`.`activo` = 1 AND `a`.`activo` = 1 AND `l`.`activo` = 1 AND `m`.`activo` = 1 AND `e`.`activo` = 1 ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `afiliados`
--
ALTER TABLE `afiliados`
  ADD PRIMARY KEY (`idAfiliado`),
  ADD UNIQUE KEY `uq_afiliado_rfc` (`rfc`),
  ADD UNIQUE KEY `uq_afiliado_slug` (`slug`),
  ADD KEY `fk_afiliado_creado_por` (`idUsuarioCreador`),
  ADD KEY `fk_afiliado_actualizado_por` (`idUsuarioActualizador`),
  ADD KEY `fk_afiliado_desactivado_por` (`idUsuarioDesactivador`),
  ADD KEY `ix_afiliado_camara_activo` (`idCamara`,`activo`,`nombre_comercial`),
  ADD KEY `ix_afiliado_nombre` (`nombre_comercial`),
  ADD KEY `ix_afiliado_alias` (`alias`);

--
-- Indices de la tabla `afiliados_archivos`
--
ALTER TABLE `afiliados_archivos`
  ADD PRIMARY KEY (`idAfiliado`,`idArchivo`),
  ADD UNIQUE KEY `uq_afiliado_archivo_orden` (`idAfiliado`,`tipo`,`orden`),
  ADD UNIQUE KEY `uq_afiliado_logo_activo` (`logo_activo_unico`),
  ADD KEY `fk_afiliado_archivo_archivo` (`idArchivo`),
  ADD KEY `ix_afiliado_archivo_tipo` (`idAfiliado`,`tipo`,`activo`,`orden`);

--
-- Indices de la tabla `afiliados_categorias`
--
ALTER TABLE `afiliados_categorias`
  ADD PRIMARY KEY (`idAfiliado`,`idCategoria`),
  ADD UNIQUE KEY `uq_afiliado_categoria_principal` (`principal_unica`),
  ADD KEY `ix_afiliado_categoria_categoria` (`idCategoria`,`idAfiliado`),
  ADD KEY `ix_afiliado_categoria_orden` (`idAfiliado`,`orden`);

--
-- Indices de la tabla `afiliados_palabras_clave`
--
ALTER TABLE `afiliados_palabras_clave`
  ADD PRIMARY KEY (`idAfiliadoPalabraClave`),
  ADD UNIQUE KEY `uq_palabra_clave_afiliado` (`idAfiliado`,`palabra_normalizada`),
  ADD KEY `ix_palabra_clave_busqueda` (`palabra_normalizada`,`activo`);

--
-- Indices de la tabla `archivos`
--
ALTER TABLE `archivos`
  ADD PRIMARY KEY (`idArchivo`),
  ADD UNIQUE KEY `uq_archivo_storage_key` (`storage_key`),
  ADD KEY `fk_archivo_creado_por` (`idUsuarioCreador`),
  ADD KEY `ix_archivo_checksum` (`checksum_sha256`),
  ADD KEY `ix_archivo_activo` (`activo`,`mime_type`);

--
-- Indices de la tabla `auditorias_cambios`
--
ALTER TABLE `auditorias_cambios`
  ADD PRIMARY KEY (`idAuditoriaCambio`),
  ADD KEY `ix_auditoria_entidad` (`entidad`,`idEntidad`,`creado_at`),
  ADD KEY `ix_auditoria_usuario` (`idUsuario`,`creado_at`);

--
-- Indices de la tabla `busquedas`
--
ALTER TABLE `busquedas`
  ADD PRIMARY KEY (`idBusqueda`),
  ADD KEY `fk_busqueda_sesion` (`idSesionVisitante`),
  ADD KEY `fk_busqueda_categoria` (`idCategoria`),
  ADD KEY `ix_busqueda_fecha` (`buscado_at`),
  ADD KEY `ix_busqueda_termino` (`termino_normalizado`),
  ADD KEY `ix_busqueda_filtros` (`idMunicipio`,`idCategoria`,`buscado_at`),
  ADD KEY `ix_busqueda_sin_resultados` (`cantidad_resultados`,`buscado_at`);

--
-- Indices de la tabla `busquedas_resultados`
--
ALTER TABLE `busquedas_resultados`
  ADD PRIMARY KEY (`idBusqueda`,`idAfiliado`),
  ADD UNIQUE KEY `uq_busqueda_resultado_posicion` (`idBusqueda`,`posicion`),
  ADD KEY `ix_resultado_afiliado_fecha` (`idAfiliado`,`mostrado_at`);

--
-- Indices de la tabla `camaras`
--
ALTER TABLE `camaras`
  ADD PRIMARY KEY (`idCamara`),
  ADD UNIQUE KEY `uq_camara_clave` (`clave`),
  ADD KEY `fk_camara_municipio_sede` (`idMunicipioSede`),
  ADD KEY `ix_camara_activo` (`activo`,`nombre`);

--
-- Indices de la tabla `camaras_municipios`
--
ALTER TABLE `camaras_municipios`
  ADD PRIMARY KEY (`idCamara`,`idMunicipio`),
  ADD KEY `ix_camara_municipio_municipio` (`idMunicipio`,`activo`);

--
-- Indices de la tabla `canales_digitales`
--
ALTER TABLE `canales_digitales`
  ADD PRIMARY KEY (`idCanalDigital`),
  ADD UNIQUE KEY `uq_canal_digital_url` (`idAfiliado`,`tipo`,`url`),
  ADD KEY `ix_canal_digital_afiliado` (`idAfiliado`,`activo`,`tipo`),
  ADD KEY `ix_canal_digital_sucursal` (`idSucursal`,`activo`);

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`idCategoria`),
  ADD UNIQUE KEY `uq_categoria_slug` (`slug`),
  ADD UNIQUE KEY `uq_categoria_padre_nombre` (`idCategoriaPadre`,`nombre`),
  ADD KEY `ix_categoria_padre_activo` (`idCategoriaPadre`,`activo`,`nombre`);

--
-- Indices de la tabla `configuraciones_sistema`
--
ALTER TABLE `configuraciones_sistema`
  ADD PRIMARY KEY (`clave`),
  ADD KEY `fk_configuracion_actualizado_por` (`idUsuarioActualizador`);

--
-- Indices de la tabla `contactos_afiliados`
--
ALTER TABLE `contactos_afiliados`
  ADD PRIMARY KEY (`idContactoAfiliado`),
  ADD KEY `ix_contacto_afiliado_principal` (`idAfiliado`,`activo`,`es_principal`);

--
-- Indices de la tabla `estadisticas_diarias_afiliados`
--
ALTER TABLE `estadisticas_diarias_afiliados`
  ADD PRIMARY KEY (`fecha`,`idAfiliado`),
  ADD KEY `ix_estadistica_afiliado_fecha` (`idAfiliado`,`fecha`);

--
-- Indices de la tabla `estados`
--
ALTER TABLE `estados`
  ADD PRIMARY KEY (`idEstado`),
  ADD UNIQUE KEY `uq_estado_clave` (`clave_inegi`),
  ADD UNIQUE KEY `uq_estado_nombre` (`nombre`);

--
-- Indices de la tabla `importaciones_empresas_staging`
--
ALTER TABLE `importaciones_empresas_staging`
  ADD PRIMARY KEY (`idImportacionEmpresaStaging`),
  ADD UNIQUE KEY `uq_staging_lote_fila` (`idImportacionLote`,`hoja_origen`,`numero_fila`),
  ADD KEY `fk_staging_afiliado` (`idAfiliadoGenerado`),
  ADD KEY `fk_staging_sucursal` (`idSucursalGenerada`),
  ADD KEY `ix_staging_estado` (`idImportacionLote`,`estado_validacion`);

--
-- Indices de la tabla `importaciones_lotes`
--
ALTER TABLE `importaciones_lotes`
  ADD PRIMARY KEY (`idImportacionLote`),
  ADD KEY `fk_importacion_lote_usuario` (`idUsuario`),
  ADD KEY `ix_importacion_lote_estado` (`estado`,`creado_at`);

--
-- Indices de la tabla `indices_busquedas_afiliados`
--
ALTER TABLE `indices_busquedas_afiliados`
  ADD PRIMARY KEY (`idAfiliado`);
ALTER TABLE `indices_busquedas_afiliados` ADD FULLTEXT KEY `ft_indice_busqueda` (`nombre_alias`,`categorias`,`palabras_clave`,`promociones_vigentes`,`descripcion`);

--
-- Indices de la tabla `interacciones_afiliados`
--
ALTER TABLE `interacciones_afiliados`
  ADD PRIMARY KEY (`idInteraccionAfiliado`),
  ADD KEY `fk_interaccion_sesion` (`idSesionVisitante`),
  ADD KEY `fk_interaccion_busqueda` (`idBusqueda`),
  ADD KEY `fk_interaccion_sucursal` (`idSucursal`),
  ADD KEY `fk_interaccion_canal` (`idCanalDigital`),
  ADD KEY `ix_interaccion_afiliado_fecha` (`idAfiliado`,`ocurrido_at`),
  ADD KEY `ix_interaccion_tipo_fecha` (`tipo`,`ocurrido_at`),
  ADD KEY `ix_interaccion_promocion` (`idPromocion`,`ocurrido_at`);

--
-- Indices de la tabla `items_seccion_portada`
--
ALTER TABLE `items_seccion_portada`
  ADD PRIMARY KEY (`idItemSeccionPortada`),
  ADD UNIQUE KEY `uq_item_portada_orden` (`idSeccionPortada`,`orden`),
  ADD KEY `fk_item_portada_archivo` (`idArchivo`),
  ADD KEY `ix_item_portada_activo` (`idSeccionPortada`,`activo`,`orden`);

--
-- Indices de la tabla `localidades`
--
ALTER TABLE `localidades`
  ADD PRIMARY KEY (`idLocalidad`),
  ADD UNIQUE KEY `uq_localidad_municipio_nombre` (`idMunicipio`,`nombre`),
  ADD KEY `ix_localidad_municipio_activo` (`idMunicipio`,`activo`,`nombre`);

--
-- Indices de la tabla `municipios`
--
ALTER TABLE `municipios`
  ADD PRIMARY KEY (`idMunicipio`),
  ADD UNIQUE KEY `uq_municipio_estado_nombre` (`idEstado`,`nombre`),
  ADD UNIQUE KEY `uq_municipio_clave` (`clave_inegi`),
  ADD KEY `ix_municipio_estado_activo` (`idEstado`,`activo`,`nombre`);

--
-- Indices de la tabla `municipios_adyacencias`
--
ALTER TABLE `municipios_adyacencias`
  ADD PRIMARY KEY (`idMunicipioA`,`idMunicipioB`),
  ADD KEY `fk_adyacencia_municipio_b` (`idMunicipioB`);

--
-- Indices de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD PRIMARY KEY (`idNotificacion`),
  ADD KEY `fk_notificacion_promocion` (`idPromocion`),
  ADD KEY `ix_notificacion_pendiente` (`estado_envio`,`creado_at`),
  ADD KEY `ix_notificacion_usuario` (`idUsuarioDestino`,`creado_at`);

--
-- Indices de la tabla `permisos`
--
ALTER TABLE `permisos`
  ADD PRIMARY KEY (`idPermiso`),
  ADD UNIQUE KEY `uq_permiso_clave` (`clave`),
  ADD KEY `ix_permiso_modulo` (`modulo`,`activo`);

--
-- Indices de la tabla `promociones`
--
ALTER TABLE `promociones`
  ADD PRIMARY KEY (`idPromocion`),
  ADD KEY `fk_promocion_creado_por` (`idUsuarioCreador`),
  ADD KEY `fk_promocion_actualizado_por` (`idUsuarioActualizador`),
  ADD KEY `ix_promocion_publicacion` (`idAfiliado`,`activo`,`inicio_vigencia`,`fin_vigencia`),
  ADD KEY `ix_promocion_inicio` (`inicio_vigencia`),
  ADD KEY `ix_promocion_fin` (`fin_vigencia`);

--
-- Indices de la tabla `promociones_archivos`
--
ALTER TABLE `promociones_archivos`
  ADD PRIMARY KEY (`idPromocion`,`idArchivo`),
  ADD UNIQUE KEY `uq_promocion_archivo_orden` (`idPromocion`,`orden`),
  ADD KEY `fk_promocion_archivo_archivo` (`idArchivo`),
  ADD KEY `ix_promocion_archivo_activo` (`idPromocion`,`activo`,`orden`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`idRol`),
  ADD UNIQUE KEY `uq_rol_clave` (`clave`),
  ADD UNIQUE KEY `uq_rol_nombre` (`nombre`);

--
-- Indices de la tabla `roles_permisos`
--
ALTER TABLE `roles_permisos`
  ADD PRIMARY KEY (`idRol`,`idPermiso`),
  ADD KEY `fk_rol_permiso_permiso` (`idPermiso`);

--
-- Indices de la tabla `secciones_portada`
--
ALTER TABLE `secciones_portada`
  ADD PRIMARY KEY (`idSeccionPortada`),
  ADD UNIQUE KEY `uq_seccion_portada_codigo` (`codigo`),
  ADD UNIQUE KEY `uq_seccion_portada_orden` (`orden`),
  ADD KEY `ix_seccion_portada_activa` (`activo`,`orden`);

--
-- Indices de la tabla `sesiones_visitantes`
--
ALTER TABLE `sesiones_visitantes`
  ADD PRIMARY KEY (`idSesionVisitante`),
  ADD UNIQUE KEY `uq_sesion_visitante_hash` (`identificador_hash`),
  ADD KEY `ix_sesion_visitante_actividad` (`ultima_actividad_at`);

--
-- Indices de la tabla `sucursales`
--
ALTER TABLE `sucursales`
  ADD PRIMARY KEY (`idSucursal`),
  ADD UNIQUE KEY `uq_sucursal_matriz_activa` (`matriz_activa_unica`),
  ADD KEY `ix_sucursal_afiliado_activo` (`idAfiliado`,`activo`),
  ADD KEY `ix_sucursal_localidad_activo` (`idLocalidad`,`activo`),
  ADD KEY `ix_sucursal_geo` (`latitud`,`longitud`);

--
-- Indices de la tabla `sucursales_telefonos`
--
ALTER TABLE `sucursales_telefonos`
  ADD PRIMARY KEY (`idSucursalTelefono`),
  ADD UNIQUE KEY `uq_sucursal_telefono_numero` (`idSucursal`,`tipo`,`numero_normalizado`),
  ADD KEY `ix_sucursal_telefono_principal` (`idSucursal`,`tipo`,`activo`,`es_principal`);

--
-- Indices de la tabla `tokens_recuperacion_password`
--
ALTER TABLE `tokens_recuperacion_password`
  ADD PRIMARY KEY (`idTokenRecuperacionPassword`),
  ADD UNIQUE KEY `uq_token_password_hash` (`token_hash`),
  ADD KEY `ix_token_password_usuario_vigencia` (`idUsuario`,`expira_at`,`utilizado_at`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`idUsuario`),
  ADD UNIQUE KEY `uq_usuario_correo` (`correo`),
  ADD KEY `ix_usuario_rol_activo` (`idRol`,`activo`),
  ADD KEY `ix_usuario_ultimo_acceso` (`ultimo_acceso_at`);

--
-- Indices de la tabla `usuarios_afiliados`
--
ALTER TABLE `usuarios_afiliados`
  ADD PRIMARY KEY (`idUsuario`,`idAfiliado`),
  ADD KEY `ix_usuario_afiliado_afiliado` (`idAfiliado`,`es_principal`);

--
-- Indices de la tabla `usuarios_camaras`
--
ALTER TABLE `usuarios_camaras`
  ADD PRIMARY KEY (`idUsuario`),
  ADD KEY `ix_usuario_camara_camara` (`idCamara`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `afiliados`
--
ALTER TABLE `afiliados`
  MODIFY `idAfiliado` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `afiliados_palabras_clave`
--
ALTER TABLE `afiliados_palabras_clave`
  MODIFY `idAfiliadoPalabraClave` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `archivos`
--
ALTER TABLE `archivos`
  MODIFY `idArchivo` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `auditorias_cambios`
--
ALTER TABLE `auditorias_cambios`
  MODIFY `idAuditoriaCambio` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `busquedas`
--
ALTER TABLE `busquedas`
  MODIFY `idBusqueda` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `camaras`
--
ALTER TABLE `camaras`
  MODIFY `idCamara` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `canales_digitales`
--
ALTER TABLE `canales_digitales`
  MODIFY `idCanalDigital` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `idCategoria` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT de la tabla `contactos_afiliados`
--
ALTER TABLE `contactos_afiliados`
  MODIFY `idContactoAfiliado` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `estados`
--
ALTER TABLE `estados`
  MODIFY `idEstado` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT de la tabla `importaciones_empresas_staging`
--
ALTER TABLE `importaciones_empresas_staging`
  MODIFY `idImportacionEmpresaStaging` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `importaciones_lotes`
--
ALTER TABLE `importaciones_lotes`
  MODIFY `idImportacionLote` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `interacciones_afiliados`
--
ALTER TABLE `interacciones_afiliados`
  MODIFY `idInteraccionAfiliado` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `items_seccion_portada`
--
ALTER TABLE `items_seccion_portada`
  MODIFY `idItemSeccionPortada` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `localidades`
--
ALTER TABLE `localidades`
  MODIFY `idLocalidad` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `municipios`
--
ALTER TABLE `municipios`
  MODIFY `idMunicipio` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  MODIFY `idNotificacion` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `permisos`
--
ALTER TABLE `permisos`
  MODIFY `idPermiso` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `promociones`
--
ALTER TABLE `promociones`
  MODIFY `idPromocion` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `idRol` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `secciones_portada`
--
ALTER TABLE `secciones_portada`
  MODIFY `idSeccionPortada` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `sesiones_visitantes`
--
ALTER TABLE `sesiones_visitantes`
  MODIFY `idSesionVisitante` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `sucursales`
--
ALTER TABLE `sucursales`
  MODIFY `idSucursal` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `sucursales_telefonos`
--
ALTER TABLE `sucursales_telefonos`
  MODIFY `idSucursalTelefono` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tokens_recuperacion_password`
--
ALTER TABLE `tokens_recuperacion_password`
  MODIFY `idTokenRecuperacionPassword` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `idUsuario` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `afiliados`
--
--
-- Filtros para la tabla `afiliados_archivos`
--
--
-- Filtros para la tabla `afiliados_categorias`
--
--
-- Filtros para la tabla `afiliados_palabras_clave`
--
--
-- Filtros para la tabla `archivos`
--
--
-- Filtros para la tabla `auditorias_cambios`
--
--
-- Filtros para la tabla `busquedas`
--
--
-- Filtros para la tabla `busquedas_resultados`
--
--
-- Filtros para la tabla `camaras`
--
--
-- Filtros para la tabla `camaras_municipios`
--
--
-- Filtros para la tabla `canales_digitales`
--
--
-- Filtros para la tabla `categorias`
--
--
-- Filtros para la tabla `configuraciones_sistema`
--
--
-- Filtros para la tabla `contactos_afiliados`
--
--
-- Filtros para la tabla `estadisticas_diarias_afiliados`
--
--
-- Filtros para la tabla `importaciones_empresas_staging`
--
--
-- Filtros para la tabla `importaciones_lotes`
--
--
-- Filtros para la tabla `indices_busquedas_afiliados`
--
--
-- Filtros para la tabla `interacciones_afiliados`
--
--
-- Filtros para la tabla `items_seccion_portada`
--
--
-- Filtros para la tabla `localidades`
--
--
-- Filtros para la tabla `municipios`
--
--
-- Filtros para la tabla `municipios_adyacencias`
--
--
-- Filtros para la tabla `notificaciones`
--
--
-- Filtros para la tabla `promociones`
--
--
-- Filtros para la tabla `promociones_archivos`
--
--
-- Filtros para la tabla `roles_permisos`
--
--
-- Filtros para la tabla `sucursales`
--
--
-- Filtros para la tabla `sucursales_telefonos`
--
--
-- Filtros para la tabla `tokens_recuperacion_password`
--
--
-- Filtros para la tabla `usuarios`
--
--
-- Filtros para la tabla `usuarios_afiliados`
--
--
-- Filtros para la tabla `usuarios_camaras`
--

-- Restored AUTO_INCREMENT attributes for cPanel deployment.
ALTER TABLE `estados` MODIFY `idEstado` SMALLINT UNSIGNED AUTO_INCREMENT;
ALTER TABLE `municipios` MODIFY `idMunicipio` BIGINT UNSIGNED AUTO_INCREMENT;
ALTER TABLE `localidades` MODIFY `idLocalidad` BIGINT UNSIGNED AUTO_INCREMENT;
ALTER TABLE `camaras` MODIFY `idCamara` BIGINT UNSIGNED AUTO_INCREMENT;
ALTER TABLE `roles` MODIFY `idRol` SMALLINT UNSIGNED AUTO_INCREMENT;
ALTER TABLE `permisos` MODIFY `idPermiso` BIGINT UNSIGNED AUTO_INCREMENT;
ALTER TABLE `usuarios` MODIFY `idUsuario` BIGINT UNSIGNED AUTO_INCREMENT;
ALTER TABLE `tokens_recuperacion_password` MODIFY `idTokenRecuperacionPassword` BIGINT UNSIGNED AUTO_INCREMENT;
ALTER TABLE `afiliados` MODIFY `idAfiliado` BIGINT UNSIGNED AUTO_INCREMENT;
ALTER TABLE `contactos_afiliados` MODIFY `idContactoAfiliado` BIGINT UNSIGNED AUTO_INCREMENT;
ALTER TABLE `sucursales` MODIFY `idSucursal` BIGINT UNSIGNED AUTO_INCREMENT;
ALTER TABLE `sucursales_telefonos` MODIFY `idSucursalTelefono` BIGINT UNSIGNED AUTO_INCREMENT;
ALTER TABLE `canales_digitales` MODIFY `idCanalDigital` BIGINT UNSIGNED AUTO_INCREMENT;
ALTER TABLE `categorias` MODIFY `idCategoria` BIGINT UNSIGNED AUTO_INCREMENT;
ALTER TABLE `afiliados_palabras_clave` MODIFY `idAfiliadoPalabraClave` BIGINT UNSIGNED AUTO_INCREMENT;
ALTER TABLE `archivos` MODIFY `idArchivo` BIGINT UNSIGNED AUTO_INCREMENT;
ALTER TABLE `promociones` MODIFY `idPromocion` BIGINT UNSIGNED AUTO_INCREMENT;
ALTER TABLE `notificaciones` MODIFY `idNotificacion` BIGINT UNSIGNED AUTO_INCREMENT;
ALTER TABLE `secciones_portada` MODIFY `idSeccionPortada` BIGINT UNSIGNED AUTO_INCREMENT;
ALTER TABLE `items_seccion_portada` MODIFY `idItemSeccionPortada` BIGINT UNSIGNED AUTO_INCREMENT;
ALTER TABLE `sesiones_visitantes` MODIFY `idSesionVisitante` BIGINT UNSIGNED AUTO_INCREMENT;
ALTER TABLE `busquedas` MODIFY `idBusqueda` BIGINT UNSIGNED AUTO_INCREMENT;
ALTER TABLE `interacciones_afiliados` MODIFY `idInteraccionAfiliado` BIGINT UNSIGNED AUTO_INCREMENT;
ALTER TABLE `auditorias_cambios` MODIFY `idAuditoriaCambio` BIGINT UNSIGNED AUTO_INCREMENT;
ALTER TABLE `importaciones_lotes` MODIFY `idImportacionLote` BIGINT UNSIGNED AUTO_INCREMENT;
ALTER TABLE `importaciones_empresas_staging` MODIFY `idImportacionEmpresaStaging` BIGINT UNSIGNED AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
