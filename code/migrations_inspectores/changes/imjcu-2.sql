
-- -------------------- CATÁLOGOS SCHEMA INSPECCIÓN
INSERT INTO "inspeccion"."tbl_cat_carga_trabajo_tipo" (txtnombre, txtdescripcion, breten)
SELECT txtnombre, txtdescripcion, breten
FROM (VALUES 
    ('Inspección urbana (aforo)', NULL, false),
    ('Inspección foránea (retén)', NULL, true)
) AS data(txtnombre, txtdescripcion, breten)
WHERE NOT EXISTS (
    SELECT 1 
    FROM "inspeccion"."tbl_cat_carga_trabajo_tipo" 
    WHERE txtnombre = data.txtnombre
);

INSERT INTO "inspeccion"."tbl_cat_inspector_categoria" (txtnombre, txtdescripcion, bcoordinador, bgenera_boleta)
SELECT txtnombre, txtdescripcion, bcoordinador, bgenera_boleta
FROM (VALUES 
    ('Coordinador', NULL, true, false),
    ('Inspector nombrado', NULL, false, true),
    ('Inspector', NULL, false, false)
) AS data(txtnombre, txtdescripcion, bcoordinador, bgenera_boleta)
WHERE NOT EXISTS (
    SELECT 1 
    FROM "inspeccion"."tbl_cat_inspector_categoria" 
    WHERE txtnombre = data.txtnombre
);

INSERT INTO "inspeccion"."tbl_cat_turno" (txtnombre, txtdescripcion, bruta_nocturna, thora_inicio, thora_fin)
SELECT txtnombre, txtdescripcion, bruta_nocturna, CAST(thora_inicio AS TIME), CAST(thora_fin AS TIME)
FROM (VALUES 
    ('Matutino', NULL, false, '08:00:00', '14:00:00'),
    ('Vespertino', NULL, false, '14:00:00', '20:00:00'),
    ('Nocturno', NULL, false, '20:00:00', '02:00:00'),
    ('Ruta nocturna', NULL, true, '02:00:00', '08:00:00')
) AS data(txtnombre, txtdescripcion, bruta_nocturna, thora_inicio, thora_fin)
WHERE NOT EXISTS (
    SELECT 1 
    FROM "inspeccion"."tbl_cat_turno" 
    WHERE txtnombre = data.txtnombre
);

-- -------------------- CATÁLOGOS SCHEMA BOLETA
INSERT INTO boleta.tbl_boleta_rol (txtnombre)
SELECT value
FROM (VALUES 
    ('operador'),
    ('propietario'),
    ('concesionario'),
    ('poseedor')
) AS data(value)
WHERE value NOT IN (SELECT txtnombre FROM boleta.tbl_boleta_rol);
