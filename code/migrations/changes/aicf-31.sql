--liquibase formatted sql
--changeset aicf:31
--Insertar registro de valor del puntos de un operador


INSERT INTO comun.tbl_configuracion (txtclave, txtvalor, txtdescripcion)
VALUES ('PUNTOSOPERADOR', '12', 'Total de puntos default de los operadores');

