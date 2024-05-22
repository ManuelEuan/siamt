DROP SCHEMA IF EXISTS "territorio" CASCADE;
DROP SCHEMA IF EXISTS  "comun" CASCADE;
DROP SCHEMA IF EXISTS "persona" CASCADE;
DROP SCHEMA IF EXISTS "inspeccion" CASCADE;
CREATE EXTENSION IF NOT EXISTS postgis;

CREATE SCHEMA "territorio";

CREATE SCHEMA "comun";

CREATE SCHEMA "persona";

CREATE SCHEMA "inspeccion";



/*
 Navicat Premium Data Transfer

 Source Server         : Local Postgres 12
 Source Server Type    : PostgreSQL
 Source Server Version : 120018
 Source Host           : localhost:5432
 Source Catalog        : siamt
 Source Schema         : territorio

 Target Server Type    : PostgreSQL
 Target Server Version : 120018
 File Encoding         : 65001

 Date: 20/05/2024 09:38:16
*/


-- ----------------------------
-- Sequence structure for cat_colonia_iidcolonia_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "territorio"."cat_colonia_iidcolonia_seq";
CREATE SEQUENCE "territorio"."cat_colonia_iidcolonia_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for cat_estado_iidestado_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "territorio"."cat_estado_iidestado_seq";
CREATE SEQUENCE "territorio"."cat_estado_iidestado_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for cat_municipio_iidmunicipio_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "territorio"."cat_municipio_iidmunicipio_seq";
CREATE SEQUENCE "territorio"."cat_municipio_iidmunicipio_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for cat_zona_iidzona_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "territorio"."cat_zona_iidzona_seq";
CREATE SEQUENCE "territorio"."cat_zona_iidzona_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Table structure for cat_colonia
-- ----------------------------
DROP TABLE IF EXISTS "territorio"."cat_colonia";
CREATE TABLE "territorio"."cat_colonia" (
  "iidcolonia" int4 NOT NULL DEFAULT nextval('"territorio".cat_colonia_iidcolonia_seq'::regclass),
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "iclave_municipio" int4 NOT NULL,
  "icodigo_postal" int4 NOT NULL,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
  "iclave_colonia" int4 NOT NULL
)
;

