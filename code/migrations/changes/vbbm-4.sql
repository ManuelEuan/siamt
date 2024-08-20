--liquibase formatted sql
--changeset vbbm:4
-- Recrear tabla de tbl_empresa_vehiculo y nueva columna para concesion

DROP TABLE "transporte"."tbl_empresa_vehiculo";

create table transporte.tbl_empresa_vehiculo(
    iid serial not null PRIMARY key,
    iidempresa integer references transporte.tbl_empresa(iid) not null,
    iidconcesion integer references transporte.tbl_concesion(iid),
    iidvehiculo integer references vehiculo.tbl_vehiculo(iid) not null,
    vnomenclatura varchar(5) not null,
    inumero_economico integer not null,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);