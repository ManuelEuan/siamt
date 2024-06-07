
-- changeset imjcu-0.sql
-- Crear las extensiones necesarias así como los schemas boleta, comun, inspeccion, persona, territorio, usuario con su estructura correspondiente

-- **************************************************************** EXTENSIONES NECESARIAS ***********************************************************

CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS postgis;

-- **************************************************************** CREACÓN DE SCHEMAS ***********************************************************

CREATE SCHEMA "usuario";
CREATE SCHEMA "territorio";
CREATE SCHEMA "comun";
CREATE SCHEMA "persona";
CREATE SCHEMA "inspeccion";
CREATE SCHEMA "boleta";

-- **************************************************************** INFORMACIÓN SCHEMA USUARIO ***********************************************************
-- -------------------- SEQUENCIAS
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

-- -------------------- TABLAS

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

-- **************************************************************** INFORMACIÓN SCHEMA COMUN ***********************************************************
-- -------------------- SEQUENCIAS
DO $$ 
BEGIN 
  IF EXISTS(SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'comun' AND sequence_name = 'cat_etapa_iidetapa_seq') THEN 
    DROP SEQUENCE "comun"."cat_etapa_iidetapa_seq"; 
  END IF; 

  IF EXISTS(SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'comun' AND sequence_name = 'cat_flujo_iidflujo_seq') THEN 
    DROP SEQUENCE "comun"."cat_flujo_iidflujo_seq"; 
  END IF; 

  IF EXISTS(SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'comun' AND sequence_name = 'cat_proceso_iidproceso_seq') THEN 
    DROP SEQUENCE "comun"."cat_proceso_iidproceso_seq"; 
  END IF; 

  IF EXISTS(SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'comun' AND sequence_name = 'cat_subetapa_iidsubetapa_seq') THEN 
    DROP SEQUENCE "comun"."cat_subetapa_iidsubetapa_seq"; 
  END IF; 
END $$; 

CREATE SEQUENCE "comun"."cat_etapa_iidetapa_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
CREATE SEQUENCE "comun"."cat_flujo_iidflujo_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
CREATE SEQUENCE "comun"."cat_proceso_iidproceso_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
CREATE SEQUENCE "comun"."cat_subetapa_iidsubetapa_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 

-- -------------------- TABLAS
CREATE TABLE "comun"."cat_proceso" (
  "iidproceso" int4 NOT NULL DEFAULT nextval('"comun".cat_proceso_iidproceso_seq'::regclass),
  "iidmodulo" int4 NOT NULL,
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtdescripcion" text COLLATE "pg_catalog"."default",
  "txtsigla" text COLLATE "pg_catalog"."default" NOT NULL,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
  CONSTRAINT "cat_proceso_pkey" PRIMARY KEY ("iidproceso")
);

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
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
  CONSTRAINT "cat_etapa_pkey" PRIMARY KEY ("iidetapa"),
  CONSTRAINT "fk_cat_etapa_cat_proceso_iidproceso" FOREIGN KEY ("iidproceso") REFERENCES "comun"."cat_proceso" ("iidproceso") ON DELETE NO ACTION ON UPDATE NO ACTION
);
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
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
  CONSTRAINT "cat_subetapa_pkey" PRIMARY KEY ("iidsubetapa"),
  CONSTRAINT "fk_cat_subetapa_cat_etapa_iidetapa" FOREIGN KEY ("iidetapa") REFERENCES "comun"."cat_etapa" ("iidetapa") ON DELETE NO ACTION ON UPDATE NO ACTION
);


