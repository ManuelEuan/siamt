
CREATE TABLE comun.tbl_cat_estatus(
    "iid" SERIAL primary key not null,
    "txtdescripcion" varchar(50) not null,
    "txttipo" varchar(50) not null,
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6)
);

INSERT INTO comun.tbl_cat_estatus (txtdescripcion, txttipo) VALUES( 'En Proceso', 'correctivo');
INSERT INTO comun.tbl_cat_estatus (txtdescripcion, txttipo) VALUES( 'Cancelada', 'correctivo');
INSERT INTO comun.tbl_cat_estatus (txtdescripcion, txttipo) VALUES( 'Parcialmente Realizada', 'correctivo');
INSERT INTO comun.tbl_cat_estatus (txtdescripcion, txttipo) VALUES( 'Completada', 'correctivo');
INSERT INTO comun.tbl_cat_estatus (txtdescripcion, txttipo) VALUES( 'Pendiente para programar', 'preventivo');
INSERT INTO comun.tbl_cat_estatus (txtdescripcion, txttipo) VALUES( 'Programada', 'preventivo');
INSERT INTO comun.tbl_cat_estatus (txtdescripcion, txttipo) VALUES( 'Cancelada', 'preventivo');
INSERT INTO comun.tbl_cat_estatus (txtdescripcion, txttipo) VALUES( 'Retrazada', 'preventivo');
INSERT INTO comun.tbl_cat_estatus (txtdescripcion, txttipo) VALUES( 'Completada', 'preventivo');


CREATE TABLE comun.tbl_mantenimientos(
    "iid" SERIAL primary key not null,
    "iidestatus" int4 NOT NULL,
    "iidunidad" int4 NOT NULL,
    "dtfecha_ingreso" date NOT NULL,
    "dtfecha_salida" date,
    "fcosto_total" float4 NOT NULL DEFAULT 0,
    "txtlugar" text NOT NULL,
    "txtdescripcion" text,
    "txtcomentarios" text,
    "txtarchivo" text,
    "txttipo" varchar(50) not null DEFAULT 'correctivo',
    "bactivo" bool NOT NULL DEFAULT true,
    "dtfecha_creacion" timestamp(6) NOT NULL DEFAULT now(),
    "dtfecha_modificacion" timestamp(6),
    CONSTRAINT fk_tbl_mantenimiento_tbl_cat_estatus FOREIGN KEY (iidestatus) REFERENCES comun.tbl_cat_estatus (iid) ON DELETE CASCADE ON UPDATE CASCADE
);