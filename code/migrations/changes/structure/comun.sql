/*
 Navicat Premium Data Transfer

 Source Server         : Local PostgreSQL 12 - 5432
 Source Server Type    : PostgreSQL
 Source Server Version : 120018
 Source Host           : localhost:5432
 Source Catalog        : siamt
 Source Schema         : comun

 Target Server Type    : PostgreSQL
 Target Server Version : 120018
 File Encoding         : 65001

 Date: 16/05/2024 22:41:58
*/


-- ----------------------------
-- Sequence structure for cat_etapa_iidetapa_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "comun"."cat_etapa_iidetapa_seq";
CREATE SEQUENCE "comun"."cat_etapa_iidetapa_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for cat_flujo_iidflujo_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "comun"."cat_flujo_iidflujo_seq";
CREATE SEQUENCE "comun"."cat_flujo_iidflujo_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for cat_proceso_iidproceso_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "comun"."cat_proceso_iidproceso_seq";
CREATE SEQUENCE "comun"."cat_proceso_iidproceso_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for cat_subetapa_iidsubetapa_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "comun"."cat_subetapa_iidsubetapa_seq";
CREATE SEQUENCE "comun"."cat_subetapa_iidsubetapa_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Table structure for cat_etapa
-- ----------------------------
DROP TABLE IF EXISTS "comun"."cat_etapa";
CREATE TABLE "comun"."cat_etapa" (
  "iidetapa" int4 NOT NULL DEFAULT nextval('"comun".cat_etapa_iidetapa_seq'::regclass),
  "iidproceso" int4 NOT NULL,
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtsigla" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtdescripcion" text COLLATE "pg_catalog"."default",
  "txtcolor" text COLLATE "pg_catalog"."default",
  "txtpermiso" text COLLATE "pg_catalog"."default",
  "binicial" bool NOT NULL DEFAULT false,
  "bfinal" bool NOT NULL DEFAULT false,
  "bcancelacion" bool NOT NULL DEFAULT false,
  "brequiere_motivo" bool NOT NULL DEFAULT false,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
)
;
COMMENT ON COLUMN "comun"."cat_etapa"."iidetapa" IS 'Identificador único';

-- ----------------------------
-- Records of cat_etapa
-- ----------------------------
INSERT INTO "comun"."cat_etapa" VALUES (1, 1, 'Prospecto', 'MJCU', 'Ejemplo etapa 1', 'blue', NULL, 'f', 'f', 'f', 'f', 't', '2024-03-28 11:25:49.25123', '2024-03-28 11:25:49.25123');
INSERT INTO "comun"."cat_etapa" VALUES (3, 1, 'Vigente', 'BOLE', 'Ejemplo etapa 2', 'green', NULL, 'f', 'f', 'f', 'f', 't', '2024-04-05 14:04:52.451219', '2024-04-05 14:04:52.451219');
INSERT INTO "comun"."cat_etapa" VALUES (5, 3, 'Captura de inspección', 'MCUU', 'Ejemplo etapa 1', 'blue', NULL, 'f', 'f', 'f', 'f', 't', '2024-04-05 15:16:16.210524', '2024-04-05 15:16:16.210524');
INSERT INTO "comun"."cat_etapa" VALUES (6, 3, 'Generación de Boleta', 'MJCU', 'Ejemplo etapa 2', 'green', NULL, 'f', 'f', 'f', 'f', 't', '2024-04-18 03:51:40.002294', '2024-04-18 03:51:40.002294');
INSERT INTO "comun"."cat_etapa" VALUES (8, 3, 'Inspección Finalizada', 'INSP', 'Ejemplo etapa 3', NULL, NULL, 'f', 'f', 'f', 'f', 't', '2024-04-18 03:56:27.28293', '2024-04-18 03:56:27.28293');
INSERT INTO "comun"."cat_etapa" VALUES (14, 4, 'ds', 'df', 'de', '#ff0000', 'wewew', 't', 'f', 't', 'f', 't', '2024-05-13 21:25:51', '2024-05-13 21:25:51.265568');
INSERT INTO "comun"."cat_etapa" VALUES (15, 4, 'dwdwd', 'dwdw', 'dwdwd', '#f50000', 'dswdw', 'f', 't', 'f', 't', 't', '2024-05-13 21:27:56', '2024-05-13 21:27:56.448618');
INSERT INTO "comun"."cat_etapa" VALUES (4, 1, 'Baja', 'BAJA', 'Ejemplo etapa 3', '#ff0000', NULL, 't', 'f', 't', 'f', 't', '2024-04-05 14:09:17.514022', '2024-05-14 20:48:19');

-- ----------------------------
-- Table structure for cat_flujo
-- ----------------------------
DROP TABLE IF EXISTS "comun"."cat_flujo";
CREATE TABLE "comun"."cat_flujo" (
  "iidflujo" int4 NOT NULL DEFAULT nextval('"comun".cat_flujo_iidflujo_seq'::regclass),
  "iidsubetapa" int4 NOT NULL,
  "iidsubetapa_siguiente" int4 NOT NULL,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
)
;
COMMENT ON COLUMN "comun"."cat_flujo"."iidflujo" IS 'Identificador único';

