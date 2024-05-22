/*
 Navicat Premium Data Transfer

 Source Server         : Local PostgreSQL 12 - 5432
 Source Server Type    : PostgreSQL
 Source Server Version : 120018
 Source Host           : localhost:5432
 Source Catalog        : siamt
 Source Schema         : inspeccion

 Target Server Type    : PostgreSQL
 Target Server Version : 120018
 File Encoding         : 65001

 Date: 16/05/2024 22:42:05
*/


-- ----------------------------
-- Sequence structure for cat_carga_trabajo_tipo_iidcarga_trabajo_tipo_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inspeccion"."cat_carga_trabajo_tipo_iidcarga_trabajo_tipo_seq";
CREATE SEQUENCE "inspeccion"."cat_carga_trabajo_tipo_iidcarga_trabajo_tipo_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for cat_inspector_categoria_iidinspector_categoria_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inspeccion"."cat_inspector_categoria_iidinspector_categoria_seq";
CREATE SEQUENCE "inspeccion"."cat_inspector_categoria_iidinspector_categoria_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for cat_turno_iidturno_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inspeccion"."cat_turno_iidturno_seq";
CREATE SEQUENCE "inspeccion"."cat_turno_iidturno_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_carga_trabajo_detalle_iidcarga_trabajo_detalle_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inspeccion"."tbl_carga_trabajo_detalle_iidcarga_trabajo_detalle_seq";
CREATE SEQUENCE "inspeccion"."tbl_carga_trabajo_detalle_iidcarga_trabajo_detalle_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_carga_trabajo_detalle_ins_iidcarga_trabajo_detalle_ins_seq1
-- ----------------------------
DROP SEQUENCE IF EXISTS "inspeccion"."tbl_carga_trabajo_detalle_ins_iidcarga_trabajo_detalle_ins_seq1";
CREATE SEQUENCE "inspeccion"."tbl_carga_trabajo_detalle_ins_iidcarga_trabajo_detalle_ins_seq1" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_carga_trabajo_detalle_ins_iidcarga_trabajo_detalle_insp_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inspeccion"."tbl_carga_trabajo_detalle_ins_iidcarga_trabajo_detalle_insp_seq";
CREATE SEQUENCE "inspeccion"."tbl_carga_trabajo_detalle_ins_iidcarga_trabajo_detalle_insp_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_carga_trabajo_iidcarga_trabajo_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inspeccion"."tbl_carga_trabajo_iidcarga_trabajo_seq";
CREATE SEQUENCE "inspeccion"."tbl_carga_trabajo_iidcarga_trabajo_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_carga_trabajo_turno_iidcarga_trabajo_turno_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inspeccion"."tbl_carga_trabajo_turno_iidcarga_trabajo_turno_seq";
CREATE SEQUENCE "inspeccion"."tbl_carga_trabajo_turno_iidcarga_trabajo_turno_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_carga_trabajo_turno_inspe_iidcarga_trabajo_turno_inspec_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inspeccion"."tbl_carga_trabajo_turno_inspe_iidcarga_trabajo_turno_inspec_seq";
CREATE SEQUENCE "inspeccion"."tbl_carga_trabajo_turno_inspe_iidcarga_trabajo_turno_inspec_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_inspector_iidinspector_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inspeccion"."tbl_inspector_iidinspector_seq";
CREATE SEQUENCE "inspeccion"."tbl_inspector_iidinspector_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for tbl_inspector_seguimiento_iidinspector_seguimiento_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "inspeccion"."tbl_inspector_seguimiento_iidinspector_seguimiento_seq";
CREATE SEQUENCE "inspeccion"."tbl_inspector_seguimiento_iidinspector_seguimiento_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Table structure for cat_carga_trabajo_tipo
-- ----------------------------
DROP TABLE IF EXISTS "inspeccion"."cat_carga_trabajo_tipo";
CREATE TABLE "inspeccion"."cat_carga_trabajo_tipo" (
  "iidcarga_trabajo_tipo" int4 NOT NULL DEFAULT nextval('"inspeccion".cat_carga_trabajo_tipo_iidcarga_trabajo_tipo_seq'::regclass),
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtdescripcion" text COLLATE "pg_catalog"."default",
  "breten" bool NOT NULL DEFAULT false,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
)
;
COMMENT ON COLUMN "inspeccion"."cat_carga_trabajo_tipo"."iidcarga_trabajo_tipo" IS 'Identificador único';
COMMENT ON COLUMN "inspeccion"."cat_carga_trabajo_tipo"."breten" IS 'cuando este activo el reten se tomara en cuenta un turno';

