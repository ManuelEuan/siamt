-- ***************** RESETEO DE SECUENCIAS *****************

-- ----------------------------
-- Type structure for data_t
-- ----------------------------

-- Antes de eliminar el tipo, elimina las columnas que dependen de él en las tablas mencionadas
-- ALTER TABLE "usuario"."dominio_configuracion" DROP COLUMN "tipo";
-- ALTER TABLE "usuario"."usuario_dominio_configuracion" DROP COLUMN "tipo";

-- DROP TYPE IF EXISTS "usuario"."data_t";
-- CREATE TYPE "usuario"."data_t" AS ENUM (
--   'string',
--   'number',
--   'boolean',
--   'array'
-- );
-- ALTER TYPE "usuario"."data_t" OWNER TO "postgres";

-- ----------------------------
-- Sequence structure for cat_firma_plantilla_iid_firma_plantilla_seq
-- ----------------------------
-- Primero, eliminamos las columnas con valores predeterminados que dependen de la secuencia
ALTER TABLE "usuario"."cat_firma_plantilla" ALTER COLUMN "iidfirma_plantilla" DROP DEFAULT;
ALTER TABLE "usuario"."tbl_firma_registro" ALTER COLUMN "iidfirma_registro" DROP DEFAULT;
ALTER TABLE "usuario"."tbl_firma_registro_usuario" ALTER COLUMN "iidfirma_registro_usuario" DROP DEFAULT;

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
DROP SEQUENCE IF EXISTS "usuario"."dominio_id_seq" CASCADE;
CREATE SEQUENCE "usuario"."dominio_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for modulo_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "usuario"."modulo_id_seq" CASCADE;
CREATE SEQUENCE "usuario"."modulo_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for perfil_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "usuario"."perfil_id_seq" CASCADE;
CREATE SEQUENCE "usuario"."perfil_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for permiso_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "usuario"."permiso_id_seq" CASCADE;
CREATE SEQUENCE "usuario"."permiso_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for usuario_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "usuario"."usuario_id_seq" CASCADE;
CREATE SEQUENCE "usuario"."usuario_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;


-- ***************** CREACIÓN DE TABLAS *****************

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


-- AQUÍ AGREGA LA RESTRICCIÓN ÚNICA EN LA COLUMNA "iidfirma_plantilla"
ALTER TABLE "usuario"."cat_firma_plantilla" ADD CONSTRAINT "unique_iidfirma_plantilla" UNIQUE ("iidfirma_plantilla");

-- ----------------------------
-- Table structure for dominio
-- ----------------------------
-- Paso 1: Eliminar las restricciones que dependen de la tabla "usuario.dominio"
ALTER TABLE "usuario"."dominio_configuracion" DROP CONSTRAINT IF EXISTS "fk_dom_configuracion_dominio";
ALTER TABLE "usuario"."usuario_dominio" DROP CONSTRAINT IF EXISTS "fk_usuario_dominio_dominio";
ALTER TABLE "usuario"."usuario_dominio_configuracion" DROP CONSTRAINT IF EXISTS "fk_usr_dom_configuracion_dominio";
ALTER TABLE "usuario"."usuario_dominio_modulo" DROP CONSTRAINT IF EXISTS "fk_usuario_dominio_modulo_iddominio";

-- Paso 2: Ahora puedes eliminar la tabla "usuario.dominio"
DROP TABLE IF EXISTS "usuario"."dominio";
-- Crear una restricción única en la columna "id"

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
ALTER TABLE "usuario"."dominio" ADD CONSTRAINT "unique_id_dominio" UNIQUE ("id");
-------------------------
-- Table structure for dominio_configuracion
-- ----------------------------
DROP TABLE IF EXISTS "usuario"."dominio_configuracion";
CREATE TABLE "usuario"."dominio_configuracion" (
  "iddominio" int4 NOT NULL,
  "clave" varchar(30) COLLATE "pg_catalog"."default" NOT NULL,
  "valor" varchar(30) COLLATE "pg_catalog"."default",
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now()
)
;

-- ----------------------------
-- Table structure for modulo
-- ----------------------------
-- Paso 1: Eliminar las restricciones que dependen de la tabla "usuario.modulo"
ALTER TABLE "usuario"."permiso" DROP CONSTRAINT IF EXISTS "fk_permiso_idmodulo";
ALTER TABLE "usuario"."usuario_dominio_modulo" DROP CONSTRAINT IF EXISTS "fk_usuario_dominio_modulo_idmodulo";

-- Paso 2: Ahora puedes eliminar la tabla "usuario.modulo"
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
-- AQUÍ AGREGA LA RESTRICCIÓN ÚNICA EN LA COLUMNA "id"
ALTER TABLE "usuario"."modulo" ADD CONSTRAINT "unique_id_modulo" UNIQUE ("id");



