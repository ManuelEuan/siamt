--liquibase formatted sql
--changeset aicf:1
--Tablas de tramite y derechos

CREATE SCHEMA comun;
-- -------------------- TABLAS
CREATE TABLE comun.tbl_cat_tramite (
     "iid" serial primary key not null,
     vclave varchar(10) not null,
     "txtnombre" text  NOT NULL,
     "txtdescripcion" text NOT NULL,
     "bactivo" bool NOT NULL DEFAULT true,
     "dtfecha_creacion" timestamp(6),
     "dtfecha_modificacion" timestamp(6)
);

CREATE TABLE "comun"."tbl_cat_derecho" (
   "iid" serial primary key not null ,
   vclave varchar(10) not null,
   "txtnombre" text NOT NULL,
   "txtdescripcion" text,
   txtcuenta_contable text NOT NULL,
   numa_minimo numeric not null,
   numa_maximo numeric not null,
   nvalor_inicial numeric not null DEFAULT 1,
   nvalor_final numeric not null DEFAULT 1,
   "bactivo" bool NOT NULL DEFAULT true,
   "dtfecha_creacion" timestamp(0),
   "dtfecha_modificacion" timestamp(0) DEFAULT now()
);

CREATE TABLE comun.tbl_cat_tramite_derecho (
   "iid" serial primary key not null,
   iidtramite INTEGER REFERENCES comun.tbl_cat_tramite(iid),
   iidderecho INTEGER REFERENCES comun.tbl_cat_derecho(iid),
   "bactivo" bool NOT NULL DEFAULT true,
   "dtfecha_creacion" timestamp(6),
   "dtfecha_modificacion" timestamp(6)
);