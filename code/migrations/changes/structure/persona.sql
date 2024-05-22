/*
 Navicat Premium Data Transfer

 Source Server         : Local PostgreSQL 12 - 5432
 Source Server Type    : PostgreSQL
 Source Server Version : 120018
 Source Host           : localhost:5432
 Source Catalog        : siamt
 Source Schema         : persona

 Target Server Type    : PostgreSQL
 Target Server Version : 120018
 File Encoding         : 65001

 Date: 16/05/2024 22:42:11
*/


-- ----------------------------
-- Sequence structure for cat_estado_civil_iidestado_civil_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "persona"."cat_estado_civil_iidestado_civil_seq";
CREATE SEQUENCE "persona"."cat_estado_civil_iidestado_civil_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for cat_lada_iidlada_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "persona"."cat_lada_iidlada_seq";
CREATE SEQUENCE "persona"."cat_lada_iidlada_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for cat_sexo_iidsexo_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "persona"."cat_sexo_iidsexo_seq";
CREATE SEQUENCE "persona"."cat_sexo_iidsexo_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for cat_telefono_tipo_iidtelefono_tipo_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "persona"."cat_telefono_tipo_iidtelefono_tipo_seq";
CREATE SEQUENCE "persona"."cat_telefono_tipo_iidtelefono_tipo_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for cat_tipo_iidtipo_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "persona"."cat_tipo_iidtipo_seq";
CREATE SEQUENCE "persona"."cat_tipo_iidtipo_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_direccion_iiddireccion_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "persona"."tbl_direccion_iiddireccion_seq";
CREATE SEQUENCE "persona"."tbl_direccion_iiddireccion_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_persona_direccion_iidpersona_direccion_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "persona"."tbl_persona_direccion_iidpersona_direccion_seq";
CREATE SEQUENCE "persona"."tbl_persona_direccion_iidpersona_direccion_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_persona_iidpersona_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "persona"."tbl_persona_iidpersona_seq";
CREATE SEQUENCE "persona"."tbl_persona_iidpersona_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_persona_telefono_iidpersona_telefono_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "persona"."tbl_persona_telefono_iidpersona_telefono_seq";
CREATE SEQUENCE "persona"."tbl_persona_telefono_iidpersona_telefono_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_persona_tipo_iidpersona_tipo_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "persona"."tbl_persona_tipo_iidpersona_tipo_seq";
CREATE SEQUENCE "persona"."tbl_persona_tipo_iidpersona_tipo_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_telefono_iidtelefono_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "persona"."tbl_telefono_iidtelefono_seq";
CREATE SEQUENCE "persona"."tbl_telefono_iidtelefono_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Table structure for cat_estado_civil
-- ----------------------------
DROP TABLE IF EXISTS "persona"."cat_estado_civil";
CREATE TABLE "persona"."cat_estado_civil" (
  "iidestado_civil" int4 NOT NULL DEFAULT nextval('"persona".cat_estado_civil_iidestado_civil_seq'::regclass),
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtdescripcion" text COLLATE "pg_catalog"."default",
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
)
;
COMMENT ON COLUMN "persona"."cat_estado_civil"."iidestado_civil" IS 'Identificador único';

-- ----------------------------
-- Records of cat_estado_civil
-- ----------------------------
INSERT INTO "persona"."cat_estado_civil" VALUES (1, 'Soltero', NULL, 't', '2024-03-28 11:25:40.754864', '2024-03-28 11:25:40.754864');