-- ----------------------------
-- Records of cat_colonia
-- ----------------------------
INSERT INTO "territorio"."cat_colonia" VALUES (1, 'Aguascalientes Centro', 1, 20000, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 1);
INSERT INTO "territorio"."cat_colonia" VALUES (2, 'Colinas del Rio', 1, 20010, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 5);
INSERT INTO "territorio"."cat_colonia" VALUES (3, 'Olivares Santana', 1, 20010, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 6);
INSERT INTO "territorio"."cat_colonia" VALUES (4, 'Las Brisas', 1, 20010, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 7);
INSERT INTO "territorio"."cat_colonia" VALUES (5, 'Ramon Romo Franco', 1, 20010, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 8);
INSERT INTO "territorio"."cat_colonia" VALUES (6, 'San Cayetano', 1, 20010, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 9);
INSERT INTO "territorio"."cat_colonia" VALUES (7, 'Colinas de San Ignacio', 1, 20016, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 10);
INSERT INTO "territorio"."cat_colonia" VALUES (8, 'La Fundición', 1, 20016, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 11);
INSERT INTO "territorio"."cat_colonia" VALUES (9, 'Fundición II', 1, 20016, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 12);
INSERT INTO "territorio"."cat_colonia" VALUES (10, 'Los Sauces', 1, 20016, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 13);
INSERT INTO "territorio"."cat_colonia" VALUES (11, 'Línea de Fuego', 1, 20018, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 14);
INSERT INTO "territorio"."cat_colonia" VALUES (12, 'Buenos Aires', 1, 20020, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 16);
INSERT INTO "territorio"."cat_colonia" VALUES (13, 'Circunvalación Norte', 1, 20020, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 18);
INSERT INTO "territorio"."cat_colonia" VALUES (14, 'Las Arboledas', 1, 20020, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 19);
INSERT INTO "territorio"."cat_colonia" VALUES (15, 'Villas de San Francisco', 1, 20020, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 20);
INSERT INTO "territorio"."cat_colonia" VALUES (16, 'Vergel', 50, 97173, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 122);
INSERT INTO "territorio"."cat_colonia" VALUES (17, 'Vergel II', 50, 97173, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 123);
INSERT INTO "territorio"."cat_colonia" VALUES (18, 'Vergel III', 50, 97173, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 124);
INSERT INTO "territorio"."cat_colonia" VALUES (19, 'Vergel IV', 50, 97173, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 125);
INSERT INTO "territorio"."cat_colonia" VALUES (20, 'San Jose Vergel', 50, 97173, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 126);
INSERT INTO "territorio"."cat_colonia" VALUES (21, 'Real San José', 50, 97173, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 283);
INSERT INTO "territorio"."cat_colonia" VALUES (22, 'Misne III', 50, 97173, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 1893);
INSERT INTO "territorio"."cat_colonia" VALUES (23, 'Villas La Macarena', 50, 97174, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 127);
INSERT INTO "territorio"."cat_colonia" VALUES (24, 'Morelos Oriente', 50, 97174, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 128);
INSERT INTO "territorio"."cat_colonia" VALUES (25, 'Amalia Solorzano', 50, 97175, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 129);
INSERT INTO "territorio"."cat_colonia" VALUES (26, 'Misné II', 50, 97176, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 278);
INSERT INTO "territorio"."cat_colonia" VALUES (27, 'San Pablo Oriente', 50, 97176, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 682);
INSERT INTO "territorio"."cat_colonia" VALUES (28, 'Vergel 65', 50, 97176, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 859);
INSERT INTO "territorio"."cat_colonia" VALUES (29, 'San Antonio Kaua', 50, 97176, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 911);
INSERT INTO "territorio"."cat_colonia" VALUES (30, 'El Vergel', 50, 97176, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 1006);
INSERT INTO "territorio"."cat_colonia" VALUES (31, 'Azcorra', 50, 97177, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 133);

-- ----------------------------
-- Table structure for cat_estado
-- ----------------------------
DROP TABLE IF EXISTS "territorio"."cat_estado";
CREATE TABLE "territorio"."cat_estado" (
  "iidestado" int4 NOT NULL DEFAULT nextval('"territorio".cat_estado_iidestado_seq'::regclass),
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
  "iclave_estado" int4 NOT NULL
)
;

