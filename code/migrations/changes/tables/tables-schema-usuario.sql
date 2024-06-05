-- ***************** RESETEO DE SECUENCIAS *****************

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

----------------------------
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

-------------------------
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
  "tipo" "usuario"."data_t",
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
