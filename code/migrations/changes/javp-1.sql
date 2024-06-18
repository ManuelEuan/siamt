--liquibase formatted sql
--changeset javp:1

-- CREATE DATABASE mexico OWNER postgres;

CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE SCHEMA IF NOT EXISTS usuario AUTHORIZATION postgres;

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
BEGIN;
INSERT INTO "usuario"."dominio" VALUES (1, 'localhost', 'Inicial', 'a4e270a1-9689-4507-8988-749a0a919b21', 't', '2020-12-10 05:39:04.293219', '2020-12-10 05:39:04.293219');
COMMIT;

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
  "configuracion" jsonb NOT NULL DEFAULT '{}',
  "busqueda" text COLLATE "pg_catalog"."default" GENERATED ALWAYS AS (COALESCE(seccion,'') || ' ' || COALESCE(nombre,'') || ' ' || COALESCE(descripcion,'') || ' ' || COALESCE(siglas,'')) STORED,
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now()
)
;


CREATE INDEX trgm_idx_modulo_busqueda ON "usuario"."modulo" USING gin (busqueda gin_trgm_ops);
-- ----------------------------
-- Records of modulo
-- ----------------------------
BEGIN;
INSERT INTO "usuario"."modulo"(id,seccion,nombre,descripcion,siglas,icono,orden,activo,idpadre,fecha_creacion,fecha_modificacion) VALUES (1, 'Administración','Módulos', NULL, 'mdl', 'mdi-view-module', 1, 't', NULL, '2020-12-16 06:33:31.828102', '2020-12-16 06:33:31.828102');
INSERT INTO "usuario"."modulo"(id,seccion,nombre,descripcion,siglas,icono,orden,activo,idpadre,fecha_creacion,fecha_modificacion) VALUES (2, NULL,'Personas', NULL, 'pel', 'mdi-human-capacity-increase', NULL, 't', NULL, '2020-12-16 06:33:31.828102', '2020-12-16 06:33:31.828102');
COMMIT;

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
BEGIN;
INSERT INTO "usuario"."perfil" VALUES (1, 'Admin', 'Todos los permisos', 't', '2020-12-16 06:39:39.218785', '2020-12-16 06:39:39.218785');
COMMIT;

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
BEGIN;
COMMIT;

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
BEGIN;
INSERT INTO "usuario"."perfil_usuario" VALUES (1, 1, 't', '2020-12-16 06:42:56.281166', '2020-12-16 06:42:56.281166');
COMMIT;

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
BEGIN;
COMMIT;

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
  "correo" varchar(30) COLLATE "pg_catalog"."default",
  "admin" bool DEFAULT false,
  "activo" bool DEFAULT true,
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now()
)
;


-- ----------------------------
-- Records of usuario
-- ----------------------------
BEGIN;
INSERT INTO "usuario"."usuario" VALUES (1, 'master', 'fc613b4dfd6736a7bd268c8a0e74ed0d1c04a959f59dd74ef2874983fd443fc9', 'El', 'Administrador', NULL, NULL, 't', 't', '2020-11-23 22:03:05.743631', '2020-11-23 22:03:05.743631');
COMMIT;

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
BEGIN;
INSERT INTO "usuario"."usuario_dominio" VALUES (1, 1, 'f', 't', '2020-12-10 06:02:01.963005', '2020-12-10 06:02:01.963005');
COMMIT;

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
BEGIN;
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (1, 1, 1, 't', '2020-12-29 05:07:17.726421', '2020-12-29 05:07:17.726421');
INSERT INTO "usuario"."usuario_dominio_modulo" VALUES (1, 1, 2, 't', '2020-12-29 05:07:17.726421', '2020-12-29 05:07:17.726421');
COMMIT;

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
BEGIN;
COMMIT;

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
SELECT setval('"usuario"."modulo_id_seq"', 3, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "usuario"."perfil_id_seq"
OWNED BY "usuario"."perfil"."id";
SELECT setval('"usuario"."perfil_id_seq"', 2, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "usuario"."permiso_id_seq"
OWNED BY "usuario"."permiso"."id";
SELECT setval('"usuario"."permiso_id_seq"', 2, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "usuario"."usuario_id_seq"
OWNED BY "usuario"."usuario"."id";
SELECT setval('"usuario"."usuario_id_seq"', 2, true);


-- ----------------------------
-- Primary Key structure for table dominio
-- ----------------------------
ALTER TABLE "usuario"."dominio" ADD CONSTRAINT "pk_dominio" PRIMARY KEY ("id");

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
-- Primary Key structure for table usuario
-- ----------------------------
ALTER TABLE "usuario"."usuario" ADD CONSTRAINT "pk_usuario" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table usuario_dominio
-- ----------------------------
ALTER TABLE "usuario"."usuario_dominio" ADD CONSTRAINT "pk_usuario_dominio" PRIMARY KEY ("idusuario", "iddominio");

-- ----------------------------
-- Primary Key structure for table usuario_dominio_modulo
-- ----------------------------
ALTER TABLE "usuario"."usuario_dominio_modulo" ADD CONSTRAINT "pk_usuario_dominio_modulo" PRIMARY KEY ("idusuario", "iddominio", "idmodulo");

-- ----------------------------
-- Primary Key structure for table usuario_permiso
-- ----------------------------
ALTER TABLE "usuario"."usuario_permiso" ADD CONSTRAINT "pk_usuario_permiso" PRIMARY KEY ("idusuario", "idpermiso");

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
