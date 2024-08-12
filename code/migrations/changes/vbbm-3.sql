--liquibase formatted sql
--changeset vbbm:3
-- Modificacion de tbl_empresa y se crea la tabla tbl_empresa_vehiculo 

ALTER table transporte.tbl_empresa ADD vnomenclatura varchar(5) not null;

create table transporte.tbl_empresa_vehiculo(
    iid serial not null PRIMARY key,
    iidempresa integer references transporte.tbl_empresa(iid) not null,
    iidvehiculo integer references vehiculo.tbl_vehiculo(iid) not null,
    vnomenclatura varchar(5) not null,
    inumero_economico integer not null,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);