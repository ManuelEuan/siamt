-- Inserción de datos en cat_estado_civil solo si no existen
INSERT INTO "persona"."cat_estado_civil" (txtnombre)
SELECT value
FROM (VALUES 
    ('Soltero'),
    ('Casado'),
    ('Divorciado'),
    ('Viudo'),
    ('Separado'),
    ('Unión civil'),
    ('Conviviente')
) AS data(value)
WHERE NOT EXISTS (
    SELECT 1 
    FROM "persona"."cat_estado_civil" 
    WHERE txtnombre = data.value
);

-- Inserción de datos en cat_lada solo si no existen
INSERT INTO "persona"."cat_lada" (txtnombre, txtdescripcion, txtiso_tres)
SELECT txtnombre, txtdescripcion, txtiso_tres
FROM (VALUES 
    ('+1', 'Estados Unidos y Canadá', 'USA/CAN'),
    ('+52', 'México', 'MEX'),
    ('+44', 'Reino Unido', 'GBR'),
    ('+49', 'Alemania', 'DEU'),
    ('+33', 'Francia', 'FRA'),
    ('+34', 'España', 'ESP'),
    ('+86', 'China', 'CHN'),
    ('+81', 'Japón', 'JPN'),
    ('+61', 'Australia', 'AUS'),
    ('+55', 'Brasil', 'BRA')
) AS data(txtnombre, txtdescripcion, txtiso_tres)
WHERE NOT EXISTS (
    SELECT 1 
    FROM "persona"."cat_lada" 
    WHERE txtnombre = data.txtnombre
);


-- Inserción de datos en cat_sexo solo si no existen
INSERT INTO "persona"."cat_sexo" (txtnombre)
SELECT value
FROM (VALUES 
    ('Masculino'),
    ('Femenino')
) AS data(value)
WHERE NOT EXISTS (
    SELECT 1 
    FROM "persona"."cat_sexo" 
    WHERE txtnombre = data.value
);


-- Inserción de datos en cat_telefono_tipo solo si no existen
INSERT INTO "persona"."cat_telefono_tipo" (txtnombre, txtdescripcion)
SELECT txtnombre, txtdescripcion
FROM (VALUES 
    ('Celular', 'Teléfono celular'),
    ('Casa', 'Teléfono de casa')
) AS data(txtnombre, txtdescripcion)
WHERE NOT EXISTS (
    SELECT 1 
    FROM "persona"."cat_telefono_tipo" 
    WHERE txtnombre = data.txtnombre
);

