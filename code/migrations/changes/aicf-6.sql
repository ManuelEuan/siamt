--liquibase formatted sql
--changeset aicf:6
--Se crea el schema comun y las tablas necesarias para procesos, etapas, subetapas y flujos

create schema IF NOT EXISTS comun;

CREATE TABLE "comun"."tbl_bitacora" (
    iid serial not null PRIMARY key,
    "iidusuario" int4 NOT NULL REFERENCES "usuario"."usuario" ("id"),
    "txtmodulo" text COLLATE "pg_catalog"."default",
    "iidentificador" int4,
    "txttabla" text COLLATE "pg_catalog"."default",
    "txtoriginal" text COLLATE "pg_catalog"."default",
    "txtcambios" text COLLATE "pg_catalog"."default",
    "bactivo" bool DEFAULT true,
    "dtfecha_creacion" timestamp(6) DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) DEFAULT now()
);

CREATE TABLE "comun"."tbl_cat_proceso" (
   iid serial not null PRIMARY key,
   "iidmodulo" int4 NOT NULL REFERENCES "usuario"."modulo" ("id"),
   "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
   "txtaccion" text COLLATE "pg_catalog"."default",
   "bactivo" bool DEFAULT true,
   "dtfecha_creacion" timestamp(6) DEFAULT now(),
   "dtfecha_modificacion" timestamp(6) DEFAULT now()
);

CREATE TABLE "comun"."tbl_cat_etapa" (
     iid serial not null PRIMARY key,
     "iidproceso" int4 NOT NULL REFERENCES "comun"."tbl_cat_proceso" ("iid"),
     "vclave" varchar(5) COLLATE "pg_catalog"."default" NOT NULL,
     "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
     "txtdescripcion" text COLLATE "pg_catalog"."default",
     "txtcolor" text COLLATE "pg_catalog"."default" DEFAULT 'black'::text,
     "bactivo" bool DEFAULT true,
     "dtfecha_creacion" timestamp(6) DEFAULT now(),
     "dtfecha_modificacion" timestamp(6) DEFAULT now()
);

CREATE TABLE "comun"."tbl_cat_subetapa" (
    iid serial not null PRIMARY key,
    "iidetapa" int4 NOT NULL REFERENCES "comun"."tbl_cat_etapa" ("iid"),
    "vclave" varchar(5) COLLATE "pg_catalog"."default" NOT NULL,
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "txtcolor" text COLLATE "pg_catalog"."default",
    "txtpermiso" text COLLATE "pg_catalog"."default",
    "binicial" bool NOT NULL DEFAULT false,
    "bfinal" bool NOT NULL DEFAULT false,
    "bcancelacion" bool NOT NULL DEFAULT false,
    "brequiere_motivo" bool NOT NULL DEFAULT false,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

CREATE TABLE "comun"."tbl_seguimiento" (
   iid serial not null PRIMARY key,
   "iidfolio" int4 NOT NULL,
   "iidproceso" int4 NOT NULL REFERENCES "comun"."tbl_cat_proceso" ("iid"),
   "iidetapa" int4 NOT NULL REFERENCES "comun"."tbl_cat_etapa" ("iid"),
   "idsubetapa" int4 not null REFERENCES "comun"."tbl_cat_subetapa" ("iid"),
   "idusuarioautorizo" int4 REFERENCES "usuario"."usuario" ("id"),
   "txtmotivo" text COLLATE "pg_catalog"."default",
   "bactivo" bool NOT NULL DEFAULT true,
   "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now()
);


CREATE TABLE "comun"."tbl_flujo" (
     iid serial not null PRIMARY key,
     "iidetapa" int4 NOT NULL REFERENCES "comun"."tbl_cat_etapa" ("iid"),
     "iidsubetapa" int4 not null REFERENCES "comun"."tbl_cat_subetapa" ("iid"),
     "iidsubetapa_siguiente" int4 not null REFERENCES "comun"."tbl_cat_subetapa" ("iid"),
     "bactivo" bool DEFAULT true,
     "dtfecha_creacion" timestamp(6) DEFAULT now(),
     "dtfecha_modificacion" timestamp(6) DEFAULT now()
);


