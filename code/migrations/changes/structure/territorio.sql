/*
 Navicat Premium Data Transfer

 Source Server         : Local PostgreSQL 12 - 5432
 Source Server Type    : PostgreSQL
 Source Server Version : 120018
 Source Host           : localhost:5432
 Source Catalog        : siamt
 Source Schema         : territorio

 Target Server Type    : PostgreSQL
 Target Server Version : 120018
 File Encoding         : 65001

 Date: 16/05/2024 22:42:18
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
