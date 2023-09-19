--liquibase formatted sql
--changeset javp:2

DROP TYPE IF EXISTS "usuario"."data_t";
CREATE TYPE "usuario"."data_t" AS ENUM('string', 'number', 'boolean', 'array');


DROP TABLE IF EXISTS "usuario"."usuario_dominio_configuracion";
CREATE TABLE "usuario"."usuario_dominio_configuracion" (
  "idusuario" int4 NOT NULL,
  "iddominio" int4 NOT NULL,
	"clave" varchar(30) COLLATE "pg_catalog"."default" NOT NULL,
  "valor" varchar(30) COLLATE "pg_catalog"."default",
	"tipo" "usuario"."data_t",
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now()
)
;

ALTER TABLE "usuario"."usuario_dominio_configuracion" ADD CONSTRAINT "pk_usr_dom_clv_configuracion" PRIMARY KEY ("idusuario", "iddominio", "clave");
ALTER TABLE "usuario"."usuario_dominio_configuracion" ADD CONSTRAINT "fk_usr_dom_configuracion_dominio" FOREIGN KEY ("iddominio") REFERENCES "usuario"."dominio" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "usuario"."usuario_dominio_configuracion" ADD CONSTRAINT "fk_usr_dom_configuracion_usuario" FOREIGN KEY ("idusuario") REFERENCES "usuario"."usuario" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

DROP TABLE IF EXISTS "usuario"."dominio_configuracion";
CREATE TABLE "usuario"."dominio_configuracion" (
  "iddominio" int4 NOT NULL,
	"clave" varchar(30) COLLATE "pg_catalog"."default" NOT NULL,
  "valor" varchar(30) COLLATE "pg_catalog"."default",
	"tipo" "usuario"."data_t",
  "fecha_creacion" timestamp(6) DEFAULT now(),
  "fecha_modificacion" timestamp(6) DEFAULT now()
)
;

ALTER TABLE "usuario"."dominio_configuracion" ADD CONSTRAINT "pk_dom_clv_configuracion" PRIMARY KEY ("iddominio", "clave");
ALTER TABLE "usuario"."dominio_configuracion" ADD CONSTRAINT "fk_dom_configuracion_dominio" FOREIGN KEY ("iddominio") REFERENCES "usuario"."dominio" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
