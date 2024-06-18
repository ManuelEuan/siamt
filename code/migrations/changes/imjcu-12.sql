WITH check_existence AS (
    -- Verificar si ya existe un proceso con la sigla 'ELAB'
    SELECT EXISTS (
        SELECT 1 FROM "comun"."tbl_cat_proceso"
        WHERE "txtnombre" = 'ELABORACIÓN DE BOLETA'
    ) AS exists
),
existing_proceso AS (
    -- Seleccionar el proceso si ya existe
    SELECT iid
    FROM "comun"."tbl_cat_proceso"
    WHERE "txtnombre" = 'ELABORACIÓN DE BOLETA'
),
insert_proceso AS (
    -- Insertar datos del proceso "ELABORACIÓN DE BOLETA" si no existe
    INSERT INTO "comun"."tbl_cat_proceso" ("iidmodulo", "txtnombre")
    SELECT 12, 'ELABORACIÓN DE BOLETA'
    FROM check_existence
    WHERE NOT exists
    RETURNING iid
),
Proceso AS (
    -- Seleccionar el proceso existente o el proceso recién insertado
    SELECT iid FROM existing_proceso
    UNION ALL
    SELECT iid FROM insert_proceso
),
Etapa AS (
    -- Insertar etapas del proceso "ELABORACIÓN DE BOLETA"
    INSERT INTO "comun"."tbl_cat_etapa" ("iidproceso", "txtnombre", "vclave", "txtdescripcion")
    SELECT Proceso.iid, data.txtnombre, LEFT(data.txtnombre || '00000', 5) AS vclave, data.txtdescripcion
    FROM (VALUES 
        ('Creación de boleta', 'Crear la boleta con la información relevante.'),
        ('Pago de boleta', 'Realizar el pago correspondiente de la boleta.'),
        ('Comparecencia', 'Convocar a una comparecencia si es necesario.')
    ) AS data(txtnombre, txtdescripcion)
    CROSS JOIN Proceso
    RETURNING iid, txtnombre
)
-- Insertar subetapas del proceso "ELABORACIÓN DE BOLETA"
INSERT INTO "comun"."tbl_cat_subetapa" ("iidetapa", "txtnombre", "vclave", "txtdescripcion", "binicial")
SELECT iid, txtnombre, LEFT(data.txtnombre || '00000', 5) AS vclave, txtdescripcion,
    CASE 
        WHEN txtnombre = 'Ingreso de información' THEN true
        ELSE false
    END AS binicial
FROM (
    VALUES 
        -- Subetapas de la etapa "Creación de boleta"
        ((SELECT iid FROM Etapa WHERE txtnombre = 'Creación de boleta'), 'Ingreso de información',  'Ingresar la información básica para la creación de la boleta.', true),
        ((SELECT iid FROM Etapa WHERE txtnombre = 'Creación de boleta'), 'Revisión de datos', 'Revisar los datos ingresados en la boleta antes de su emisión.', false),
        ((SELECT iid FROM Etapa WHERE txtnombre = 'Creación de boleta'), 'Emisión de boleta',  'Emitir la boleta después de su creación y revisión.', false),
        -- Subetapas de la etapa "Pago de boleta"
        ((SELECT iid FROM Etapa WHERE txtnombre = 'Pago de boleta'), 'Selección de método de pago',  'Seleccionar el método de pago preferido.', false),
        ((SELECT iid FROM Etapa WHERE txtnombre = 'Pago de boleta'), 'Realización del pago',  'Realizar el pago correspondiente de la boleta.', false),
        -- Subetapas de la etapa "Comparecencia"
        ((SELECT iid FROM Etapa WHERE txtnombre = 'Comparecencia'), 'Convocatoria a comparecencia',  'Convocar a la parte interesada a una comparecencia si es necesario.', false),
        ((SELECT iid FROM Etapa WHERE txtnombre = 'Comparecencia'), 'Desarrollo de comparecencia', 'Llevar a cabo la comparecencia con todas las partes involucradas.', false),
        ((SELECT iid FROM Etapa WHERE txtnombre = 'Comparecencia'), 'Resolución de comparecencia', 'Resolver las cuestiones planteadas durante la comparecencia.', false)
) AS data(iid, txtnombre, txtdescripcion, binicial);
