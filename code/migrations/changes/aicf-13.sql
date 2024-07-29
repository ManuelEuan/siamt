--changeset aicf:13
-- Tablas de Aplicación

CREATE TABLE "usuario"."aplicacion" (
    "iid" serial primary key not null,
    "txtnombre" text NOT NULL unique,
    "txtllave" text NOT NULL unique,
    "bvalida_dispositivo" bool NOT NULL DEFAULT true,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

CREATE OR REPLACE FUNCTION "usuario"."set_aplicacion_llave"()
RETURNS "pg_catalog"."trigger" AS $BODY$
BEGIN
 IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' AND NEW.txtnombre <> OLD.txtnombre THEN
 NEW.txtllave = md5(NEW.txtnombre);
END IF;
RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER "set_aplicacion_llave" BEFORE INSERT OR UPDATE ON "usuario"."aplicacion"
FOR EACH ROW
EXECUTE PROCEDURE "usuario"."set_aplicacion_llave"();

CREATE TABLE "usuario"."dispositivo" (
     "iid" serial primary key not null,
     "txtaplicacion" text NOT NULL REFERENCES "usuario"."aplicacion" ("txtllave"),
     "bpermitido" bool DEFAULT false,
     "txtusuario" text COLLATE "pg_catalog"."default",
     "bactivo" bool DEFAULT true,
     "dtfecha_creacion" timestamp(6) DEFAULT now(),
     "dtfecha_modificacion" timestamp(6) DEFAULT now()

);

CREATE TABLE "usuario"."usuario_aplicacion" (
    "iidusuario" int4 NOT NULL REFERENCES "usuario"."usuario" ("id"),
    "iidaplicacion" int4 NOT NULL REFERENCES "usuario"."aplicacion" ("iid"),
    "bactivo" bool DEFAULT true,
     "dtfecha_creacion" timestamp(6) DEFAULT now(),
     "dtfecha_modificacion" timestamp(6) DEFAULT now(),
    CONSTRAINT "pku_usuario_aplicacion" PRIMARY KEY ("iidusuario", "iidaplicacion")
);

WITH ruser AS (
    SELECT id FROM usuario.usuario AS u WHERE u.usuario = 'master' AND u.activo = TRUE LIMIT 1
),
aplicacion AS (
    INSERT INTO usuario.aplicacion (txtnombre)
    VALUES ('EGIT') RETURNING iid
)

INSERT INTO usuario.usuario_aplicacion (iidusuario, iidaplicacion)
SELECT ruser.id, aplicacion.iid FROM ruser, aplicacion;

WITH ruser AS (
    SELECT id FROM usuario.usuario AS u WHERE u.usuario = 'master' AND u.activo = TRUE LIMIT 1
),
aplicacion AS (
    INSERT INTO usuario.aplicacion (txtnombre)
    VALUES ('APP INSPECCIÓN') RETURNING iid
)

INSERT INTO usuario.usuario_aplicacion (iidusuario, iidaplicacion)
SELECT ruser.id, aplicacion.iid FROM ruser, aplicacion;