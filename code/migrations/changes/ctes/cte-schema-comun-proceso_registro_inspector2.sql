WITH check_existence AS (
    -- Verificar si ya existe un proceso con la sigla 'REIN'
    SELECT EXISTS (
        SELECT 1 FROM "comun"."cat_proceso"
        WHERE "txtsigla" = 'REIN'
    ) AS exists
),
Proceso AS (
    -- Insertar datos del proceso "REGISTRO DE INSPECTOR" si no existe
    INSERT INTO "comun"."cat_proceso" ("iidmodulo", "txtnombre", "txtdescripcion", "txtsigla")
    SELECT 11, 'REGISTRO DE INSPECTOR', 'Proceso para el registro de inspectores', 'REIN'
    FROM check_existence
    WHERE NOT exists
    RETURNING iidproceso, txtnombre
),
Etapa AS (
    -- Insertar etapas del proceso "REGISTRO DE INSPECTOR"
    INSERT INTO "comun"."cat_etapa" ("iidproceso", "txtnombre", "txtsigla", "txtdescripcion")
    SELECT Proceso.iidproceso, data.txtnombre, data.txtsigla, data.txtdescripcion
    FROM Proceso,
    (
        VALUES 
            ( 'Recopilación de información', 'RECI', 'Recopilar la información necesaria para el registro del inspector.' ),
            ( 'Evaluación del candidato', 'EVCA', 'Evaluar al candidato para determinar su idoneidad como inspector.' ),
            ( 'Permiso', 'PERM', 'Asignar permisos al candidato seleccionado como inspector.' )
    ) AS data(txtnombre, txtsigla, txtdescripcion)
    RETURNING iidetapa, txtnombre
)
-- Insertar subetapas del proceso "REGISTRO DE INSPECTOR"
INSERT INTO "comun"."cat_subetapa" ("iidetapa", "txtnombre", "txtsigla", "txtdescripcion", "binicial")
SELECT Etapa.iidetapa, data.txtnombre, data.txtsigla, data.txtdescripcion, data.binicial
FROM Etapa,
(
    VALUES 
        -- Subetapas de la etapa "Recopilación de información"
        ( 'Recopilación de información', 'Captura de información', 'CAPI', 'Datos generales, puesto y turno al que aspira.', true ),
        ( 'Recopilación de información', 'Verificación de documentos', 'VEDO', 'Verificar la autenticidad y validez de los documentos presentados por el candidato.', false ),
        -- Subetapas de la etapa "Evaluación del candidato"
        ( 'Evaluación del candidato', 'Evaluación de competencias', 'ECOM', 'Evaluar las habilidades y competencias del candidato en relación con el puesto de inspector.', false ),
        -- Subetapas de la etapa "Permiso"
        ( 'Permiso', 'Emitir boleta de infracción', 'EBIN', 'Generar y entregar al candidato seleccionado el documento oficial que registra y sanciona una violación específica de las regulaciones establecidas, proporcionando evidencia documentada del incumplimiento.', false )
) AS data(etapa, txtnombre, txtsigla, txtdescripcion, binicial);