-- ----------------------------
-- Records of cat_estado
-- ----------------------------
INSERT INTO "territorio"."cat_estado" VALUES (1, 'Aguascalientes', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 1);
INSERT INTO "territorio"."cat_estado" VALUES (2, 'Baja California', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 2);
INSERT INTO "territorio"."cat_estado" VALUES (3, 'Baja California Sur', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 3);
INSERT INTO "territorio"."cat_estado" VALUES (4, 'Campeche', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 4);
INSERT INTO "territorio"."cat_estado" VALUES (5, 'Coahuila de Zaragoza', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 5);
INSERT INTO "territorio"."cat_estado" VALUES (6, 'Colima', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 6);
INSERT INTO "territorio"."cat_estado" VALUES (7, 'Chiapas', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 7);
INSERT INTO "territorio"."cat_estado" VALUES (8, 'Chihuahua', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 8);
INSERT INTO "territorio"."cat_estado" VALUES (9, 'Ciudad de México', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 9);
INSERT INTO "territorio"."cat_estado" VALUES (10, 'Durango', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 10);
INSERT INTO "territorio"."cat_estado" VALUES (11, 'Guanajuato', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 11);
INSERT INTO "territorio"."cat_estado" VALUES (12, 'Guerrero', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 12);
INSERT INTO "territorio"."cat_estado" VALUES (13, 'Hidalgo', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 13);
INSERT INTO "territorio"."cat_estado" VALUES (14, 'Jalisco', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 14);
INSERT INTO "territorio"."cat_estado" VALUES (15, 'México', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 15);
INSERT INTO "territorio"."cat_estado" VALUES (16, 'Michoacán de Ocampo', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 16);
INSERT INTO "territorio"."cat_estado" VALUES (17, 'Morelos', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 17);
INSERT INTO "territorio"."cat_estado" VALUES (18, 'Nayarit', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 18);
INSERT INTO "territorio"."cat_estado" VALUES (19, 'Nuevo León', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 19);
INSERT INTO "territorio"."cat_estado" VALUES (20, 'Oaxaca', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 20);
INSERT INTO "territorio"."cat_estado" VALUES (21, 'Puebla', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 21);
INSERT INTO "territorio"."cat_estado" VALUES (22, 'Querétaro', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 22);
INSERT INTO "territorio"."cat_estado" VALUES (23, 'Quintana Roo', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 23);
INSERT INTO "territorio"."cat_estado" VALUES (24, 'San Luis Potosí', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 24);
INSERT INTO "territorio"."cat_estado" VALUES (25, 'Sinaloa', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 25);
INSERT INTO "territorio"."cat_estado" VALUES (26, 'Sonora', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 26);
INSERT INTO "territorio"."cat_estado" VALUES (27, 'Tabasco', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 27);
INSERT INTO "territorio"."cat_estado" VALUES (28, 'Tamaulipas', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 28);
INSERT INTO "territorio"."cat_estado" VALUES (29, 'Tlaxcala', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 29);
INSERT INTO "territorio"."cat_estado" VALUES (30, 'Veracruz de Ignacio de la Llave', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 30);
INSERT INTO "territorio"."cat_estado" VALUES (31, 'Yucatán', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 31);
INSERT INTO "territorio"."cat_estado" VALUES (32, 'Zacatecas', 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 32);

-- ----------------------------
-- Table structure for cat_municipio
-- ----------------------------
DROP TABLE IF EXISTS "territorio"."cat_municipio";
CREATE TABLE "territorio"."cat_municipio" (
  "iidmunicipio" int4 NOT NULL DEFAULT nextval('"territorio".cat_municipio_iidmunicipio_seq'::regclass),
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "iclave_estado" int4 NOT NULL,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
  "iclave_municipio" int4 NOT NULL
)
;

