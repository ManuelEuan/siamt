WITH check_existence AS (
    -- Verificar si ya existe un proceso con la sigla 'ELAB'
    SELECT EXISTS (
        SELECT 1 FROM "comun"."cat_proceso"
        WHERE "txtsigla" = 'ELAB'
    ) AS exists
),
existing_proceso AS (
    -- Seleccionar el proceso si ya existe
    SELECT iidproceso
    FROM "comun"."cat_proceso"
    WHERE "txtsigla" = 'ELAB'
),
insert_proceso AS (
    -- Insertar datos del proceso "ELABORACIÓN DE BOLETA" si no existe
    INSERT INTO "comun"."cat_proceso" ("iidmodulo", "txtnombre", "txtdescripcion", "txtsigla")
    SELECT 12, 'ELABORACIÓN DE BOLETA', 'Proceso para la elaboración de boletas', 'ELAB'
    FROM check_existence
    WHERE NOT exists
    RETURNING iidproceso
),
Proceso AS (
    -- Seleccionar el proceso existente o el proceso recién insertado
    SELECT iidproceso FROM existing_proceso
    UNION ALL
    SELECT iidproceso FROM insert_proceso
),
Etapa AS (
    -- Insertar etapas del proceso "ELABORACIÓN DE BOLETA"
    INSERT INTO "comun"."cat_etapa" ("iidproceso", "txtnombre", "txtsigla", "txtdescripcion")
    SELECT Proceso.iidproceso, data.txtnombre, data.txtsigla, data.txtdescripcion
    FROM (VALUES 
        ('Creación de boleta', 'CREA', 'Crear la boleta con la información relevante.'),
        ('Pago de boleta', 'PAGO', 'Realizar el pago correspondiente de la boleta.'),
        ('Comparecencia', 'COMP', 'Convocar a una comparecencia si es necesario.')
    ) AS data(txtnombre, txtsigla, txtdescripcion)
    CROSS JOIN Proceso
    RETURNING iidetapa, txtnombre
)
-- Insertar subetapas del proceso "ELABORACIÓN DE BOLETA"
INSERT INTO "comun"."cat_subetapa" ("iidetapa", "txtnombre", "txtsigla", "txtdescripcion", "binicial")
SELECT iidetapa, txtnombre, txtsigla, txtdescripcion,
    CASE 
        WHEN txtnombre = 'Ingreso de información' THEN true
        ELSE false
    END AS binicial
FROM (
    VALUES 
        -- Subetapas de la etapa "Creación de boleta"
        ((SELECT iidetapa FROM Etapa WHERE txtnombre = 'Creación de boleta'), 'Ingreso de información', 'INFO', 'Ingresar la información básica para la creación de la boleta.', true),
        ((SELECT iidetapa FROM Etapa WHERE txtnombre = 'Creación de boleta'), 'Revisión de datos', 'REV', 'Revisar los datos ingresados en la boleta antes de su emisión.', false),
        ((SELECT iidetapa FROM Etapa WHERE txtnombre = 'Creación de boleta'), 'Emisión de boleta', 'EMIT', 'Emitir la boleta después de su creación y revisión.', false),
        -- Subetapas de la etapa "Pago de boleta"
        ((SELECT iidetapa FROM Etapa WHERE txtnombre = 'Pago de boleta'), 'Selección de método de pago', 'METP', 'Seleccionar el método de pago preferido.', false),
        ((SELECT iidetapa FROM Etapa WHERE txtnombre = 'Pago de boleta'), 'Realización del pago', 'REAL', 'Realizar el pago correspondiente de la boleta.', false),
        -- Subetapas de la etapa "Comparecencia"
        ((SELECT iidetapa FROM Etapa WHERE txtnombre = 'Comparecencia'), 'Convocatoria a comparecencia', 'CONV', 'Convocar a la parte interesada a una comparecencia si es necesario.', false),
        ((SELECT iidetapa FROM Etapa WHERE txtnombre = 'Comparecencia'), 'Desarrollo de comparecencia', 'DES', 'Llevar a cabo la comparecencia con todas las partes involucradas.', false),
        ((SELECT iidetapa FROM Etapa WHERE txtnombre = 'Comparecencia'), 'Resolución de comparecencia', 'RES', 'Resolver las cuestiones planteadas durante la comparecencia.', false)
) AS data(iidetapa, txtnombre, txtsigla, txtdescripcion, binicial);
