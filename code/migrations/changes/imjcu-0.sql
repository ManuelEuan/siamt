-- changeset imjcu-0.sql
-- Crear las extensiones necesarias así como los schemas boleta, comun, inspeccion, persona, territorio, usuario con su estructura correspondiente

-- **************************************************************** EXTENSIONES NECESARIAS ***********************************************************

CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS postgis;

-- **************************************************************** CREACÓN DE SCHEMAS ***********************************************************

CREATE SCHEMA "inspeccion";
CREATE SCHEMA "boleta";

-- **************************************************************** INFORMACIÓN SCHEMA USUARIO ***********************************************************
-- -------------------- SEQUENCIAS
DO $$ 
BEGIN 
  IF EXISTS(SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'usuario' AND sequence_name = 'tbl_cat_firma_plantilla_iid_firma_plantilla_seq') THEN 
    DROP SEQUENCE "usuario"."tbl_cat_firma_plantilla_iid_firma_plantilla_seq" CASCADE; 
  END IF; 

  IF EXISTS(SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'usuario' AND sequence_name = 'tbl_firma_registro_iidfirma_registro_seq') THEN 
    DROP SEQUENCE "usuario"."tbl_firma_registro_iidfirma_registro_seq" CASCADE; 
  END IF; 

  IF EXISTS(SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'usuario' AND sequence_name = 'tbl_firma_registro_usuario_iidfirma_registro_usuario_seq') THEN 
    DROP SEQUENCE "usuario"."tbl_firma_registro_usuario_iidfirma_registro_usuario_seq" CASCADE; 
  END IF; 
END $$;

CREATE SEQUENCE "usuario"."tbl_cat_firma_plantilla_iid_firma_plantilla_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1; 
-- CREATE SEQUENCE "usuario"."dominio_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
-- CREATE SEQUENCE "usuario"."modulo_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
-- CREATE SEQUENCE "usuario"."perfil_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
-- CREATE SEQUENCE "usuario"."permiso_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
-- CREATE SEQUENCE "usuario"."usuario_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
CREATE SEQUENCE "usuario"."tbl_firma_registro_iidfirma_registro_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1; 
CREATE SEQUENCE "usuario"."tbl_firma_registro_usuario_iidfirma_registro_usuario_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1; 

-- -------------------- TABLAS

CREATE TABLE IF NOT EXISTS "usuario"."tbl_cat_firma_plantilla" (
  "iidfirma_plantilla" int4 NOT NULL DEFAULT nextval('"usuario"."tbl_cat_firma_plantilla_iid_firma_plantilla_seq"'::regclass),
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtplantilla" text COLLATE "pg_catalog"."default" NOT NULL,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6),
  "dtfecha_modificacion" timestamp(6),
  CONSTRAINT "unique_iidfirma_plantilla" UNIQUE ("iidfirma_plantilla")
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
  CONSTRAINT "fk_tbl_firma_registro_iidfirma_plantilla" FOREIGN KEY ("iidfirma_plantilla") REFERENCES "usuario"."tbl_cat_firma_plantilla"("iidfirma_plantilla") ON DELETE CASCADE ON UPDATE CASCADE
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

-- **************************************************************** INFORMACIÓN SCHEMA PERSONA ***********************************************************
-- -------------------- SEQUENCIAS
DO $$
BEGIN
    
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'persona' AND sequencename = 'tbl_cat_lada_iidlada_seq') THEN
        CREATE SEQUENCE "persona"."tbl_cat_lada_iidlada_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'persona' AND sequencename = 'tbl_cat_telefono_tipo_iidtelefono_tipo_seq') THEN
        CREATE SEQUENCE "persona"."tbl_cat_telefono_tipo_iidtelefono_tipo_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'persona' AND sequencename = 'tbl_cat_tipo_iidtipo_seq') THEN
        CREATE SEQUENCE "persona"."tbl_cat_tipo_iidtipo_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
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

CREATE TABLE IF NOT EXISTS "persona"."tbl_cat_lada" (
    "iidlada" int4 NOT NULL DEFAULT nextval('"persona".tbl_cat_lada_iidlada_seq'::regclass),
    "txtnombre" text COLLATE "pg_catalog"."default",
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "txtiso_tres" text COLLATE "pg_catalog"."default",
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_cat_lada_pkey" PRIMARY KEY ("iidlada")
);

CREATE TABLE IF NOT EXISTS "persona"."tbl_cat_telefono_tipo" (
    "iidtelefono_tipo" int4 NOT NULL DEFAULT nextval('"persona".tbl_cat_telefono_tipo_iidtelefono_tipo_seq'::regclass),
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_cat_telefono_tipo_pkey" PRIMARY KEY ("iidtelefono_tipo")
);

CREATE TABLE IF NOT EXISTS "persona"."tbl_cat_tipo" (
    "iidtipo" int4 NOT NULL DEFAULT nextval('"persona".tbl_cat_tipo_iidtipo_seq'::regclass),
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_cat_tipo_pkey" PRIMARY KEY ("iidtipo")
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

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'territorio' AND sequencename = 'tbl_cat_zona_iidzona_seq') THEN
        CREATE SEQUENCE "territorio"."tbl_cat_zona_iidzona_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;
END$$;

-- -------------------- TABLAS

CREATE TABLE IF NOT EXISTS "territorio"."tbl_cat_zona" (
    "iidzona" int4 NOT NULL DEFAULT nextval('"territorio".tbl_cat_zona_iidzona_seq'::regclass),
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    "gthe_geom" geometry(GEOMETRY),
    "txtgeojson" text COLLATE "pg_catalog"."default",
    CONSTRAINT "tbl_cat_zona_pkey" PRIMARY KEY ("iidzona")
);

