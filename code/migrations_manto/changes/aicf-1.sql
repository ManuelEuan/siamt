--liquibase formatted sql
--changeset aicf:1
--Tabla ejemplo

CREATE SCHEMA comun;

CREATE TABLE comun.tbl_cat_tipo_conjunto(
    "iid" SERIAL primary key not null,
    "txtdescripcion" text not null,
    "txtcomentarios" text,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6)
);

CREATE TABLE comun.tbl_cat_complejidad(
    "iid" SERIAL primary key not null,
    "txtdescripcion" text not null,
    "txtcomentarios" text,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6)
);

CREATE TABLE comun.tbl_actividad_mantenimiento(
    "iid" SERIAL primary key not null,
    "iidtipo_conjunto" int4 NOT NULL,
    "iidcomplejidad" int4 NOT NULL,
    "iidmodelo" int4 NOT NULL,
    "vclave" varchar(50) not null,
    "vdirigido_a" varchar(50) not null DEFAULT 'vehiculos',
    "txtdescripcion" text,
    "ikms" int4 NOT NULL,
    "imeses" int4,
    "itolerancia_kms" int4,
    "itolerancia_meses" int4,
    "fcosto_mano_obra" float4 NOT NULL,
    "fcosto_refacciones" float4 NOT NULL DEFAULT 0,
    "fcosto_otro" float4 NOT NULL DEFAULT 0,
    "fcosto_total" float4 NOT NULL DEFAULT 0,
    "txtnotas_tecnicas" text,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6),
    CONSTRAINT fk_tbl_actividad_mantenimiento_tbl_cat_tipo_conjunto FOREIGN KEY (iidtipo_conjunto) REFERENCES comun.tbl_cat_tipo_conjunto (iid) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_tbl_actividad_mantenimiento_tbl_cat_complejidad FOREIGN KEY (iidcomplejidad) REFERENCES comun.tbl_cat_complejidad (iid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE comun.tbl_equipos_carga(
    "iid" SERIAL primary key not null,
    "inumero_economico" int4 NOT NULL,
    "vnumero_serie" varchar(50) not null,
    "vmodelo" varchar(150) not null,
    "vmarca" varchar(150) not null,
    "fcapacidad_carga" float4 NOT NULL DEFAULT 0,
    "fconsumo_corriente" float4 NOT NULL DEFAULT 0,
    "fvoltaje_operacion" float4 NOT NULL DEFAULT 0,
    "ihoras_operacion" integer NOT NULL DEFAULT 0,
    "txtnotas_tecnicas" text,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6)
);

COMMENT ON COLUMN comun.tbl_equipos_carga.fcapacidad_carga IS 'La capacidad de carga vene en Kw/Hr';
COMMENT ON COLUMN comun.tbl_equipos_carga.fconsumo_corriente IS 'La medicion se da en amperes';

CREATE TABLE comun.tbl_plan_matenimiento(
    "iid" SERIAL primary key not null,
    "iidmodelo" int4 NOT NULL,
    "vnombre" varchar(250) not null,
    "iciclo" int4 NOT NULL,
    "imeses" int4 NOT NULL,
    "txtcomentarios" text,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6)
);

CREATE TABLE comun.tbl_plan_matenimiento_actividades(
    "iid" SERIAL primary key not null,
    "iidplan_mantenimiento" int4 NOT NULL,
    "iidactividad" int4 NOT NULL,
    "txtcomentarios" text,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6),
    CONSTRAINT fk_tbl_plan_mantenimiento_tbl_actividad_mantenimiento FOREIGN KEY (iidplan_mantenimiento) REFERENCES comun.tbl_plan_matenimiento (iid) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_tbl_actividad_mantenimiento_tbl_plan_mantenimiento FOREIGN KEY (iidactividad) REFERENCES comun.tbl_actividad_mantenimiento (iid) ON DELETE CASCADE ON UPDATE CASCADE
);