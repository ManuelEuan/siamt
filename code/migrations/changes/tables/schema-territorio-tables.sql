-- Creación de secuencias
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