-- **************************************************************** INFORMACIÓN SCHEMA INSPECCION ***********************************************************
-- -------------------- SEQUENCIAS
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'tbl_cat_carga_trabajo_tipo_iidcarga_trabajo_tipo_seq') THEN
        CREATE SEQUENCE "inspeccion"."tbl_cat_carga_trabajo_tipo_iidcarga_trabajo_tipo_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'tbl_cat_inspector_categoria_iidinspector_categoria_seq') THEN
        CREATE SEQUENCE "inspeccion"."tbl_cat_inspector_categoria_iidinspector_categoria_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'tbl_cat_turno_iidturno_seq') THEN
        CREATE SEQUENCE "inspeccion"."tbl_cat_turno_iidturno_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
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
CREATE TABLE IF NOT EXISTS "inspeccion"."tbl_cat_carga_trabajo_tipo" (
    "iidcarga_trabajo_tipo" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_cat_carga_trabajo_tipo_iidcarga_trabajo_tipo_seq'::regclass),
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "breten" bool NOT NULL DEFAULT false,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_cat_carga_trabajo_tipo_pkey" PRIMARY KEY ("iidcarga_trabajo_tipo")
);

CREATE TABLE IF NOT EXISTS "inspeccion"."tbl_cat_inspector_categoria" (
    "iidinspector_categoria" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_cat_inspector_categoria_iidinspector_categoria_seq'::regclass),
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "bcoordinador" bool DEFAULT false,
    "bgenera_boleta" bool DEFAULT false,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_cat_inspector_categoria_pkey" PRIMARY KEY ("iidinspector_categoria")
);

CREATE TABLE IF NOT EXISTS "inspeccion"."tbl_cat_turno" (
    "iidturno" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_cat_turno_iidturno_seq'::regclass),
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "bruta_nocturna" bool NOT NULL DEFAULT false,
    "thora_inicio" time(6) NOT NULL,
    "thora_fin" time(6) NOT NULL,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_cat_turno_pkey" PRIMARY KEY ("iidturno")
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
ALTER TABLE "inspeccion"."tbl_carga_trabajo_detalle" ADD CONSTRAINT "fk_tbl_carga_trabajo_detalle_tbl_cat_carga_trabajo_tipo_iidcarga_trabajo_tipo" FOREIGN KEY ("iidcarga_trabajo_tipo") REFERENCES "inspeccion"."tbl_cat_carga_trabajo_tipo" ("iidcarga_trabajo_tipo") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_carga_trabajo_detalle_inspector" ADD CONSTRAINT "fk_tbl_carga_trabajo_detalle_inspector_tbl_carga_trabajo_detalle_iidcarga_trabajo_detalle" FOREIGN KEY ("iidcarga_trabajo_detalle") REFERENCES "inspeccion"."tbl_carga_trabajo_detalle" ("iidcarga_trabajo_detalle") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_carga_trabajo_detalle_inspector" ADD CONSTRAINT "fk_tbl_carga_trabajo_detalle_inspector_tbl_carga_trabajo_turno_inspector_iidcarga_trabajo_turno_inspector" FOREIGN KEY ("iidcarga_trabajo_turno_inspector") REFERENCES "inspeccion"."tbl_carga_trabajo_turno_inspector" ("iidcarga_trabajo_turno_inspector") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_carga_trabajo_turno" ADD CONSTRAINT "fk_tbl_carga_trabajo_turno_tbl_carga_trabajo_iidcarga_trabajo" FOREIGN KEY ("iidcarga_trabajo") REFERENCES "inspeccion"."tbl_carga_trabajo" ("iidcarga_trabajo") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_carga_trabajo_turno" ADD CONSTRAINT "fk_tbl_carga_trabajo_turno_tbl_cat_turno_iidturno" FOREIGN KEY ("iidturno") REFERENCES "inspeccion"."tbl_cat_turno" ("iidturno") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_carga_trabajo_turno" ADD CONSTRAINT "fk_tbl_carga_trabajo_turno_tbl_inspector_iidinspector" FOREIGN KEY ("iidcoordinador") REFERENCES "inspeccion"."tbl_inspector" ("iidinspector") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_carga_trabajo_turno_inspector" ADD CONSTRAINT "fk_tbl_carga_trabajo_turno_inspector_tbl_carga_trabajo_turno_iidcarga_trabajo_turno" FOREIGN KEY ("iidcarga_trabajo_turno") REFERENCES "inspeccion"."tbl_carga_trabajo_turno" ("iidcarga_trabajo_turno") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_carga_trabajo_turno_inspector" ADD CONSTRAINT "fk_tbl_carga_trabajo_turno_inspector_tbl_inspector_iidinspector" FOREIGN KEY ("iidinspector") REFERENCES "inspeccion"."tbl_inspector" ("iidinspector") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_inspector" ADD CONSTRAINT "fk_tbl_inspector_tbl_turno_iidturno" FOREIGN KEY ("iidturno") REFERENCES "inspeccion"."tbl_cat_turno" ("iidturno") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_inspector" ADD CONSTRAINT "fk_tbl_inspector_tbl_cat_inspector_categoria_iidinspector_categoria" FOREIGN KEY ("iidinspector_categoria") REFERENCES "inspeccion"."tbl_cat_inspector_categoria" ("iidinspector_categoria") ON DELETE CASCADE ON UPDATE CASCADE;
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
    CONSTRAINT fk_iidinfractor FOREIGN KEY (iidinfractor) REFERENCES persona.tbl_persona(iid),
    CONSTRAINT fk_iidempleado FOREIGN KEY (iidempleado) REFERENCES persona.tbl_persona(iid)
);
