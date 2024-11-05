--changeset aicf:36
--modificar direccción completa de las personas



ALTER TABLE "persona"."tbl_direccion"
DROP COLUMN IF EXISTS txtdireccion_completa;

ALTER TABLE "persona"."tbl_direccion"
    ADD COLUMN txtdireccion_completa text;

CREATE OR REPLACE FUNCTION actualizar_txtdireccion_completa()
RETURNS TRIGGER AS $$
BEGIN
    NEW.txtdireccion_completa := TRIM(
        COALESCE(
            (SELECT txtnombre FROM "persona"."tbl_cat_tipo_direccion" WHERE iid = NEW."iidtipo_direccion"),
            ''
        ) || ' ' ||
        CASE
            WHEN
                (SELECT vclave FROM "persona"."tbl_cat_tipo_direccion" WHERE iid = NEW."iidtipo_direccion") = 'PRED' AND
                (SELECT vclave FROM "persona"."tbl_cat_tipo_vialidad" WHERE iid = NEW."iidtipo_vialidad") = 'CALL'
            THEN
                COALESCE(
                    (SELECT txtnombre FROM "persona"."tbl_cat_tipo_vialidad" WHERE iid = NEW."iidtipo_vialidad") || ' ' ||
                    NEW.txtcalle || COALESCE(NEW.txtcalle_letra, ''), ''
                ) || ' ' ||
                COALESCE('# ' || NEW.inumero_exterior::text || COALESCE(NEW.txtnumero_exterior_letra, ''), '') || ' ' ||
                COALESCE('POR ' || NEW.txtcruzamiento_uno || COALESCE(NEW.txtcruzamiento_uno_letra, ''), '') ||
                CASE
                    WHEN NEW.txtcruzamiento_dos IS NOT NULL AND NEW.txtcruzamiento_dos <> '' THEN
                        ' Y ' || NEW.txtcruzamiento_dos || COALESCE(NEW.txtcruzamiento_dos_letra, '')
                    ELSE ''
                END
            WHEN
                (SELECT vclave FROM "persona"."tbl_cat_tipo_direccion" WHERE iid = NEW."iidtipo_direccion") = 'PRED' AND
                (SELECT vclave FROM "persona"."tbl_cat_tipo_vialidad" WHERE iid = NEW."iidtipo_vialidad") = 'AVEK'
            THEN
                COALESCE(
                    (SELECT txtnombre FROM "persona"."tbl_cat_tipo_vialidad" WHERE iid = NEW."iidtipo_vialidad") || ' ' ||
                    COALESCE(NEW.txtcalle, ''), ''
                )
            WHEN
                (SELECT vclave FROM "persona"."tbl_cat_tipo_direccion" WHERE iid = NEW."iidtipo_direccion") IN ('TABL', 'DOMC')
            THEN
                COALESCE(NEW.txtcalle, '')
            ELSE ''
        END ||
        CASE
            WHEN NEW.txtcolonia IS NOT NULL THEN ' COL. ' || NEW.txtcolonia
            ELSE ''
        END
    );

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_actualizar_txtdireccion_completa ON "persona"."tbl_direccion";

CREATE TRIGGER trg_actualizar_txtdireccion_completa
    BEFORE INSERT OR UPDATE ON "persona"."tbl_direccion"
                         FOR EACH ROW
                         EXECUTE FUNCTION actualizar_txtdireccion_completa();

UPDATE "persona"."tbl_direccion"
SET txtdireccion_completa = TRIM(
        COALESCE(
                (SELECT txtnombre FROM "persona"."tbl_cat_tipo_direccion" WHERE iid = "iidtipo_direccion"),
                ''
        ) || ' ' ||
        CASE
            WHEN
                (SELECT vclave FROM "persona"."tbl_cat_tipo_direccion" WHERE iid = "iidtipo_direccion") = 'PRED' AND
                (SELECT vclave FROM "persona"."tbl_cat_tipo_vialidad" WHERE iid = "iidtipo_vialidad") = 'CALL'
                THEN
                COALESCE(
                        (SELECT txtnombre FROM "persona"."tbl_cat_tipo_vialidad" WHERE iid = "iidtipo_vialidad") || ' ' ||
                        txtcalle || COALESCE(txtcalle_letra, ''), ''
                ) || ' ' ||
                COALESCE('# ' || inumero_exterior::text || COALESCE(txtnumero_exterior_letra, ''), '') || ' ' ||
                COALESCE('POR ' || txtcruzamiento_uno || COALESCE(txtcruzamiento_uno_letra, ''), '') ||
                CASE
                    WHEN txtcruzamiento_dos IS NOT NULL AND txtcruzamiento_dos <> '' THEN
                        ' Y ' || txtcruzamiento_dos || COALESCE(txtcruzamiento_dos_letra, '')
                    ELSE ''
                    END
            WHEN
                (SELECT vclave FROM "persona"."tbl_cat_tipo_direccion" WHERE iid = "iidtipo_direccion") = 'PRED' AND
                (SELECT vclave FROM "persona"."tbl_cat_tipo_vialidad" WHERE iid = "iidtipo_vialidad") = 'AVEK'
                THEN
                COALESCE(
                        (SELECT txtnombre FROM "persona"."tbl_cat_tipo_vialidad" WHERE iid = "iidtipo_vialidad") || ' ' ||
                        COALESCE(txtcalle, ''), ''
                )
            WHEN (SELECT vclave FROM "persona"."tbl_cat_tipo_direccion" WHERE iid = "iidtipo_direccion") IN ('TABL', 'DOMC') THEN
                COALESCE(txtcalle, '')
            ELSE ''
            END ||
        CASE
            WHEN txtcolonia IS NOT NULL THEN ' COL. ' || txtcolonia
            ELSE ''
            END
);


