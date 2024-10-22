--liquibase formatted sql
--changeset aicf:33
--Modificar direccion completa

ALTER TABLE "persona"."tbl_direccion"
DROP COLUMN txtdireccion_completa;

ALTER TABLE "persona"."tbl_direccion"
ADD COLUMN txtdireccion_completa text GENERATED ALWAYS AS (
    TRIM(
            CASE
                WHEN "iidtipo_direccion" = 1 THEN
                    COALESCE('CALLE ' || txtcalle || COALESCE(txtcalle_letra, ''), '') || ' ' ||
                    COALESCE('# ' || inumero_exterior::text || COALESCE(txtnumero_exterior_letra, ''), '') || ' ' ||
                    COALESCE('ENTRE ' || txtcruzamiento_uno || COALESCE(txtcruzamiento_uno_letra, ''), '') || ' ' ||
                    COALESCE('Y ' || txtcruzamiento_dos || COALESCE(txtcruzamiento_dos_letra, ' '), ' ')
                WHEN "iidtipo_direccion" IN (2, 3) THEN
                    COALESCE(txtcalle, '')
                ELSE ''
                END ||
            CASE
                WHEN txtcolonia IS NOT NULL THEN ' COL. ' || txtcolonia
                ELSE ''
                END
    )
) STORED;

