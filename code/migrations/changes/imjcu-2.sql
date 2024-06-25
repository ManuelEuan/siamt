
-- **************************************************************** INFORMACIÓN SCHEMA USUARIO ***********************************************************
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'usuario' AND sequence_name = 'tbl_cat_firma_plantilla_iid_seq') THEN
        CREATE SEQUENCE "usuario"."tbl_cat_firma_plantilla_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'usuario' AND sequence_name = 'tbl_firma_iid_seq') THEN
        CREATE SEQUENCE "usuario"."tbl_firma_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'usuario' AND sequence_name = 'tbl_firma_usuario_iid_seq') THEN
        CREATE SEQUENCE "usuario"."tbl_firma_usuario_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;
    END IF;
END $$;

-- -------------------- TABLAS
CREATE TABLE "usuario"."tbl_cat_firma_plantilla" (
  "iid" int4 NOT NULL DEFAULT nextval('"usuario"."tbl_cat_firma_plantilla_iid_seq"'::regclass),
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtplantilla" text COLLATE "pg_catalog"."default" NOT NULL,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6),
  "dtfecha_modificacion" timestamp(6),
  CONSTRAINT "pk_tbl_cat_firma_plantilla" PRIMARY KEY ("iid")
);

CREATE TABLE "usuario"."tbl_firma" (
  "iid" int4 NOT NULL DEFAULT nextval('"usuario"."tbl_firma_iid_seq"'::regclass),
  "iidfirma_plantilla" int4 NOT NULL,
  "txttitulo" text COLLATE "pg_catalog"."default",
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtapellido_paterno" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtapellido_materno" text COLLATE "pg_catalog"."default",
  "txtpuesto" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtoficina" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtdepartamento" text COLLATE "pg_catalog"."default",
  "txtemail" text COLLATE "pg_catalog"."default",
  "txttelefono" text COLLATE "pg_catalog"."default",
  "txtextension" text COLLATE "pg_catalog"."default",
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(0),
  "dtfecha_modificacion" timestamp(0) DEFAULT now(),
  CONSTRAINT "pk_tbl_firma" PRIMARY KEY ("iid"),
  CONSTRAINT "fk_tbl_firma_iidfirma_plantilla" FOREIGN KEY ("iidfirma_plantilla") REFERENCES "usuario"."tbl_cat_firma_plantilla"("iid") ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE "usuario"."tbl_firma_usuario" (
  "iid" int4 NOT NULL DEFAULT nextval('"usuario"."tbl_firma_usuario_iid_seq"'::regclass),
  "iidfirma_registro" int4 NOT NULL,
  "iidusuario" int4 NOT NULL,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6),
  "dtfecha_modificacion" timestamp(6),
  CONSTRAINT "fk_tbl_firma_usuario_iidfirma_registro" FOREIGN KEY ("iidfirma_registro") REFERENCES "usuario"."tbl_firma"("iid") ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "fk_tbl_firma_usuario_iidusuario" FOREIGN KEY ("iidusuario") REFERENCES "usuario"."usuario"("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- **************************************************************** INFORMACIÓN SCHEMA PERSONA ***********************************************************

DROP TABLE IF EXISTS persona.tblcat_tipo_telefono CASCADE;
DROP TABLE IF EXISTS "persona"."tbl_telefono";

DO $$
BEGIN
    CREATE SEQUENCE IF NOT EXISTS "persona"."tbl_cat_tipo_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;
    CREATE SEQUENCE IF NOT EXISTS "persona"."tbl_cat_tipo_telefono_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;
    CREATE SEQUENCE IF NOT EXISTS "persona"."tbl_telefono_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;
END $$;

CREATE TABLE "persona"."tbl_cat_tipo" (
    "iid" int4 NOT NULL DEFAULT nextval('"persona".tbl_cat_tipo_iid_seq'::regclass),
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_cat_tipo_pkey" PRIMARY KEY ("iid")
);

CREATE TABLE "persona"."tbl_telefono" (
    "iid" int4 NOT NULL DEFAULT nextval('"persona".tbl_telefono_iid_seq'::regclass),
    "inumero" int8 NOT NULL,
    "iidtipo_telefono" int4 NOT NULL,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    "txtlada" text COLLATE "pg_catalog"."default",
    CONSTRAINT "tbl_telefono_pkey" PRIMARY KEY ("iid")
);

CREATE TABLE "persona"."tbl_cat_tipo_telefono" (
    "iid" int4 NOT NULL DEFAULT nextval('"persona".tbl_cat_tipo_telefono_iid_seq'::regclass),
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_cat_tipo_telefono_pkey" PRIMARY KEY ("iid")
);



-- **************************************************************** INFORMACIÓN SCHEMA TERRITORIO ***********************************************************
-- -------------------- SEQUENCIAS
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'territorio' AND sequencename = 'tbl_cat_zona_iid_seq') THEN
        CREATE SEQUENCE "territorio"."tbl_cat_zona_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;
END$$;

-- -------------------- TABLAS

CREATE TABLE "territorio"."tbl_cat_zona" (
    "iid" int4 NOT NULL DEFAULT nextval('"territorio".tbl_cat_zona_iid_seq'::regclass),
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    "gthe_geom" geometry(GEOMETRY),
    "txtgeojson" text COLLATE "pg_catalog"."default",
    CONSTRAINT "tbl_cat_zona_pkey" PRIMARY KEY ("iid")
);
