--liquibase formatted sql
--changeset aicf:30
--Insertar registro de valor del iva


INSERT INTO comun.tbl_configuracion (txtclave, txtvalor, txtdescripcion)
VALUES ('VALORIVA', '16', 'Porcentaje del valor del iva');