-- ----------------------------
-- Records of cat_flujo
-- ----------------------------
INSERT INTO "comun"."cat_flujo" VALUES (10, 1, 2, 't', '2024-05-15 00:36:42.870709', '2024-05-15 00:36:42.870709');
INSERT INTO "comun"."cat_flujo" VALUES (11, 2, 3, 't', '2024-05-15 00:36:52.836942', '2024-05-15 00:36:52.836942');
INSERT INTO "comun"."cat_flujo" VALUES (14, 2, 5, 't', '2024-05-15 00:39:34.523031', '2024-05-15 00:39:34.523031');
INSERT INTO "comun"."cat_flujo" VALUES (15, 3, 6, 't', '2024-05-15 00:40:06.886814', '2024-05-15 00:40:06.886814');

-- ----------------------------
-- Table structure for cat_proceso
-- ----------------------------
DROP TABLE IF EXISTS "comun"."cat_proceso";
CREATE TABLE "comun"."cat_proceso" (
  "iidproceso" int4 NOT NULL DEFAULT nextval('"comun".cat_proceso_iidproceso_seq'::regclass),
  "iidmodulo" int4 NOT NULL,
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtdescripcion" text COLLATE "pg_catalog"."default",
  "txtsigla" text COLLATE "pg_catalog"."default" NOT NULL,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
)
;
COMMENT ON COLUMN "comun"."cat_proceso"."iidproceso" IS 'Identificador único';

-- ----------------------------
-- Records of cat_proceso
-- ----------------------------
INSERT INTO "comun"."cat_proceso" VALUES (1, 11, 'Registro de inspector', 'Proceso de inscripción de inspectores', 'MJCU', 't', '2024-03-28 11:25:49.25123', '2024-03-28 11:25:49.25123');
INSERT INTO "comun"."cat_proceso" VALUES (3, 1, 'Registro de Inspección', 'Proceso llevado a cabo para registrar una inspección', 'MJCC', 't', '2024-04-05 14:06:51.63241', '2024-04-05 14:06:51.63241');
INSERT INTO "comun"."cat_proceso" VALUES (4, 4, 'Daaa', 'Eweww', 'FRFR', 'f', '2024-05-13 16:58:52', '2024-05-14 20:47:01');

-- ----------------------------
-- Table structure for cat_subetapa
-- ----------------------------
DROP TABLE IF EXISTS "comun"."cat_subetapa";
CREATE TABLE "comun"."cat_subetapa" (
  "iidsubetapa" int4 NOT NULL DEFAULT nextval('"comun".cat_subetapa_iidsubetapa_seq'::regclass),
  "iidetapa" int4 NOT NULL,
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtsigla" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtdescripcion" text COLLATE "pg_catalog"."default",
  "txtcolor" text COLLATE "pg_catalog"."default",
  "txtpermiso" text COLLATE "pg_catalog"."default",
  "binicial" bool NOT NULL DEFAULT false,
  "bfinal" bool NOT NULL DEFAULT false,
  "bcancelacion" bool NOT NULL DEFAULT false,
  "brequiere_motivo" bool NOT NULL DEFAULT false,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
)
;
COMMENT ON COLUMN "comun"."cat_subetapa"."iidsubetapa" IS 'Identificador único';

