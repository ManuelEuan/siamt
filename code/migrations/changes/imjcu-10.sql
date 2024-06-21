
/*
 Navicat Premium Data Transfer

 Source Server         : wsl postgres 14
 Source Server Type    : PostgreSQL
 Source Server Version : 140012
 Source Host           : 172.20.199.57:5432
 Source Catalog        : siamt_complete
 Source Schema         : unidad

 Target Server Type    : PostgreSQL
 Target Server Version : 140012
 File Encoding         : 65001

 Date: 21/06/2024 12:00:43
*/


-- ----------------------------
-- Sequence structure for cat_cobertura_tipo_iidcobertura_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "unidad"."cat_cobertura_tipo_iidcobertura_seq";
CREATE SEQUENCE "unidad"."cat_cobertura_tipo_iidcobertura_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for cat_empresa_iidempresa_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "unidad"."cat_empresa_iidempresa_seq";
CREATE SEQUENCE "unidad"."cat_empresa_iidempresa_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for cat_marca_iidmarca_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "unidad"."cat_marca_iidmarca_seq";
CREATE SEQUENCE "unidad"."cat_marca_iidmarca_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for cat_modelo_iidmodelo_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "unidad"."cat_modelo_iidmodelo_seq";
CREATE SEQUENCE "unidad"."cat_modelo_iidmodelo_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for cat_unidad_tipo_iidunidad_tipo_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "unidad"."cat_unidad_tipo_iidunidad_tipo_seq";
CREATE SEQUENCE "unidad"."cat_unidad_tipo_iidunidad_tipo_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_unidad_iidunidad_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "unidad"."tbl_unidad_iidunidad_seq";
CREATE SEQUENCE "unidad"."tbl_unidad_iidunidad_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Table structure for cat_cobertura_tipo
-- ----------------------------
DROP TABLE IF EXISTS "unidad"."cat_cobertura_tipo";
CREATE TABLE "unidad"."cat_cobertura_tipo" (
  "iidcobertura" int4 NOT NULL DEFAULT nextval('"unidad".cat_cobertura_tipo_iidcobertura_seq'::regclass),
  "txtnombre" text COLLATE "pg_catalog"."default",
  "bactivo" bool DEFAULT true,
  "dtfecha_creacion" timestamp(6),
  "dtfecha_modificacion" timestamp(6)
)
;
COMMENT ON COLUMN "unidad"."cat_cobertura_tipo"."iidcobertura" IS 'Identificador único';

-- ----------------------------
-- Records of cat_cobertura_tipo
-- ----------------------------

-- ----------------------------
-- Table structure for cat_empresa
-- ----------------------------
DROP TABLE IF EXISTS "unidad"."cat_empresa";
CREATE TABLE "unidad"."cat_empresa" (
  "iidempresa" int4 NOT NULL DEFAULT nextval('"unidad".cat_empresa_iidempresa_seq'::regclass),
  "txtnombre" text COLLATE "pg_catalog"."default",
  "bactivo" bool DEFAULT true,
  "dtfecha_creacion" timestamp(6),
  "dtfecha_modificacion" timestamp(6)
)
;
COMMENT ON COLUMN "unidad"."cat_empresa"."iidempresa" IS 'Identificador único';
COMMENT ON TABLE "unidad"."cat_empresa" IS 'Empresas registradas';

-- ----------------------------
-- Records of cat_empresa
-- ----------------------------

-- ----------------------------
-- Table structure for cat_marca
-- ----------------------------
DROP TABLE IF EXISTS "unidad"."cat_marca";
CREATE TABLE "unidad"."cat_marca" (
  "iidmarca" int4 NOT NULL DEFAULT nextval('"unidad".cat_marca_iidmarca_seq'::regclass),
  "txtnombre" text COLLATE "pg_catalog"."default",
  "bactivo" bool DEFAULT true,
  "dtfecha_creacion" timestamp(6),
  "dtfecha_modificacion" timestamp(6)
)
;
COMMENT ON COLUMN "unidad"."cat_marca"."iidmarca" IS 'Identificador único';

-- ----------------------------
-- Records of cat_marca
-- ----------------------------

-- ----------------------------
-- Table structure for cat_modelo
-- ----------------------------
DROP TABLE IF EXISTS "unidad"."cat_modelo";
CREATE TABLE "unidad"."cat_modelo" (
  "iidmodelo" int4 NOT NULL DEFAULT nextval('"unidad".cat_modelo_iidmodelo_seq'::regclass),
  "iidmarca" int4,
  "txtnombre" text COLLATE "pg_catalog"."default",
  "bactivo" bool DEFAULT true,
  "dtfecha_creacion" timestamp(6),
  "dtfecha_modificacion" timestamp(6)
)
;
COMMENT ON COLUMN "unidad"."cat_modelo"."iidmodelo" IS 'Identificador único';

-- ----------------------------
-- Records of cat_modelo
-- ----------------------------

-- ----------------------------
-- Table structure for cat_unidad_tipo
-- ----------------------------
DROP TABLE IF EXISTS "unidad"."cat_unidad_tipo";
CREATE TABLE "unidad"."cat_unidad_tipo" (
  "iidunidad_tipo" int4 NOT NULL DEFAULT nextval('"unidad".cat_unidad_tipo_iidunidad_tipo_seq'::regclass),
  "txtnombre" text COLLATE "pg_catalog"."default",
  "bactivo" bool DEFAULT true,
  "dtfecha_creacion" timestamp(6),
  "dtfecha_modificacion" timestamp(6)
)
;
COMMENT ON COLUMN "unidad"."cat_unidad_tipo"."iidunidad_tipo" IS 'Identificador único';

