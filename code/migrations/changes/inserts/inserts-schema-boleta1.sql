INSERT INTO boleta.tbl_boleta_rol (txtnombre)
SELECT value
FROM (VALUES 
    ('operador'),
    ('propietario'),
    ('concesionario'),
    ('poseedor')
) AS data(value)
WHERE value NOT IN (SELECT txtnombre FROM boleta.tbl_boleta_rol);

-- INSERT INTO boleta.tbl_boleta (
--     dtfecha_hora_infraccion,
--     txtlugar_infraccion,
--     txtdireccion,
--     imonto_total,
--     iidinfractor,
--     iidboleta_rol_id,
--     txtlicencia,
--     txtunidad,
--     tarjeta_circulacion_id,
--     iidempleado,
--     txtreporte_especial_id,
--     txtinspeccion_fisica,
--     bretencion_vehiculo,
--     bretencion_documento,
--     txtobservaciones,
--     bapercibimiento,
--     dapercibimiento_fecha,
--     dfecha_limite_comparecencia,
--     dfecha_limite_resolucion,
--     dfecha_limite_notificacion,
--     bno_ha_lugar,
--     bsuspension,
--     isuspension_dias,
--     dsuspension_fecha,
--     bactivo,
--     dtfecha_creacion,
--     dtfecha_modificacion
-- ) VALUES (
--     '2024-06-07 12:00:00', -- Fecha y hora de la infracción
--     'Ciudad',              -- Lugar de la infracción
--     'Calle X, Número Y',   -- Dirección
--     100.50,                -- Monto total
--     2,                     -- ID del infractor
--     1,                     -- ID del rol de la boleta
--     'Licencia A',          -- Licencia
--     'Unidad A',            -- Unidad
--     'Tarjeta A',           -- ID de la tarjeta de circulación
--     1,                     -- ID del empleado
--     'Reporte Especial A',  -- ID del reporte especial
--     'Inspección Física A', -- ID de la inspección física
--     false,                 -- Retención de vehículo
--     false,                 -- Retención de documento
--     'Observaciones...',    -- Observaciones
--     false,                 -- Apercibimiento
--     NULL,                  -- Fecha de apercibimiento
--     '2024-06-14',          -- Fecha límite de comparecencia
--     '2024-06-21',          -- Fecha límite de resolución
--     '2024-06-28',          -- Fecha límite de notificación
--     false,                 -- No ha lugar
--     true,                  -- Suspensión
--     30,                    -- Días de suspensión
--     '2024-07-07',          -- Fecha de suspensión
--     true,                  -- Activo
--     NOW(),                 -- Fecha de creación
--     NOW()                  -- Fecha de modificación
-- );