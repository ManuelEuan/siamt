/*
 Navicat Premium Data Transfer

 Source Server         : Local PostgreSQL 12 - 5432
 Source Server Type    : PostgreSQL
 Source Server Version : 120018
 Source Host           : localhost:5432
 Source Catalog        : siamt
 Source Schema         : usuario

 Target Server Type    : PostgreSQL
 Target Server Version : 120018
 File Encoding         : 65001

 Date: 16/05/2024 22:42:25
*/


-- ----------------------------
-- Type structure for data_t
-- ----------------------------
DROP TYPE IF EXISTS "usuario"."data_t";
CREATE TYPE "usuario"."data_t" AS ENUM (
  'string',
  'number',
  'boolean',
  'array'
);
ALTER TYPE "usuario"."data_t" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for cat_firma_plantilla_iid_firma_plantilla_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "usuario"."cat_firma_plantilla_iid_firma_plantilla_seq";
CREATE SEQUENCE "usuario"."cat_firma_plantilla_iid_firma_plantilla_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for dominio_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "usuario"."dominio_id_seq";
CREATE SEQUENCE "usuario"."dominio_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for modulo_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "usuario"."modulo_id_seq";
CREATE SEQUENCE "usuario"."modulo_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for perfil_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "usuario"."perfil_id_seq";
CREATE SEQUENCE "usuario"."perfil_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for permiso_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "usuario"."permiso_id_seq";
CREATE SEQUENCE "usuario"."permiso_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for usuario_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "usuario"."usuario_id_seq";
CREATE SEQUENCE "usuario"."usuario_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Table structure for cat_firma_plantilla
-- ----------------------------
DROP TABLE IF EXISTS "usuario"."cat_firma_plantilla";
CREATE TABLE "usuario"."cat_firma_plantilla" (
  "iidfirma_plantilla" int4 NOT NULL DEFAULT nextval('"usuario".cat_firma_plantilla_iid_firma_plantilla_seq'::regclass),
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtplantilla" text COLLATE "pg_catalog"."default" NOT NULL,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6),
  "dtfecha_modificacion" timestamp(6)
)
;

-- ----------------------------
-- Records of cat_firma_plantilla
-- ----------------------------
INSERT INTO "usuario"."cat_firma_plantilla" VALUES (1, 'Agencia de Transporte de Yucatán (ATY)', '%3Cimg%20style%3D%22margin-top%3A%205rem%3B%20padding%3A%200px%202rem%200px%201rem%3B%20float%3A%20left%3B%20width%3A%2035%25%3B%22%20src%3D%22..%2Fimages%2Faty.png%22%20alt%3D%22%22%20%2F%3E%0A%3Cdiv%20class%3D%22px-4%20pt-1%22%20style%3D%22border-left%3A%203px%20solid%20%23444444%3B%20float%3A%20left%3B%20max-width%3A%2065%25%3B%20height%3A%20195px%3B%22%3E%0A%3Cdiv%20class%3D%22pb-4%22%20style%3D%22font-weight%3A%20800%3B%20font-size%3A%201.8em%3B%20color%3A%20%23242f5d%3B%20font-family%3A%20''Helvetica%20Neue''%3B%22%3E%7B%25%25NOMBRE_COMPLETO%25%25%7D%3C%2Fdiv%3E%0A%3Cdiv%20class%3D%22pb-3%22%20style%3D%22font-weight%3A%20bold%3B%20font-size%3A%201.6em%3B%20color%3A%20%23242f5d%3B%20font-family%3A%20''Helvetica%20Neue''%3B%22%3E%3Cspan%20style%3D%22color%3A%20%2359af31%3B%20font-family%3A%20Panton%3B%22%3E%7B%25%25DEPENDENCIA%25%25%7D%3C%2Fspan%3E%3C%2Fdiv%3E%0A%3Cdiv%20class%3D%22pb-1%22%20style%3D%22font-weight%3A%20bold%3B%20font-size%3A%2014pt%3B%20color%3A%20%23242f5d%3B%20font-family%3A%20''Helvetica%20Neue''%3B%22%3E%7B%25%25PUESTO%25%25%7D%3C%2Fdiv%3E%0A%3Cdiv%20class%3D%22pb-1%22%20style%3D%22font-weight%3A%20bold%3B%20font-size%3A%2014pt%3B%20color%3A%20%23242f5d%3B%20font-family%3A%20''Helvetica%20Neue''%3B%22%3E%7B%25%25DEPARTAMENTO%25%25%7D%3C%2Fdiv%3E%0A%3Cdiv%20class%3D%22pb-1%22%20style%3D%22font-weight%3A%20bold%3B%20font-size%3A%2014pt%3B%20color%3A%20%23242f5d%3B%20font-family%3A%20''Helvetica%20Neue''%3B%22%3E%7B%25%25OFICINA%25%25%7D%20--%20%7B%25%25TELEFONO%25%25%7D%3C%2Fdiv%3E%0A%3C%2Fdiv%3E', 't', '2024-05-08 09:01:55', '2024-05-09 12:41:52.194842');