-- ----------------------------
-- Records of cat_carga_trabajo_tipo
-- ----------------------------
INSERT INTO "inspeccion"."cat_carga_trabajo_tipo" VALUES (1, 'Inspección urbana (aforo)', NULL, 'f', 't', '2024-03-28 11:25:56.48608', '2024-03-28 11:25:56.48608');
INSERT INTO "inspeccion"."cat_carga_trabajo_tipo" VALUES (2, 'Inspección foranea (retén)', NULL, 'f', 't', '2024-03-28 11:25:56.48608', '2024-03-28 11:25:56.48608');

-- ----------------------------
-- Table structure for cat_inspector_categoria
-- ----------------------------
DROP TABLE IF EXISTS "inspeccion"."cat_inspector_categoria";
CREATE TABLE "inspeccion"."cat_inspector_categoria" (
  "iidinspector_categoria" int4 NOT NULL DEFAULT nextval('"inspeccion".cat_inspector_categoria_iidinspector_categoria_seq'::regclass),
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtdescripcion" text COLLATE "pg_catalog"."default",
  "bcoordinador" bool DEFAULT false,
  "bgenera_boleta" bool DEFAULT false,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
)
;
COMMENT ON COLUMN "inspeccion"."cat_inspector_categoria"."iidinspector_categoria" IS 'Identificador único';

-- ----------------------------
-- Records of cat_inspector_categoria
-- ----------------------------
INSERT INTO "inspeccion"."cat_inspector_categoria" VALUES (1, 'Coordinador', NULL, 't', 'f', 't', '2024-03-28 11:25:40.754864', '2024-03-28 11:25:40.754864');
INSERT INTO "inspeccion"."cat_inspector_categoria" VALUES (2, 'Inspector nombrado', NULL, 'f', 't', 't', '2024-03-28 11:25:40.754864', '2024-03-28 11:25:40.754864');
INSERT INTO "inspeccion"."cat_inspector_categoria" VALUES (3, 'Inspector', NULL, 'f', 'f', 't', '2024-03-28 11:25:40.754864', '2024-03-28 11:25:40.754864');

-- ----------------------------
-- Table structure for cat_turno
-- ----------------------------
DROP TABLE IF EXISTS "inspeccion"."cat_turno";
CREATE TABLE "inspeccion"."cat_turno" (
  "iidturno" int4 NOT NULL DEFAULT nextval('"inspeccion".cat_turno_iidturno_seq'::regclass),
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtdescripcion" text COLLATE "pg_catalog"."default",
  "bruta_nocturna" bool NOT NULL DEFAULT false,
  "thora_inicio" time(6) NOT NULL,
  "thora_fin" time(6) NOT NULL,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
)
;
COMMENT ON COLUMN "inspeccion"."cat_turno"."iidturno" IS 'Identificador único';
COMMENT ON COLUMN "inspeccion"."cat_turno"."bruta_nocturna" IS 'Boolean que representa un turno que comprende dos dias (usualmente noche anterior - dia siguiente)';