-- ----------------------------
-- Records of cat_unidad_tipo
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_unidad
-- ----------------------------
DROP TABLE IF EXISTS "unidad"."tbl_unidad";
CREATE TABLE "unidad"."tbl_unidad" (
  "iidunidad" int4 NOT NULL DEFAULT nextval('"unidad".tbl_unidad_iidunidad_seq'::regclass),
  "iidempresa" int4,
  "iidcobertura" int4,
  "iidunidad_tipo" int4,
  "iidmarca" int4,
  "txtpoliza" text COLLATE "pg_catalog"."default",
  "txttarjeta_circulacion" text COLLATE "pg_catalog"."default",
  "dpoliza_expiracion" date,
  "dtarjeta_circulacion_expiracion" date,
  "bactivo" bool DEFAULT true,
  "dtfecha_creacion" timestamp(6),
  "dtfecha_modificacion" timestamp(6)
)
;
COMMENT ON COLUMN "unidad"."tbl_unidad"."iidunidad" IS 'Identificador único';
COMMENT ON TABLE "unidad"."tbl_unidad" IS 'Catálogo de unidades';

-- ----------------------------
-- Records of tbl_unidad
-- ----------------------------

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "unidad"."cat_cobertura_tipo_iidcobertura_seq"
OWNED BY "unidad"."cat_cobertura_tipo"."iidcobertura";
SELECT setval('"unidad"."cat_cobertura_tipo_iidcobertura_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "unidad"."cat_empresa_iidempresa_seq"
OWNED BY "unidad"."cat_empresa"."iidempresa";
SELECT setval('"unidad"."cat_empresa_iidempresa_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "unidad"."cat_marca_iidmarca_seq"
OWNED BY "unidad"."cat_marca"."iidmarca";
SELECT setval('"unidad"."cat_marca_iidmarca_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "unidad"."cat_modelo_iidmodelo_seq"
OWNED BY "unidad"."cat_modelo"."iidmodelo";
SELECT setval('"unidad"."cat_modelo_iidmodelo_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "unidad"."cat_unidad_tipo_iidunidad_tipo_seq"
OWNED BY "unidad"."cat_unidad_tipo"."iidunidad_tipo";
SELECT setval('"unidad"."cat_unidad_tipo_iidunidad_tipo_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "unidad"."tbl_unidad_iidunidad_seq"
OWNED BY "unidad"."tbl_unidad"."iidunidad";
SELECT setval('"unidad"."tbl_unidad_iidunidad_seq"', 1, false);

-- ----------------------------
-- Primary Key structure for table cat_cobertura_tipo
-- ----------------------------
ALTER TABLE "unidad"."cat_cobertura_tipo" ADD CONSTRAINT "_copy_5" PRIMARY KEY ("iidcobertura");

-- ----------------------------
-- Primary Key structure for table cat_empresa
-- ----------------------------
ALTER TABLE "unidad"."cat_empresa" ADD CONSTRAINT "_copy_4" PRIMARY KEY ("iidempresa");

-- ----------------------------
-- Primary Key structure for table cat_marca
-- ----------------------------
ALTER TABLE "unidad"."cat_marca" ADD CONSTRAINT "_copy_2" PRIMARY KEY ("iidmarca");

-- ----------------------------
-- Primary Key structure for table cat_modelo
-- ----------------------------
ALTER TABLE "unidad"."cat_modelo" ADD CONSTRAINT "_copy_1" PRIMARY KEY ("iidmodelo");

-- ----------------------------
-- Primary Key structure for table cat_unidad_tipo
-- ----------------------------
ALTER TABLE "unidad"."cat_unidad_tipo" ADD CONSTRAINT "_copy_3" PRIMARY KEY ("iidunidad_tipo");

-- ----------------------------
-- Primary Key structure for table tbl_unidad
-- ----------------------------
ALTER TABLE "unidad"."tbl_unidad" ADD CONSTRAINT "tbl_unidad_pkey" PRIMARY KEY ("iidunidad");

-- ----------------------------
-- Foreign Keys structure for table cat_modelo
-- ----------------------------
ALTER TABLE "unidad"."cat_modelo" ADD CONSTRAINT "fk_cat_modelo_cat_marca_1" FOREIGN KEY ("iidmarca") REFERENCES "unidad"."cat_marca" ("iidmarca") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table tbl_unidad
-- ----------------------------
ALTER TABLE "unidad"."tbl_unidad" ADD CONSTRAINT "fk_cat_unidad_cat_cobertura_tipo_1" FOREIGN KEY ("iidcobertura") REFERENCES "unidad"."cat_cobertura_tipo" ("iidcobertura") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "unidad"."tbl_unidad" ADD CONSTRAINT "fk_cat_unidad_cat_empresa_1" FOREIGN KEY ("iidempresa") REFERENCES "unidad"."cat_empresa" ("iidempresa") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "unidad"."tbl_unidad" ADD CONSTRAINT "fk_cat_unidad_cat_marca_1" FOREIGN KEY ("iidmarca") REFERENCES "unidad"."cat_marca" ("iidmarca") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "unidad"."tbl_unidad" ADD CONSTRAINT "fk_cat_unidad_cat_unidad_tipo_1" FOREIGN KEY ("iidunidad_tipo") REFERENCES "unidad"."cat_unidad_tipo" ("iidunidad_tipo") ON DELETE NO ACTION ON UPDATE NO ACTION;
