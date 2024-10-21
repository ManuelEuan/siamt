--liquibase formatted sql
--changeset aicf:2
--Tabla ejemplo 2

ALTER TABLE comun.tbl_dia_inhabil
    ADD COLUMN dtfecha_dos timestamp(6) NOT NULL DEFAULT now();