-- ----------------------------
-- Table structure for cat_lada
-- ----------------------------
DROP TABLE IF EXISTS "persona"."cat_lada";
CREATE TABLE "persona"."cat_lada" (
  "iidlada" int4 NOT NULL DEFAULT nextval('"persona".cat_lada_iidlada_seq'::regclass),
  "txtnombre" text COLLATE "pg_catalog"."default",
  "txtdescripcion" text COLLATE "pg_catalog"."default",
  "txtiso_tres" text COLLATE "pg_catalog"."default",
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Records of cat_lada
-- ----------------------------
INSERT INTO "persona"."cat_lada" VALUES (1, '+1', 'Estados Unidos y Canadá', 'USA/CAN', 't', '2024-04-05 09:27:27.572749', '2024-04-05 09:27:27.572749');
INSERT INTO "persona"."cat_lada" VALUES (2, '+52', 'México', 'MEX', 't', '2024-04-05 09:27:27.572749', '2024-04-05 09:27:27.572749');
INSERT INTO "persona"."cat_lada" VALUES (3, '+44', 'Reino Unido', 'GBR', 't', '2024-04-05 09:27:27.572749', '2024-04-05 09:27:27.572749');
INSERT INTO "persona"."cat_lada" VALUES (4, '+49', 'Alemania', 'DEU', 't', '2024-04-05 09:27:27.572749', '2024-04-05 09:27:27.572749');
INSERT INTO "persona"."cat_lada" VALUES (5, '+33', 'Francia', 'FRA', 't', '2024-04-05 09:27:27.572749', '2024-04-05 09:27:27.572749');
INSERT INTO "persona"."cat_lada" VALUES (6, '+34', 'España', 'ESP', 't', '2024-04-05 09:27:27.572749', '2024-04-05 09:27:27.572749');
INSERT INTO "persona"."cat_lada" VALUES (7, '+86', 'China', 'CHN', 't', '2024-04-05 09:27:27.572749', '2024-04-05 09:27:27.572749');
INSERT INTO "persona"."cat_lada" VALUES (8, '+81', 'Japón', 'JPN', 't', '2024-04-05 09:27:27.572749', '2024-04-05 09:27:27.572749');
INSERT INTO "persona"."cat_lada" VALUES (9, '+61', 'Australia', 'AUS', 't', '2024-04-05 09:27:27.572749', '2024-04-05 09:27:27.572749');
INSERT INTO "persona"."cat_lada" VALUES (10, '+55', 'Brasil', 'BRA', 't', '2024-04-05 09:27:27.572749', '2024-04-05 09:27:27.572749');

-- ----------------------------
-- Table structure for cat_sexo
-- ----------------------------
DROP TABLE IF EXISTS "persona"."cat_sexo";
CREATE TABLE "persona"."cat_sexo" (
  "iidsexo" int4 NOT NULL DEFAULT nextval('"persona".cat_sexo_iidsexo_seq'::regclass),
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtdescripcion" text COLLATE "pg_catalog"."default",
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
)
;
COMMENT ON COLUMN "persona"."cat_sexo"."iidsexo" IS 'Identificador único';

-- ----------------------------
-- Records of cat_sexo
-- ----------------------------
INSERT INTO "persona"."cat_sexo" VALUES (1, 'Masculino', NULL, 't', '2024-03-28 11:25:40.754864', '2024-03-28 11:25:40.754864');
INSERT INTO "persona"."cat_sexo" VALUES (2, 'Femenino', NULL, 't', '2024-03-28 11:25:40.754864', '2024-03-28 11:25:40.754864');

-- ----------------------------
-- Table structure for cat_telefono_tipo
-- ----------------------------
DROP TABLE IF EXISTS "persona"."cat_telefono_tipo";
CREATE TABLE "persona"."cat_telefono_tipo" (
  "iidtelefono_tipo" int4 NOT NULL DEFAULT nextval('"persona".cat_telefono_tipo_iidtelefono_tipo_seq'::regclass),
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtdescripcion" text COLLATE "pg_catalog"."default",
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
)
;
COMMENT ON COLUMN "persona"."cat_telefono_tipo"."iidtelefono_tipo" IS 'Identificador único';

-- ----------------------------
-- Records of cat_telefono_tipo
-- ----------------------------
INSERT INTO "persona"."cat_telefono_tipo" VALUES (1, 'Celular', 'Teléfono celular', 't', '2024-04-02 15:27:19.444874', '2024-04-02 15:27:19.444874');
INSERT INTO "persona"."cat_telefono_tipo" VALUES (2, 'Casa', 'Teléfono de casa', 't', '2024-04-02 15:27:32.999883', '2024-04-02 15:27:32.999883');

-- ----------------------------
-- Table structure for cat_tipo
-- ----------------------------
DROP TABLE IF EXISTS "persona"."cat_tipo";
CREATE TABLE "persona"."cat_tipo" (
  "iidtipo" int4 NOT NULL DEFAULT nextval('"persona".cat_tipo_iidtipo_seq'::regclass),
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtdescripcion" text COLLATE "pg_catalog"."default",
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
)
;
COMMENT ON COLUMN "persona"."cat_tipo"."iidtipo" IS 'Identificador único';

-- ----------------------------
-- Records of cat_tipo
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_direccion
-- ----------------------------
DROP TABLE IF EXISTS "persona"."tbl_direccion";
CREATE TABLE "persona"."tbl_direccion" (
  "iiddireccion" int4 NOT NULL DEFAULT nextval('"persona".tbl_direccion_iiddireccion_seq'::regclass),
  "iidcolonia" int4 NOT NULL,
  "txtcalle" text COLLATE "pg_catalog"."default",
  "txtcalle_letra" text COLLATE "pg_catalog"."default",
  "inumero_exterior" int4,
  "txtnumero_exterior_letra" text COLLATE "pg_catalog"."default",
  "inumero_interior" int4,
  "txtnumero_interior_letra" text COLLATE "pg_catalog"."default",
  "txtcruzamiento_uno" text COLLATE "pg_catalog"."default",
  "txtcruzamiento_uno_letra" text COLLATE "pg_catalog"."default",
  "txtcruzamiento_dos" text COLLATE "pg_catalog"."default",
  "txtcruzamiento_dos_letra" text COLLATE "pg_catalog"."default",
  "txtreferencia" text COLLATE "pg_catalog"."default",
  "flatitud" float8,
  "flongitud" float8,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
  "itipo_direccion" int4 DEFAULT 1,
  "itipo_vialidad" int4,
  "txtavenida_kilometro" text COLLATE "pg_catalog"."default",
  "txttablaje" text COLLATE "pg_catalog"."default",
  "txtdescripcion_direccion" text COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "persona"."tbl_direccion"."iiddireccion" IS 'Identificador único';

-- ----------------------------
-- Records of tbl_direccion
-- ----------------------------
INSERT INTO "persona"."tbl_direccion" VALUES (1, 16, '', '', NULL, '', NULL, '', '', '', '', '', '', NULL, NULL, 't', '2024-04-23 22:21:04.05924', '2024-04-23 22:21:04.05924', 3, 0, '', '', 's');
INSERT INTO "persona"."tbl_direccion" VALUES (2, 16, '15', 'B', 240, '', NULL, '', '10', 'C', '14', '', 'Casa blanca rejas blancas', 20.958377223178, -89.58499360341, 't', '2024-04-23 22:41:32.523058', '2024-04-23 22:41:32.523058', 1, 1, '', '', '');
INSERT INTO "persona"."tbl_direccion" VALUES (4, 18, '', '', NULL, '', NULL, '', '', '', '', '', '', NULL, NULL, 't', '2024-04-25 11:27:01.351806', '2024-04-25 11:27:01.351806', 2, 0, '', 'Tab', '');
INSERT INTO "persona"."tbl_direccion" VALUES (5, 19, '', '', NULL, '', NULL, '', '', '', '', '', '', NULL, NULL, 't', '2024-04-25 13:32:55.639886', '2024-04-25 13:32:55.639886', 3, 0, '', '', 'demo');
INSERT INTO "persona"."tbl_direccion" VALUES (6, 17, '', '', NULL, '', NULL, '', '', '', '', '', '', NULL, NULL, 't', '2024-05-02 09:29:52.131649', '2024-05-02 09:29:52.131649', 3, 0, '', '', 'd');
INSERT INTO "persona"."tbl_direccion" VALUES (7, 16, '', '', NULL, NULL, NULL, NULL, '', '', NULL, NULL, NULL, NULL, NULL, 't', '2024-05-08 15:18:50.443325', '2024-05-08 15:39:03', 3, 0, '', '', 'Nuevo');
INSERT INTO "persona"."tbl_direccion" VALUES (8, 24, '', '', NULL, '', NULL, '', '', '', '', '', '', NULL, NULL, 't', '2024-05-08 15:39:18.30229', '2024-05-08 15:39:18.30229', 2, 0, '', 'tabs', '');
INSERT INTO "persona"."tbl_direccion" VALUES (9, 16, '', '', NULL, '', NULL, '', '', '', '', '', '', NULL, NULL, 't', '2024-05-16 11:44:15.816492', '2024-05-16 11:44:15.816492', 3, 0, '', '', 'Demo');
INSERT INTO "persona"."tbl_direccion" VALUES (10, 16, '15', '', 240, '', NULL, '', '', '', '', '', '', NULL, NULL, 't', '2024-05-16 12:00:29.971484', '2024-05-16 12:00:29.971484', 3, 1, '', '789', 'Desc');
INSERT INTO "persona"."tbl_direccion" VALUES (11, 26, '', '', NULL, '', NULL, '', '', '', '', '', '', NULL, NULL, 't', '2024-05-16 12:15:58.036478', '2024-05-16 12:15:58.036478', 2, 0, '', 'RE', '');

-- ----------------------------
-- Table structure for tbl_persona
-- ----------------------------
DROP TABLE IF EXISTS "persona"."tbl_persona";
CREATE TABLE "persona"."tbl_persona" (
  "iidpersona" int4 NOT NULL DEFAULT nextval('"persona".tbl_persona_iidpersona_seq'::regclass),
  "bfisica" bool NOT NULL DEFAULT true,
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtapepat" text COLLATE "pg_catalog"."default",
  "txtapemat" text COLLATE "pg_catalog"."default",
  "dfecha_nacimiento" date,
  "iidestado_nacimiento" int4,
  "txtrfc" text COLLATE "pg_catalog"."default",
  "txtcurp" text COLLATE "pg_catalog"."default",
  "txtine" text COLLATE "pg_catalog"."default",
  "iidestado_civil" int4,
  "iidsexo" int4,
  "txtcorreo" text COLLATE "pg_catalog"."default",
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Records of tbl_persona
-- ----------------------------
INSERT INTO "persona"."tbl_persona" VALUES (5, 't', 'Demo', 'Demo', '', '2024-04-30', NULL, '', 'CAUM990224HYNRCC05', '', NULL, NULL, '', 't', '2024-05-16 11:44:15.816492', '2024-05-16 11:44:15.816492');
INSERT INTO "persona"."tbl_persona" VALUES (6, 't', 'Demo', 'demo', '', '2024-05-01', NULL, '', 'CAUM990224HYNRCC06', '', NULL, NULL, '', 't', '2024-05-16 12:00:29.971484', '2024-05-16 12:00:29.971484');
INSERT INTO "persona"."tbl_persona" VALUES (4, 't', 'Demo 3', 'prueba', 'Uicab 2', '2024-05-01', NULL, '', 'CAUM990224HYNRCC04', '', NULL, NULL, '', 't', '2024-05-08 15:18:50.443325', '2024-05-08 15:42:43');

-- ----------------------------
-- Table structure for tbl_persona_direccion
-- ----------------------------
DROP TABLE IF EXISTS "persona"."tbl_persona_direccion";
CREATE TABLE "persona"."tbl_persona_direccion" (
  "iidpersona_direccion" int4 NOT NULL DEFAULT nextval('"persona".tbl_persona_direccion_iidpersona_direccion_seq'::regclass),
  "iidpersona" int4 NOT NULL,
  "iiddireccion" int4 NOT NULL,
  "bactual" bool DEFAULT true,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
)
;
COMMENT ON COLUMN "persona"."tbl_persona_direccion"."iidpersona_direccion" IS 'Identificador único';

-- ----------------------------
-- Records of tbl_persona_direccion
-- ----------------------------
INSERT INTO "persona"."tbl_persona_direccion" VALUES (7, 4, 8, 'f', 't', '2024-05-08 15:39:18.30229', '2024-05-08 15:39:18.30229');
INSERT INTO "persona"."tbl_persona_direccion" VALUES (6, 4, 7, 't', 't', '2024-05-08 15:18:50.443325', '2024-05-08 15:18:50.443325');
INSERT INTO "persona"."tbl_persona_direccion" VALUES (8, 5, 9, 't', 't', '2024-05-16 11:44:15.816492', '2024-05-16 11:44:15.816492');
INSERT INTO "persona"."tbl_persona_direccion" VALUES (9, 6, 10, 't', 't', '2024-05-16 12:00:29.971484', '2024-05-16 12:00:29.971484');
INSERT INTO "persona"."tbl_persona_direccion" VALUES (10, 6, 11, 'f', 'f', '2024-05-16 12:15:58.036478', '2024-05-16 12:15:58.036478');

-- ----------------------------
-- Table structure for tbl_persona_telefono
-- ----------------------------
DROP TABLE IF EXISTS "persona"."tbl_persona_telefono";
CREATE TABLE "persona"."tbl_persona_telefono" (
  "iidpersona_telefono" int4 NOT NULL DEFAULT nextval('"persona".tbl_persona_telefono_iidpersona_telefono_seq'::regclass),
  "iidpersona" int4 NOT NULL,
  "iidtelefono" int4 NOT NULL,
  "bactual" bool DEFAULT true,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
)
;
COMMENT ON COLUMN "persona"."tbl_persona_telefono"."iidpersona_telefono" IS 'Identificador único';

-- ----------------------------
-- Records of tbl_persona_telefono
-- ----------------------------
INSERT INTO "persona"."tbl_persona_telefono" VALUES (7, 4, 7, 'f', 't', '2024-05-08 15:18:50.443325', '2024-05-08 15:18:50.443325');
INSERT INTO "persona"."tbl_persona_telefono" VALUES (8, 4, 8, 't', 't', '2024-05-08 15:39:44.200227', '2024-05-08 15:39:44.200227');
INSERT INTO "persona"."tbl_persona_telefono" VALUES (9, 5, 9, 't', 't', '2024-05-16 11:44:15.816492', '2024-05-16 11:44:15.816492');
INSERT INTO "persona"."tbl_persona_telefono" VALUES (10, 6, 10, 't', 't', '2024-05-16 12:00:29.971484', '2024-05-16 12:00:29.971484');

-- ----------------------------
-- Table structure for tbl_persona_tipo
-- ----------------------------
DROP TABLE IF EXISTS "persona"."tbl_persona_tipo";
CREATE TABLE "persona"."tbl_persona_tipo" (
  "iidpersona_tipo" int4 NOT NULL DEFAULT nextval('"persona".tbl_persona_tipo_iidpersona_tipo_seq'::regclass),
  "iidpersona" int4 NOT NULL,
  "iidtipo" int4 NOT NULL,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
)
;
COMMENT ON COLUMN "persona"."tbl_persona_tipo"."iidpersona_tipo" IS 'Identificador único';

-- ----------------------------
-- Records of tbl_persona_tipo
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_telefono
-- ----------------------------
DROP TABLE IF EXISTS "persona"."tbl_telefono";
CREATE TABLE "persona"."tbl_telefono" (
  "iidtelefono" int4 NOT NULL DEFAULT nextval('"persona".tbl_telefono_iidtelefono_seq'::regclass),
  "inumero" int8 NOT NULL,
  "iidtelefono_tipo" int4 NOT NULL,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
  "txtlada" text COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "persona"."tbl_telefono"."iidtelefono" IS 'Identificador único';

-- ----------------------------
-- Records of tbl_telefono
-- ----------------------------
INSERT INTO "persona"."tbl_telefono" VALUES (1, 4564567893, 1, 'f', '2024-04-23 22:21:04.05924', '2024-04-23 22:33:33', '');
INSERT INTO "persona"."tbl_telefono" VALUES (2, 9997473339, 1, 't', '2024-04-23 22:41:32.523058', '2024-04-23 22:41:32.523058', '');
INSERT INTO "persona"."tbl_telefono" VALUES (3, 7897897897, 1, 't', '2024-05-02 09:29:52.131649', '2024-05-02 09:29:52.131649', '');
INSERT INTO "persona"."tbl_telefono" VALUES (4, 7845786321, 2, 't', '2024-05-06 01:12:39.019346', '2024-05-06 01:12:39.019346', '');
INSERT INTO "persona"."tbl_telefono" VALUES (5, 4564564665, 1, 't', '2024-05-06 01:14:44.058355', '2024-05-06 01:14:44.058355', '');
INSERT INTO "persona"."tbl_telefono" VALUES (6, 4714741474, 2, 't', '2024-05-06 01:14:56.841987', '2024-05-06 01:14:56.841987', '');
INSERT INTO "persona"."tbl_telefono" VALUES (7, 7897897998, 1, 't', '2024-05-08 15:18:50.443325', '2024-05-08 15:39:33', '');
INSERT INTO "persona"."tbl_telefono" VALUES (8, 1474147147, 2, 't', '2024-05-08 15:39:44.200227', '2024-05-08 15:39:44.200227', '');
INSERT INTO "persona"."tbl_telefono" VALUES (9, 7897897979, 1, 't', '2024-05-16 11:44:15.816492', '2024-05-16 11:44:15.816492', '');
INSERT INTO "persona"."tbl_telefono" VALUES (10, 7897897894, 1, 't', '2024-05-16 12:00:29.971484', '2024-05-16 12:00:29.971484', '');

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "persona"."cat_estado_civil_iidestado_civil_seq"
OWNED BY "persona"."cat_estado_civil"."iidestado_civil";
SELECT setval('"persona"."cat_estado_civil_iidestado_civil_seq"', 1, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "persona"."cat_lada_iidlada_seq"
OWNED BY "persona"."cat_lada"."iidlada";
SELECT setval('"persona"."cat_lada_iidlada_seq"', 10, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "persona"."cat_sexo_iidsexo_seq"
OWNED BY "persona"."cat_sexo"."iidsexo";
SELECT setval('"persona"."cat_sexo_iidsexo_seq"', 2, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "persona"."cat_telefono_tipo_iidtelefono_tipo_seq"
OWNED BY "persona"."cat_telefono_tipo"."iidtelefono_tipo";
SELECT setval('"persona"."cat_telefono_tipo_iidtelefono_tipo_seq"', 2, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "persona"."cat_tipo_iidtipo_seq"
OWNED BY "persona"."cat_tipo"."iidtipo";
SELECT setval('"persona"."cat_tipo_iidtipo_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "persona"."tbl_direccion_iiddireccion_seq"
OWNED BY "persona"."tbl_direccion"."iiddireccion";
SELECT setval('"persona"."tbl_direccion_iiddireccion_seq"', 11, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "persona"."tbl_persona_direccion_iidpersona_direccion_seq"
OWNED BY "persona"."tbl_persona_direccion"."iidpersona_direccion";
SELECT setval('"persona"."tbl_persona_direccion_iidpersona_direccion_seq"', 10, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "persona"."tbl_persona_iidpersona_seq"
OWNED BY "persona"."tbl_persona"."iidpersona";
SELECT setval('"persona"."tbl_persona_iidpersona_seq"', 6, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "persona"."tbl_persona_telefono_iidpersona_telefono_seq"
OWNED BY "persona"."tbl_persona_telefono"."iidpersona_telefono";
SELECT setval('"persona"."tbl_persona_telefono_iidpersona_telefono_seq"', 10, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "persona"."tbl_persona_tipo_iidpersona_tipo_seq"
OWNED BY "persona"."tbl_persona_tipo"."iidpersona_tipo";
SELECT setval('"persona"."tbl_persona_tipo_iidpersona_tipo_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "persona"."tbl_telefono_iidtelefono_seq"
OWNED BY "persona"."tbl_telefono"."iidtelefono";
SELECT setval('"persona"."tbl_telefono_iidtelefono_seq"', 10, true);

-- ----------------------------
-- Primary Key structure for table cat_estado_civil
-- ----------------------------
ALTER TABLE "persona"."cat_estado_civil" ADD CONSTRAINT "cat_estado_civil_pkey" PRIMARY KEY ("iidestado_civil");

-- ----------------------------
-- Primary Key structure for table cat_lada
-- ----------------------------
ALTER TABLE "persona"."cat_lada" ADD CONSTRAINT "cat_lada_pkey" PRIMARY KEY ("iidlada");

-- ----------------------------
-- Primary Key structure for table cat_sexo
-- ----------------------------
ALTER TABLE "persona"."cat_sexo" ADD CONSTRAINT "cat_sexo_pkey" PRIMARY KEY ("iidsexo");

-- ----------------------------
-- Primary Key structure for table cat_telefono_tipo
-- ----------------------------
ALTER TABLE "persona"."cat_telefono_tipo" ADD CONSTRAINT "cat_telefono_tipo_pkey" PRIMARY KEY ("iidtelefono_tipo");

-- ----------------------------
-- Primary Key structure for table cat_tipo
-- ----------------------------
ALTER TABLE "persona"."cat_tipo" ADD CONSTRAINT "cat_tipo_pkey" PRIMARY KEY ("iidtipo");

-- ----------------------------
-- Primary Key structure for table tbl_direccion
-- ----------------------------
ALTER TABLE "persona"."tbl_direccion" ADD CONSTRAINT "tbl_direccion_pkey" PRIMARY KEY ("iiddireccion");

-- ----------------------------
-- Uniques structure for table tbl_persona
-- ----------------------------
ALTER TABLE "persona"."tbl_persona" ADD CONSTRAINT "uq_tbl_persona_txtcurp" UNIQUE ("txtcurp");

-- ----------------------------
-- Primary Key structure for table tbl_persona
-- ----------------------------
ALTER TABLE "persona"."tbl_persona" ADD CONSTRAINT "tbl_persona_pkey" PRIMARY KEY ("iidpersona");

-- ----------------------------
-- Primary Key structure for table tbl_persona_direccion
-- ----------------------------
ALTER TABLE "persona"."tbl_persona_direccion" ADD CONSTRAINT "tbl_persona_direccion_pkey" PRIMARY KEY ("iidpersona_direccion");

-- ----------------------------
-- Primary Key structure for table tbl_persona_telefono
-- ----------------------------
ALTER TABLE "persona"."tbl_persona_telefono" ADD CONSTRAINT "tbl_persona_telefono_pkey" PRIMARY KEY ("iidpersona_telefono");

-- ----------------------------
-- Primary Key structure for table tbl_persona_tipo
-- ----------------------------
ALTER TABLE "persona"."tbl_persona_tipo" ADD CONSTRAINT "tbl_persona_tipo_pkey" PRIMARY KEY ("iidpersona_tipo");

-- ----------------------------
-- Primary Key structure for table tbl_telefono
-- ----------------------------
ALTER TABLE "persona"."tbl_telefono" ADD CONSTRAINT "tbl_telefono_pkey" PRIMARY KEY ("iidtelefono");