CREATE TABLE "comun"."cat_flujo" (
  "iidflujo" int4 NOT NULL DEFAULT nextval('"comun".cat_flujo_iidflujo_seq'::regclass),
  "iidsubetapa" int4 NOT NULL,
  "iidsubetapa_siguiente" int4 NOT NULL,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
  CONSTRAINT "cat_flujo_pkey" PRIMARY KEY ("iidflujo"),
  CONSTRAINT "fk_cat_flujo_cat_subetapa_iidsubetapa" FOREIGN KEY ("iidsubetapa") REFERENCES "comun"."cat_subetapa" ("iidsubetapa") ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT "fk_cat_flujo_cat_subetapa_iidsubetapa_siguiente" FOREIGN KEY ("iidsubetapa_siguiente") REFERENCES "comun"."cat_subetapa" ("iidsubetapa") ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- **************************************************************** INFORMACIÓN SCHEMA PERSONA ***********************************************************
-- -------------------- SEQUENCIAS
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'persona' AND sequencename = 'cat_estado_civil_iidestado_civil_seq') THEN
        CREATE SEQUENCE "persona"."cat_estado_civil_iidestado_civil_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'persona' AND sequencename = 'cat_lada_iidlada_seq') THEN
        CREATE SEQUENCE "persona"."cat_lada_iidlada_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'persona' AND sequencename = 'cat_sexo_iidsexo_seq') THEN
        CREATE SEQUENCE "persona"."cat_sexo_iidsexo_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'persona' AND sequencename = 'cat_telefono_tipo_iidtelefono_tipo_seq') THEN
        CREATE SEQUENCE "persona"."cat_telefono_tipo_iidtelefono_tipo_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'persona' AND sequencename = 'cat_tipo_iidtipo_seq') THEN
        CREATE SEQUENCE "persona"."cat_tipo_iidtipo_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'persona' AND sequencename = 'tbl_direccion_iiddireccion_seq') THEN
        CREATE SEQUENCE "persona"."tbl_direccion_iiddireccion_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'persona' AND sequencename = 'tbl_persona_direccion_iidpersona_direccion_seq') THEN
        CREATE SEQUENCE "persona"."tbl_persona_direccion_iidpersona_direccion_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'persona' AND sequencename = 'tbl_persona_iidpersona_seq') THEN
        CREATE SEQUENCE "persona"."tbl_persona_iidpersona_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'persona' AND sequencename = 'tbl_persona_telefono_iidpersona_telefono_seq') THEN
        CREATE SEQUENCE "persona"."tbl_persona_telefono_iidpersona_telefono_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'persona' AND sequencename = 'tbl_persona_tipo_iidpersona_tipo_seq') THEN
        CREATE SEQUENCE "persona"."tbl_persona_tipo_iidpersona_tipo_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'persona' AND sequencename = 'tbl_telefono_iidtelefono_seq') THEN
        CREATE SEQUENCE "persona"."tbl_telefono_iidtelefono_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;
END$$;

-- -------------------- TABLAS
CREATE TABLE IF NOT EXISTS "persona"."cat_estado_civil" (
    "iidestado_civil" int4 NOT NULL DEFAULT nextval('"persona".cat_estado_civil_iidestado_civil_seq'::regclass),
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "cat_estado_civil_pkey" PRIMARY KEY ("iidestado_civil")
);

CREATE TABLE IF NOT EXISTS "persona"."cat_lada" (
    "iidlada" int4 NOT NULL DEFAULT nextval('"persona".cat_lada_iidlada_seq'::regclass),
    "txtnombre" text COLLATE "pg_catalog"."default",
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "txtiso_tres" text COLLATE "pg_catalog"."default",
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "cat_lada_pkey" PRIMARY KEY ("iidlada")
);

CREATE TABLE IF NOT EXISTS "persona"."cat_sexo" (
    "iidsexo" int4 NOT NULL DEFAULT nextval('"persona".cat_sexo_iidsexo_seq'::regclass),
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "cat_sexo_pkey" PRIMARY KEY ("iidsexo")
);

CREATE TABLE IF NOT EXISTS "persona"."cat_telefono_tipo" (
    "iidtelefono_tipo" int4 NOT NULL DEFAULT nextval('"persona".cat_telefono_tipo_iidtelefono_tipo_seq'::regclass),
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "cat_telefono_tipo_pkey" PRIMARY KEY ("iidtelefono_tipo")
);

