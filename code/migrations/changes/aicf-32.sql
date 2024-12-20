--liquibase formatted sql
--changeset aicf:32
--Tabla de días inhábiles

CREATE TABLE comun.tbl_dia_inhabil(
    iid SERIAL primary key not null,
    dfecha date not null,
    txtdescripcion text not null,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

