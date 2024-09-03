--liquibase formatted sql
--changeset aicf:17
-- Recrear tabla de seguimiento

DROP TABLE "comun"."tbl_seguimiento";

CREATE TABLE "comun"."tbl_seguimiento" (
   iid serial not null PRIMARY key,
   "iidfolio" int4 NOT NULL,
   "iidproceso" int4 NOT NULL REFERENCES "comun"."tbl_cat_proceso" ("iid"),
   "iidetapa" int4 NOT NULL REFERENCES "comun"."tbl_cat_etapa" ("iid"),
   "iidsubetapa" int4 not null REFERENCES "comun"."tbl_cat_subetapa" ("iid"),
   "iidusuarioautorizo" int4 REFERENCES "usuario"."usuario" ("id"),
   "txtmotivo" text COLLATE "pg_catalog"."default",
   "bactivo" bool NOT NULL DEFAULT true,
   "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now()
);