-- ----------------------------
-- Records of cat_municipio
-- ----------------------------
INSERT INTO "territorio"."cat_municipio" VALUES (1, 'Aguascalientes', 1, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 1);
INSERT INTO "territorio"."cat_municipio" VALUES (2, 'San Francisco de los Romo', 1, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 11);
INSERT INTO "territorio"."cat_municipio" VALUES (3, 'El Llano', 1, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 10);
INSERT INTO "territorio"."cat_municipio" VALUES (4, 'Rincón de Romos', 1, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 7);
INSERT INTO "territorio"."cat_municipio" VALUES (5, 'Cosío', 1, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 4);
INSERT INTO "territorio"."cat_municipio" VALUES (6, 'San José de Gracia', 1, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 8);
INSERT INTO "territorio"."cat_municipio" VALUES (7, 'Tepezalá', 1, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 9);
INSERT INTO "territorio"."cat_municipio" VALUES (8, 'Pabellón de Arteaga', 1, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 6);
INSERT INTO "territorio"."cat_municipio" VALUES (9, 'Asientos', 1, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 2);
INSERT INTO "territorio"."cat_municipio" VALUES (10, 'Calvillo', 1, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 3);
INSERT INTO "territorio"."cat_municipio" VALUES (11, 'Jesús María', 1, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 5);
INSERT INTO "territorio"."cat_municipio" VALUES (12, 'Mérida', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 50);
INSERT INTO "territorio"."cat_municipio" VALUES (13, 'Progreso', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 59);
INSERT INTO "territorio"."cat_municipio" VALUES (14, 'Chicxulub Pueblo', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 20);
INSERT INTO "territorio"."cat_municipio" VALUES (15, 'Ixil', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 39);
INSERT INTO "territorio"."cat_municipio" VALUES (16, 'Conkal', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 13);
INSERT INTO "territorio"."cat_municipio" VALUES (17, 'Yaxkukul', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 105);
INSERT INTO "territorio"."cat_municipio" VALUES (18, 'Hunucmá', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 38);
INSERT INTO "territorio"."cat_municipio" VALUES (19, 'Ucú', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 100);
INSERT INTO "territorio"."cat_municipio" VALUES (20, 'Kinchil', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 44);
INSERT INTO "territorio"."cat_municipio" VALUES (21, 'Tetiz', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 87);
INSERT INTO "territorio"."cat_municipio" VALUES (22, 'Celestún', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 11);
INSERT INTO "territorio"."cat_municipio" VALUES (23, 'Kanasín', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 41);
INSERT INTO "territorio"."cat_municipio" VALUES (24, 'Timucuy', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 90);
INSERT INTO "territorio"."cat_municipio" VALUES (25, 'Acanceh', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 2);
INSERT INTO "territorio"."cat_municipio" VALUES (26, 'Tixpéhual', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 95);
INSERT INTO "territorio"."cat_municipio" VALUES (27, 'Umán', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 101);
INSERT INTO "territorio"."cat_municipio" VALUES (28, 'Telchac Pueblo', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 82);
INSERT INTO "territorio"."cat_municipio" VALUES (29, 'Dzemul', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 26);
INSERT INTO "territorio"."cat_municipio" VALUES (30, 'Telchac Puerto', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 83);
INSERT INTO "territorio"."cat_municipio" VALUES (31, 'Cansahcab', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 9);
INSERT INTO "territorio"."cat_municipio" VALUES (32, 'Sinanché', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 68);
INSERT INTO "territorio"."cat_municipio" VALUES (33, 'Yobaín', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 106);
INSERT INTO "territorio"."cat_municipio" VALUES (34, 'Motul', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 52);
INSERT INTO "territorio"."cat_municipio" VALUES (35, 'Baca', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 4);
INSERT INTO "territorio"."cat_municipio" VALUES (36, 'Mocochá', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 51);
INSERT INTO "territorio"."cat_municipio" VALUES (37, 'Muxupip', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 54);
INSERT INTO "territorio"."cat_municipio" VALUES (38, 'Cacalchén', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 7);
INSERT INTO "territorio"."cat_municipio" VALUES (39, 'Bokobá', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 5);
INSERT INTO "territorio"."cat_municipio" VALUES (40, 'Tixkokob', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 93);
INSERT INTO "territorio"."cat_municipio" VALUES (41, 'Hoctún', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 35);
INSERT INTO "territorio"."cat_municipio" VALUES (42, 'Tahmek', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 74);
INSERT INTO "territorio"."cat_municipio" VALUES (43, 'Dzidzantún', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 27);
INSERT INTO "territorio"."cat_municipio" VALUES (44, 'Temax', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 84);
INSERT INTO "territorio"."cat_municipio" VALUES (45, 'Tekantó', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 78);
INSERT INTO "territorio"."cat_municipio" VALUES (46, 'Teya', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 88);
INSERT INTO "territorio"."cat_municipio" VALUES (47, 'Suma', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 72);
INSERT INTO "territorio"."cat_municipio" VALUES (48, 'Tepakán', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 86);
INSERT INTO "territorio"."cat_municipio" VALUES (49, 'Tekal de Venegas', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 77);
INSERT INTO "territorio"."cat_municipio" VALUES (50, 'Izamal', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 40);
INSERT INTO "territorio"."cat_municipio" VALUES (51, 'Hocabá', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 34);
INSERT INTO "territorio"."cat_municipio" VALUES (52, 'Xocchel', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 103);
INSERT INTO "territorio"."cat_municipio" VALUES (53, 'Seyé', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 67);
INSERT INTO "territorio"."cat_municipio" VALUES (54, 'Cuzamá', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 15);
INSERT INTO "territorio"."cat_municipio" VALUES (55, 'Homún', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 36);
INSERT INTO "territorio"."cat_municipio" VALUES (56, 'Sanahcat', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 64);
INSERT INTO "territorio"."cat_municipio" VALUES (57, 'Huhí', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 37);
INSERT INTO "territorio"."cat_municipio" VALUES (58, 'Dzilam González', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 29);
INSERT INTO "territorio"."cat_municipio" VALUES (59, 'Dzilam de Bravo', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 28);
INSERT INTO "territorio"."cat_municipio" VALUES (60, 'Panabá', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 57);
INSERT INTO "territorio"."cat_municipio" VALUES (61, 'San Felipe', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 65);
INSERT INTO "territorio"."cat_municipio" VALUES (62, 'Buctzotz', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 6);
INSERT INTO "territorio"."cat_municipio" VALUES (63, 'Sucilá', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 70);
INSERT INTO "territorio"."cat_municipio" VALUES (64, 'Cenotillo', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 12);
INSERT INTO "territorio"."cat_municipio" VALUES (65, 'Dzoncauich', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 31);
INSERT INTO "territorio"."cat_municipio" VALUES (66, 'Tunkás', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 97);
INSERT INTO "territorio"."cat_municipio" VALUES (67, 'Quintana Roo', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 60);
INSERT INTO "territorio"."cat_municipio" VALUES (68, 'Dzitás', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 30);
INSERT INTO "territorio"."cat_municipio" VALUES (69, 'Kantunil', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 42);
INSERT INTO "territorio"."cat_municipio" VALUES (70, 'Sudzal', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 71);
INSERT INTO "territorio"."cat_municipio" VALUES (71, 'Tekit', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 80);
INSERT INTO "territorio"."cat_municipio" VALUES (72, 'Sotuta', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 69);
INSERT INTO "territorio"."cat_municipio" VALUES (73, 'Tizimín', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 96);
INSERT INTO "territorio"."cat_municipio" VALUES (74, 'Río Lagartos', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 61);
INSERT INTO "territorio"."cat_municipio" VALUES (75, 'Espita', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 32);
INSERT INTO "territorio"."cat_municipio" VALUES (76, 'Temozón', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 85);
INSERT INTO "territorio"."cat_municipio" VALUES (77, 'Calotmul', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 8);
INSERT INTO "territorio"."cat_municipio" VALUES (78, 'Tinum', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 91);
INSERT INTO "territorio"."cat_municipio" VALUES (79, 'Chankom', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 17);
INSERT INTO "territorio"."cat_municipio" VALUES (80, 'Chichimilá', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 21);
INSERT INTO "territorio"."cat_municipio" VALUES (81, 'Tixcacalcupul', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 92);
INSERT INTO "territorio"."cat_municipio" VALUES (82, 'Kaua', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 43);
INSERT INTO "territorio"."cat_municipio" VALUES (83, 'Cuncunul', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 14);
INSERT INTO "territorio"."cat_municipio" VALUES (84, 'Tekom', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 81);
INSERT INTO "territorio"."cat_municipio" VALUES (85, 'Chemax', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 19);
INSERT INTO "territorio"."cat_municipio" VALUES (86, 'Valladolid', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 102);
INSERT INTO "territorio"."cat_municipio" VALUES (87, 'Uayma', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 99);
INSERT INTO "territorio"."cat_municipio" VALUES (88, 'Maxcanú', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 48);
INSERT INTO "territorio"."cat_municipio" VALUES (89, 'Samahil', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 63);
INSERT INTO "territorio"."cat_municipio" VALUES (90, 'Opichén', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 55);
INSERT INTO "territorio"."cat_municipio" VALUES (91, 'Chocholá', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 23);
INSERT INTO "territorio"."cat_municipio" VALUES (92, 'Kopomá', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 45);
INSERT INTO "territorio"."cat_municipio" VALUES (93, 'Tecoh', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 76);
INSERT INTO "territorio"."cat_municipio" VALUES (94, 'Akil', 31, 't', '2024-03-28 21:45:23.128034', '2024-03-28 21:45:23.128034', 3);

