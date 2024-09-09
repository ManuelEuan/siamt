--liquibase formatted sql
--changeset aicf:2
--Poner fedault en fechas de las Tablas de tramite y derechos

ALTER TABLE comun.tbl_cat_tramite ALTER COLUMN dtfecha_creacion SET DEFAULT now();
ALTER TABLE comun.tbl_cat_tramite ALTER COLUMN dtfecha_modificacion SET DEFAULT now();

ALTER TABLE comun.tbl_cat_derecho ALTER COLUMN dtfecha_creacion SET DEFAULT now();
ALTER TABLE comun.tbl_cat_derecho ALTER COLUMN dtfecha_modificacion SET DEFAULT now();

ALTER TABLE comun.tbl_cat_tramite_derecho ALTER COLUMN dtfecha_creacion SET DEFAULT now();
ALTER TABLE comun.tbl_cat_tramite_derecho ALTER COLUMN dtfecha_modificacion SET DEFAULT now();

