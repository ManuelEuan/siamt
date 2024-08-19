--liquibase formatted sql
--changeset aicf:18
-- Aumentar el tamaño de la clave de modulo

ALTER TABLE usuario.modulo
    DROP COLUMN busqueda,
    ALTER COLUMN siglas TYPE varchar(10),
    ADD COLUMN "busqueda" text COLLATE "pg_catalog"."default" GENERATED ALWAYS AS (
((((((COALESCE(seccion, ''::text) || ' '::text) || COALESCE(nombre, ''::text)) || ' '::text) || COALESCE(descripcion, ''::text)) || ' '::text) || (COALESCE(siglas, ''::character varying))::text)
) STORED;