-- ----------------------------
-- Records of cat_subetapa
-- ----------------------------
INSERT INTO "comun"."cat_subetapa" VALUES (2, 1, 'Prueba de habilidades', 'MJC1', 'Ejemplo subetapa 2', 'blue', NULL, 'f', 'f', 'f', 'f', 't', '2024-04-05 10:43:15.168923', '2024-04-05 10:43:15.168923');
INSERT INTO "comun"."cat_subetapa" VALUES (3, 1, 'Contratado', 'MJC1', 'Ejemplo subetapa 3', 'green', NULL, 'f', 'f', 'f', 'f', 't', '2024-04-05 14:11:53.584827', '2024-04-05 14:11:53.584827');
INSERT INTO "comun"."cat_subetapa" VALUES (5, 3, 'Subetapa 1 etapa 2', 'MJC2', 'Ejemplo subetapa 1', 'yellow', NULL, 'f', 'f', 'f', 'f', 't', '2024-04-05 14:14:49.123717', '2024-04-05 14:14:49.123717');
INSERT INTO "comun"."cat_subetapa" VALUES (6, 3, 'Subeteapa 2 etapa 2', 'MJC2', 'Ejemplo subetapa 2', NULL, NULL, 'f', 'f', 'f', 'f', 't', '2024-04-05 14:15:08.271951', '2024-04-05 14:15:08.271951');
INSERT INTO "comun"."cat_subetapa" VALUES (7, 4, 'Subetapa 1 etapa 3', 'MJC3', 'Ejemplo subetapa 1', NULL, NULL, 'f', 'f', 'f', 'f', 't', '2024-04-05 14:15:31.696727', '2024-04-05 14:15:31.696727');
INSERT INTO "comun"."cat_subetapa" VALUES (8, 5, 'Verificación de documentos', 'VER1', 'Ejemplo subetapa 1', 'orange', NULL, 'f', 'f', 'f', 'f', 't', '2024-04-18 03:54:27.827992', '2024-04-18 03:54:27.827992');
INSERT INTO "comun"."cat_subetapa" VALUES (9, 5, 'Verificación de vehículo', 'VER2', 'Ejemplo subetapa 2', 'green', NULL, 'f', 'f', 'f', 'f', 't', '2024-04-18 03:54:27.827992', '2024-04-18 03:54:27.827992');
INSERT INTO "comun"."cat_subetapa" VALUES (11, 5, 'Finalizado-Boleta', 'VER3', 'Ejemplo subetapa 3', NULL, NULL, 'f', 'f', 'f', 'f', 't', '2024-04-18 03:55:39.730616', '2024-04-18 03:55:39.730616');
INSERT INTO "comun"."cat_subetapa" VALUES (12, 6, 'Generación de Boleta', 'BOLE', 'Ejemplo subetapa multiple', NULL, NULL, 'f', 'f', 'f', 'f', 't', '2024-04-18 03:57:39.265726', '2024-04-18 03:57:39.265726');
INSERT INTO "comun"."cat_subetapa" VALUES (13, 8, 'Inspección finalizada', 'MJCU2', 'Ejemplo subetapa multiple 2', NULL, NULL, 'f', 'f', 'f', 'f', 't', '2024-04-18 03:58:33.244899', '2024-04-18 03:58:33.244899');
INSERT INTO "comun"."cat_subetapa" VALUES (14, 8, 'aaaaa', 'aaaa', 'aaaaa', '#b5f330', 'qqqqq', 'f', 'f', 'f', 't', 'f', '2024-05-13 21:34:56', '2024-05-14 20:53:56');
INSERT INTO "comun"."cat_subetapa" VALUES (1, 1, 'Entrevista', 'MJC1', 'Ejemplo subetapa 1', 'orange', NULL, 't', 'f', 'f', 'f', 't', '2024-03-28 11:25:49.25123', '2024-03-28 11:25:49.25123');

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "comun"."cat_etapa_iidetapa_seq"
OWNED BY "comun"."cat_etapa"."iidetapa";
SELECT setval('"comun"."cat_etapa_iidetapa_seq"', 15, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "comun"."cat_flujo_iidflujo_seq"
OWNED BY "comun"."cat_flujo"."iidflujo";
SELECT setval('"comun"."cat_flujo_iidflujo_seq"', 17, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "comun"."cat_proceso_iidproceso_seq"
OWNED BY "comun"."cat_proceso"."iidproceso";
SELECT setval('"comun"."cat_proceso_iidproceso_seq"', 4, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "comun"."cat_subetapa_iidsubetapa_seq"
OWNED BY "comun"."cat_subetapa"."iidsubetapa";
SELECT setval('"comun"."cat_subetapa_iidsubetapa_seq"', 14, true);

-- ----------------------------
-- Primary Key structure for table cat_etapa
-- ----------------------------
ALTER TABLE "comun"."cat_etapa" ADD CONSTRAINT "cat_etapa_pkey" PRIMARY KEY ("iidetapa");

-- ----------------------------
-- Primary Key structure for table cat_flujo
-- ----------------------------
ALTER TABLE "comun"."cat_flujo" ADD CONSTRAINT "cat_flujo_pkey" PRIMARY KEY ("iidflujo");

-- ----------------------------
-- Primary Key structure for table cat_proceso
-- ----------------------------
ALTER TABLE "comun"."cat_proceso" ADD CONSTRAINT "cat_proceso_pkey" PRIMARY KEY ("iidproceso");

-- ----------------------------
-- Primary Key structure for table cat_subetapa
-- ----------------------------
ALTER TABLE "comun"."cat_subetapa" ADD CONSTRAINT "cat_subetapa_pkey" PRIMARY KEY ("iidsubetapa");

-- ----------------------------
-- Foreign Keys structure for table cat_etapa
-- ----------------------------
ALTER TABLE "comun"."cat_etapa" ADD CONSTRAINT "fk_cat_etapa_cat_proceso_iidproceso" FOREIGN KEY ("iidproceso") REFERENCES "comun"."cat_proceso" ("iidproceso") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cat_flujo
-- ----------------------------
ALTER TABLE "comun"."cat_flujo" ADD CONSTRAINT "fk_cat_flujo_cat_subetapa_iidsubetapa" FOREIGN KEY ("iidsubetapa") REFERENCES "comun"."cat_subetapa" ("iidsubetapa") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "comun"."cat_flujo" ADD CONSTRAINT "fk_cat_flujo_cat_subetapa_iidsubetapa_siguiente" FOREIGN KEY ("iidsubetapa_siguiente") REFERENCES "comun"."cat_subetapa" ("iidsubetapa") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cat_subetapa
-- ----------------------------
ALTER TABLE "comun"."cat_subetapa" ADD CONSTRAINT "fk_cat_subetapa_cat_etapa_iidetapa" FOREIGN KEY ("iidetapa") REFERENCES "comun"."cat_etapa" ("iidetapa") ON DELETE NO ACTION ON UPDATE NO ACTION;
