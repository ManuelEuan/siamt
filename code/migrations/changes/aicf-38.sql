--liquibase formatted sql
--changeset aicf:38
--Agreagar autogenerado de llave en dominio

ALTER TABLE "usuario"."dominio"
    ALTER COLUMN "llave" SET DEFAULT uuid_generate_v4();