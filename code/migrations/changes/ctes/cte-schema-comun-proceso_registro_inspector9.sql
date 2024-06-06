WITH check_existence AS (
    -- Verificar si ya existe un proceso con la sigla 'REIN'
    SELECT EXISTS (
        SELECT 1 FROM "comun"."cat_proceso"
        WHERE "txtsigla" = 'REIN'
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
    SELECT 11, 'REGISTRO DE INSPECTOR', 'Proceso para el registro de inspectores', 'REIN'
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
        ( 'Recopilación de información', 'RECI', 'Recopilar la información necesaria para el registro del inspector.' ),
        ( 'Evaluación del candidato', 'EVCA', 'Evaluar al candidato para determinar su idoneidad como inspector.' ),
        ( 'Permiso', 'PERM', 'Asignar permisos al candidato seleccionado como inspector.' ),
        ( 'Baja', 'BAJA', 'Proceso de baja de inspectores.' )
    ) AS data(txtnombre, txtsigla, txtdescripcion)
    CROSS JOIN Proceso
    RETURNING iidetapa, txtnombre
)
-- Insertar subetapas del proceso "ELABORACIÓN DE BOLETA"
INSERT INTO "comun"."cat_subetapa" ("iidetapa", "txtnombre", "txtsigla", "txtdescripcion", "binicial")
SELECT iidetapa, txtnombre, txtsigla, txtdescripcion,
    CASE 
        WHEN txtnombre = 'Captura de información' THEN true
        ELSE false
    END AS binicial
FROM (
    VALUES 
        -- Subetapas de la etapa "Creación de boleta"
        ((SELECT iidetapa FROM Etapa WHERE txtnombre = 'Recopilación de información'), 'Captura de información', 'CAPI', 'Datos generales, puesto y turno al que aspira.'),
        ((SELECT iidetapa FROM Etapa WHERE txtnombre = 'Recopilación de información'), 'Verificación de documentos', 'VEDO', 'Verificar la autenticidad y validez de los documentos presentados por el candidato.'),
        -- Subetapas de la etapa "Pago de boleta"
        ((SELECT iidetapa FROM Etapa WHERE txtnombre = 'Evaluación del candidato'), 'Evaluación de competencias', 'ECOM', 'Evaluar las habilidades y competencias del candidato en relación con el puesto de inspector.'),
        -- Subetapas de la etapa "Comparecencia"
        ((SELECT iidetapa FROM Etapa WHERE txtnombre = 'Permiso'), 'Emitir boleta de infracción', 'EBIN', 'Generar y entregar al candidato seleccionado el documento oficial que registra y sanciona una violación específica de las regulaciones establecidas, proporcionando evidencia documentada del incumplimiento.'),
        -- Subetapas de la etapa "Baja"
        ((SELECT iidetapa FROM Etapa WHERE txtnombre = 'Baja'), 'Solicitud de baja', 'SOBA', 'Recopilación de la información necesaria para solicitar la baja del inspector.'),
        ((SELECT iidetapa FROM Etapa WHERE txtnombre = 'Baja'), 'Revisión de solicitud', 'RESO', 'Revisión y validación de la solicitud de baja del inspector.'),
        ((SELECT iidetapa FROM Etapa WHERE txtnombre = 'Baja'), 'Proceso de baja', 'PROB', 'Ejecución del proceso de baja del inspector.')
) AS data(iidetapa, txtnombre, txtsigla, txtdescripcion);
