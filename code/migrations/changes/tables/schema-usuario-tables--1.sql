DO $$ 
BEGIN 
  IF EXISTS(SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'usuario' AND sequence_name = 'cat_firma_plantilla_iid_firma_plantilla_seq') THEN 
    DROP SEQUENCE "usuario"."cat_firma_plantilla_iid_firma_plantilla_seq" CASCADE; 
  END IF; 

  IF EXISTS(SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'usuario' AND sequence_name = 'dominio_id_seq') THEN 
    DROP SEQUENCE "usuario"."dominio_id_seq" CASCADE; 
  END IF; 

  IF EXISTS(SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'usuario' AND sequence_name = 'modulo_id_seq') THEN 
    DROP SEQUENCE "usuario"."modulo_id_seq" CASCADE; 
  END IF; 

  IF EXISTS(SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'usuario' AND sequence_name = 'perfil_id_seq') THEN 
    DROP SEQUENCE "usuario"."perfil_id_seq" CASCADE; 
  END IF; 

  IF EXISTS(SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'usuario' AND sequence_name = 'permiso_id_seq') THEN 
    DROP SEQUENCE "usuario"."permiso_id_seq" CASCADE; 
  END IF; 

  IF EXISTS(SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'usuario' AND sequence_name = 'usuario_id_seq') THEN 
    DROP SEQUENCE "usuario"."usuario_id_seq" CASCADE; 
  END IF; 

  IF EXISTS(SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'usuario' AND sequence_name = 'tbl_firma_registro_iidfirma_registro_seq') THEN 
    DROP SEQUENCE "usuario"."tbl_firma_registro_iidfirma_registro_seq" CASCADE; 
  END IF; 

  IF EXISTS(SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'usuario' AND sequence_name = 'tbl_firma_registro_usuario_iidfirma_registro_usuario_seq') THEN 
    DROP SEQUENCE "usuario"."tbl_firma_registro_usuario_iidfirma_registro_usuario_seq" CASCADE; 
  END IF; 
END $$;

CREATE SEQUENCE "usuario"."cat_firma_plantilla_iid_firma_plantilla_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1; 
CREATE SEQUENCE "usuario"."dominio_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
CREATE SEQUENCE "usuario"."modulo_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
CREATE SEQUENCE "usuario"."perfil_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
CREATE SEQUENCE "usuario"."permiso_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
CREATE SEQUENCE "usuario"."usuario_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
CREATE SEQUENCE "usuario"."tbl_firma_registro_iidfirma_registro_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1; 
CREATE SEQUENCE "usuario"."tbl_firma_registro_usuario_iidfirma_registro_usuario_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1; 


CREATE TABLE IF NOT EXISTS "usuario"."usuario" (
  "id" int4 NOT NULL DEFAULT nextval('"usuario"."usuario_id_seq"'::regclass),
  "usuario" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "clave" char(64) COLLATE "pg_catalog"."default",
  "nombre" varchar(30) COLLATE "pg_catalog"."default",
  "apepat" varchar(30) COLLATE "pg_catalog"."default",
  "apemat" varchar(30) COLLATE "pg_catalog"."default",
  "correo" varchar(50) COLLATE "pg_catalog"."default",
  "admin" bool DEFAULT false,
  "activo" bool DEFAULT true,
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now(),
  CONSTRAINT "unique_id_usuario" UNIQUE ("id")
);


CREATE TABLE IF NOT EXISTS "usuario"."cat_firma_plantilla" (
  "iidfirma_plantilla" int4 NOT NULL DEFAULT nextval('"usuario"."cat_firma_plantilla_iid_firma_plantilla_seq"'::regclass),
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtplantilla" text COLLATE "pg_catalog"."default" NOT NULL,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6),
  "dtfecha_modificacion" timestamp(6),
  CONSTRAINT "unique_iidfirma_plantilla" UNIQUE ("iidfirma_plantilla")
);

CREATE TABLE IF NOT EXISTS "usuario"."dominio" (
  "id" int4 NOT NULL DEFAULT nextval('"usuario"."dominio_id_seq"'::regclass),
  "nombre" varchar(48) COLLATE "pg_catalog"."default" NOT NULL,
  "descripcion" varchar(48) COLLATE "pg_catalog"."default" NOT NULL,
  "llave" uuid NOT NULL,
  "activo" bool NOT NULL DEFAULT true,
  "fecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "fecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
  CONSTRAINT "unique_id_dominio" UNIQUE ("id")
);

