--liquibase formatted sql
--changeset aicf:1
--Tablas iniciales

CREATE SCHEMA comun;
-- -------------------- TABLAS
CREATE TABLE "comun"."tbl_cat_firma_plantilla" (
     "iid" serial primary key not null ,
     "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
     "txtplantilla" text COLLATE "pg_catalog"."default" NOT NULL,
     "bactivo" bool NOT NULL DEFAULT true,
     "dtfecha_creacion" timestamp(6),
     "dtfecha_modificacion" timestamp(6)
);

CREATE TABLE "comun"."tbl_firma" (
   "iid" serial primary key not null ,
   "iidfirma_plantilla" int4 NOT NULL REFERENCES "comun"."tbl_cat_firma_plantilla"("iid"),
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
   "dtfecha_modificacion" timestamp(0) DEFAULT now()
);

CREATE TABLE "comun"."tbl_firma_usuario" (
    "iid" serial primary key not null ,
   "iidfirma_registro" int4 NOT NULL REFERENCES "comun"."tbl_firma"("iid"),
   "iidusuario" int4 NOT NULL,
   "bactivo" bool NOT NULL DEFAULT true,
   "dtfecha_creacion" timestamp(6),
   "dtfecha_modificacion" timestamp(6)
);
