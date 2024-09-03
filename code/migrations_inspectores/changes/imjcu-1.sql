-- changeset imjcu-1.sql
-- Crear las extensiones necesarias así como los schemas boleta, comun, inspeccion, persona, territorio, usuario con su estructura correspondiente

-- **************************************************************** EXTENSIONES NECESARIAS ***********************************************************
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS dblink;

-- SELECT pg_terminate_backend(pg_stat_activity.pid)
-- FROM pg_stat_activity
-- WHERE pg_stat_activity.datname = 'siamt_unstable_jair'
-- AND pid <> pg_backend_pid();
-- CREATE DATABASE siamt_unstable_jair;
-- CREATE DATABASE inspecciones;
-- CREATE DATABASE mantenimiento;
-- **************************************************************** CREACÓN DE SCHEMAS ***********************************************************
CREATE SCHEMA "inspeccion";

CREATE SCHEMA "boleta";

CREATE SCHEMA "unidad";

-- **************************************************************** INFORMACIÓN SCHEMA INSPECCION ***********************************************************
-- -------------------- SEQUENCIAS
-- Creación de secuencias en una sola línea por cada una
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'tbl_cat_carga_trabajo_tipo_iid_seq') THEN 
        CREATE SEQUENCE "inspeccion"."tbl_cat_carga_trabajo_tipo_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'tbl_cat_inspector_categoria_iid_seq') THEN 
        CREATE SEQUENCE "inspeccion"."tbl_cat_inspector_categoria_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'tbl_cat_turno_iid_seq') THEN 
        CREATE SEQUENCE "inspeccion"."tbl_cat_turno_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'tbl_carga_trabajo_detalle_iid_seq') THEN 
        CREATE SEQUENCE "inspeccion"."tbl_carga_trabajo_detalle_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'tbl_carga_trabajo_detalle_inspector_iid_seq1') THEN 
        CREATE SEQUENCE "inspeccion"."tbl_carga_trabajo_detalle_inspector_iid_seq1" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'tbl_carga_trabajo_detalle_inspector_iid_seq') THEN 
        CREATE SEQUENCE "inspeccion"."tbl_carga_trabajo_detalle_inspector_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'tbl_carga_trabajo_iid_seq') THEN 
        CREATE SEQUENCE "inspeccion"."tbl_carga_trabajo_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'tbl_carga_trabajo_turno_iid_seq') THEN 
        CREATE SEQUENCE "inspeccion"."tbl_carga_trabajo_turno_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'tbl_carga_trabajo_turno_inspe_iid_seq') THEN 
        CREATE SEQUENCE "inspeccion"."tbl_carga_trabajo_turno_inspe_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'tbl_inspector_seq') THEN 
        CREATE SEQUENCE "inspeccion"."tbl_inspector_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'tbl_inspector_seguimiento_iid_seq') THEN 
        CREATE SEQUENCE "inspeccion"."tbl_inspector_seguimiento_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
    END IF;
END $$;


CREATE TABLE "inspeccion"."tbl_cat_inspector_categoria" (
    "iid" int4 NOT NULL DEFAULT nextval(
        '"inspeccion".tbl_cat_inspector_categoria_iid_seq' :: regclass
    ),
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "bcoordinador" bool DEFAULT false,
    "bgenera_boleta" bool DEFAULT false,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_cat_inspector_categoria_pkey" PRIMARY KEY ("iid")
);

CREATE TABLE "inspeccion"."tbl_cat_turno" (
    "iid" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_cat_turno_iid_seq' :: regclass),
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "bruta_nocturna" bool NOT NULL DEFAULT false,
    "thora_inicio" time(6) NOT NULL,
    "thora_fin" time(6) NOT NULL,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_cat_turno_pkey" PRIMARY KEY ("iid")
);

