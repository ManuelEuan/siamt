--liquibase formatted sql
--changeset aicf:29
--Tabla de configuracion general

CREATE TABLE comun.tbl_configuracion(
    iid SERIAL primary key not null,
    txtclave text not null,
    txtvalor text not null,
    txtdescripcion text not null,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

INSERT INTO comun.tbl_configuracion (txtclave, txtvalor, txtdescripcion)
VALUES ('VALORUMA', '103.74', 'VALOR ACTUAL DEL UMA');