-- ----------------------------
-- Table structure for cat_zona
-- ----------------------------
DROP TABLE IF EXISTS "territorio"."cat_zona";
CREATE TABLE "territorio"."cat_zona" (
  "iidzona" int4 NOT NULL DEFAULT nextval('"territorio".cat_zona_iidzona_seq'::regclass),
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtdescripcion" text COLLATE "pg_catalog"."default",
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
  "gthe_geom" geometry(GEOMETRY),
  "txtgeojson" text COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "territorio"."cat_zona"."iidzona" IS 'Identificador único';

-- ----------------------------
-- Records of cat_zona
-- ----------------------------
INSERT INTO "territorio"."cat_zona" VALUES (1, 'Norte', NULL, 't', '2024-03-27 09:50:50.011115', '2024-03-27 09:50:50.011115', NULL, NULL);
INSERT INTO "territorio"."cat_zona" VALUES (2, 'Sur', NULL, 't', '2024-03-27 09:50:50.011115', '2024-03-27 09:50:50.011115', NULL, NULL);
INSERT INTO "territorio"."cat_zona" VALUES (3, 'Poniente', NULL, 't', '2024-03-27 09:50:50.011115', '2024-03-27 09:50:50.011115', NULL, NULL);
INSERT INTO "territorio"."cat_zona" VALUES (4, 'Oriente', NULL, 't', '2024-03-27 09:50:50.011115', '2024-03-27 09:50:50.011115', NULL, NULL);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "territorio"."cat_colonia_iidcolonia_seq"
OWNED BY "territorio"."cat_colonia"."iidcolonia";
SELECT setval('"territorio"."cat_colonia_iidcolonia_seq"', 31, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "territorio"."cat_estado_iidestado_seq"
OWNED BY "territorio"."cat_estado"."iidestado";
SELECT setval('"territorio"."cat_estado_iidestado_seq"', 32, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "territorio"."cat_municipio_iidmunicipio_seq"
OWNED BY "territorio"."cat_municipio"."iidmunicipio";
SELECT setval('"territorio"."cat_municipio_iidmunicipio_seq"', 94, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "territorio"."cat_zona_iidzona_seq"
OWNED BY "territorio"."cat_zona"."iidzona";
SELECT setval('"territorio"."cat_zona_iidzona_seq"', 4, true);

-- ----------------------------
-- Primary Key structure for table cat_colonia
-- ----------------------------
ALTER TABLE "territorio"."cat_colonia" ADD CONSTRAINT "cat_colonia_pkey" PRIMARY KEY ("iidcolonia");

-- ----------------------------
-- Primary Key structure for table cat_estado
-- ----------------------------
ALTER TABLE "territorio"."cat_estado" ADD CONSTRAINT "cat_estado_pkey" PRIMARY KEY ("iidestado");

-- ----------------------------
-- Primary Key structure for table cat_municipio
-- ----------------------------
ALTER TABLE "territorio"."cat_municipio" ADD CONSTRAINT "cat_municipio_pkey" PRIMARY KEY ("iidmunicipio");

-- ----------------------------
-- Primary Key structure for table cat_zona
-- ----------------------------
ALTER TABLE "territorio"."cat_zona" ADD CONSTRAINT "cat_zona_pkey" PRIMARY KEY ("iidzona");

-- ----------------------------
-- Foreign Keys structure for table cat_colonia
-- ----------------------------
ALTER TABLE "territorio"."cat_colonia" ADD CONSTRAINT "fk_cat_colonia_cat_municipio_iidmunicipio" FOREIGN KEY ("iclave_municipio") REFERENCES "territorio"."cat_municipio" ("iidmunicipio") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cat_municipio
-- ----------------------------
ALTER TABLE "territorio"."cat_municipio" ADD CONSTRAINT "fk_cat_municipio_cat_estado_iidestado" FOREIGN KEY ("iclave_estado") REFERENCES "territorio"."cat_estado" ("iidestado") ON DELETE NO ACTION ON UPDATE NO ACTION;



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


/*
 Navicat Premium Data Transfer

 Source Server         : Local Postgres 12
 Source Server Type    : PostgreSQL
 Source Server Version : 120018
 Source Host           : localhost:5432
 Source Catalog        : siamt
 Source Schema         : persona

 Target Server Type    : PostgreSQL
 Target Server Version : 120018
 File Encoding         : 65001

 Date: 20/05/2024 09:38:05
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
INSERT INTO "persona"."tbl_persona" VALUES (4, 't', 'Michael Jair', 'Carrilllo', 'Uicab 2', '2024-05-01', NULL, '', 'CAUM990224HYNRCC04', '', NULL, NULL, '', 't', '2024-05-08 15:18:50.443325', '2024-05-08 15:42:43');

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
SELECT setval('"persona"."tbl_direccion_iiddireccion_seq"', 8, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "persona"."tbl_persona_direccion_iidpersona_direccion_seq"
OWNED BY "persona"."tbl_persona_direccion"."iidpersona_direccion";
SELECT setval('"persona"."tbl_persona_direccion_iidpersona_direccion_seq"', 7, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "persona"."tbl_persona_iidpersona_seq"
OWNED BY "persona"."tbl_persona"."iidpersona";
SELECT setval('"persona"."tbl_persona_iidpersona_seq"', 4, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "persona"."tbl_persona_telefono_iidpersona_telefono_seq"
OWNED BY "persona"."tbl_persona_telefono"."iidpersona_telefono";
SELECT setval('"persona"."tbl_persona_telefono_iidpersona_telefono_seq"', 8, true);

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
SELECT setval('"persona"."tbl_telefono_iidtelefono_seq"', 8, true);

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



/*
 Navicat Premium Data Transfer

 Source Server         : Local Postgres 12
 Source Server Type    : PostgreSQL
 Source Server Version : 120018
 Source Host           : localhost:5432
 Source Catalog        : siamt
 Source Schema         : inspeccion

 Target Server Type    : PostgreSQL
 Target Server Version : 120018
 File Encoding         : 65001

 Date: 20/05/2024 09:37:56
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
INSERT INTO "inspeccion"."tbl_inspector" VALUES (4, 4, 1, 3, 12, 2, 'Folio', '2024-05-10', NULL, NULL, '', 't', '2024-05-08 15:48:12.579478', '2024-05-10 14:13:51');

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
INSERT INTO "inspeccion"."tbl_inspector_seguimiento" VALUES (55, 4, 1, 1, 1, 2, 't', '2024-05-10 14:13:44.149136', '2024-05-10 14:13:44.149136');
INSERT INTO "inspeccion"."tbl_inspector_seguimiento" VALUES (56, 4, 1, 2, 1, 3, 't', '2024-05-10 14:13:45.97264', '2024-05-10 14:13:45.97264');
INSERT INTO "inspeccion"."tbl_inspector_seguimiento" VALUES (57, 4, 1, 3, 3, 5, 't', '2024-05-10 14:13:47.35528', '2024-05-10 14:13:47.35528');
INSERT INTO "inspeccion"."tbl_inspector_seguimiento" VALUES (58, 4, 3, 5, 3, 6, 't', '2024-05-10 14:13:49.085255', '2024-05-10 14:13:49.085255');
INSERT INTO "inspeccion"."tbl_inspector_seguimiento" VALUES (59, 4, 3, 6, 3, 12, 't', '2024-05-10 14:13:51.198391', '2024-05-10 14:13:51.198391');

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
SELECT setval('"inspeccion"."tbl_inspector_iidinspector_seq"', 4, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "inspeccion"."tbl_inspector_seguimiento_iidinspector_seguimiento_seq"
OWNED BY "inspeccion"."tbl_inspector_seguimiento"."iidinspector_seguimiento";
SELECT setval('"inspeccion"."tbl_inspector_seguimiento_iidinspector_seguimiento_seq"', 59, true);

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



DROP TABLE IF EXISTS "usuario"."cat_firma_plantilla";
CREATE TABLE "usuario"."cat_firma_plantilla" (
  "iidfirma_plantilla" SERIAL PRIMARY KEY,
  "txtnombre" TEXT COLLATE "pg_catalog"."default" NOT NULL,
  "txtplantilla" TEXT COLLATE "pg_catalog"."default" NOT NULL,
  "bactivo" BOOLEAN NOT NULL DEFAULT true,
  "dtfecha_creacion" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "dtfecha_modificacion" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- ----------------------------
-- ----------------------------
-- Records of cat_firma_plantilla
-- ----------------------------
INSERT INTO "usuario"."cat_firma_plantilla" VALUES (1, 'Agencia de Transporte de Yucatán (ATY)', '%3Cimg%20style%3D%22margin-top%3A%205rem%3B%20padding%3A%200px%202rem%200px%201rem%3B%20float%3A%20left%3B%20width%3A%2035%25%3B%22%20src%3D%22..%2Fimages%2Faty.png%22%20alt%3D%22%22%20%2F%3E%0A%3Cdiv%20class%3D%22px-4%20pt-1%22%20style%3D%22border-left%3A%203px%20solid%20%23444444%3B%20float%3A%20left%3B%20max-width%3A%2065%25%3B%20height%3A%20195px%3B%22%3E%0A%3Cdiv%20class%3D%22pb-4%22%20style%3D%22font-weight%3A%20800%3B%20font-size%3A%201.8em%3B%20color%3A%20%23242f5d%3B%20font-family%3A%20''Helvetica%20Neue''%3B%22%3E%7B%25%25NOMBRE_COMPLETO%25%25%7D%3C%2Fdiv%3E%0A%3Cdiv%20class%3D%22pb-3%22%20style%3D%22font-weight%3A%20bold%3B%20font-size%3A%201.6em%3B%20color%3A%20%23242f5d%3B%20font-family%3A%20''Helvetica%20Neue''%3B%22%3E%3Cspan%20style%3D%22color%3A%20%2359af31%3B%20font-family%3A%20Panton%3B%22%3E%7B%25%25DEPENDENCIA%25%25%7D%3C%2Fspan%3E%3C%2Fdiv%3E%0A%3Cdiv%20class%3D%22pb-1%22%20style%3D%22font-weight%3A%20bold%3B%20font-size%3A%2014pt%3B%20color%3A%20%23242f5d%3B%20font-family%3A%20''Helvetica%20Neue''%3B%22%3E%7B%25%25PUESTO%25%25%7D%3C%2Fdiv%3E%0A%3Cdiv%20class%3D%22pb-1%22%20style%3D%22font-weight%3A%20bold%3B%20font-size%3A%2014pt%3B%20color%3A%20%23242f5d%3B%20font-family%3A%20''Helvetica%20Neue''%3B%22%3E%7B%25%25DEPARTAMENTO%25%25%7D%3C%2Fdiv%3E%0A%3Cdiv%20class%3D%22pb-1%22%20style%3D%22font-weight%3A%20bold%3B%20font-size%3A%2014pt%3B%20color%3A%20%23242f5d%3B%20font-family%3A%20''Helvetica%20Neue''%3B%22%3E%7B%25%25OFICINA%25%25%7D%20--%20%7B%25%25TELEFONO%25%25%7D%3C%2Fdiv%3E%0A%3C%2Fdiv%3E', 't', '2024-05-08 09:01:55', '2024-05-09 12:41:52.194842');

DROP TABLE IF EXISTS "usuario"."tbl_firma_registro";
CREATE TABLE IF NOT EXISTS usuario.tbl_firma_registro (
  iidfirma_registro SERIAL PRIMARY KEY,
  txtnombre TEXT,
  txtapepat TEXT,
  txtapemat TEXT,
  txtpuesto TEXT,
  txtoficina TEXT,
  txtdepartamento TEXT,
  txtemail TEXT,
  txttelefono TEXT,
  txtextension TEXT,
  txttitulo TEXT,
  iidfirma_plantilla INTEGER,
  bactivo BOOLEAN DEFAULT true,
  dtfecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  dtfecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
