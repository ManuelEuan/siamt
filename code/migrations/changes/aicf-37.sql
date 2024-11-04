--liquibase formatted sql
--changeset aicf:37
--Modificar tablas de vehiculos y agregar la tabla genérica de documentos

CREATE TABLE "comun"."tbl_cat_documento" (
     "iid" SERIAL PRIMARY KEY,
     "vclave_padre" VARCHAR (20) NOT NULL,
     "vclave" VARCHAR (20) NOT NULL UNIQUE,
     "txtnombre" TEXT NOT NULL,
     "txtdescripcion" TEXT NOT NULL,
     "txtextension" TEXT NOT NULL DEFAULT 'jpg, jpeg, pdf',
     "jsetiqueta" JSONB NOT NULL DEFAULT '{}'::jsonb,
     "bactivo" BOOLEAN NOT NULL DEFAULT true,
     "dtfecha_creacion" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
     "dtfecha_modificacion" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW()
);


ALTER TABLE "comun"."tbl_cat_proceso"
    ADD COLUMN "iidtramite" INTEGER UNIQUE;


CREATE TABLE "vehiculo"."tbl_cat_cobertura" (
    "iid" SERIAL PRIMARY KEY,
    "vclave" VARCHAR (20) NOT NULL UNIQUE,
    "txtnombre" TEXT NOT NULL,
    "txtdescripcion" TEXT NOT NULL,
    "bactivo" BOOLEAN NOT NULL DEFAULT true,
    "dtfecha_creacion" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW(),
    "dtfecha_modificacion" TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW()
);


ALTER TABLE "vehiculo"."tbl_vehiculo_poliza"
    ADD COLUMN "nsuma_asegurada" NUMERIC,
    ADD COLUMN "iidcobertura" INTEGER REFERENCES vehiculo.tbl_cat_cobertura (iid);


ALTER TABLE "vehiculo"."tbl_cat_aseguradora"
    ADD COLUMN "txttelefono_contacto" TEXT;


ALTER TABLE "vehiculo"."tbl_vehiculo_motor"
    RENAME COLUMN "txtnombre" TO "txtnumero";


ALTER TABLE "vehiculo"."tbl_vehiculo_motor"
    DROP COLUMN "inumero",
    ADD COLUMN dfecha_instalacion DATE;


ALTER TABLE "vehiculo"."tbl_vehiculo"
    ADD COLUMN "txtnumero_chasis" TEXT,
    ADD COLUMN "txtnumero_serie" TEXT,
    ADD COLUMN "ikm_inicial" BIGINT DEFAULT 0,
    ADD COLUMN "ikm_actual" BIGINT DEFAULT 0;


ALTER TABLE "vehiculo"."tbl_vehiculo"
    DROP COLUMN "npeso",
    DROP COLUMN "iidtipo_peso",
    DROP COLUMN "ipasajeros",
    DROP COLUMN "ipasajeros_sentados",
    DROP COLUMN "ipasajeros_pie";


ALTER TABLE "vehiculo"."tbl_cat_version"
    ADD COLUMN "npeso" NUMERIC NOT NULL,
    ADD COLUMN "nancho" NUMERIC NOT NULL,
    ADD COLUMN "nalto" NUMERIC NOT NULL,
    ADD COLUMN "nlargo" NUMERIC NOT NULL,
    ADD COLUMN "iidtipo_peso" INTEGER REFERENCES vehiculo.tbl_cat_tipo_peso(iid) NOT NULL,
    ADD COLUMN "ipasajeros_sentados" INTEGER NOT NULL,
    ADD COLUMN "ipasajeros_pie" INTEGER NOT NULL,
    ADD COLUMN "ipasajeros" INTEGER GENERATED ALWAYS AS (ipasajeros_sentados + ipasajeros_pie) STORED;

