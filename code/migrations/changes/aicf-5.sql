--liquibase formatted sql
--changeset aicf:5
--Se crea el schema personba y las tablas necesarias

create schema IF NOT EXISTS persona;

create table persona.tbl_cat_nacionalidad(
 iid serial not null PRIMARY key,
 vsiglas varchar(4) not null,
 "txtnombre" text NOT NULL,
 "txtdescripcion" text NOT NULL,
 "bactivo" bool NOT NULL DEFAULT true,
 "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
 "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

create schema IF NOT EXISTS territorio;

CREATE TABLE "territorio"."tbl_cat_estado" (
   iid serial not null PRIMARY key,
   "iclave_estado" int4 NOT NULL,
   vsiglas varchar(4) not null,
   "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
   "bactivo" bool NOT NULL DEFAULT true,
   "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
   "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

CREATE TABLE "territorio"."tbl_cat_municipio" (
  iid serial not null PRIMARY key,
  "iclave_estado" int4 NOT NULL,
  "iclave_municipio" int4 NOT NULL,
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

CREATE TABLE "territorio"."tbl_cat_colonia" (
    iid serial not null PRIMARY key,
    "iclave_estado" int4 NOT NULL,
    "iclave_municipio" int4 NOT NULL,
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);


CREATE TABLE "persona"."tbl_cat_estado_civil" (
  iid serial not null PRIMARY key,
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtdescripcion" text COLLATE "pg_catalog"."default",
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

CREATE TABLE "persona"."tbl_cat_sexo" (
  iid serial not null PRIMARY key,
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtdescripcion" text COLLATE "pg_catalog"."default",
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

drop table IF EXISTS "persona"."tbl_persona";

CREATE TABLE "persona"."tbl_persona" (
 iid serial not null PRIMARY key,
 "bfisica" bool NOT NULL DEFAULT true,
 "txtnombre" text NOT NULL,
 "txtapellido_paterno" text,
 "txtapellido_materno" text,
 "nombre_completo" text GENERATED ALWAYS AS (
     (((((COALESCE(txtapellido_paterno, ''::character varying))::text || ' '::text) || (COALESCE(txtapellido_materno, ''::character varying))::text) || ' '::text) || (COALESCE(txtnombre, ''::character varying))::text)
) STORED,
  "dfecha_nacimiento" date,
	iidnacionalidad integer references persona.tbl_cat_nacionalidad(iid),
	iclave_estado integer ,
	iclave_municipio integer,
	"txtrfc" text COLLATE "pg_catalog"."default",
  "txtcurp" text COLLATE "pg_catalog"."default",
  "txtine" text COLLATE "pg_catalog"."default",
  "iidestado_civil" integer references persona.tbl_cat_estado_civil(iid),
  "iidsexo" integer references persona.tbl_cat_sexo(iid),
  "txtcorreo" text COLLATE "pg_catalog"."default",
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

CREATE TABLE "persona"."tbl_cat_tipo_direccion" (
    iid serial not null PRIMARY key,
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

CREATE TABLE "persona"."tbl_direccion2" (
    iid serial not null PRIMARY key,
    "txtcalle" text COLLATE "pg_catalog"."default",
    "txtcalle_letra" text COLLATE "pg_catalog"."default",
    "inumero_exterior" int4,
    "txtnumero_exterior_letra" text COLLATE "pg_catalog"."default",
    "inumero_interior" int4,
    "txtnumero_interior_letra" text COLLATE "pg_catalog"."default",
    "txtcruzamiento_uno" text COLLATE "pg_catalog"."default",
    "txtcruzamiento_uno_letra" text COLLATE "pg_catalog"."default",
    "txtcruzamiento_dos" text COLLATE "pg_catalog"."default",
    "txtcruzamiento_dos_letra" text COLLATE "pg_catalog"."default",
    "txtreferencia" text COLLATE "pg_catalog"."default",
    "txtcolonia" text,
    "nlatitud" numeric,
    "nlongitud" numeric,
    iclave_estado integer,
    iclave_municipio integer,
    "iidtipo_direccion" integer references persona.tbl_cat_tipo_direccion(iid),
    "txtdescripcion_direccion" text COLLATE "pg_catalog"."default",
    txtdireccion_completa text GENERATED ALWAYS AS (txtcruzamiento_uno) STORED,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

CREATE TABLE "persona"."tbl_direccion" (
   iid serial not null PRIMARY key,
   "txtcalle" text COLLATE "pg_catalog"."default",
   "txtcalle_letra" text COLLATE "pg_catalog"."default",
   "inumero_exterior" int4,
   "txtnumero_exterior_letra" text COLLATE "pg_catalog"."default",
   "inumero_interior" int4,
   "txtnumero_interior_letra" text COLLATE "pg_catalog"."default",
   "txtcruzamiento_uno" text COLLATE "pg_catalog"."default",
   "txtcruzamiento_uno_letra" text COLLATE "pg_catalog"."default",
   "txtcruzamiento_dos" text COLLATE "pg_catalog"."default",
   "txtcruzamiento_dos_letra" text COLLATE "pg_catalog"."default",
   "txtreferencia" text COLLATE "pg_catalog"."default",
   "txtcolonia" text,
   "nlatitud" numeric,
   "nlongitud" numeric,
   iclave_estado integer,
   iclave_municipio integer,
   "txtdescripcion_direccion" text COLLATE "pg_catalog"."default",
   txtdireccion_completa text GENERATED ALWAYS AS (
           CASE WHEN (txtcalle = '') IS NOT FALSE THEN ''  ELSE 'CALLE ' || txtcalle || COALESCE (txtcalle_letra, '') END || ' '
               || CASE WHEN (inumero_exterior is not null) IS NOT FALSE THEN ''  ELSE '# ' || inumero_exterior || COALESCE (txtnumero_exterior_letra, '') END || ' '
               || CASE WHEN (txtcruzamiento_uno = '') IS NOT FALSE THEN ''  ELSE 'ENTRE ' || txtcruzamiento_uno || COALESCE (txtcruzamiento_uno_letra, '') END || ' '
               || CASE WHEN (txtcruzamiento_dos = '') IS NOT FALSE THEN ''  ELSE 'Y ' || txtcruzamiento_dos || COALESCE (txtcruzamiento_dos_letra, '') END || ' '
               || CASE WHEN (txtcolonia = '') IS NOT FALSE THEN ''  ELSE 'COL. ' || txtcolonia END
           ) STORED,
   "bactivo" bool NOT NULL DEFAULT true,
   "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
   "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

CREATE TABLE "persona"."tbl_persona_direccion" (
   iid serial not null PRIMARY key,
   "iidpersona" int4 NOT NULL  references persona.tbl_persona(iid),
   "iiddireccion" int4 NOT NULL  references persona.tbl_direccion(iid),
   "iidtipo_direccion" integer references persona.tbl_cat_tipo_direccion(iid),
   "bactivo" bool NOT NULL DEFAULT true,
   "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
   "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

CREATE TABLE "persona"."tblcat_tipo_telefono" (
  iid serial not null PRIMARY key,
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtdescripcion" text COLLATE "pg_catalog"."default",
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);



CREATE TABLE "persona"."persona_telefono" (
  iid serial not null PRIMARY key,
  "iidpersona" int4 NOT NULL  references persona.tbl_persona(iid),
  "iidtipo_telefono" int4 NOT NULL references persona.tblcat_tipo_telefono(iid),
  "vtelefono" varchar(10) COLLATE "pg_catalog"."default",
  "vdescripcion" varchar COLLATE "pg_catalog"."default",
  "propio" bool DEFAULT true,
  "telegram" bool DEFAULT false,
  "whatsapp" bool DEFAULT false,
  "actual" bool DEFAULT false
);