-- ----------------------------
-- Table structure for dominio
-- ----------------------------
DROP TABLE IF EXISTS "usuario"."dominio";
CREATE TABLE "usuario"."dominio" (
  "id" int4 NOT NULL DEFAULT nextval('"usuario".dominio_id_seq'::regclass),
  "nombre" varchar(48) COLLATE "pg_catalog"."default" NOT NULL,
  "descripcion" varchar(48) COLLATE "pg_catalog"."default" NOT NULL,
  "llave" uuid NOT NULL,
  "activo" bool NOT NULL DEFAULT true,
  "fecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "fecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Records of dominio
-- ----------------------------
INSERT INTO "usuario"."dominio" VALUES (1, 'localhost', 'Inicial', 'a4e270a1-9689-4507-8988-749a0a919b21', 't', '2020-12-10 05:39:04.293219', '2020-12-10 05:39:04.293219');
INSERT INTO "usuario"."dominio" VALUES (2, 'egit.transporteyucatan.org.mx', 'Inicial', 'a4e270a1-9689-4507-8988-749a0a919b21', 't', '2020-12-10 05:39:04.293219', '2020-12-10 05:39:04.293219');

-- ----------------------------
-- Table structure for dominio_configuracion
-- ----------------------------
DROP TABLE IF EXISTS "usuario"."dominio_configuracion";
CREATE TABLE "usuario"."dominio_configuracion" (
  "iddominio" int4 NOT NULL,
  "clave" varchar(30) COLLATE "pg_catalog"."default" NOT NULL,
  "valor" varchar(30) COLLATE "pg_catalog"."default",
  "tipo" "usuario"."data_t",
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now()
)
;

-- ----------------------------
-- Records of dominio_configuracion
-- ----------------------------

-- ----------------------------
-- Table structure for modulo
-- ----------------------------
DROP TABLE IF EXISTS "usuario"."modulo";
CREATE TABLE "usuario"."modulo" (
  "id" int4 NOT NULL DEFAULT nextval('"usuario".modulo_id_seq'::regclass),
  "seccion" text COLLATE "pg_catalog"."default",
  "nombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "descripcion" text COLLATE "pg_catalog"."default",
  "siglas" varchar(3) COLLATE "pg_catalog"."default" NOT NULL,
  "icono" varchar(50) COLLATE "pg_catalog"."default",
  "orden" int4,
  "activo" bool DEFAULT true,
  "idpadre" int4,
  "configuracion" jsonb NOT NULL DEFAULT '{}'::jsonb,
  "busqueda" text COLLATE "pg_catalog"."default" GENERATED ALWAYS AS (
((((((COALESCE(seccion, ''::text) || ' '::text) || COALESCE(nombre, ''::text)) || ' '::text) || COALESCE(descripcion, ''::text)) || ' '::text) || (COALESCE(siglas, ''::character varying))::text)
) STORED,
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now()
)
;

-- ----------------------------
-- Records of modulo
-- ----------------------------
INSERT INTO "usuario"."modulo" ("id", "seccion", "nombre", "descripcion", "siglas", "icono", "orden", "activo", "idpadre", "configuracion", "fecha_creacion", "fecha_modificacion") VALUES (1, 'Administración', 'Módulos', NULL, 'mdl', 'mdi-view-module', 1, 'f', NULL, '{}', '2020-12-16 06:33:31.828102', '2020-12-16 06:33:31.828102');
INSERT INTO "usuario"."modulo" ("id", "seccion", "nombre", "descripcion", "siglas", "icono", "orden", "activo", "idpadre", "configuracion", "fecha_creacion", "fecha_modificacion") VALUES (2, 'Administración', 'Personas', NULL, 'pel', 'mdi-human-capacity-increase', NULL, 't', NULL, '{}', '2020-12-16 06:33:31.828102', '2020-12-16 06:33:31.828102');
INSERT INTO "usuario"."modulo" ("id", "seccion", "nombre", "descripcion", "siglas", "icono", "orden", "activo", "idpadre", "configuracion", "fecha_creacion", "fecha_modificacion") VALUES (4, 'Administración', 'Debitaciones', NULL, 'deb', 'mdi-credit-card-clock-outline', NULL, 't', NULL, '{}', '2024-03-28 17:15:22.74482', '2024-03-28 17:15:22.74482');
INSERT INTO "usuario"."modulo" ("id", "seccion", "nombre", "descripcion", "siglas", "icono", "orden", "activo", "idpadre", "configuracion", "fecha_creacion", "fecha_modificacion") VALUES (5, 'Administración', 'Usuarios', NULL, 'usr', 'mdi-human-capacity-increase', NULL, 't', NULL, '{}', '2024-03-28 17:15:22.758855', '2024-03-28 17:15:22.758855');
INSERT INTO "usuario"."modulo" ("id", "seccion", "nombre", "descripcion", "siglas", "icono", "orden", "activo", "idpadre", "configuracion", "fecha_creacion", "fecha_modificacion") VALUES (6, 'Administración', 'Perfiles', NULL, 'per', 'mdi-human-capacity-increase', NULL, 't', NULL, '{}', '2024-03-28 17:15:22.795579', '2024-03-28 17:15:22.795579');
INSERT INTO "usuario"."modulo" ("id", "seccion", "nombre", "descripcion", "siglas", "icono", "orden", "activo", "idpadre", "configuracion", "fecha_creacion", "fecha_modificacion") VALUES (7, 'Módulo Api', 'Mto. Unidades', NULL, 'mto', 'mdi-tools', NULL, 't', NULL, '{}', '2024-03-28 11:22:24.106227', '2024-03-28 11:22:24.106227');
INSERT INTO "usuario"."modulo" ("id", "seccion", "nombre", "descripcion", "siglas", "icono", "orden", "activo", "idpadre", "configuracion", "fecha_creacion", "fecha_modificacion") VALUES (8, 'Inspección', 'Carga de trabajo', 'Carga de trabajo', 'ica', 'mdi-human-capacity-increase', NULL, 't', NULL, '{}', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."modulo" ("id", "seccion", "nombre", "descripcion", "siglas", "icono", "orden", "activo", "idpadre", "configuracion", "fecha_creacion", "fecha_modificacion") VALUES (9, 'Inspección', 'Trabajo', 'Trabajo', 'itr', 'mdi-human-capacity-increase', NULL, 'f', 10, '{}', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."modulo" ("id", "seccion", "nombre", "descripcion", "siglas", "icono", "orden", "activo", "idpadre", "configuracion", "fecha_creacion", "fecha_modificacion") VALUES (10, 'Inspección', 'Listas', 'Catalogo de inspecciones', 'ins', 'mdi-human-capacity-increase', NULL, 't', NULL, '{}', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."modulo" ("id", "seccion", "nombre", "descripcion", "siglas", "icono", "orden", "activo", "idpadre", "configuracion", "fecha_creacion", "fecha_modificacion") VALUES (11, 'Inspección', 'Inspectores', 'Inspectores', 'iin', 'mdi-human-capacity-increase', NULL, 't', 10, '{}', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."modulo" ("id", "seccion", "nombre", "descripcion", "siglas", "icono", "orden", "activo", "idpadre", "configuracion", "fecha_creacion", "fecha_modificacion") VALUES (12, 'Gestión de firmas', 'Tablero', 'Tablero', 'fit', 'mdi-human-capacity-increase', NULL, 't', NULL, '{}', '2024-05-06 05:18:10.874135', '2024-05-06 05:18:10.874135');
INSERT INTO "usuario"."modulo" ("id", "seccion", "nombre", "descripcion", "siglas", "icono", "orden", "activo", "idpadre", "configuracion", "fecha_creacion", "fecha_modificacion") VALUES (13, 'Gestión de firmas', 'Firmas', 'Firmas', 'fif', 'mdi-human-capacity-increase', NULL, 't', 14, '{}', '2024-05-06 05:18:10.874135', '2024-05-06 05:18:10.874135');
INSERT INTO "usuario"."modulo" ("id", "seccion", "nombre", "descripcion", "siglas", "icono", "orden", "activo", "idpadre", "configuracion", "fecha_creacion", "fecha_modificacion") VALUES (14, 'Gestión de firmas', 'Listas', 'Gestión de firmas', 'fir', 'mdi-human-capacity-increase', NULL, 't', NULL, '{}', '2024-05-06 05:18:10.874135', '2024-05-06 05:18:10.874135');
INSERT INTO "usuario"."modulo" ("id", "seccion", "nombre", "descripcion", "siglas", "icono", "orden", "activo", "idpadre", "configuracion", "fecha_creacion", "fecha_modificacion") VALUES (15, 'Gestión de firmas', 'Plantillas', 'Plantillas', 'fip', 'mdi-human-capacity-increase', NULL, 't', 14, '{}', '2024-05-06 05:18:10.874135', '2024-05-06 05:18:10.874135');
INSERT INTO "usuario"."modulo" ("id", "seccion", "nombre", "descripcion", "siglas", "icono", "orden", "activo", "idpadre", "configuracion", "fecha_creacion", "fecha_modificacion") VALUES (17, 'Administración', 'Procesos', NULL, 'pro', 'mdi-tools', NULL, 't', NULL, '{}', '2024-05-06 05:36:22.867967', '2024-05-06 05:36:22.867967');
INSERT INTO "usuario"."modulo" ("id", "seccion", "nombre", "descripcion", "siglas", "icono", "orden", "activo", "idpadre", "configuracion", "fecha_creacion", "fecha_modificacion") VALUES (18, 'Módulo normal', 'Demo', NULL, 'ooo', 'mdi-tools', NULL, 't', NULL, '{}', '2024-05-16 15:48:23.174816', '2024-05-16 15:48:23.174816');

-- ----------------------------
-- Table structure for perfil
-- ----------------------------
DROP TABLE IF EXISTS "usuario"."perfil";
CREATE TABLE "usuario"."perfil" (
  "id" int4 NOT NULL DEFAULT nextval('"usuario".perfil_id_seq'::regclass),
  "nombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "descripcion" text COLLATE "pg_catalog"."default",
  "activo" bool DEFAULT true,
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now()
)
;

-- ----------------------------
-- Records of perfil
-- ----------------------------
INSERT INTO "usuario"."perfil" VALUES (1, 'Admin', 'Todos los permisos', 't', '2020-12-16 06:39:39.218785', '2020-12-16 06:39:39.218785');
INSERT INTO "usuario"."perfil" VALUES (3, 'ACiudadana', 'Perfíl para visualizar los módulos relacionados a brindar información a ciudadanos', 't', '2024-03-28 17:15:22.76836', '2024-03-28 17:15:22.76836');
INSERT INTO "usuario"."perfil" VALUES (5, 'Coordinador General (inspectores)', 'Descripción Coordinador General (inspectores)', 't', '2024-04-18 11:30:30.998756', '2024-04-18 11:30:30.998756');
INSERT INTO "usuario"."perfil" VALUES (6, 'Usuario Consulta Persona', 'Usuarios que requieran componente de personas (Ejemplo  solo ver información general y direcciones)', 't', '2024-04-24 21:37:10.419261', '2024-04-24 21:37:10.419261');
INSERT INTO "usuario"."perfil" VALUES (4, 'Jefe de departamento (inspectores)', 'Descripción Jefe de departamento (inspectores)', 't', '2024-04-18 11:26:58.704648', '2024-04-18 11:26:58.704648');

-- ----------------------------
-- Table structure for perfil_permiso
-- ----------------------------
DROP TABLE IF EXISTS "usuario"."perfil_permiso";
CREATE TABLE "usuario"."perfil_permiso" (
  "idperfil" int4 NOT NULL,
  "idpermiso" int4 NOT NULL,
  "activo" bool DEFAULT true,
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now()
)
;

-- ----------------------------
-- Records of perfil_permiso
-- ----------------------------
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 3, 't', '2024-03-28 17:15:22.76836', '2024-03-28 17:15:22.76836');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 4, 't', '2024-03-28 17:15:22.76836', '2024-03-28 17:15:22.76836');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 5, 't', '2024-03-28 17:15:22.76836', '2024-03-28 17:15:22.76836');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 6, 't', '2024-03-28 17:15:22.76836', '2024-03-28 17:15:22.76836');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 7, 't', '2024-03-28 17:15:22.76836', '2024-03-28 17:15:22.76836');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 8, 't', '2024-03-28 17:15:22.76836', '2024-03-28 17:15:22.76836');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 9, 't', '2024-03-28 17:15:22.795579', '2024-03-28 17:15:22.795579');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 10, 't', '2024-03-28 17:15:22.795579', '2024-03-28 17:15:22.795579');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 11, 't', '2024-03-28 17:15:22.795579', '2024-03-28 17:15:22.795579');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 12, 't', '2024-03-28 17:15:22.795579', '2024-03-28 17:15:22.795579');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 13, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 14, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 15, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 16, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 17, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 18, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 19, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 20, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 21, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 22, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 23, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 24, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 25, 't', '2024-04-17 09:25:02.08923', '2024-04-17 09:25:02.08923');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 26, 't', '2024-04-17 09:25:02.08923', '2024-04-17 09:25:02.08923');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 27, 't', '2024-04-17 09:25:02.08923', '2024-04-17 09:25:02.08923');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 28, 't', '2024-04-17 09:25:02.08923', '2024-04-17 09:25:02.08923');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 29, 't', '2024-04-17 09:25:02.08923', '2024-04-17 09:25:02.08923');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 30, 't', '2024-04-17 09:25:02.08923', '2024-04-17 09:25:02.08923');
INSERT INTO "usuario"."perfil_permiso" VALUES (3, 26, 't', '2024-04-17 09:54:01.305012', '2024-04-17 09:54:01.305012');
INSERT INTO "usuario"."perfil_permiso" VALUES (3, 21, 't', '2024-04-17 10:29:00.871333', '2024-04-17 10:29:00.871333');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 32, 't', '2024-04-24 21:17:14.347612', '2024-04-24 21:17:14.347612');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 33, 't', '2024-04-24 21:17:14.347612', '2024-04-24 21:17:14.347612');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 34, 't', '2024-04-24 21:17:14.347612', '2024-04-24 21:17:14.347612');
INSERT INTO "usuario"."perfil_permiso" VALUES (5, 26, 'f', '2024-04-18 11:30:30.998756', '2024-04-18 11:30:30.998756');
INSERT INTO "usuario"."perfil_permiso" VALUES (5, 25, 't', '2024-04-18 11:30:30.998756', '2024-04-18 11:30:30.998756');
INSERT INTO "usuario"."perfil_permiso" VALUES (5, 30, 't', '2024-04-18 11:30:30.998756', '2024-04-18 11:30:30.998756');
INSERT INTO "usuario"."perfil_permiso" VALUES (5, 21, 't', '2024-04-18 11:30:30.998756', '2024-04-18 11:30:30.998756');
INSERT INTO "usuario"."perfil_permiso" VALUES (5, 22, 't', '2024-04-18 11:30:30.998756', '2024-04-18 11:30:30.998756');
INSERT INTO "usuario"."perfil_permiso" VALUES (5, 24, 't', '2024-04-18 11:30:30.998756', '2024-04-18 11:30:30.998756');
INSERT INTO "usuario"."perfil_permiso" VALUES (5, 23, 't', '2024-04-18 11:30:30.998756', '2024-04-18 11:30:30.998756');
INSERT INTO "usuario"."perfil_permiso" VALUES (5, 32, 't', '2024-04-24 21:35:05.358598', '2024-04-24 21:35:05.358598');
INSERT INTO "usuario"."perfil_permiso" VALUES (5, 33, 't', '2024-04-24 21:35:05.358598', '2024-04-24 21:35:05.358598');
INSERT INTO "usuario"."perfil_permiso" VALUES (5, 34, 't', '2024-04-24 21:35:05.358598', '2024-04-24 21:35:05.358598');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 35, 't', '2024-04-25 11:04:25.756955', '2024-04-25 11:04:25.756955');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 36, 't', '2024-04-25 11:04:25.756955', '2024-04-25 11:04:25.756955');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 37, 't', '2024-04-25 11:04:25.756955', '2024-04-25 11:04:25.756955');
INSERT INTO "usuario"."perfil_permiso" VALUES (6, 25, 't', '2024-04-25 11:41:36.344241', '2024-04-25 11:41:36.344241');
INSERT INTO "usuario"."perfil_permiso" VALUES (6, 32, 't', '2024-04-25 11:41:36.344241', '2024-04-25 11:41:36.344241');
INSERT INTO "usuario"."perfil_permiso" VALUES (6, 27, 't', '2024-04-25 11:41:36.344241', '2024-04-25 11:41:36.344241');
INSERT INTO "usuario"."perfil_permiso" VALUES (6, 35, 't', '2024-04-25 11:44:28.082088', '2024-04-25 11:44:28.082088');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 38, 't', '2024-05-06 05:18:10.874135', '2024-05-06 05:18:10.874135');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 39, 't', '2024-05-06 05:18:10.874135', '2024-05-06 05:18:10.874135');
INSERT INTO "usuario"."perfil_permiso" VALUES (1, 40, 't', '2024-05-06 05:18:10.874135', '2024-05-06 05:18:10.874135');
INSERT INTO "usuario"."perfil_permiso" VALUES (4, 30, 'f', '2024-05-16 11:32:51.291171', '2024-05-16 11:32:51.291171');
INSERT INTO "usuario"."perfil_permiso" VALUES (4, 21, 't', '2024-04-18 11:26:58.704648', '2024-04-18 11:26:58.704648');
INSERT INTO "usuario"."perfil_permiso" VALUES (4, 25, 't', '2024-04-18 11:26:58.704648', '2024-04-18 11:26:58.704648');
INSERT INTO "usuario"."perfil_permiso" VALUES (4, 26, 't', '2024-04-24 20:18:08.344395', '2024-04-24 20:18:08.344395');
INSERT INTO "usuario"."perfil_permiso" VALUES (4, 27, 't', '2024-04-24 20:18:08.344395', '2024-04-24 20:18:08.344395');
INSERT INTO "usuario"."perfil_permiso" VALUES (4, 28, 't', '2024-04-24 20:18:08.344395', '2024-04-24 20:18:08.344395');
INSERT INTO "usuario"."perfil_permiso" VALUES (4, 29, 't', '2024-04-24 20:18:08.344395', '2024-04-24 20:18:08.344395');
INSERT INTO "usuario"."perfil_permiso" VALUES (4, 32, 't', '2024-04-24 21:34:23.029873', '2024-04-24 21:34:23.029873');
INSERT INTO "usuario"."perfil_permiso" VALUES (4, 33, 't', '2024-04-24 21:34:23.029873', '2024-04-24 21:34:23.029873');
INSERT INTO "usuario"."perfil_permiso" VALUES (4, 34, 't', '2024-04-24 21:34:23.029873', '2024-04-24 21:34:23.029873');
INSERT INTO "usuario"."perfil_permiso" VALUES (4, 24, 't', '2024-04-18 11:26:58.704648', '2024-04-18 11:26:58.704648');