-- ----------------------------
-- Table structure for perfil
-- ----------------------------
-- Paso 1: Eliminar las restricciones que dependen de la tabla "usuario.perfil"
ALTER TABLE "usuario"."perfil_permiso" DROP CONSTRAINT IF EXISTS "fk_perfil_permiso_idperfil";
ALTER TABLE "usuario"."perfil_usuario" DROP CONSTRAINT IF EXISTS "fk_perfil_usuario_perfil";

-- Paso 2: Ahora puedes eliminar la tabla "usuario.perfil"
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

-- AQUÍ AGREGA LA RESTRICCIÓN ÚNICA EN LA COLUMNA "id"
ALTER TABLE "usuario"."perfil" ADD CONSTRAINT "unique_id_perfil" UNIQUE ("id");


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
-- Table structure for permiso
-- ----------------------------
ALTER TABLE "usuario"."usuario_permiso" DROP CONSTRAINT IF EXISTS "fk_usuario_permiso_idpermiso";

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

-- AQUÍ AGREGA LA RESTRICCIÓN ÚNICA EN LA COLUMNA "id"
ALTER TABLE "usuario"."permiso" ADD CONSTRAINT "unique_id_permiso" UNIQUE ("id");

-- ----------------------------
-- Sequence structure for tbl_firma_registro_iidfirma_registro_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "usuario"."tbl_firma_registro_iidfirma_registro_seq";
CREATE SEQUENCE "usuario"."tbl_firma_registro_iidfirma_registro_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Table structure for tbl_firma_registro
-- ----------------------------
DROP TABLE IF EXISTS "usuario"."tbl_firma_registro";
CREATE TABLE "usuario"."tbl_firma_registro" (
  "iidfirma_registro" int4 NOT NULL DEFAULT nextval('"usuario".tbl_firma_registro_iidfirma_registro_seq'::regclass),
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

-- AQUÍ AGREGA LA RESTRICCIÓN ÚNICA EN LA COLUMNA "iidfirma_registro"
ALTER TABLE "usuario"."tbl_firma_registro" ADD CONSTRAINT "unique_iidfirma_registro" UNIQUE ("iidfirma_registro");


-- ----------------------------
-- Sequence structure for tbl_firma_registro_usuario_iidfirma_registro_usuario_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "usuario"."tbl_firma_registro_usuario_iidfirma_registro_usuario_seq";
CREATE SEQUENCE "usuario"."tbl_firma_registro_usuario_iidfirma_registro_usuario_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Table structure for tbl_firma_registro_usuario
-- ----------------------------
DROP TABLE IF EXISTS "usuario"."tbl_firma_registro_usuario";
CREATE TABLE "usuario"."tbl_firma_registro_usuario" (
  "iidfirma_registro_usuario" int4 NOT NULL DEFAULT nextval('"usuario"."tbl_firma_registro_usuario_iidfirma_registro_usuario_seq"'::regclass),
  "iidfirma_registro" int4 NOT NULL,
  "iidusuario" int4 NOT NULL,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6),
  "dtfecha_modificacion" timestamp(6),
  PRIMARY KEY ("iidfirma_registro_usuario")
)
;



-- ----------------------------
-- Table structure for usuario
-- ----------------------------
DROP TABLE IF EXISTS "usuario"."usuario" CASCADE;
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
-- AQUÍ AGREGA LA RESTRICCIÓN ÚNICA EN LA COLUMNA "id"
ALTER TABLE "usuario"."usuario" ADD CONSTRAINT "unique_id_usuario" UNIQUE ("id");

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
-- Table structure for usuario_dominio_configuracion
-- ----------------------------
DROP TABLE IF EXISTS "usuario"."usuario_dominio_configuracion";
CREATE TABLE "usuario"."usuario_dominio_configuracion" (
  "idusuario" int4 NOT NULL,
  "iddominio" int4 NOT NULL,
  "clave" varchar(30) COLLATE "pg_catalog"."default" NOT NULL,
  "valor" varchar(30) COLLATE "pg_catalog"."default",
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now()
)
;


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
-- Table structure for usuario_permiso
-- ----------------------------

-- Finalmente, elimina la tabla "usuario.permiso"
DROP TABLE IF EXISTS "usuario"."usuario_permiso";

