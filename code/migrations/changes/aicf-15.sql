--liquibase formatted sql
--changeset aicf:15
-- Agregar calve a la tabla de procesos


ALTER TABLE comun.tbl_cat_proceso
    ADD COLUMN vclave varchar(5) unique;

UPDATE comun.tbl_cat_proceso set vclave = 'INSPC' where txtnombre = 'REGISTRO DE INSPECTOR';