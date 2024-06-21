-- changeset imjcu-0.sql
-- Crear las extensiones necesarias así como los schemas boleta, comun, inspeccion, persona, territorio, usuario con su estructura correspondiente

-- **************************************************************** EXTENSIONES NECESARIAS ***********************************************************

CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS postgis;

-- SELECT pg_terminate_backend(pg_stat_activity.pid)
-- FROM pg_stat_activity
-- WHERE pg_stat_activity.datname = 'siamt_unstable_jair'
-- AND pid <> pg_backend_pid();
-- **************************************************************** CREACÓN DE SCHEMAS ***********************************************************

CREATE SCHEMA "inspeccion";
CREATE SCHEMA "boleta";

-- **************************************************************** INFORMACIÓN SCHEMA USUARIO ***********************************************************
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'usuario' AND sequence_name = 'tbl_cat_firma_plantilla_iid_seq') THEN
        CREATE SEQUENCE "usuario"."tbl_cat_firma_plantilla_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'usuario' AND sequence_name = 'tbl_firma_registro_iid_seq') THEN
        CREATE SEQUENCE "usuario"."tbl_firma_registro_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'usuario' AND sequence_name = 'tbl_firma_registro_usuario_iid_seq') THEN
        CREATE SEQUENCE "usuario"."tbl_firma_registro_usuario_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;
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

CREATE TABLE "usuario"."tbl_firma_registro" (
  "iid" int4 NOT NULL DEFAULT nextval('"usuario"."tbl_firma_registro_iid_seq"'::regclass),
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
  CONSTRAINT "pk_tbl_firma_registro" PRIMARY KEY ("iid"),
  CONSTRAINT "fk_tbl_firma_registro_iidfirma_plantilla" FOREIGN KEY ("iidfirma_plantilla") REFERENCES "usuario"."tbl_cat_firma_plantilla"("iid") ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE "usuario"."tbl_firma_registro_usuario" (
  "iid" int4 NOT NULL DEFAULT nextval('"usuario"."tbl_firma_registro_usuario_iid_seq"'::regclass),
  "iidfirma_registro" int4 NOT NULL,
  "iidusuario" int4 NOT NULL,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6),
  "dtfecha_modificacion" timestamp(6),
  CONSTRAINT "fk_tbl_firma_registro_usuario_iidfirma_registro" FOREIGN KEY ("iidfirma_registro") REFERENCES "usuario"."tbl_firma_registro"("iid") ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "fk_tbl_firma_registro_usuario_iidusuario" FOREIGN KEY ("iidusuario") REFERENCES "usuario"."usuario"("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- **************************************************************** INFORMACIÓN SCHEMA PERSONA ***********************************************************

DROP TABLE IF EXISTS persona.tblcat_tipo_telefono CASCADE;
DROP TABLE IF EXISTS "persona"."tbl_cat_lada";
DROP TABLE IF EXISTS "persona"."tbl_telefono";

DO $$
BEGIN
    CREATE SEQUENCE IF NOT EXISTS "persona"."tbl_cat_lada_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;
    CREATE SEQUENCE IF NOT EXISTS "persona"."tbl_cat_tipo_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;
    CREATE SEQUENCE IF NOT EXISTS "persona"."tbl_cat_tipo_telefono_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;
    CREATE SEQUENCE IF NOT EXISTS "persona"."tbl_telefono_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;
END $$;

CREATE TABLE "persona"."tbl_cat_lada" (
    "iid" int4 NOT NULL DEFAULT nextval('"persona".tbl_cat_lada_iid_seq'::regclass),
    "txtnombre" text COLLATE "pg_catalog"."default",
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "txtiso_tres" text COLLATE "pg_catalog"."default",
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_cat_lada_pkey" PRIMARY KEY ("iid")
);

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

-- **************************************************************** INFORMACIÓN SCHEMA INSPECCION ***********************************************************
-- -------------------- SEQUENCIAS
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

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'tbl_carga_trabajo_detalle_iidseq') THEN
        CREATE SEQUENCE "inspeccion"."tbl_carga_trabajo_detalle_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'tbl_carga_trabajo_detalle_ins_iid_seq1') THEN
        CREATE SEQUENCE "inspeccion"."tbl_carga_trabajo_detalle_ins_iid_seq1" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'inspeccion' AND sequencename = 'tbl_carga_trabajo_detalle_ins_iid_seq') THEN
        CREATE SEQUENCE "inspeccion"."tbl_carga_trabajo_detalle_ins_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
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
END$$;

-- -------------------- TABLAS
CREATE TABLE "inspeccion"."tbl_cat_carga_trabajo_tipo" (
    "iid" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_cat_carga_trabajo_tipo_iid_seq'::regclass),
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "breten" bool NOT NULL DEFAULT false,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_cat_carga_trabajo_tipo_pkey" PRIMARY KEY ("iid")
);