CREATE TABLE "inspeccion"."tbl_inspector" (
    "iid" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_inspector_iid_seq' :: regclass),
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
    CONSTRAINT "tbl_inspector_pkey" PRIMARY KEY ("iid"),
    CONSTRAINT fk_tbl_inspector_tbl_turno_iidturno FOREIGN KEY (iidturno) REFERENCES inspeccion.tbl_cat_turno (iid) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_tbl_inspector_tbl_cat_inspector_categoria_iidinspector_categoria FOREIGN KEY (iidinspector_categoria) REFERENCES inspeccion.tbl_cat_inspector_categoria (iid) ON DELETE CASCADE ON UPDATE CASCADE
);



CREATE TABLE "inspeccion"."tbl_carga_trabajo_turno" (
    "iid" int4 NOT NULL DEFAULT nextval(
        '"inspeccion".tbl_carga_trabajo_turno_iid_seq' :: regclass
    ),
    "iidcarga_trabajo" int4 NOT NULL,
    "iidturno" int4 NOT NULL,
    "iidcoordinador" int4 NOT NULL,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_carga_trabajo_turno_pkey" PRIMARY KEY ("iid"),
    CONSTRAINT fk_tbl_carga_trabajo_turno_tbl_cat_turno_iidturno FOREIGN KEY (iidturno) REFERENCES inspeccion.tbl_cat_turno (iid) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_tbl_carga_trabajo_turno_tbl_inspector_iidinspector FOREIGN KEY (iidcoordinador) REFERENCES inspeccion.tbl_inspector (iid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "inspeccion"."tbl_cat_carga_trabajo_tipo" (
    "iid" int4 NOT NULL DEFAULT nextval(
        '"inspeccion".tbl_cat_carga_trabajo_tipo_iid_seq' :: regclass
    ),
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "breten" bool NOT NULL DEFAULT false,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_cat_carga_trabajo_tipo_pkey" PRIMARY KEY ("iid")
);

CREATE TABLE "inspeccion"."tbl_carga_trabajo" (
    "iid" int4 NOT NULL DEFAULT nextval(
        '"inspeccion".tbl_carga_trabajo_iid_seq' :: regclass
    ),
    "iidzona" int4 NOT NULL,
    "dfecha_inicio" date NOT NULL DEFAULT now(),
    "dfecha_fin" date NOT NULL DEFAULT now(),
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_carga_trabajo_pkey" PRIMARY KEY ("iid")
);

CREATE TABLE "inspeccion"."tbl_carga_trabajo_detalle" (
    "iid" int4 NOT NULL DEFAULT nextval(
        '"inspeccion".tbl_carga_trabajo_detalle_iid_seq' :: regclass
    ),
    "iidcarga_trabajo" int4 NOT NULL,
    "iidcarga_trabajo_tipo" int4 NOT NULL,
    "iidcarga_trabajo_turno" int4,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "thora_inicio" time(6),
    "thora_fin" time(6),
    "nlatitud" float8,
    "flongitud" float8,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_carga_trabajo_detalle_pkey" PRIMARY KEY ("iid"),
    CONSTRAINT fk_tbl_carga_trabajo_detalle_tbl_carga_trabajo_iidcarga_trabajo FOREIGN KEY (iidcarga_trabajo) REFERENCES inspeccion.tbl_carga_trabajo (iid) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_tbl_carga_trabajo_detalle_tbl_cat_carga_trabajo_tipo_iidcarga_trabajo_tipo FOREIGN KEY (iidcarga_trabajo_tipo) REFERENCES inspeccion.tbl_cat_carga_trabajo_tipo (iid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "inspeccion"."tbl_carga_trabajo_turno_inspector" (
    "iid" int4 NOT NULL DEFAULT nextval(
        '"inspeccion".tbl_carga_trabajo_turno_inspe_iid_seq' :: regclass
    ),
    "iidcarga_trabajo_turno" int4 NOT NULL,
    "iidinspector" int4 NOT NULL,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_carga_trabajo_turno_inspector_pkey" PRIMARY KEY ("iid"),
    CONSTRAINT fk_tbl_carga_trabajo_turno_inspector_tbl_carga_trabajo_turno_iidcarga_trabajo_turno FOREIGN KEY (iidcarga_trabajo_turno) REFERENCES inspeccion.tbl_carga_trabajo_turno (iid) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_tbl_carga_trabajo_turno_inspector_tbl_inspector_iidinspector FOREIGN KEY (iidinspector) REFERENCES inspeccion.tbl_inspector (iid) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE "inspeccion"."tbl_carga_trabajo_detalle_inspector" (
    "iid" int4 NOT NULL DEFAULT nextval(
        '"inspeccion".tbl_carga_trabajo_detalle_inspector_iid_seq' :: regclass
    ),
    "iidcarga_trabajo_detalle" int4 NOT NULL,
    "iidcarga_trabajo_turno_inspector" int4 NOT NULL,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_carga_trabajo_detalle_inspector_pkey" PRIMARY KEY ("iid"),
    CONSTRAINT fk_tbl_carga_trabajo_detalle_inspector_tbl_carga_trabajo_detalle_iidcarga_trabajo_detalle FOREIGN KEY (iidcarga_trabajo_detalle) REFERENCES inspeccion.tbl_carga_trabajo_detalle (iid) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_tbl_carga_trabajo_detalle_inspector_tbl_carga_trabajo_turno_inspector_iidcarga_trabajo_turno_inspector FOREIGN KEY (iidcarga_trabajo_turno_inspector) REFERENCES inspeccion.tbl_carga_trabajo_turno_inspector (iid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "inspeccion"."tbl_carga_trabajo_detalle_inspector_seguimiento" (
    "iid" int4 NOT NULL DEFAULT nextval(
        '"inspeccion".tbl_carga_trabajo_detalle_inspector_iid_seq1' :: regclass
    ),
    "iidcarga_trabajo_detalle_inspector" int4 NOT NULL,
    "dtfecha_hora_inico" timestamp(6),
    "dtfecha_hora_fin" timestamp(6),
    "bactivo" bool NOT NULL DEFAULT false,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_carga_trabajo_detalle_inspector_seguimiento_pkey" PRIMARY KEY ("iid")
);

CREATE TABLE "inspeccion"."tbl_inspector_seguimiento" (
    "iid" int4 NOT NULL DEFAULT nextval(
        '"inspeccion".tbl_inspector_seguimiento_iid_seq' :: regclass
    ),
    "iidinspector" int4 NOT NULL,
    "iidetapa_anterior" int4 NOT NULL,
    "iidsubetapa_anterior" int4,
    "iidetapa_actual" int4 NOT NULL,
    "iidsubetapa_actual" int4,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_inspector_seguimiento_pkey" PRIMARY KEY ("iid"),
    CONSTRAINT fk_tbl_inspector_seguimiento_tbl_inspector_iidinspector FOREIGN KEY (iidinspector) REFERENCES inspeccion.tbl_inspector (iid) ON DELETE CASCADE ON UPDATE CASCADE
);

-- **************************************************************** INFORMACIÓN SCHEMA BOLETA ***********************************************************
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'boleta' AND sequencename = 'tbl_boleta_iid_seq') THEN 
        CREATE SEQUENCE "boleta"."tbl_boleta_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'boleta' AND sequencename = 'tbl_boleta_rol_iid_seq') 
        THEN CREATE SEQUENCE "boleta"."tbl_boleta_rol_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
    END IF;
END $$;

CREATE TABLE boleta.tbl_boleta_rol (
    iid SERIAL PRIMARY KEY,
    txtnombre TEXT NOT NULL,
    bactivo BOOLEAN DEFAULT true,
    dtfecha_creacion TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    dtfecha_modificacion TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);

CREATE TABLE boleta.tbl_boleta (
    iid INTEGER PRIMARY KEY DEFAULT nextval ('boleta.tbl_boleta_iid_seq'),
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
    dtfecha_modificacion TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);