CREATE TABLE IF NOT EXISTS "usuario"."modulo" (
  "id" int4 NOT NULL DEFAULT nextval('"usuario"."modulo_id_seq"'::regclass),
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
  "fecha_modificacion" timestamp(6) DEFAULT now(),
  CONSTRAINT "unique_id_modulo" UNIQUE ("id"),
  CONSTRAINT "fk_modulo_idpadre" FOREIGN KEY ("idpadre") REFERENCES "usuario"."modulo"("id") ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS "usuario"."perfil" (
  "id" int4 NOT NULL DEFAULT nextval('"usuario"."perfil_id_seq"'::regclass),
  "nombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "descripcion" text COLLATE "pg_catalog"."default",
  "activo" bool DEFAULT true,
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now(),
  CONSTRAINT "unique_id_perfil" UNIQUE ("id")
);

CREATE TABLE IF NOT EXISTS "usuario"."permiso" (
  "id" int4 NOT NULL DEFAULT nextval('"usuario"."permiso_id_seq"'::regclass),
  "nombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "descripcion" text COLLATE "pg_catalog"."default",
  "siglas" varchar(30) COLLATE "pg_catalog"."default" NOT NULL,
  "idmodulo" int4,
  "activo" bool DEFAULT true,
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now(),
  CONSTRAINT "unique_id_permiso" UNIQUE ("id"),
  CONSTRAINT "fk_permiso_idmodulo" FOREIGN KEY ("idmodulo") REFERENCES "usuario"."modulo"("id") ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS "usuario"."tbl_firma_registro" (
  "iidfirma_registro" int4 NOT NULL DEFAULT nextval('"usuario"."tbl_firma_registro_iidfirma_registro_seq"'::regclass),
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
  "iidfirma_plantilla" int4 NOT NULL,
  CONSTRAINT "unique_iidfirma_registro" UNIQUE ("iidfirma_registro"),
  CONSTRAINT "fk_tbl_firma_registro_iidfirma_plantilla" FOREIGN KEY ("iidfirma_plantilla") REFERENCES "usuario"."cat_firma_plantilla"("iidfirma_plantilla") ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS "usuario"."tbl_firma_registro_usuario" (
  "iidfirma_registro_usuario" int4 NOT NULL DEFAULT nextval('"usuario"."tbl_firma_registro_usuario_iidfirma_registro_usuario_seq"'::regclass),
  "iidfirma_registro" int4 NOT NULL,
  "iidusuario" int4 NOT NULL,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6),
  "dtfecha_modificacion" timestamp(6),
  PRIMARY KEY ("iidfirma_registro_usuario"),
  CONSTRAINT "fk_tbl_firma_registro_usuario_iidfirma_registro" FOREIGN KEY ("iidfirma_registro") REFERENCES "usuario"."tbl_firma_registro"("iidfirma_registro") ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "fk_tbl_firma_registro_usuario_iidusuario" FOREIGN KEY ("iidusuario") REFERENCES "usuario"."usuario"("id") ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS "usuario"."dominio_configuracion" (
  "iddominio" int4 NOT NULL,
  "clave" varchar(30) COLLATE "pg_catalog"."default" NOT NULL,
  "valor" varchar(30) COLLATE "pg_catalog"."default",
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now(),
  CONSTRAINT "fk_dominio_configuracion_iddominio" FOREIGN KEY ("iddominio") REFERENCES "usuario"."dominio"("id") ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS "usuario"."perfil_permiso" (
  "idperfil" int4 NOT NULL,
  "idpermiso" int4 NOT NULL,
  "activo" bool DEFAULT true,
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now(),
  CONSTRAINT "fk_perfil_permiso_idperfil" FOREIGN KEY ("idperfil") REFERENCES "usuario"."perfil"("id") ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "fk_perfil_permiso_idpermiso" FOREIGN KEY ("idpermiso") REFERENCES "usuario"."permiso"("id") ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS "usuario"."perfil_usuario" (
  "idusuario" int4 NOT NULL,
  "idperfil" int4 NOT NULL,
  "activo" bool DEFAULT true,
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now(),
  CONSTRAINT "fk_perfil_usuario_idusuario" FOREIGN KEY ("idusuario") REFERENCES "usuario"."usuario"("id") ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "fk_perfil_usuario_idperfil" FOREIGN KEY ("idperfil") REFERENCES "usuario"."perfil"("id") ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS "usuario"."usuario_permiso" (
  "idusuario" int4 NOT NULL,
  "idpermiso" int4 NOT NULL,
  "activo" bool DEFAULT true,
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now(),
  CONSTRAINT "fk_usuario_permiso_idpermiso" FOREIGN KEY ("idpermiso") REFERENCES "usuario"."permiso"("id") ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "fk_usuario_permiso_idusuario" FOREIGN KEY ("idusuario") REFERENCES "usuario"."usuario"("id") ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS "usuario"."usuario_dominio" (
  "idusuario" int4 NOT NULL,
  "iddominio" int4 NOT NULL,
  "admin" bool DEFAULT false,
  "activo" bool DEFAULT true,
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now(),
  CONSTRAINT "fk_usuario_dominio_iddominio" FOREIGN KEY ("iddominio") REFERENCES "usuario"."dominio"("id") ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "fk_usuario_dominio_idusuario" FOREIGN KEY ("idusuario") REFERENCES "usuario"."usuario"("id") ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS "usuario"."usuario_dominio_configuracion" (
  "idusuario" int4 NOT NULL,
  "iddominio" int4 NOT NULL,
  "clave" varchar(30) COLLATE "pg_catalog"."default" NOT NULL,
  "valor" varchar(30) COLLATE "pg_catalog"."default",
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now(),
  CONSTRAINT "fk_usuario_dominio_configuracion_iddominio" FOREIGN KEY ("iddominio") REFERENCES "usuario"."dominio"("id") ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "fk_usuario_dominio_configuracion_idusuario" FOREIGN KEY ("idusuario") REFERENCES "usuario"."usuario"("id") ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS "usuario"."usuario_dominio_modulo" (
  "idusuario" int4 NOT NULL,
  "iddominio" int4 NOT NULL,
  "idmodulo" int4 NOT NULL,
  "activo" bool DEFAULT true,
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now(),
  CONSTRAINT "fk_usuario_dominio_modulo_iddominio" FOREIGN KEY ("iddominio") REFERENCES "usuario"."dominio"("id") ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "fk_usuario_dominio_modulo_idmodulo" FOREIGN KEY ("idmodulo") REFERENCES "usuario"."modulo"("id") ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "fk_usuario_dominio_modulo_idusuario" FOREIGN KEY ("idusuario") REFERENCES "usuario"."usuario"("id") ON DELETE CASCADE ON UPDATE CASCADE
);