CREATE TABLE IF NOT EXISTS "persona"."cat_tipo" (
    "iidtipo" int4 NOT NULL DEFAULT nextval('"persona".cat_tipo_iidtipo_seq'::regclass),
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "cat_tipo_pkey" PRIMARY KEY ("iidtipo")
);

CREATE TABLE IF NOT EXISTS "persona"."tbl_direccion" (
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
    "txtdescripcion_direccion" text COLLATE "pg_catalog"."default",
    CONSTRAINT "tbl_direccion_pkey" PRIMARY KEY ("iiddireccion")
);

CREATE TABLE IF NOT EXISTS "persona"."tbl_persona" (
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
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_persona_pkey" PRIMARY KEY ("iidpersona"),
    CONSTRAINT "uq_tbl_persona_txtcurp" UNIQUE ("txtcurp")
);

CREATE TABLE IF NOT EXISTS "persona"."tbl_persona_direccion" (
    "iidpersona_direccion" int4 NOT NULL DEFAULT nextval('"persona".tbl_persona_direccion_iidpersona_direccion_seq'::regclass),
    "iidpersona" int4 NOT NULL,
    "iiddireccion" int4 NOT NULL,
    "bactual" bool DEFAULT true,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_persona_direccion_pkey" PRIMARY KEY ("iidpersona_direccion")
);

CREATE TABLE IF NOT EXISTS "persona"."tbl_persona_telefono" (
    "iidpersona_telefono" int4 NOT NULL DEFAULT nextval('"persona".tbl_persona_telefono_iidpersona_telefono_seq'::regclass),
    "iidpersona" int4 NOT NULL,
    "iidtelefono" int4 NOT NULL,
    "bactual" bool DEFAULT true,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_persona_telefono_pkey" PRIMARY KEY ("iidpersona_telefono")
);

CREATE TABLE IF NOT EXISTS "persona"."tbl_persona_tipo" (
    "iidpersona_tipo" int4 NOT NULL DEFAULT nextval('"persona".tbl_persona_tipo_iidpersona_tipo_seq'::regclass),
    "iidpersona" int4 NOT NULL,
    "iidtipo" int4 NOT NULL,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_persona_tipo_pkey" PRIMARY KEY ("iidpersona_tipo")
);

CREATE TABLE IF NOT EXISTS "persona"."tbl_telefono" (
    "iidtelefono" int4 NOT NULL DEFAULT nextval('"persona".tbl_telefono_iidtelefono_seq'::regclass),
    "inumero" int8 NOT NULL,
    "iidtelefono_tipo" int4 NOT NULL,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    "txtlada" text COLLATE "pg_catalog"."default",
    CONSTRAINT "tbl_telefono_pkey" PRIMARY KEY ("iidtelefono")
);


-- **************************************************************** INFORMACIÓN SCHEMA TERRITORIO ***********************************************************
-- -------------------- SEQUENCIAS
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'territorio' AND sequencename = 'cat_colonia_iidcolonia_seq') THEN
        CREATE SEQUENCE "territorio"."cat_colonia_iidcolonia_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'territorio' AND sequencename = 'cat_estado_iidestado_seq') THEN
        CREATE SEQUENCE "territorio"."cat_estado_iidestado_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'territorio' AND sequencename = 'cat_municipio_iidmunicipio_seq') THEN
        CREATE SEQUENCE "territorio"."cat_municipio_iidmunicipio_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'territorio' AND sequencename = 'cat_zona_iidzona_seq') THEN
        CREATE SEQUENCE "territorio"."cat_zona_iidzona_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;
END$$;

-- -------------------- TABLAS
CREATE TABLE IF NOT EXISTS "territorio"."cat_estado" (
    "iidestado" int4 NOT NULL DEFAULT nextval('"territorio".cat_estado_iidestado_seq'::regclass),
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    "iclave_estado" int4 NOT NULL,
    CONSTRAINT "cat_estado_pkey" PRIMARY KEY ("iidestado")
);


