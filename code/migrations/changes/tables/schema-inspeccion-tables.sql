-- Creación de secuencias
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

-- Creación de tablas
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

-- Creación de restricciones
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

