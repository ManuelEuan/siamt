DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'unidad' AND sequence_name = 'cat_cobertura_tipo_iid_seq') THEN
        CREATE SEQUENCE "unidad"."cat_cobertura_tipo_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'unidad' AND sequence_name = 'cat_empresa_iid_seq') THEN
        CREATE SEQUENCE "unidad"."cat_empresa_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'unidad' AND sequence_name = 'cat_marca_iid_seq') THEN
        CREATE SEQUENCE "unidad"."cat_marca_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'unidad' AND sequence_name = 'cat_modelo_iid_seq') THEN
        CREATE SEQUENCE "unidad"."cat_modelo_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'unidad' AND sequence_name = 'cat_unidad_tipo_iid_seq') THEN
        CREATE SEQUENCE "unidad"."cat_unidad_tipo_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'unidad' AND sequence_name = 'tbl_unidad_iid_seq') THEN
        CREATE SEQUENCE "unidad"."tbl_unidad_iid_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;
END $$;
DROP TABLE IF EXISTS "unidad"."cat_cobertura_tipo";
CREATE TABLE "unidad"."cat_cobertura_tipo" (
  "iid" int4 NOT NULL DEFAULT nextval(
    '"unidad".cat_cobertura_tipo_iid_seq' :: regclass
  ),
  "txtnombre" text COLLATE "pg_catalog"."default",
  "bactivo" bool DEFAULT true,
  "dtfecha_creacion" timestamp(6),
  "dtfecha_modificacion" timestamp(6),
  CONSTRAINT "pk_cat_cobertura_tipo" PRIMARY KEY ("iid")
);
DROP TABLE IF EXISTS "unidad"."cat_empresa";
CREATE TABLE "unidad"."cat_empresa" (
  "iid" int4 NOT NULL DEFAULT nextval('"unidad".cat_empresa_iid_seq' :: regclass),
  "txtnombre" text COLLATE "pg_catalog"."default",
  "bactivo" bool DEFAULT true,
  "dtfecha_creacion" timestamp(6),
  "dtfecha_modificacion" timestamp(6),
  CONSTRAINT "pk_cat_empresa" PRIMARY KEY ("iid")
);
DROP TABLE IF EXISTS "unidad"."cat_marca";
CREATE TABLE "unidad"."cat_marca" (
  "iid" int4 NOT NULL DEFAULT nextval('"unidad".cat_marca_iid_seq' :: regclass),
  "txtnombre" text COLLATE "pg_catalog"."default",
  "bactivo" bool DEFAULT true,
  "dtfecha_creacion" timestamp(6),
  "dtfecha_modificacion" timestamp(6),
  CONSTRAINT "pk_cat_marca" PRIMARY KEY ("iid")
);
DROP TABLE IF EXISTS "unidad"."cat_modelo";
CREATE TABLE "unidad"."cat_modelo" (
  "iid" int4 NOT NULL DEFAULT nextval('"unidad".cat_modelo_iid_seq' :: regclass),
  "iidmarca" int4,
  "txtnombre" text COLLATE "pg_catalog"."default",
  "bactivo" bool DEFAULT true,
  "dtfecha_creacion" timestamp(6),
  "dtfecha_modificacion" timestamp(6),
  CONSTRAINT "fk_cat_modelo_cat_marca" FOREIGN KEY ("iidmarca") REFERENCES "unidad"."cat_marca" ("iid") ON DELETE NO ACTION ON UPDATE NO ACTION
);
DROP TABLE IF EXISTS "unidad"."cat_unidad_tipo";
CREATE TABLE "unidad"."cat_unidad_tipo" (
  "iid" int4 NOT NULL DEFAULT nextval(
    '"unidad".cat_unidad_tipo_iid_seq' :: regclass
  ),
  "txtnombre" text COLLATE "pg_catalog"."default",
  "bactivo" bool DEFAULT true,
  "dtfecha_creacion" timestamp(6),
  "dtfecha_modificacion" timestamp(6),
   CONSTRAINT "pk_cat_unidad_tipo" PRIMARY KEY ("iid")
);
DROP TABLE IF EXISTS "unidad"."tbl_unidad";
CREATE TABLE "unidad"."tbl_unidad" (
  "iid" int4 NOT NULL DEFAULT nextval('"unidad".tbl_unidad_iid_seq' :: regclass),
  "iidempresa" int4,
  "iidcobertura" int4,
  "iidunidad_tipo" int4,
  "iidmarca" int4,
  "txtpoliza" text COLLATE "pg_catalog"."default",
  "txttarjeta_circulacion" text COLLATE "pg_catalog"."default",
  "dpoliza_expiracion" date,
  "dtarjeta_circulacion_expiracion" date,
  "bactivo" bool DEFAULT true,
  "dtfecha_creacion" timestamp(6),
  "dtfecha_modificacion" timestamp(6),
  CONSTRAINT "pk_tbl_unidad" PRIMARY KEY ("iid"),
  CONSTRAINT "fk_cat_unidad_cat_cobertura_tipo" FOREIGN KEY ("iidcobertura") REFERENCES "unidad"."cat_cobertura_tipo" ("iid") ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT "fk_cat_unidad_cat_empresa" FOREIGN KEY ("iidempresa") REFERENCES "unidad"."cat_empresa" ("iid") ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT "fk_cat_unidad_cat_marca" FOREIGN KEY ("iidmarca") REFERENCES "unidad"."cat_marca" ("iid") ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT "fk_cat_unidad_cat_unidad_tipo" FOREIGN KEY ("iidunidad_tipo") REFERENCES "unidad"."cat_unidad_tipo" ("iid") ON DELETE NO ACTION ON UPDATE NO ACTION
);
