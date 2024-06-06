DO $$ 
BEGIN 
  IF EXISTS(SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'comun' AND sequence_name = 'cat_etapa_iidetapa_seq') THEN 
    DROP SEQUENCE "comun"."cat_etapa_iidetapa_seq"; 
  END IF; 

  IF EXISTS(SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'comun' AND sequence_name = 'cat_flujo_iidflujo_seq') THEN 
    DROP SEQUENCE "comun"."cat_flujo_iidflujo_seq"; 
  END IF; 

  IF EXISTS(SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'comun' AND sequence_name = 'cat_proceso_iidproceso_seq') THEN 
    DROP SEQUENCE "comun"."cat_proceso_iidproceso_seq"; 
  END IF; 

  IF EXISTS(SELECT 1 FROM information_schema.sequences WHERE sequence_schema = 'comun' AND sequence_name = 'cat_subetapa_iidsubetapa_seq') THEN 
    DROP SEQUENCE "comun"."cat_subetapa_iidsubetapa_seq"; 
  END IF; 
END $$; 

CREATE SEQUENCE "comun"."cat_etapa_iidetapa_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
CREATE SEQUENCE "comun"."cat_flujo_iidflujo_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
CREATE SEQUENCE "comun"."cat_proceso_iidproceso_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 
CREATE SEQUENCE "comun"."cat_subetapa_iidsubetapa_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1; 

CREATE TABLE "comun"."cat_proceso" (
  "iidproceso" int4 NOT NULL DEFAULT nextval('"comun".cat_proceso_iidproceso_seq'::regclass),
  "iidmodulo" int4 NOT NULL,
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtdescripcion" text COLLATE "pg_catalog"."default",
  "txtsigla" text COLLATE "pg_catalog"."default" NOT NULL,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
  CONSTRAINT "cat_proceso_pkey" PRIMARY KEY ("iidproceso")
);

CREATE TABLE "comun"."cat_etapa" (
  "iidetapa" int4 NOT NULL DEFAULT nextval('"comun".cat_etapa_iidetapa_seq'::regclass),
  "iidproceso" int4 NOT NULL,
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtsigla" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtdescripcion" text COLLATE "pg_catalog"."default",
  "txtcolor" text COLLATE "pg_catalog"."default",
  "txtpermiso" text COLLATE "pg_catalog"."default",
  "binicial" bool NOT NULL DEFAULT false,
  "bfinal" bool NOT NULL DEFAULT false,
  "bcancelacion" bool NOT NULL DEFAULT false,
  "brequiere_motivo" bool NOT NULL DEFAULT false,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
  CONSTRAINT "cat_etapa_pkey" PRIMARY KEY ("iidetapa"),
  CONSTRAINT "fk_cat_etapa_cat_proceso_iidproceso" FOREIGN KEY ("iidproceso") REFERENCES "comun"."cat_proceso" ("iidproceso") ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE "comun"."cat_subetapa" (
  "iidsubetapa" int4 NOT NULL DEFAULT nextval('"comun".cat_subetapa_iidsubetapa_seq'::regclass),
  "iidetapa" int4 NOT NULL,
  "txtnombre" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtsigla" text COLLATE "pg_catalog"."default" NOT NULL,
  "txtdescripcion" text COLLATE "pg_catalog"."default",
  "txtcolor" text COLLATE "pg_catalog"."default",
  "txtpermiso" text COLLATE "pg_catalog"."default",
  "binicial" bool NOT NULL DEFAULT false,
  "bfinal" bool NOT NULL DEFAULT false,
  "bcancelacion" bool NOT NULL DEFAULT false,
  "brequiere_motivo" bool NOT NULL DEFAULT false,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
  CONSTRAINT "cat_subetapa_pkey" PRIMARY KEY ("iidsubetapa"),
  CONSTRAINT "fk_cat_subetapa_cat_etapa_iidetapa" FOREIGN KEY ("iidetapa") REFERENCES "comun"."cat_etapa" ("iidetapa") ON DELETE NO ACTION ON UPDATE NO ACTION
);


CREATE TABLE "comun"."cat_flujo" (
  "iidflujo" int4 NOT NULL DEFAULT nextval('"comun".cat_flujo_iidflujo_seq'::regclass),
  "iidsubetapa" int4 NOT NULL,
  "iidsubetapa_siguiente" int4 NOT NULL,
  "bactivo" bool NOT NULL DEFAULT true,
  "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
  "dtfecha_modificacion" timestamp(6) NOT NULL DEFAULT now(),
  CONSTRAINT "cat_flujo_pkey" PRIMARY KEY ("iidflujo"),
  CONSTRAINT "fk_cat_flujo_cat_subetapa_iidsubetapa" FOREIGN KEY ("iidsubetapa") REFERENCES "comun"."cat_subetapa" ("iidsubetapa") ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT "fk_cat_flujo_cat_subetapa_iidsubetapa_siguiente" FOREIGN KEY ("iidsubetapa_siguiente") REFERENCES "comun"."cat_subetapa" ("iidsubetapa") ON DELETE NO ACTION ON UPDATE NO ACTION
);