CREATE TABLE IF NOT EXISTS "territorio"."cat_municipio" (
    "iidmunicipio" int4 NOT NULL DEFAULT nextval('"territorio".cat_municipio_iidmunicipio_seq'::regclass),
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "iclave_estado" int4 NOT NULL,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    "iclave_municipio" int4 NOT NULL,
    CONSTRAINT "cat_municipio_pkey" PRIMARY KEY ("iidmunicipio"),
    CONSTRAINT "fk_cat_municipio_cat_estado_iidestado" FOREIGN KEY ("iclave_estado") REFERENCES "territorio"."cat_estado" ("iidestado") ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS "territorio"."cat_colonia" (
    "iidcolonia" int4 NOT NULL DEFAULT nextval('"territorio".cat_colonia_iidcolonia_seq'::regclass),
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "iclave_municipio" int4 NOT NULL,
    "icodigo_postal" int4 NOT NULL,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    "iclave_colonia" int4 NOT NULL,
    CONSTRAINT "cat_colonia_pkey" PRIMARY KEY ("iidcolonia"),
    CONSTRAINT "fk_cat_colonia_cat_municipio_iidmunicipio" FOREIGN KEY ("iclave_municipio") REFERENCES "territorio"."cat_municipio" ("iidmunicipio") ON DELETE NO ACTION ON UPDATE NO ACTION
);



CREATE TABLE IF NOT EXISTS "territorio"."cat_zona" (
    "iidzona" int4 NOT NULL DEFAULT nextval('"territorio".cat_zona_iidzona_seq'::regclass),
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    "gthe_geom" geometry(GEOMETRY),
    "txtgeojson" text COLLATE "pg_catalog"."default",
    CONSTRAINT "cat_zona_pkey" PRIMARY KEY ("iidzona")
);

-- **************************************************************** INFORMACIÓN SCHEMA INSPECCION ***********************************************************
-- -------------------- SEQUENCIAS
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'cat_carga_trabajo_tipo_iidcarga_trabajo_tipo_seq') THEN
        CREATE SEQUENCE "inspeccion"."cat_carga_trabajo_tipo_iidcarga_trabajo_tipo_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'cat_inspector_categoria_iidinspector_categoria_seq') THEN
        CREATE SEQUENCE "inspeccion"."cat_inspector_categoria_iidinspector_categoria_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'cat_turno_iidturno_seq') THEN
        CREATE SEQUENCE "inspeccion"."cat_turno_iidturno_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'tbl_carga_trabajo_detalle_iidcarga_trabajo_detalle_seq') THEN
        CREATE SEQUENCE "inspeccion"."tbl_carga_trabajo_detalle_iidcarga_trabajo_detalle_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'tbl_carga_trabajo_detalle_ins_iidcarga_trabajo_detalle_ins_seq1') THEN
        CREATE SEQUENCE "inspeccion"."tbl_carga_trabajo_detalle_ins_iidcarga_trabajo_detalle_ins_seq1" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'tbl_carga_trabajo_detalle_ins_iidcarga_trabajo_detalle_insp_seq') THEN
        CREATE SEQUENCE "inspeccion"."tbl_carga_trabajo_detalle_ins_iidcarga_trabajo_detalle_insp_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'tbl_carga_trabajo_iidcarga_trabajo_seq') THEN
        CREATE SEQUENCE "inspeccion"."tbl_carga_trabajo_iidcarga_trabajo_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'tbl_carga_trabajo_turno_iidcarga_trabajo_turno_seq') THEN
        CREATE SEQUENCE "inspeccion"."tbl_carga_trabajo_turno_iidcarga_trabajo_turno_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'tbl_carga_trabajo_turno_inspe_iidcarga_trabajo_turno_inspec_seq') THEN
        CREATE SEQUENCE "inspeccion"."tbl_carga_trabajo_turno_inspe_iidcarga_trabajo_turno_inspec_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'tbl_inspector_iidinspector_seq') THEN
        CREATE SEQUENCE "inspeccion"."tbl_inspector_iidinspector_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'tbl_inspector_seguimiento_iidinspector_seguimiento_seq') THEN
        CREATE SEQUENCE "inspeccion"."tbl_inspector_seguimiento_iidinspector_seguimiento_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;