-- ----------------------------
-- Table structure for perfil_usuario
-- ----------------------------
DROP TABLE IF EXISTS "usuario"."perfil_usuario";
CREATE TABLE "usuario"."perfil_usuario" (
  "idusuario" int4 NOT NULL,
  "idperfil" int4 NOT NULL,
  "activo" bool DEFAULT true,
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now()
)
;

-- ----------------------------
-- Records of perfil_usuario
-- ----------------------------
INSERT INTO "usuario"."perfil_usuario" VALUES (1, 1, 't', '2020-12-16 06:42:56.281166', '2020-12-16 06:42:56.281166');
INSERT INTO "usuario"."perfil_usuario" VALUES (3, 3, 't', '2024-03-28 17:15:22.76836', '2024-03-28 17:15:22.76836');
INSERT INTO "usuario"."perfil_usuario" VALUES (4, 3, 't', '2024-03-28 17:15:22.76836', '2024-03-28 17:15:22.76836');
INSERT INTO "usuario"."perfil_usuario" VALUES (5, 3, 't', '2024-03-28 17:15:22.76836', '2024-03-28 17:15:22.76836');
INSERT INTO "usuario"."perfil_usuario" VALUES (7, 5, 't', '2024-04-24 20:21:35.697674', '2024-04-24 20:21:35.697674');
INSERT INTO "usuario"."perfil_usuario" VALUES (8, 6, 't', '2024-04-24 21:54:32.165308', '2024-04-24 21:54:32.165308');
INSERT INTO "usuario"."perfil_usuario" VALUES (6, 3, 'f', '2024-04-17 09:53:35.439961', '2024-04-17 09:53:35.439961');
INSERT INTO "usuario"."perfil_usuario" VALUES (6, 4, 't', '2024-04-18 11:37:15.688027', '2024-04-18 11:37:15.688027');
INSERT INTO "usuario"."perfil_usuario" VALUES (6, 5, 't', '2024-05-16 15:36:26.544739', '2024-05-16 15:36:26.544739');