-- ----------------------------
-- Records of cat_turno
-- ----------------------------
INSERT INTO "inspeccion"."cat_turno" VALUES (1, 'Matutino', NULL, 'f', '08:00:00', '14:00:00', 't', '2024-03-28 11:25:49.25123', '2024-03-28 11:25:49.25123');
INSERT INTO "inspeccion"."cat_turno" VALUES (2, 'Vespertino', NULL, 'f', '14:00:00', '20:00:00', 't', '2024-03-28 11:25:49.25123', '2024-03-28 11:25:49.25123');
INSERT INTO "inspeccion"."cat_turno" VALUES (3, 'Nocturno', NULL, 'f', '20:00:00', '02:00:00', 't', '2024-03-28 11:25:49.25123', '2024-03-28 11:25:49.25123');
INSERT INTO "inspeccion"."cat_turno" VALUES (4, 'Ruta nocturna', NULL, 'f', '02:00:00', '08:00:00', 't', '2024-03-28 11:25:49.25123', '2024-03-28 11:25:49.25123');

-- ----------------------------
-- Table structure for tbl_carga_trabajo
-- ----------------------------
DROP TABLE IF EXISTS "inspeccion"."tbl_carga_trabajo";
CREATE TABLE "inspeccion"."tbl_carga_trabajo" (
  "iidcarga_trabajo" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_carga_trabajo_iidcarga_trabajo_seq'::regclass),
  "iidzona" int4 NOT NULL,
  "dfecha_inicio" date NOT NULL DEFAULT now(),
  "dfecha_fin" date NOT NULL DEFAULT now(),
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtdescripcion" text COLLATE "pg_catalog"."default",
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Records of tbl_carga_trabajo
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_carga_trabajo_detalle
-- ----------------------------
DROP TABLE IF EXISTS "inspeccion"."tbl_carga_trabajo_detalle";
CREATE TABLE "inspeccion"."tbl_carga_trabajo_detalle" (
  "iidcarga_trabajo_detalle" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_carga_trabajo_detalle_iidcarga_trabajo_detalle_seq'::regclass),
  "iidcarga_trabajo" int4 NOT NULL,
  "iidcarga_trabajo_tipo" int4 NOT NULL,
  "iidcarga_trabajo_turno" int4,
  "txtdescripcion" text COLLATE "pg_catalog"."default",
  "thora_inicio" time(6),
  "thora_fin" time(6),
  "flatitud" float8,
  "flongitud" float8,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Records of tbl_carga_trabajo_detalle
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_carga_trabajo_detalle_inspector
-- ----------------------------
DROP TABLE IF EXISTS "inspeccion"."tbl_carga_trabajo_detalle_inspector";
CREATE TABLE "inspeccion"."tbl_carga_trabajo_detalle_inspector" (
  "iidcarga_trabajo_detalle_inspector" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_carga_trabajo_detalle_ins_iidcarga_trabajo_detalle_insp_seq'::regclass),
  "iidcarga_trabajo_detalle" int4 NOT NULL,
  "iidcarga_trabajo_turno_inspector" int4 NOT NULL,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Records of tbl_carga_trabajo_detalle_inspector
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_carga_trabajo_detalle_inspector_seguimiento
-- ----------------------------
DROP TABLE IF EXISTS "inspeccion"."tbl_carga_trabajo_detalle_inspector_seguimiento";
CREATE TABLE "inspeccion"."tbl_carga_trabajo_detalle_inspector_seguimiento" (
  "iidcarga_trabajo_detalle_inspector_seguimiento" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_carga_trabajo_detalle_ins_iidcarga_trabajo_detalle_ins_seq1'::regclass),
  "iidcarga_trabajo_detalle_inspector" int4 NOT NULL,
  "dtfecha_hora_inico" timestamp(6),
  "dtfecha_hora_fin" timestamp(6),
  "bactivo" bool NOT NULL DEFAULT false,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Records of tbl_carga_trabajo_detalle_inspector_seguimiento
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_carga_trabajo_turno
-- ----------------------------
DROP TABLE IF EXISTS "inspeccion"."tbl_carga_trabajo_turno";
CREATE TABLE "inspeccion"."tbl_carga_trabajo_turno" (
  "iidcarga_trabajo_turno" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_carga_trabajo_turno_iidcarga_trabajo_turno_seq'::regclass),
  "iidcarga_trabajo" int4 NOT NULL,
  "iidturno" int4 NOT NULL,
  "iidcoordinador" int4 NOT NULL,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Records of tbl_carga_trabajo_turno
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_carga_trabajo_turno_inspector
-- ----------------------------
DROP TABLE IF EXISTS "inspeccion"."tbl_carga_trabajo_turno_inspector";
CREATE TABLE "inspeccion"."tbl_carga_trabajo_turno_inspector" (
  "iidcarga_trabajo_turno_inspector" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_carga_trabajo_turno_inspe_iidcarga_trabajo_turno_inspec_seq'::regclass),
  "iidcarga_trabajo_turno" int4 NOT NULL,
  "iidinspector" int4 NOT NULL,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Records of tbl_carga_trabajo_turno_inspector
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_inspector
-- ----------------------------
DROP TABLE IF EXISTS "inspeccion"."tbl_inspector";
CREATE TABLE "inspeccion"."tbl_inspector" (
  "iidinspector" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_inspector_iidinspector_seq'::regclass),
  "iidpersona" int4 NOT NULL,
  "iidturno" int4 NOT NULL,
  "iidetapa" int4 NOT NULL,
  "iidsubetapa" int4 NOT NULL,
  "iidinspector_categoria" int4 NOT NULL,
  "txtfolio_inspector" text COLLATE "pg_catalog"."default",
  "dvigencia" date,
  "dfecha_alta" date,
  "dfecha_baja" date,
  "txtcomentarios" text COLLATE "pg_catalog"."default",
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Records of tbl_inspector
-- ----------------------------
INSERT INTO "inspeccion"."tbl_inspector" VALUES (4, 4, 1, 3, 5, 2, 'Folio', '2024-05-10', NULL, NULL, 'Come', 't', '2024-05-08 15:48:12.579478', '2024-05-16 11:35:23');
INSERT INTO "inspeccion"."tbl_inspector" VALUES (5, 6, 4, 3, 5, 3, 'Folio de prueba', NULL, NULL, NULL, '', 't', '2024-05-16 12:05:24.691907', '2024-05-16 12:14:09');

-- ----------------------------
-- Table structure for tbl_inspector_seguimiento
-- ----------------------------
DROP TABLE IF EXISTS "inspeccion"."tbl_inspector_seguimiento";
CREATE TABLE "inspeccion"."tbl_inspector_seguimiento" (
  "iidinspector_seguimiento" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_inspector_seguimiento_iidinspector_seguimiento_seq'::regclass),
  "iidinspector" int4 NOT NULL,
  "iidetapa_anterior" int4 NOT NULL,
  "iidsubetapa_anterior" int4,
  "iidetapa_actual" int4 NOT NULL,
  "iidsubetapa_actual" int4,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Records of tbl_inspector_seguimiento
-- ----------------------------
INSERT INTO "inspeccion"."tbl_inspector_seguimiento" VALUES (19, 4, 1, 1, 1, 1, 't', '2024-05-08 15:48:12.579478', '2024-05-08 15:48:12.579478');
INSERT INTO "inspeccion"."tbl_inspector_seguimiento" VALUES (20, 4, 1, 1, 1, 2, 't', '2024-05-08 16:05:45.019526', '2024-05-08 16:05:45.019526');
INSERT INTO "inspeccion"."tbl_inspector_seguimiento" VALUES (21, 4, 1, 2, 1, 3, 't', '2024-05-08 16:08:50.290048', '2024-05-08 16:08:50.290048');
INSERT INTO "inspeccion"."tbl_inspector_seguimiento" VALUES (22, 4, 1, 3, 3, 5, 't', '2024-05-08 17:08:55.475468', '2024-05-08 17:08:55.475468');
INSERT INTO "inspeccion"."tbl_inspector_seguimiento" VALUES (23, 5, 1, 1, 1, 1, 't', '2024-05-16 12:05:24.691907', '2024-05-16 12:05:24.691907');
INSERT INTO "inspeccion"."tbl_inspector_seguimiento" VALUES (24, 5, 1, 1, 1, 2, 't', '2024-05-16 12:12:25.848321', '2024-05-16 12:12:25.848321');
INSERT INTO "inspeccion"."tbl_inspector_seguimiento" VALUES (25, 5, 1, 2, 3, 5, 't', '2024-05-16 12:14:09.254843', '2024-05-16 12:14:09.254843');

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inspeccion"."cat_carga_trabajo_tipo_iidcarga_trabajo_tipo_seq"
OWNED BY "inspeccion"."cat_carga_trabajo_tipo"."iidcarga_trabajo_tipo";
SELECT setval('"inspeccion"."cat_carga_trabajo_tipo_iidcarga_trabajo_tipo_seq"', 2, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inspeccion"."cat_inspector_categoria_iidinspector_categoria_seq"
OWNED BY "inspeccion"."cat_inspector_categoria"."iidinspector_categoria";
SELECT setval('"inspeccion"."cat_inspector_categoria_iidinspector_categoria_seq"', 3, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inspeccion"."cat_turno_iidturno_seq"
OWNED BY "inspeccion"."cat_turno"."iidturno";
SELECT setval('"inspeccion"."cat_turno_iidturno_seq"', 4, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inspeccion"."tbl_carga_trabajo_detalle_iidcarga_trabajo_detalle_seq"
OWNED BY "inspeccion"."tbl_carga_trabajo_detalle"."iidcarga_trabajo_detalle";
SELECT setval('"inspeccion"."tbl_carga_trabajo_detalle_iidcarga_trabajo_detalle_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inspeccion"."tbl_carga_trabajo_detalle_ins_iidcarga_trabajo_detalle_ins_seq1"
OWNED BY "inspeccion"."tbl_carga_trabajo_detalle_inspector_seguimiento"."iidcarga_trabajo_detalle_inspector_seguimiento";
SELECT setval('"inspeccion"."tbl_carga_trabajo_detalle_ins_iidcarga_trabajo_detalle_ins_seq1"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inspeccion"."tbl_carga_trabajo_detalle_ins_iidcarga_trabajo_detalle_insp_seq"
OWNED BY "inspeccion"."tbl_carga_trabajo_detalle_inspector"."iidcarga_trabajo_detalle_inspector";
SELECT setval('"inspeccion"."tbl_carga_trabajo_detalle_ins_iidcarga_trabajo_detalle_insp_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inspeccion"."tbl_carga_trabajo_iidcarga_trabajo_seq"
OWNED BY "inspeccion"."tbl_carga_trabajo"."iidcarga_trabajo";
SELECT setval('"inspeccion"."tbl_carga_trabajo_iidcarga_trabajo_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inspeccion"."tbl_carga_trabajo_turno_iidcarga_trabajo_turno_seq"
OWNED BY "inspeccion"."tbl_carga_trabajo_turno"."iidcarga_trabajo_turno";
SELECT setval('"inspeccion"."tbl_carga_trabajo_turno_iidcarga_trabajo_turno_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inspeccion"."tbl_carga_trabajo_turno_inspe_iidcarga_trabajo_turno_inspec_seq"
OWNED BY "inspeccion"."tbl_carga_trabajo_turno_inspector"."iidcarga_trabajo_turno_inspector";
SELECT setval('"inspeccion"."tbl_carga_trabajo_turno_inspe_iidcarga_trabajo_turno_inspec_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inspeccion"."tbl_inspector_iidinspector_seq"
OWNED BY "inspeccion"."tbl_inspector"."iidinspector";
SELECT setval('"inspeccion"."tbl_inspector_iidinspector_seq"', 5, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inspeccion"."tbl_inspector_seguimiento_iidinspector_seguimiento_seq"
OWNED BY "inspeccion"."tbl_inspector_seguimiento"."iidinspector_seguimiento";
SELECT setval('"inspeccion"."tbl_inspector_seguimiento_iidinspector_seguimiento_seq"', 25, true);

-- ----------------------------
-- Primary Key structure for table cat_carga_trabajo_tipo
-- ----------------------------
ALTER TABLE "inspeccion"."cat_carga_trabajo_tipo" ADD CONSTRAINT "cat_carga_trabajo_tipo_pkey" PRIMARY KEY ("iidcarga_trabajo_tipo");

-- ----------------------------
-- Primary Key structure for table cat_inspector_categoria
-- ----------------------------
ALTER TABLE "inspeccion"."cat_inspector_categoria" ADD CONSTRAINT "cat_inspector_categoria_pkey" PRIMARY KEY ("iidinspector_categoria");

-- ----------------------------
-- Primary Key structure for table cat_turno
-- ----------------------------
ALTER TABLE "inspeccion"."cat_turno" ADD CONSTRAINT "cat_turno_pkey" PRIMARY KEY ("iidturno");

-- ----------------------------
-- Primary Key structure for table tbl_carga_trabajo
-- ----------------------------
ALTER TABLE "inspeccion"."tbl_carga_trabajo" ADD CONSTRAINT "tbl_carga_trabajo_pkey" PRIMARY KEY ("iidcarga_trabajo");

-- ----------------------------
-- Primary Key structure for table tbl_carga_trabajo_detalle
-- ----------------------------
ALTER TABLE "inspeccion"."tbl_carga_trabajo_detalle" ADD CONSTRAINT "tbl_carga_trabajo_detalle_pkey" PRIMARY KEY ("iidcarga_trabajo_detalle");

-- ----------------------------
-- Primary Key structure for table tbl_carga_trabajo_detalle_inspector
-- ----------------------------
ALTER TABLE "inspeccion"."tbl_carga_trabajo_detalle_inspector" ADD CONSTRAINT "tbl_carga_trabajo_detalle_inspector_pkey" PRIMARY KEY ("iidcarga_trabajo_detalle_inspector");

-- ----------------------------
-- Primary Key structure for table tbl_carga_trabajo_detalle_inspector_seguimiento
-- ----------------------------
ALTER TABLE "inspeccion"."tbl_carga_trabajo_detalle_inspector_seguimiento" ADD CONSTRAINT "tbl_carga_trabajo_detalle_inspector_seguimiento_pkey" PRIMARY KEY ("iidcarga_trabajo_detalle_inspector_seguimiento");

-- ----------------------------
-- Primary Key structure for table tbl_carga_trabajo_turno
-- ----------------------------
ALTER TABLE "inspeccion"."tbl_carga_trabajo_turno" ADD CONSTRAINT "tbl_carga_trabajo_turno_pkey" PRIMARY KEY ("iidcarga_trabajo_turno");

-- ----------------------------
-- Primary Key structure for table tbl_carga_trabajo_turno_inspector
-- ----------------------------
ALTER TABLE "inspeccion"."tbl_carga_trabajo_turno_inspector" ADD CONSTRAINT "tbl_carga_trabajo_turno_inspector_pkey" PRIMARY KEY ("iidcarga_trabajo_turno_inspector");

-- ----------------------------
-- Primary Key structure for table tbl_inspector
-- ----------------------------
ALTER TABLE "inspeccion"."tbl_inspector" ADD CONSTRAINT "tbl_inspector_pkey" PRIMARY KEY ("iidinspector");

-- ----------------------------
-- Primary Key structure for table tbl_inspector_seguimiento
-- ----------------------------
ALTER TABLE "inspeccion"."tbl_inspector_seguimiento" ADD CONSTRAINT "tbl_inspector_seguimiento_pkey" PRIMARY KEY ("iidinspector_seguimiento");
