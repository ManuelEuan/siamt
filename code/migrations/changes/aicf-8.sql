--liquibase formatted sql
--changeset aicf:8
--Se crean tablas de conceciones y vehículos

create schema IF NOT EXISTS transporte;

CREATE TABLE "transporte"."tbl_cuenca" (
   iid serial not null PRIMARY key,
   "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
   "txtdescripcion" text COLLATE "pg_catalog"."default",
   "bactivo" bool NOT NULL DEFAULT true,
   "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
   "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

create table transporte.tbl_empresa(
 iid serial not null PRIMARY key,
 iidpersona integer references persona.tbl_persona(iid) not null,
 iidcuenca integer references transporte.tbl_cuenca(iid),
 "bactivo" bool NOT NULL DEFAULT true,
 "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
 "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

create table transporte.tbl_concesion(
   iid serial not null PRIMARY key,
   iidpersona integer references persona.tbl_persona(iid) not null,
   iidempresa integer references transporte.tbl_empresa(iid) not null,
   "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
   "txtdescripcion" text COLLATE "pg_catalog"."default",
   "dfecha_expedicion" date,
   "bactivo" bool NOT NULL DEFAULT true,
   "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
   "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);



create schema IF NOT EXISTS vehiculo;

CREATE TABLE "vehiculo"."tbl_cat_marca" (
   iid serial not null PRIMARY key,
   "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
   "txtdescripcion" text COLLATE "pg_catalog"."default",
   "bactivo" bool NOT NULL DEFAULT true,
   "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
   "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

CREATE TABLE "vehiculo"."tbl_cat_modelo" (
    iid serial not null PRIMARY key,
    iidmarca integer references vehiculo.tbl_cat_marca(iid) not null,
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

CREATE TABLE "vehiculo"."tbl_cat_version" (
     iid serial not null PRIMARY key,
     iidmodelo integer references vehiculo.tbl_cat_modelo(iid) not null,
     "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
     "txtdescripcion" text COLLATE "pg_catalog"."default",
     "bactivo" bool NOT NULL DEFAULT true,
     "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
     "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

CREATE TABLE "vehiculo"."tbl_cat_tipo_combustible" (
      iid serial not null PRIMARY key,
      "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
      "txtdescripcion" text COLLATE "pg_catalog"."default",
      "bactivo" bool NOT NULL DEFAULT true,
      "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
      "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

CREATE TABLE "vehiculo"."tbl_cat_tipo_vehiculo" (
       iid serial not null PRIMARY key,
       "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
       "txtdescripcion" text COLLATE "pg_catalog"."default",
       "bactivo" bool NOT NULL DEFAULT true,
       "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
       "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

CREATE TABLE "vehiculo"."tbl_cat_tipo_peso" (
   iid serial not null PRIMARY key,
   vsiglas varchar(5) not null,
   "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
   "txtdescripcion" text COLLATE "pg_catalog"."default",
   "bactivo" bool NOT NULL DEFAULT true,
   "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
   "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

create table vehiculo.tbl_vehiculo(
    iid serial not null PRIMARY key,
    iidtipo integer references vehiculo.tbl_cat_tipo_vehiculo(iid) not null,
    iidmodelo integer references vehiculo.tbl_cat_modelo(iid) not null,
    iidversion integer references vehiculo.tbl_cat_version(iid),
    ianio integer not null,
    npeso numeric not null,
    iidtipo_peso integer references vehiculo.tbl_cat_tipo_peso(iid) not null,
    ipasajeros_sentados integer not null,
    ipasajeros_pie integer not null,
    ipasajeros integer GENERATED ALWAYS AS (ipasajeros_sentados + ipasajeros_pie) STORED,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

create table vehiculo.tbl_vehiculo_motor(
      iid serial not null PRIMARY key,
      iidvehiculo integer references vehiculo.tbl_vehiculo(iid) not null,
      iidtipo_combustible integer references vehiculo.tbl_cat_tipo_combustible(iid) not null,
      inumero integer not null,
      "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
      "txtdescripcion" text COLLATE "pg_catalog"."default",
      "bactual" bool NOT NULL DEFAULT true,
      "bactivo" bool NOT NULL DEFAULT true,
      "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
      "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

create table vehiculo.tbl_vehiculo_placa(
    iid serial not null PRIMARY key,
    iidvehiculo integer references vehiculo.tbl_vehiculo(iid) not null,
    txtplaca text NOT NULL,
    dfecha_emision date not null,
    dfecha_vencimiento date not null,
    "bactual" bool NOT NULL DEFAULT true,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

create table vehiculo.tbl_vehiculo_tarjeta_circulacion(
    iid serial not null PRIMARY key,
    iidvehiculo integer references vehiculo.tbl_vehiculo(iid) not null,
    txtnumero text NOT NULL,
    dfecha_emision date not null,
    dfecha_vencimiento date not null,
    "bactual" bool NOT NULL DEFAULT true,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

CREATE TABLE "vehiculo"."tbl_cat_aseguradora" (
    iid serial not null PRIMARY key,
    "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
    "txtdescripcion" text COLLATE "pg_catalog"."default",
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);

create table vehiculo.tbl_vehiculo_poliza(
      iid serial not null PRIMARY key,
      iidvehiculo integer references vehiculo.tbl_vehiculo(iid) not null,
      iidaseguradora integer references vehiculo.tbl_cat_aseguradora(iid) not null,
      txtnumero text NOT NULL,
      dfecha_emision date not null,
      dfecha_vencimiento date not null,
      "bactual" bool NOT NULL DEFAULT true,
      "bactivo" bool NOT NULL DEFAULT true,
      "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
      "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now()
);