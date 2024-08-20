--liquibase formatted sql
--changeset aicf:14
-- Actualizar tabla dispositivo


DROP TABLE "usuario"."dispositivo";

CREATE TABLE "usuario"."dispositivo" (
     "txtid" text primary key not null,
     "txtaplicacion" text NOT NULL REFERENCES "usuario"."aplicacion" ("txtllave"),
     "bpermitido" bool DEFAULT false,
     "txtusuario" text COLLATE "pg_catalog"."default",
     "bactivo" bool DEFAULT true,
     "dtfecha_creacion" timestamp(6) DEFAULT now(),
     "dtfecha_modificacion" timestamp(6) DEFAULT now()

);

update usuario.aplicacion set bvalida_dispositivo = false where txtnombre = 'EGIT';