CREATE TABLE "inspeccion"."tbl_cat_inspector_categoria" (
    "iid" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_cat_inspector_categoria_iid_seq'::regclass),
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
    "iid" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_cat_turno_iid_seq'::regclass),
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

CREATE TABLE "inspeccion"."tbl_carga_trabajo" (
    "iid" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_carga_trabajo_iid_seq'::regclass),
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
    "iid" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_carga_trabajo_detalle_iid_seq'::regclass),
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
    CONSTRAINT "tbl_carga_trabajo_detalle_pkey" PRIMARY KEY ("iid")
);

CREATE TABLE "inspeccion"."tbl_carga_trabajo_detalle_inspector" (
    "iid" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_carga_trabajo_detalle_ins_iid_seq'::regclass),
    "iidcarga_trabajo_detalle" int4 NOT NULL,
    "iidcarga_trabajo_turno_inspector" int4 NOT NULL,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_carga_trabajo_detalle_inspector_pkey" PRIMARY KEY ("iid")
);

CREATE TABLE "inspeccion"."tbl_carga_trabajo_detalle_inspector_seguimiento" (
    "iid" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_carga_trabajo_detalle_ins_iid_seq1'::regclass),
    "iidcarga_trabajo_detalle_inspector" int4 NOT NULL,
    "dtfecha_hora_inico" timestamp(6),
    "dtfecha_hora_fin" timestamp(6),
    "bactivo" bool NOT NULL DEFAULT false,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_carga_trabajo_detalle_inspector_seguimiento_pkey" PRIMARY KEY ("iid")
);

CREATE TABLE "inspeccion"."tbl_carga_trabajo_turno" (
    "iid" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_carga_trabajo_turno_iid_seq'::regclass),
    "iidcarga_trabajo" int4 NOT NULL,
    "iidturno" int4 NOT NULL,
    "iidcoordinador" int4 NOT NULL,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_carga_trabajo_turno_pkey" PRIMARY KEY ("iid")
);

CREATE TABLE "inspeccion"."tbl_carga_trabajo_turno_inspector" (
    "iid" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_carga_trabajo_turno_inspe_iid_seq'::regclass),
    "iidcarga_trabajo_turno" int4 NOT NULL,
    "iidinspector" int4 NOT NULL,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_carga_trabajo_turno_inspector_pkey" PRIMARY KEY ("iid")
);

CREATE TABLE "inspeccion"."tbl_inspector" (
    "iid" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_inspector_iid_seq'::regclass),
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
    CONSTRAINT "tbl_inspector_pkey" PRIMARY KEY ("iid")
);

CREATE TABLE "inspeccion"."tbl_inspector_seguimiento" (
    "iid" int4 NOT NULL DEFAULT nextval('"inspeccion".tbl_inspector_seguimiento_iid_seq'::regclass),
    "iidinspector" int4 NOT NULL,
    "iidetapa_anterior" int4 NOT NULL,
    "iidsubetapa_anterior" int4,
    "iidetapa_actual" int4 NOT NULL,
    "iidsubetapa_actual" int4,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
    CONSTRAINT "tbl_inspector_seguimiento_pkey" PRIMARY KEY ("iid")
);

ALTER TABLE "inspeccion"."tbl_carga_trabajo_detalle" ADD CONSTRAINT "fk_tbl_carga_trabajo_detalle_tbl_carga_trabajo_iidcarga_trabajo" FOREIGN KEY ("iidcarga_trabajo") REFERENCES "inspeccion"."tbl_carga_trabajo" ("iid") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_carga_trabajo_detalle" ADD CONSTRAINT "fk_tbl_carga_trabajo_detalle_tbl_cat_carga_trabajo_tipo_iidcarga_trabajo_tipo" FOREIGN KEY ("iidcarga_trabajo_tipo") REFERENCES "inspeccion"."tbl_cat_carga_trabajo_tipo" ("iid") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_carga_trabajo_detalle_inspector" ADD CONSTRAINT "fk_tbl_carga_trabajo_detalle_inspector_tbl_carga_trabajo_detalle_iidcarga_trabajo_detalle" FOREIGN KEY ("iidcarga_trabajo_detalle") REFERENCES "inspeccion"."tbl_carga_trabajo_detalle" ("iid") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_carga_trabajo_detalle_inspector" ADD CONSTRAINT "fk_tbl_carga_trabajo_detalle_inspector_tbl_carga_trabajo_turno_inspector_iidcarga_trabajo_turno_inspector" FOREIGN KEY ("iidcarga_trabajo_turno_inspector") REFERENCES "inspeccion"."tbl_carga_trabajo_turno_inspector" ("iid") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_carga_trabajo_turno" ADD CONSTRAINT "fk_tbl_carga_trabajo_turno_tbl_carga_trabajo_iidcarga_trabajo" FOREIGN KEY ("iidcarga_trabajo") REFERENCES "inspeccion"."tbl_carga_trabajo" ("iid") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_carga_trabajo_turno" ADD CONSTRAINT "fk_tbl_carga_trabajo_turno_tbl_cat_turno_iidturno" FOREIGN KEY ("iidturno") REFERENCES "inspeccion"."tbl_cat_turno" ("iid") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_carga_trabajo_turno" ADD CONSTRAINT "fk_tbl_carga_trabajo_turno_tbl_inspector_iidinspector" FOREIGN KEY ("iidcoordinador") REFERENCES "inspeccion"."tbl_inspector" ("iid") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_carga_trabajo_turno_inspector" ADD CONSTRAINT "fk_tbl_carga_trabajo_turno_inspector_tbl_carga_trabajo_turno_iidcarga_trabajo_turno" FOREIGN KEY ("iidcarga_trabajo_turno") REFERENCES "inspeccion"."tbl_carga_trabajo_turno" ("iid") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_carga_trabajo_turno_inspector" ADD CONSTRAINT "fk_tbl_carga_trabajo_turno_inspector_tbl_inspector_iidinspector" FOREIGN KEY ("iidinspector") REFERENCES "inspeccion"."tbl_inspector" ("iid") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_inspector" ADD CONSTRAINT "fk_tbl_inspector_tbl_turno_iidturno" FOREIGN KEY ("iidturno") REFERENCES "inspeccion"."tbl_cat_turno" ("iid") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_inspector" ADD CONSTRAINT "fk_tbl_inspector_tbl_cat_inspector_categoria_iidinspector_categoria" FOREIGN KEY ("iidinspector_categoria") REFERENCES "inspeccion"."tbl_cat_inspector_categoria" ("iid") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "inspeccion"."tbl_inspector_seguimiento" ADD CONSTRAINT "fk_tbl_inspector_seguimiento_tbl_inspector_iidinspector" FOREIGN KEY ("iidinspector") REFERENCES "inspeccion"."tbl_inspector" ("iid") ON DELETE CASCADE ON UPDATE CASCADE;


-- **************************************************************** INFORMACIÓN SCHEMA BOLETA ***********************************************************
-- -------------------- SEQUENCIAS
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'boleta' AND sequencename = 'tbl_boleta_iid_seq') THEN
        CREATE SEQUENCE "boleta"."tbl_boleta_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'boleta' AND sequencename = 'tbl_boleta_rol_iid_seq') THEN
        CREATE SEQUENCE "boleta"."tbl_boleta_rol_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;