-- ----------------------------
-- Table structure for permiso
-- ----------------------------
DROP TABLE IF EXISTS "usuario"."permiso";
CREATE TABLE "usuario"."permiso" (
  "id" int4 NOT NULL DEFAULT nextval('"usuario".permiso_id_seq'::regclass),
  "nombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "descripcion" text COLLATE "pg_catalog"."default",
  "siglas" varchar(30) COLLATE "pg_catalog"."default" NOT NULL,
  "idmodulo" int4,
  "activo" bool DEFAULT true,
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now()
)
;

-- ----------------------------
-- Records of permiso
-- ----------------------------
INSERT INTO "usuario"."permiso" VALUES (3, 'Ver usuario', 'Ver información del usuario', 'veus', 5, 't', '2024-03-28 17:15:22.76836', '2024-03-28 17:15:22.76836');
INSERT INTO "usuario"."permiso" VALUES (4, 'Editar usuario', 'Editar información y configuración del usuario', 'edus', 5, 't', '2024-03-28 17:15:22.76836', '2024-03-28 17:15:22.76836');
INSERT INTO "usuario"."permiso" VALUES (5, 'Borrar usuario', 'Activar o desactivar usuario', 'bous', 5, 't', '2024-03-28 17:15:22.76836', '2024-03-28 17:15:22.76836');
INSERT INTO "usuario"."permiso" VALUES (6, 'Crear usuario', 'Crear nuevo usuario', 'crus', 5, 't', '2024-03-28 17:15:22.76836', '2024-03-28 17:15:22.76836');
INSERT INTO "usuario"."permiso" VALUES (7, 'Restablecer contraseña', 'Restablecer la contraseña del usuario', 'reco', 5, 't', '2024-03-28 17:15:22.76836', '2024-03-28 17:15:22.76836');
INSERT INTO "usuario"."permiso" VALUES (8, 'Cambiar contraseña', 'Cambiar la contraseña del usuario', 'caco', 5, 't', '2024-03-28 17:15:22.76836', '2024-03-28 17:15:22.76836');
INSERT INTO "usuario"."permiso" VALUES (9, 'Ver perfil', 'Ver información del perfil', 'vepe', 6, 't', '2024-03-28 17:15:22.795579', '2024-03-28 17:15:22.795579');
INSERT INTO "usuario"."permiso" VALUES (10, 'Editar perfil', 'Editar información y configuración del perfil', 'edpe', 6, 't', '2024-03-28 17:15:22.795579', '2024-03-28 17:15:22.795579');
INSERT INTO "usuario"."permiso" VALUES (11, 'Borrar perfil', 'Activar o desactivar perfil', 'bope', 6, 't', '2024-03-28 17:15:22.795579', '2024-03-28 17:15:22.795579');
INSERT INTO "usuario"."permiso" VALUES (12, 'Crear perfil', 'Crear nuevo perfil', 'crpe', 6, 't', '2024-03-28 17:15:22.795579', '2024-03-28 17:15:22.795579');
INSERT INTO "usuario"."permiso" VALUES (13, 'Ver carga de trabajo', 'Ver información del carga de trabajo', 'veic', 8, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."permiso" VALUES (14, 'Editar carga de trabajo', 'Editar información y configuración del carga de trabajo', 'edic', 8, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."permiso" VALUES (15, 'Borrar carga de trabajo', 'Activar o desactivar carga de trabajo', 'boic', 8, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."permiso" VALUES (16, 'Crear carga de trabajo', 'Crear nuevo carga de trabajo', 'cric', 8, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."permiso" VALUES (17, 'Ver trabajo', 'Ver información del trabajo', 'veit', 9, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."permiso" VALUES (18, 'Editar trabajo', 'Editar información y configuración del trabajo', 'edit', 9, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."permiso" VALUES (19, 'Borrar trabajo', 'Activar o desactivar trabajo', 'boit', 9, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."permiso" VALUES (20, 'Crear trabajo', 'Crear nuevo trabajo', 'crit', 9, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."permiso" VALUES (21, 'Ver inspector', 'Ver información del inspector', 'veii', 11, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."permiso" VALUES (22, 'Editar inspector', 'Editar información y configuración del inspector', 'edii', 11, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."permiso" VALUES (23, 'Borrar inspector', 'Activar o desactivar inspector', 'boii', 11, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."permiso" VALUES (24, 'Crear inspector', 'Crear nuevo inspector', 'crii', 11, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."permiso" VALUES (26, 'Editar información general de persona', 'Editar información general de la persona', 'edgp', 2, 't', '2024-04-17 09:25:02.08923', '2024-04-17 09:25:02.08923');
INSERT INTO "usuario"."permiso" VALUES (27, 'Editar direcciones de persona', 'Editar direcciones de la persona', 'eddp', 2, 't', '2024-04-17 09:25:02.08923', '2024-04-17 09:25:02.08923');
INSERT INTO "usuario"."permiso" VALUES (28, 'Editar teléfonos de persona', 'Editar teléfonos de la persona', 'edtp', 2, 't', '2024-04-17 09:25:02.08923', '2024-04-17 09:25:02.08923');
INSERT INTO "usuario"."permiso" VALUES (29, 'Editar archivos de persona', 'Editar archivos de la persona', 'edap', 2, 't', '2024-04-17 09:25:02.08923', '2024-04-17 09:25:02.08923');
INSERT INTO "usuario"."permiso" VALUES (30, 'Crear persona', 'Crear nuevo persona', 'crmp', 2, 't', '2024-04-17 09:25:02.08923', '2024-04-17 09:25:02.08923');
INSERT INTO "usuario"."permiso" VALUES (32, 'Ver direcciones de persona', 'Ver información del persona', 'vedp', 2, 't', '2024-04-24 21:17:14.347612', '2024-04-24 21:17:14.347612');
INSERT INTO "usuario"."permiso" VALUES (33, 'Ver teléfonos de persona', 'Ver información del persona', 'vetp', 2, 't', '2024-04-24 21:17:14.347612', '2024-04-24 21:17:14.347612');
INSERT INTO "usuario"."permiso" VALUES (34, 'Ver archivos de persona', 'Ver información del persona', 'veap', 2, 't', '2024-04-24 21:17:14.347612', '2024-04-24 21:17:14.347612');
INSERT INTO "usuario"."permiso" VALUES (25, 'Ver información general de persona', 'Ver información del persona', 'vemp', 2, 't', '2024-04-17 09:25:02.08923', '2024-04-17 09:25:02.08923');
INSERT INTO "usuario"."permiso" VALUES (35, 'Crear direcciones de persona', 'Crear direcciones de la persona', 'crdp', 2, 't', '2024-04-25 11:04:25.756955', '2024-04-25 11:04:25.756955');
INSERT INTO "usuario"."permiso" VALUES (36, 'Crear teléfonos de persona', 'Crear teléfonos de la persona', 'crtp', 2, 't', '2024-04-25 11:04:25.756955', '2024-04-25 11:04:25.756955');
INSERT INTO "usuario"."permiso" VALUES (37, 'Crear archivos de persona', 'Crear archivos de la persona', 'crap', 2, 't', '2024-04-25 11:04:25.756955', '2024-04-25 11:04:25.756955');
INSERT INTO "usuario"."permiso" VALUES (38, 'Ver Tablero', 'Ver información del Tablero', 'veta', 12, 't', '2024-05-06 05:18:10.874135', '2024-05-06 05:18:10.874135');
INSERT INTO "usuario"."permiso" VALUES (39, 'Ver firmas', 'Ver información de las firmas', 'vefi', 13, 't', '2024-05-06 05:18:10.874135', '2024-05-06 05:18:10.874135');
INSERT INTO "usuario"."permiso" VALUES (40, 'Ver plantillas', 'Ver información de las plantillas', 'vepl', 15, 't', '2024-05-06 05:18:10.874135', '2024-05-06 05:18:10.874135');

-- ----------------------------
-- Table structure for tbl_firma_registro
-- ----------------------------
DROP TABLE IF EXISTS "usuario"."tbl_firma_registro";
CREATE TABLE "usuario"."tbl_firma_registro" (
  "iidfirma_registro" int4 NOT NULL DEFAULT nextval('"usuario".cat_firma_plantilla_iid_firma_plantilla_seq'::regclass),
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtapepat" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtapemat" text COLLATE "pg_catalog"."default",
  "txtpuesto" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtoficina" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtdepartamento" text COLLATE "pg_catalog"."default",
  "txtemail" text COLLATE "pg_catalog"."default",
  "txttelefono" text COLLATE "pg_catalog"."default",
  "txtextension" text COLLATE "pg_catalog"."default",
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(0),
  "dtfecha_modificacion" timestamp(0) DEFAULT now(),
  "txttitulo" text COLLATE "pg_catalog"."default",
  "iidfirma_plantilla" int4 NOT NULL
)
;

-- ----------------------------
-- Records of tbl_firma_registro
-- ----------------------------
INSERT INTO "usuario"."tbl_firma_registro" VALUES (20, 't', 'ttt', 'tt', 'ttt', 'ttt', '', '', '', '', 't', '2024-05-08 12:40:09', '2024-05-08 12:40:09', '', 1);
INSERT INTO "usuario"."tbl_firma_registro" VALUES (22, 'ewe', 'dewe', 'dewd', 'ewdew', 'dwe', '', '', '', '', 't', '2024-05-08 12:45:09', '2024-05-08 14:11:53', 'dedaaaaa', 1);
INSERT INTO "usuario"."tbl_firma_registro" VALUES (24, 'Abraham', 'Canul', 'sw', 'Jefe de depa', 'w', 'ws', 'wswsww', '4848978979', '', 't', '2024-05-16 21:34:18', '2024-05-16 15:34:18', 'Ing', 1);

-- ----------------------------
-- Table structure for tbl_firma_registro_usuario
-- ----------------------------
DROP TABLE IF EXISTS "usuario"."tbl_firma_registro_usuario";
CREATE TABLE "usuario"."tbl_firma_registro_usuario" (
  "iidfirma_registro_usuario" int4 NOT NULL DEFAULT nextval('"usuario".cat_firma_plantilla_iid_firma_plantilla_seq'::regclass),
  "iidfirma_registro" int4 NOT NULL,
  "iidusuario" int4 NOT NULL,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6),
  "dtfecha_modificacion" timestamp(6)
)
;

-- ----------------------------
-- Records of tbl_firma_registro_usuario
-- ----------------------------
INSERT INTO "usuario"."tbl_firma_registro_usuario" VALUES (7, 6, 1, 't', '2024-05-08 12:09:59', NULL);
INSERT INTO "usuario"."tbl_firma_registro_usuario" VALUES (9, 8, 1, 't', '2024-05-08 12:13:20', NULL);
INSERT INTO "usuario"."tbl_firma_registro_usuario" VALUES (11, 10, 1, 't', '2024-05-08 12:36:10', NULL);
INSERT INTO "usuario"."tbl_firma_registro_usuario" VALUES (13, 12, 1, 't', '2024-05-08 12:36:47', NULL);
INSERT INTO "usuario"."tbl_firma_registro_usuario" VALUES (15, 14, 1, 't', '2024-05-08 12:37:33', NULL);
INSERT INTO "usuario"."tbl_firma_registro_usuario" VALUES (17, 16, 1, 't', '2024-05-08 12:38:17', NULL);
INSERT INTO "usuario"."tbl_firma_registro_usuario" VALUES (19, 18, 1, 't', '2024-05-08 12:39:33', NULL);
INSERT INTO "usuario"."tbl_firma_registro_usuario" VALUES (21, 20, 1, 't', '2024-05-08 12:40:09', NULL);
INSERT INTO "usuario"."tbl_firma_registro_usuario" VALUES (23, 22, 1, 't', '2024-05-08 12:45:09', NULL);
INSERT INTO "usuario"."tbl_firma_registro_usuario" VALUES (25, 24, 1, 't', '2024-05-16 21:34:18', NULL);

-- ----------------------------
-- Table structure for usuario
-- ----------------------------
DROP TABLE IF EXISTS "usuario"."usuario";
CREATE TABLE "usuario"."usuario" (
  "id" int4 NOT NULL DEFAULT nextval('"usuario".usuario_id_seq'::regclass),
  "usuario" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "clave" char(64) COLLATE "pg_catalog"."default",
  "nombre" varchar(30) COLLATE "pg_catalog"."default",
  "apepat" varchar(30) COLLATE "pg_catalog"."default",
  "apemat" varchar(30) COLLATE "pg_catalog"."default",
  "correo" varchar(50) COLLATE "pg_catalog"."default",
  "admin" bool DEFAULT false,
  "activo" bool DEFAULT true,
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now()
)
;

-- ----------------------------
-- Records of usuario
-- ----------------------------
INSERT INTO "usuario"."usuario" VALUES (1, 'master', 'fc613b4dfd6736a7bd268c8a0e74ed0d1c04a959f59dd74ef2874983fd443fc9', 'El', 'Administrador', NULL, NULL, 't', 't', '2020-11-23 22:03:05.743631', '2020-11-23 22:03:05.743631');
INSERT INTO "usuario"."usuario" VALUES (3, 'coral.dominguez', '412eed984cc09d40df7437ea40e0f722af1e24d63a4e1ce1b7747fe0684a066d', 'Coral', 'Dominguez', 'Leon', 'coral.dominguez@yucatan.gob.mx', 'f', 't', '2024-03-28 17:15:22.76836', '2024-03-28 17:15:22.76836');
INSERT INTO "usuario"."usuario" VALUES (4, 'edward.soberanis', 'bfd73f4c87871828ac5839006e8f329f81719d6d51d5bdfb003c73dd30cd3367', 'Edward Augusto', 'Soberanis', 'Cabrera', 'edward.soberanis@yucatan.gob.mx', 'f', 't', '2024-03-28 17:15:22.76836', '2024-03-28 17:15:22.76836');
INSERT INTO "usuario"."usuario" VALUES (5, 'francisco.zabaleta', '50d0bb6fec22660f5b017f2b8137797fc1bfaa39dbf3b06a54350455d7914e9c', 'Francisco Alonso', 'Zabaleta', 'Arceo', 'francisco.zabaleta@yucatan.gob.mx', 'f', 't', '2024-03-28 17:15:22.76836', '2024-03-28 17:15:22.76836');
INSERT INTO "usuario"."usuario" VALUES (7, 'inspector.coordinador_general', '7aedeb30c60767639389f68eace21e4413d0bc07c38691aad694545cf9d89359', 'Inspector', 'Coordinador', 'General', 'jc2022ia@gmail.com', 'f', 't', '2024-04-24 20:21:35.697674', '2024-04-24 20:21:35.697674');
INSERT INTO "usuario"."usuario" VALUES (8, 'usuario.componente_ejemplo', 'bf25c78425219796f8d8f5947f2397f9eb236034b3d20783dc9bdb30ddc90a88', 'Usuario ', 'Componente', 'Ejemplo', 'jc2023ia@gmail.com', 'f', 't', '2024-04-24 21:54:32.165308', '2024-04-24 21:54:32.165308');
INSERT INTO "usuario"."usuario" VALUES (6, 'inspector.jefe_departamento', 'c0c959b3327799a954b6de59c0619d8ccb5bded1120607aea6a334e494e04088', 'Inspector', 'Jefe', 'Departamento', NULL, 'f', 't', '2024-04-17 09:53:35.439961', '2024-04-17 09:53:35.439961');

-- ----------------------------
-- Table structure for usuario_dominio
-- ----------------------------
DROP TABLE IF EXISTS "usuario"."usuario_dominio";
CREATE TABLE "usuario"."usuario_dominio" (
  "idusuario" int4 NOT NULL,
  "iddominio" int4 NOT NULL,
  "admin" bool DEFAULT false,
  "activo" bool DEFAULT true,
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now()
)
;

-- ----------------------------
-- Records of usuario_dominio
-- ----------------------------
INSERT INTO "usuario"."usuario_dominio" VALUES (1, 1, 'f', 't', '2020-12-10 06:02:01.963005', '2020-12-10 06:02:01.963005');
INSERT INTO "usuario"."usuario_dominio" VALUES (3, 1, 'f', 't', '2024-03-28 17:15:22.76836', '2024-03-28 17:15:22.76836');
INSERT INTO "usuario"."usuario_dominio" VALUES (4, 1, 'f', 't', '2024-03-28 17:15:22.76836', '2024-03-28 17:15:22.76836');
INSERT INTO "usuario"."usuario_dominio" VALUES (5, 1, 'f', 't', '2024-03-28 17:15:22.76836', '2024-03-28 17:15:22.76836');
INSERT INTO "usuario"."usuario_dominio" VALUES (7, 1, 'f', 't', '2024-04-24 20:21:35.697674', '2024-04-24 20:21:35.697674');
INSERT INTO "usuario"."usuario_dominio" VALUES (8, 1, 'f', 't', '2024-04-24 21:54:32.165308', '2024-04-24 21:54:32.165308');
INSERT INTO "usuario"."usuario_dominio" VALUES (6, 1, 'f', 't', '2024-04-17 09:53:35.439961', '2024-04-17 09:53:35.439961');

-- ----------------------------
-- Table structure for usuario_dominio_configuracion
-- ----------------------------
DROP TABLE IF EXISTS "usuario"."usuario_dominio_configuracion";
CREATE TABLE "usuario"."usuario_dominio_configuracion" (
  "idusuario" int4 NOT NULL,
  "iddominio" int4 NOT NULL,
  "clave" varchar(30) COLLATE "pg_catalog"."default" NOT NULL,
  "valor" varchar(30) COLLATE "pg_catalog"."default",
  "tipo" "usuario"."data_t",
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now()
)
;

-- ----------------------------
-- Records of usuario_dominio_configuracion
-- ----------------------------

-- ----------------------------
-- Table structure for usuario_dominio_modulo
-- ----------------------------
DROP TABLE IF EXISTS "usuario"."usuario_dominio_modulo";
CREATE TABLE "usuario"."usuario_dominio_modulo" (
  "idusuario" int4 NOT NULL,
  "iddominio" int4 NOT NULL,
  "idmodulo" int4 NOT NULL,
  "activo" bool DEFAULT true,
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now()
)
;

-- ----------------------------
-- Records of usuario_dominio_modulo
-- ----------------------------
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (1, 1, 1, 't', '2020-12-29 05:07:17.726421', '2020-12-29 05:07:17.726421');
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (1, 1, 2, 't', '2020-12-29 05:07:17.726421', '2020-12-29 05:07:17.726421');
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (1, 1, 4, 't', '2024-03-28 17:15:22.74482', '2024-03-28 17:15:22.74482');
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (1, 1, 5, 't', '2024-03-28 17:15:22.758855', '2024-03-28 17:15:22.758855');
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (3, 1, 4, 't', '2024-03-28 17:15:22.76836', '2024-03-28 17:15:22.76836');
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (4, 1, 4, 't', '2024-03-28 17:15:22.76836', '2024-03-28 17:15:22.76836');
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (5, 1, 4, 't', '2024-03-28 17:15:22.76836', '2024-03-28 17:15:22.76836');
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (1, 1, 6, 't', '2024-03-28 17:15:22.795579', '2024-03-28 17:15:22.795579');
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (1, 1, 7, 't', '2024-03-28 11:22:24.106227', '2024-03-28 11:22:24.106227');
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (1, 1, 8, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (1, 1, 9, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (1, 1, 11, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (1, 1, 10, 't', '2024-03-28 11:22:47.170865', '2024-03-28 11:22:47.170865');
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (8, 1, 2, 't', '2024-04-24 21:56:00.411926', '2024-04-24 21:56:00.411926');
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (1, 1, 12, 't', '2024-05-06 05:18:10.874135', '2024-05-06 05:18:10.874135');
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (1, 1, 13, 't', '2024-05-06 05:18:10.874135', '2024-05-06 05:18:10.874135');
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (1, 1, 15, 't', '2024-05-06 05:18:10.874135', '2024-05-06 05:18:10.874135');
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (1, 1, 14, 't', '2024-05-06 05:18:10.874135', '2024-05-06 05:18:10.874135');
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (1, 1, 17, 't', '2024-05-06 05:36:22.867967', '2024-05-06 05:36:22.867967');
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (6, 1, 8, 'f', '2024-04-17 09:56:36.648881', '2024-04-17 09:56:36.648881');
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (6, 1, 9, 'f', '2024-04-17 09:56:36.648881', '2024-04-17 09:56:36.648881');
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (6, 1, 10, 'f', '2024-04-17 09:56:36.648881', '2024-04-17 09:56:36.648881');
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (6, 1, 11, 't', '2024-04-17 09:56:36.648881', '2024-04-17 09:56:36.648881');
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (6, 1, 2, 't', '2024-04-17 10:31:25.473494', '2024-04-17 10:31:25.473494');
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (1, 1, 18, 't', '2024-05-16 15:48:23.174816', '2024-05-16 15:48:23.174816');

-- ----------------------------
-- Table structure for usuario_permiso
-- ----------------------------
DROP TABLE IF EXISTS "usuario"."usuario_permiso";
CREATE TABLE "usuario"."usuario_permiso" (
  "idusuario" int4 NOT NULL,
  "idpermiso" int4 NOT NULL,
  "activo" bool DEFAULT true,
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now()
)
;

-- ----------------------------
-- Records of usuario_permiso
-- ----------------------------
INSERT INTO "usuario"."usuario_permiso" VALUES (6, 21, 't', '2024-04-18 11:37:15.688027', '2024-04-18 11:37:15.688027');
INSERT INTO "usuario"."usuario_permiso" VALUES (6, 25, 't', '2024-05-16 15:36:26.544739', '2024-05-16 15:36:26.544739');
INSERT INTO "usuario"."usuario_permiso" VALUES (6, 26, 't', '2024-04-18 11:37:15.688027', '2024-04-18 11:37:15.688027');
INSERT INTO "usuario"."usuario_permiso" VALUES (6, 27, 't', '2024-05-16 15:36:26.544739', '2024-05-16 15:36:26.544739');
INSERT INTO "usuario"."usuario_permiso" VALUES (6, 28, 't', '2024-05-16 15:36:26.544739', '2024-05-16 15:36:26.544739');
INSERT INTO "usuario"."usuario_permiso" VALUES (6, 29, 't', '2024-05-16 15:36:26.544739', '2024-05-16 15:36:26.544739');
INSERT INTO "usuario"."usuario_permiso" VALUES (6, 32, 't', '2024-05-16 15:36:26.544739', '2024-05-16 15:36:26.544739');
INSERT INTO "usuario"."usuario_permiso" VALUES (6, 33, 't', '2024-05-16 15:36:26.544739', '2024-05-16 15:36:26.544739');
INSERT INTO "usuario"."usuario_permiso" VALUES (6, 34, 't', '2024-05-16 15:36:26.544739', '2024-05-16 15:36:26.544739');
INSERT INTO "usuario"."usuario_permiso" VALUES (6, 24, 't', '2024-05-16 15:36:26.544739', '2024-05-16 15:36:26.544739');

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
SELECT setval('"usuario"."cat_firma_plantilla_iid_firma_plantilla_seq"', 25, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "usuario"."dominio_id_seq"
OWNED BY "usuario"."dominio"."id";
SELECT setval('"usuario"."dominio_id_seq"', 2, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "usuario"."modulo_id_seq"
OWNED BY "usuario"."modulo"."id";
SELECT setval('"usuario"."modulo_id_seq"', 18, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "usuario"."perfil_id_seq"
OWNED BY "usuario"."perfil"."id";
SELECT setval('"usuario"."perfil_id_seq"', 6, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "usuario"."permiso_id_seq"
OWNED BY "usuario"."permiso"."id";
SELECT setval('"usuario"."permiso_id_seq"', 40, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "usuario"."usuario_id_seq"
OWNED BY "usuario"."usuario"."id";
SELECT setval('"usuario"."usuario_id_seq"', 8, true);

-- ----------------------------
-- Primary Key structure for table cat_firma_plantilla
-- ----------------------------
ALTER TABLE "usuario"."cat_firma_plantilla" ADD CONSTRAINT "cat_firma_plantilla_pkey" PRIMARY KEY ("iidfirma_plantilla");

-- ----------------------------
-- Primary Key structure for table dominio
-- ----------------------------
ALTER TABLE "usuario"."dominio" ADD CONSTRAINT "pk_dominio" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table dominio_configuracion
-- ----------------------------
ALTER TABLE "usuario"."dominio_configuracion" ADD CONSTRAINT "pk_dom_clv_configuracion" PRIMARY KEY ("iddominio", "clave");

-- ----------------------------
-- Indexes structure for table modulo
-- ----------------------------
CREATE INDEX "trgm_idx_modulo_busqueda" ON "usuario"."modulo" USING gin (
  "busqueda" COLLATE "pg_catalog"."default" "public"."gin_trgm_ops"
);

-- ----------------------------
-- Primary Key structure for table modulo
-- ----------------------------
ALTER TABLE "usuario"."modulo" ADD CONSTRAINT "pk_modulo" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table perfil
-- ----------------------------
ALTER TABLE "usuario"."perfil" ADD CONSTRAINT "pk_perfil" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table perfil_permiso
-- ----------------------------
ALTER TABLE "usuario"."perfil_permiso" ADD CONSTRAINT "pk_perfil_permiso" PRIMARY KEY ("idperfil", "idpermiso");

-- ----------------------------
-- Primary Key structure for table perfil_usuario
-- ----------------------------
ALTER TABLE "usuario"."perfil_usuario" ADD CONSTRAINT "pk_perfil_usuario" PRIMARY KEY ("idperfil", "idusuario");

-- ----------------------------
-- Uniques structure for table permiso
-- ----------------------------
ALTER TABLE "usuario"."permiso" ADD CONSTRAINT "uq_permiso_siglas" UNIQUE ("siglas");

-- ----------------------------
-- Primary Key structure for table permiso
-- ----------------------------
ALTER TABLE "usuario"."permiso" ADD CONSTRAINT "pk_permiso" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table tbl_firma_registro
-- ----------------------------
ALTER TABLE "usuario"."tbl_firma_registro" ADD CONSTRAINT "cat_firma_plantilla_copy1_pkey" PRIMARY KEY ("iidfirma_registro");

-- ----------------------------
-- Primary Key structure for table usuario
-- ----------------------------
ALTER TABLE "usuario"."usuario" ADD CONSTRAINT "pk_usuario" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table usuario_dominio
-- ----------------------------
ALTER TABLE "usuario"."usuario_dominio" ADD CONSTRAINT "pk_usuario_dominio" PRIMARY KEY ("idusuario", "iddominio");

-- ----------------------------
-- Primary Key structure for table usuario_dominio_configuracion
-- ----------------------------
ALTER TABLE "usuario"."usuario_dominio_configuracion" ADD CONSTRAINT "pk_usr_dom_clv_configuracion" PRIMARY KEY ("idusuario", "iddominio", "clave");

-- ----------------------------
-- Primary Key structure for table usuario_dominio_modulo
-- ----------------------------
ALTER TABLE "usuario"."usuario_dominio_modulo" ADD CONSTRAINT "pk_usuario_dominio_modulo" PRIMARY KEY ("idusuario", "iddominio", "idmodulo");

-- ----------------------------
-- Primary Key structure for table usuario_permiso
-- ----------------------------
ALTER TABLE "usuario"."usuario_permiso" ADD CONSTRAINT "pk_usuario_permiso" PRIMARY KEY ("idusuario", "idpermiso");

-- ----------------------------
-- Foreign Keys structure for table dominio_configuracion
-- ----------------------------
ALTER TABLE "usuario"."dominio_configuracion" ADD CONSTRAINT "fk_dom_configuracion_dominio" FOREIGN KEY ("iddominio") REFERENCES "usuario"."dominio" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table modulo
-- ----------------------------
ALTER TABLE "usuario"."modulo" ADD CONSTRAINT "fk_modulo_idpadre" FOREIGN KEY ("idpadre") REFERENCES "usuario"."modulo" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table perfil_permiso
-- ----------------------------
ALTER TABLE "usuario"."perfil_permiso" ADD CONSTRAINT "fk_perfil_permiso_idperfil" FOREIGN KEY ("idperfil") REFERENCES "usuario"."perfil" ("id") MATCH FULL ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "usuario"."perfil_permiso" ADD CONSTRAINT "fk_perfil_permiso_idpermiso" FOREIGN KEY ("idpermiso") REFERENCES "usuario"."permiso" ("id") MATCH FULL ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table perfil_usuario
-- ----------------------------
ALTER TABLE "usuario"."perfil_usuario" ADD CONSTRAINT "fk_perfil_usuario_perfil" FOREIGN KEY ("idperfil") REFERENCES "usuario"."perfil" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "usuario"."perfil_usuario" ADD CONSTRAINT "fk_perfil_usuario_usuario" FOREIGN KEY ("idusuario") REFERENCES "usuario"."usuario" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table permiso
-- ----------------------------
ALTER TABLE "usuario"."permiso" ADD CONSTRAINT "fk_permiso_idmodulo" FOREIGN KEY ("idmodulo") REFERENCES "usuario"."modulo" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table usuario_dominio
-- ----------------------------
ALTER TABLE "usuario"."usuario_dominio" ADD CONSTRAINT "fk_usuario_dominio_dominio" FOREIGN KEY ("iddominio") REFERENCES "usuario"."dominio" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "usuario"."usuario_dominio" ADD CONSTRAINT "fk_usuario_dominio_usuario" FOREIGN KEY ("idusuario") REFERENCES "usuario"."usuario" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table usuario_dominio_configuracion
-- ----------------------------
ALTER TABLE "usuario"."usuario_dominio_configuracion" ADD CONSTRAINT "fk_usr_dom_configuracion_dominio" FOREIGN KEY ("iddominio") REFERENCES "usuario"."dominio" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "usuario"."usuario_dominio_configuracion" ADD CONSTRAINT "fk_usr_dom_configuracion_usuario" FOREIGN KEY ("idusuario") REFERENCES "usuario"."usuario" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table usuario_dominio_modulo
-- ----------------------------
ALTER TABLE "usuario"."usuario_dominio_modulo" ADD CONSTRAINT "fk_usuario_dominio_modulo_iddominio" FOREIGN KEY ("iddominio") REFERENCES "usuario"."dominio" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "usuario"."usuario_dominio_modulo" ADD CONSTRAINT "fk_usuario_dominio_modulo_idmodulo" FOREIGN KEY ("idmodulo") REFERENCES "usuario"."modulo" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "usuario"."usuario_dominio_modulo" ADD CONSTRAINT "fk_usuario_dominio_modulo_idusuario" FOREIGN KEY ("idusuario") REFERENCES "usuario"."usuario" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table usuario_permiso
-- ----------------------------
ALTER TABLE "usuario"."usuario_permiso" ADD CONSTRAINT "fk_usuario_permiso_idpermiso" FOREIGN KEY ("idpermiso") REFERENCES "usuario"."permiso" ("id") MATCH FULL ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "usuario"."usuario_permiso" ADD CONSTRAINT "fk_usuario_permiso_idusuario" FOREIGN KEY ("idusuario") REFERENCES "usuario"."usuario" ("id") MATCH FULL ON DELETE NO ACTION ON UPDATE NO ACTION;
