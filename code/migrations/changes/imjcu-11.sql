-- changeset imjcu-11.sql
-- Crear los catálogos de los schemas boleta, comun, inspeccion, persona, territorio, usuario 

WITH check_existence AS (
    SELECT EXISTS (
        SELECT 1 FROM "comun"."tbl_cat_proceso"
        WHERE "txtnombre" = 'REGISTRO DE INSPECTOR'
    ) AS exists
),
existing_proceso AS (
    -- Seleccionar el proceso si ya existe
    SELECT iid
    FROM "comun"."tbl_cat_proceso"
    WHERE "txtnombre" = 'REGISTRO DE INSPECTOR'
),
insert_proceso AS (
    -- Insertar datos del proceso "ELABORACIÓN DE BOLETA" si no existe
    INSERT INTO "comun"."tbl_cat_proceso" ("iidmodulo", "txtnombre")
    SELECT 11, 'REGISTRO DE INSPECTOR'
    FROM check_existence
    WHERE NOT exists
    RETURNING iid
),
Proceso AS (
    SELECT iid FROM existing_proceso
    UNION ALL
    SELECT iid FROM insert_proceso
),
Etapa AS (
    -- Insertar etapas del proceso "REGISTRO DE INSPECTOR"
    INSERT INTO "comun"."tbl_cat_etapa" ("iidproceso", "txtnombre", "vclave", "txtdescripcion")
    SELECT Proceso.iid, data.txtnombre, LEFT(data.txtnombre || '00000', 5) AS vclave, data.txtdescripcion
    FROM (VALUES 
        ( 'Recopilación de información', 'Recopilar la información necesaria para el registro del inspector.' ),
        ( 'Evaluación del candidato', 'Evaluar al candidato para determinar su idoneidad como inspector.' ),
        ( 'Permiso', 'Asignar permisos al candidato seleccionado como inspector.' ),
        ( 'Baja', 'Proceso de baja de inspectores.' )
    ) AS data(txtnombre, txtdescripcion)
    CROSS JOIN Proceso
    RETURNING iid, txtnombre
)
-- Insertar subetapas del proceso "REGISTRO DE INSPECTOR"
INSERT INTO "comun"."tbl_cat_subetapa" ("iidetapa", "txtnombre", "vclave", "txtdescripcion", "binicial")
SELECT iid, txtnombre, LEFT(data.txtnombre || '00000', 5) AS vclave, txtdescripcion,
    CASE 
        WHEN txtnombre = 'Captura de información' THEN true
        ELSE false
    END AS binicial
FROM (
    VALUES 
        -- Subetapas de la etapa "Creación de boleta"
        ((SELECT iid FROM Etapa WHERE txtnombre = 'Recopilación de información'), 'Captura de información', 'Datos generales, puesto y turno al que aspira.'),
        ((SELECT iid FROM Etapa WHERE txtnombre = 'Recopilación de información'), 'Verificación de documentos', 'Verificar la autenticidad y validez de los documentos presentados por el candidato.'),
        -- Subetapas de la etapa "Pago de boleta"
        ((SELECT iid FROM Etapa WHERE txtnombre = 'Evaluación del candidato'), 'Evaluación de competencias', 'Evaluar las habilidades y competencias del candidato en relación con el puesto de inspector.'),
        -- Subetapas de la etapa "Comparecencia"
        ((SELECT iid FROM Etapa WHERE txtnombre = 'Permiso'), 'Emitir boleta de infracción', 'Generar y entregar al candidato seleccionado el documento oficial que registra y sanciona una violación específica de las regulaciones establecidas, proporcionando evidencia documentada del incumplimiento.'),
        -- Subetapas de la etapa "Baja"
        ((SELECT iid FROM Etapa WHERE txtnombre = 'Baja'), 'Solicitud de baja', 'Recopilación de la información necesaria para solicitar la baja del inspector.'),
        ((SELECT iid FROM Etapa WHERE txtnombre = 'Baja'), 'Revisión de solicitud', 'Revisión y validación de la solicitud de baja del inspector.'),
        ((SELECT iid FROM Etapa WHERE txtnombre = 'Baja'), 'Proceso de baja', 'Finalización proceso de baja del inspector.')
) AS data(iid, txtnombre, txtdescripcion);