END$$;

-- -------------------- TABLAS
CREATE TABLE IF NOT EXISTS "inspeccion"."cat_carga_trabajo_tipo" (
    "iidcarga_trabajo_tipo" int4 NOT NULL DEFAULT nextval('"inspeccion".cat_carga_trabajo_tipo_iidcarga_trabajo_tipo_seq'::regclass),
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "breten" bool NOT NULL DEFAULT false,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "cat_carga_trabajo_tipo_pkey" PRIMARY KEY ("iidcarga_trabajo_tipo")
);

CREATE TABLE IF NOT EXISTS "inspeccion"."cat_inspector_categoria" (
    "iidinspector_categoria" int4 NOT NULL DEFAULT nextval('"inspeccion".cat_inspector_categoria_iidinspector_categoria_seq'::regclass),
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "bcoordinador" bool DEFAULT false,
    "bgenera_boleta" bool DEFAULT false,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "cat_inspector_categoria_pkey" PRIMARY KEY ("iidinspector_categoria")
);

CREATE TABLE IF NOT EXISTS "inspeccion"."cat_turno" (
    "iidturno" int4 NOT NULL DEFAULT nextval('"inspeccion".cat_turno_iidturno_seq'::regclass),
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "bruta_nocturna" bool NOT NULL DEFAULT false,
    "thora_inicio" time(6) NOT NULL,
    "thora_fin" time(6) NOT NULL,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "cat_turno_pkey" PRIMARY KEY ("iidturno")
);

CREATE TABLE IF NOT EXISTS "inspeccion"."tbl_carga_trabajo" (
    "iidcarga_trabajo" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_carga_trabajo_iidcarga_trabajo_seq'::regclass),
    "iidzona" int4 NOT NULL,
    "dfecha_inicio" date NOT NULL DEFAULT now(),
    "dfecha_fin" date NOT NULL DEFAULT now(),
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_carga_trabajo_pkey" PRIMARY KEY ("iidcarga_trabajo")
);

CREATE TABLE IF NOT EXISTS "inspeccion"."tbl_carga_trabajo_detalle" (
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
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_carga_trabajo_detalle_pkey" PRIMARY KEY ("iidcarga_trabajo_detalle")
);

CREATE TABLE IF NOT EXISTS "inspeccion"."tbl_carga_trabajo_detalle_inspector" (
    "iidcarga_trabajo_detalle_inspector" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_carga_trabajo_detalle_ins_iidcarga_trabajo_detalle_insp_seq'::regclass),
    "iidcarga_trabajo_detalle" int4 NOT NULL,
    "iidcarga_trabajo_turno_inspector" int4 NOT NULL,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_carga_trabajo_detalle_inspector_pkey" PRIMARY KEY ("iidcarga_trabajo_detalle_inspector")
);

CREATE TABLE IF NOT EXISTS "inspeccion"."tbl_carga_trabajo_detalle_inspector_seguimiento" (
    "iidcarga_trabajo_detalle_inspector_seguimiento" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_carga_trabajo_detalle_ins_iidcarga_trabajo_detalle_ins_seq1'::regclass),
    "iidcarga_trabajo_detalle_inspector" int4 NOT NULL,
    "dtfecha_hora_inico" timestamp(6),
    "dtfecha_hora_fin" timestamp(6),
    "bactivo" bool NOT NULL DEFAULT false,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_carga_trabajo_detalle_inspector_seguimiento_pkey" PRIMARY KEY ("iidcarga_trabajo_detalle_inspector_seguimiento")
);

CREATE TABLE IF NOT EXISTS "inspeccion"."tbl_carga_trabajo_turno" (
    "iidcarga_trabajo_turno" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_carga_trabajo_turno_iidcarga_trabajo_turno_seq'::regclass),
    "iidcarga_trabajo" int4 NOT NULL,
    "iidturno" int4 NOT NULL,
    "iidcoordinador" int4 NOT NULL,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_carga_trabajo_turno_pkey" PRIMARY KEY ("iidcarga_trabajo_turno")
);