-- Vuelve a crear la tabla si es necesario
CREATE TABLE "usuario"."usuario_permiso" (
  "idusuario" int4 NOT NULL,
  "idpermiso" int4 NOT NULL,
  "activo" bool DEFAULT true,
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now()
);


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
-- Foreign Keys structure for table dominio_configuracion
-- ----------------------------
ALTER TABLE "usuario"."dominio_configuracion" ADD CONSTRAINT "fk_dominio_configuracion_iddominio" FOREIGN KEY ("iddominio") REFERENCES "usuario"."dominio"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table modulo
-- ----------------------------
ALTER TABLE "usuario"."modulo" ADD CONSTRAINT "fk_modulo_idpadre" FOREIGN KEY ("idpadre") REFERENCES "usuario"."modulo"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table perfil_permiso
-- ----------------------------
ALTER TABLE "usuario"."perfil_permiso" ADD CONSTRAINT "fk_perfil_permiso_idperfil" FOREIGN KEY ("idperfil") REFERENCES "usuario"."perfil"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "usuario"."perfil_permiso" ADD CONSTRAINT "fk_perfil_permiso_idpermiso" FOREIGN KEY ("idpermiso") REFERENCES "usuario"."permiso"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table perfil_usuario
-- ----------------------------
ALTER TABLE "usuario"."perfil_usuario" ADD CONSTRAINT "fk_perfil_usuario_idusuario" FOREIGN KEY ("idusuario") REFERENCES "usuario"."usuario"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "usuario"."perfil_usuario" ADD CONSTRAINT "fk_perfil_usuario_idperfil" FOREIGN KEY ("idperfil") REFERENCES "usuario"."perfil"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table permiso
-- ----------------------------
ALTER TABLE "usuario"."permiso" ADD CONSTRAINT "fk_permiso_idmodulo" FOREIGN KEY ("idmodulo") REFERENCES "usuario"."modulo"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_firma_registro
-- ----------------------------
ALTER TABLE "usuario"."tbl_firma_registro" ADD CONSTRAINT "fk_tbl_firma_registro_iidfirma_plantilla" FOREIGN KEY ("iidfirma_plantilla") REFERENCES "usuario"."cat_firma_plantilla"("iidfirma_plantilla") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table tbl_firma_registro_usuario
-- ----------------------------
ALTER TABLE "usuario"."tbl_firma_registro_usuario" ADD CONSTRAINT "fk_tbl_firma_registro_usuario_iidfirma_registro" FOREIGN KEY ("iidfirma_registro") REFERENCES "usuario"."tbl_firma_registro"("iidfirma_registro") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "usuario"."tbl_firma_registro_usuario" ADD CONSTRAINT "fk_tbl_firma_registro_usuario_iidusuario" FOREIGN KEY ("iidusuario") REFERENCES "usuario"."usuario"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table usuario_dominio
-- ----------------------------
ALTER TABLE "usuario"."usuario_dominio" ADD CONSTRAINT "fk_usuario_dominio_iddominio" FOREIGN KEY ("iddominio") REFERENCES "usuario"."dominio"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "usuario"."usuario_dominio" ADD CONSTRAINT "fk_usuario_dominio_idusuario" FOREIGN KEY ("idusuario") REFERENCES "usuario"."usuario"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table usuario_dominio_configuracion
-- ----------------------------
ALTER TABLE "usuario"."usuario_dominio_configuracion" ADD CONSTRAINT "fk_usuario_dominio_configuracion_iddominio" FOREIGN KEY ("iddominio") REFERENCES "usuario"."dominio"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "usuario"."usuario_dominio_configuracion" ADD CONSTRAINT "fk_usuario_dominio_configuracion_idusuario" FOREIGN KEY ("idusuario") REFERENCES "usuario"."usuario"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table usuario_dominio_modulo
-- ----------------------------
ALTER TABLE "usuario"."usuario_dominio_modulo" ADD CONSTRAINT "fk_usuario_dominio_modulo_iddominio" FOREIGN KEY ("iddominio") REFERENCES "usuario"."dominio"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "usuario"."usuario_dominio_modulo" ADD CONSTRAINT "fk_usuario_dominio_modulo_idmodulo" FOREIGN KEY ("idmodulo") REFERENCES "usuario"."modulo"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "usuario"."usuario_dominio_modulo" ADD CONSTRAINT "fk_usuario_dominio_modulo_idusuario" FOREIGN KEY ("idusuario") REFERENCES "usuario"."usuario"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- ----------------------------
-- Foreign Keys structure for table usuario_permiso
-- ----------------------------
ALTER TABLE "usuario"."usuario_permiso" ADD CONSTRAINT "fk_usuario_permiso_idpermiso" FOREIGN KEY ("idpermiso") REFERENCES "usuario"."permiso"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "usuario"."usuario_permiso" ADD CONSTRAINT "fk_usuario_permiso_idusuario" FOREIGN KEY ("idusuario") REFERENCES "usuario"."usuario"("id") ON DELETE CASCADE ON UPDATE CASCADE;
