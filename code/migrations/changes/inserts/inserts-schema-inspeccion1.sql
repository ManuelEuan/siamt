-- Inserción de datos en cat_carga_trabajo_tipo, cat_inspector_categoria y cat_turno solo si no existen

-- Para cat_carga_trabajo_tipo
INSERT INTO "inspeccion"."cat_carga_trabajo_tipo" (txtnombre, txtdescripcion, breten)
SELECT txtnombre, txtdescripcion, breten
FROM (VALUES 
    ('Inspección urbana (aforo)', NULL, false),
    ('Inspección foránea (retén)', NULL, true)
) AS data(txtnombre, txtdescripcion, breten)
WHERE NOT EXISTS (
    SELECT 1 
    FROM "inspeccion"."cat_carga_trabajo_tipo" 
    WHERE txtnombre = data.txtnombre
);

-- Para cat_inspector_categoria
INSERT INTO "inspeccion"."cat_inspector_categoria" (txtnombre, txtdescripcion, bcoordinador, bgenera_boleta)
SELECT txtnombre, txtdescripcion, bcoordinador, bgenera_boleta
FROM (VALUES 
    ('Coordinador', NULL, true, false),
    ('Inspector nombrado', NULL, false, true),
    ('Inspector', NULL, false, false)
) AS data(txtnombre, txtdescripcion, bcoordinador, bgenera_boleta)
WHERE NOT EXISTS (
    SELECT 1 
    FROM "inspeccion"."cat_inspector_categoria" 
    WHERE txtnombre = data.txtnombre
);

-- Para cat_turno
INSERT INTO "inspeccion"."cat_turno" (txtnombre, txtdescripcion, bruta_nocturna, thora_inicio, thora_fin)
SELECT txtnombre, txtdescripcion, bruta_nocturna, CAST(thora_inicio AS TIME), CAST(thora_fin AS TIME)
FROM (VALUES 
    ('Matutino', NULL, false, '08:00:00', '14:00:00'),
    ('Vespertino', NULL, false, '14:00:00', '20:00:00'),
    ('Nocturno', NULL, false, '20:00:00', '02:00:00'),
    ('Ruta nocturna', NULL, true, '02:00:00', '08:00:00')
) AS data(txtnombre, txtdescripcion, bruta_nocturna, thora_inicio, thora_fin)
WHERE NOT EXISTS (
    SELECT 1 
    FROM "inspeccion"."cat_turno" 
    WHERE txtnombre = data.txtnombre
);