END$$;

-- -------------------- TABLAS
CREATE TABLE boleta.tbl_boleta_rol (
    iid SERIAL PRIMARY KEY,
    txtnombre TEXT NOT NULL,
    bactivo BOOLEAN DEFAULT true,
    dtfecha_creacion TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    dtfecha_modificacion TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);

CREATE TABLE boleta.tbl_boleta (
    iid INTEGER PRIMARY KEY DEFAULT nextval('boleta.tbl_boleta_iid_seq'),
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

WITH modulos_a_eliminar AS (
    -- Seleccionar los IDs de los módulos que cumplen con las condiciones
    SELECT id
    FROM usuario.modulo
    WHERE nombre = 'Personas' AND seccion IS NULL
)
DELETE FROM usuario.usuario_dominio_modulo
WHERE idmodulo IN (SELECT id FROM modulos_a_eliminar);

DELETE FROM usuario.modulo
WHERE nombre = 'Personas' AND seccion IS NULL;
ALTER TABLE persona.persona_telefono RENAME TO tbl_persona_telefono;


ALTER TABLE persona.tbl_direccion
ADD COLUMN iidcolonia int4,
ADD COLUMN itipo_direccion int4,
ADD COLUMN itipo_vialidad int4,
ADD COLUMN txtavenida_kilometro text,
ADD COLUMN txttablaje text;
ALTER TABLE persona.tbl_persona_direccion
ADD COLUMN bactual bool DEFAULT true;

ALTER TABLE persona.tbl_persona_telefono
ADD COLUMN iidtelefono int4,
ADD COLUMN bactual bool DEFAULT true,
ADD COLUMN bactivo bool DEFAULT true,
ADD COLUMN dtfecha_creacion timestamp(6),
ADD COLUMN dtfecha_modificacion timestamp(6);

ALTER TABLE comun.tbl_flujo
ALTER COLUMN iidetapa DROP NOT NULL;

UPDATE usuario.modulo
SET seccion = CASE
    WHEN nombre IN ('Debitaciones', 'Usuarios', 'Perfiles') THEN 'Administración'
    ELSE seccion
END,
activo = CASE
    WHEN nombre IN ('Módulos') THEN 't'
    ELSE activo
END
WHERE nombre IN ('Debitaciones', 'Usuarios', 'Perfiles', 'Módulos');
