-- Creación de secuencias
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

-- Creación de tablas
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