CREATE TABLE IF NOT EXISTS "inspeccion"."tbl_carga_trabajo_turno_inspector" (
    "iidcarga_trabajo_turno_inspector" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_carga_trabajo_turno_inspe_iidcarga_trabajo_turno_inspec_seq'::regclass),
    "iidcarga_trabajo_turno" int4 NOT NULL,
    "iidinspector" int4 NOT NULL,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_carga_trabajo_turno_inspector_pkey" PRIMARY KEY ("iidcarga_trabajo_turno_inspector")
);

CREATE TABLE IF NOT EXISTS "inspeccion"."tbl_inspector" (
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
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_inspector_pkey" PRIMARY KEY ("iidinspector")
);

CREATE TABLE IF NOT EXISTS "inspeccion"."tbl_inspector_seguimiento" (
    "iidinspector_seguimiento" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_inspector_seguimiento_iidinspector_seguimiento_seq'::regclass),
    "iidinspector" int4 NOT NULL,
    "iidetapa_anterior" int4 NOT NULL,
    "iidsubetapa_anterior" int4,
    "iidetapa_actual" int4 NOT NULL,
    "iidsubetapa_actual" int4,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_inspector_seguimiento_pkey" PRIMARY KEY ("iidinspector_seguimiento")
);

ALTER TABLE "inspeccion"."tbl_carga_trabajo_detalle" ADD CONSTRAINT "fk_tbl_carga_trabajo_detalle_tbl_carga_trabajo_iidcarga_trabajo" FOREIGN KEY ("iidcarga_trabajo") REFERENCES "inspeccion"."tbl_carga_trabajo" ("iidcarga_trabajo") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_carga_trabajo_detalle" ADD CONSTRAINT "fk_tbl_carga_trabajo_detalle_cat_carga_trabajo_tipo_iidcarga_trabajo_tipo" FOREIGN KEY ("iidcarga_trabajo_tipo") REFERENCES "inspeccion"."cat_carga_trabajo_tipo" ("iidcarga_trabajo_tipo") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_carga_trabajo_detalle_inspector" ADD CONSTRAINT "fk_tbl_carga_trabajo_detalle_inspector_tbl_carga_trabajo_detalle_iidcarga_trabajo_detalle" FOREIGN KEY ("iidcarga_trabajo_detalle") REFERENCES "inspeccion"."tbl_carga_trabajo_detalle" ("iidcarga_trabajo_detalle") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_carga_trabajo_detalle_inspector" ADD CONSTRAINT "fk_tbl_carga_trabajo_detalle_inspector_tbl_carga_trabajo_turno_inspector_iidcarga_trabajo_turno_inspector" FOREIGN KEY ("iidcarga_trabajo_turno_inspector") REFERENCES "inspeccion"."tbl_carga_trabajo_turno_inspector" ("iidcarga_trabajo_turno_inspector") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_carga_trabajo_turno" ADD CONSTRAINT "fk_tbl_carga_trabajo_turno_tbl_carga_trabajo_iidcarga_trabajo" FOREIGN KEY ("iidcarga_trabajo") REFERENCES "inspeccion"."tbl_carga_trabajo" ("iidcarga_trabajo") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_carga_trabajo_turno" ADD CONSTRAINT "fk_tbl_carga_trabajo_turno_cat_turno_iidturno" FOREIGN KEY ("iidturno") REFERENCES "inspeccion"."cat_turno" ("iidturno") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_carga_trabajo_turno" ADD CONSTRAINT "fk_tbl_carga_trabajo_turno_tbl_inspector_iidinspector" FOREIGN KEY ("iidcoordinador") REFERENCES "inspeccion"."tbl_inspector" ("iidinspector") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_carga_trabajo_turno_inspector" ADD CONSTRAINT "fk_tbl_carga_trabajo_turno_inspector_tbl_carga_trabajo_turno_iidcarga_trabajo_turno" FOREIGN KEY ("iidcarga_trabajo_turno") REFERENCES "inspeccion"."tbl_carga_trabajo_turno" ("iidcarga_trabajo_turno") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_carga_trabajo_turno_inspector" ADD CONSTRAINT "fk_tbl_carga_trabajo_turno_inspector_tbl_inspector_iidinspector" FOREIGN KEY ("iidinspector") REFERENCES "inspeccion"."tbl_inspector" ("iidinspector") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_inspector" ADD CONSTRAINT "fk_tbl_inspector_tbl_turno_iidturno" FOREIGN KEY ("iidturno") REFERENCES "inspeccion"."cat_turno" ("iidturno") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_inspector" ADD CONSTRAINT "fk_tbl_inspector_cat_inspector_categoria_iidinspector_categoria" FOREIGN KEY ("iidinspector_categoria") REFERENCES "inspeccion"."cat_inspector_categoria" ("iidinspector_categoria") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_inspector_seguimiento" ADD CONSTRAINT "fk_tbl_inspector_seguimiento_tbl_inspector_iidinspector" FOREIGN KEY ("iidinspector") REFERENCES "inspeccion"."tbl_inspector" ("iidinspector") ON DELETE CASCADE ON UPDATE CASCADE;


