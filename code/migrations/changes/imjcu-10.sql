ALTER TABLE persona.persona_telefono RENAME TO tbl_persona_telefono;


ALTER TABLE persona.tbl_direccion
ADD COLUMN iidcolonia int4,
ADD COLUMN itipo_direccion int4,
ADD COLUMN itipo_vialidad int4,
ADD COLUMN txtavenida_kilometro text,
ADD COLUMN txttablaje text;
ALTER TABLE persona.tbl_persona_direccion
ADD COLUMN bactual bool DEFAULT true;

ALTER TABLE persona.tbl_persona_telefono
ADD COLUMN iidtelefono int4,
ADD COLUMN bactual bool DEFAULT true,
ADD COLUMN bactivo bool DEFAULT true,
ADD COLUMN dtfecha_creacion timestamp(6),
ADD COLUMN dtfecha_modificacion timestamp(6);

ALTER TABLE comun.tbl_flujo
ALTER COLUMN iidetapa DROP NOT NULL;