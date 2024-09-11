--liquibase formatted sql
--changeset aicf:19
--Refactorizar tabla de bitacora

drop table comun.tbl_bitacora;

CREATE TABLE "comun"."tbl_bitacora" (
    iid serial not null PRIMARY key,
    "iidusuario" int4 NOT NULL REFERENCES "usuario"."usuario" ("id"),
    "txtmodulo" text NOT NULL,
    "iidentificador" int4 NOT NULL,
    "txttabla" text NOT NULL,
    "txtoriginal" text ,
    "txtcambios" text NOT NULL,
    "bactivo" bool DEFAULT true NOT NULL,
    "dtfecha_creacion" timestamp(6) DEFAULT now() NOT NULL,
    "dtfecha_modificacion" timestamp(6) DEFAULT now() NOT NULL
);