-- **************************************************************** INFORMACIÓN SCHEMA BOLETA ***********************************************************
-- -------------------- SEQUENCIAS
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'boleta' AND sequencename = 'tbl_boleta_iidboleta_seq') THEN
        CREATE SEQUENCE "boleta"."tbl_boleta_iidboleta_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'boleta' AND sequencename = 'tbl_boleta_rol_iidboleta_rol_seq') THEN
        CREATE SEQUENCE "boleta"."tbl_boleta_rol_iidboleta_rol_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;
END$$;

-- -------------------- TABLAS
CREATE TABLE IF NOT EXISTS boleta.tbl_boleta_rol (
    iidboleta_rol SERIAL PRIMARY KEY,
    txtnombre TEXT NOT NULL,
    bactivo BOOLEAN DEFAULT true,
    dtfecha_creacion TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    dtfecha_modificacion TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS boleta.tbl_boleta (
    iidboleta INTEGER PRIMARY KEY DEFAULT nextval('boleta.tbl_boleta_iidboleta_seq'),
    dtfecha_hora_infraccion TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    txtlugar_infraccion TEXT NOT NULL,
    txtdireccion TEXT NOT NULL,
    imonto_total FLOAT NOT NULL,
    iidinfractor INTEGER NOT NULL, 
    iidboleta_rol_id INTEGER NOT NULL, 
    txtlicencia TEXT NOT NULL,
    txtunidad TEXT NOT NULL,
    tarjeta_circulacion_id TEXT NOT NULL,
    iidempleado INTEGER NOT NULL, 
    txtreporte_especial_id TEXT NOT NULL,
    txtinspeccion_fisica TEXT NOT NULL,
    bretencion_vehiculo BOOLEAN DEFAULT false,
    bretencion_documento BOOLEAN DEFAULT false,
    txtobservaciones TEXT,
    bapercibimiento BOOLEAN DEFAULT false,
    dapercibimiento_fecha TIMESTAMP WITHOUT TIME ZONE,
    dfecha_limite_comparecencia TIMESTAMP WITHOUT TIME ZONE,
    dfecha_limite_resolucion TIMESTAMP WITHOUT TIME ZONE,
    dfecha_limite_notificacion TIMESTAMP WITHOUT TIME ZONE,
    bno_ha_lugar BOOLEAN DEFAULT false,
    bsuspension BOOLEAN DEFAULT false,
    isuspension_dias INTEGER,
    dsuspension_fecha DATE,
    bactivo BOOLEAN DEFAULT true,
    dtfecha_creacion TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    dtfecha_modificacion TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    CONSTRAINT fk_iidinfractor FOREIGN KEY (iidinfractor) REFERENCES persona.tbl_persona(iidpersona),
    CONSTRAINT fk_iidempleado FOREIGN KEY (iidempleado) REFERENCES persona.tbl_persona(iidpersona)
);
