-- Inserción de datos en cat_estado
INSERT INTO "territorio"."cat_estado" (txtnombre, iclave_estado) 
SELECT nombre, clave_estado
FROM (VALUES 
    ('Aguascalientes', 1),
    ('Baja California', 2),
    ('Baja California Sur', 3),
    ('Campeche', 4),
    ('Coahuila de Zaragoza', 5),
    ('Colima', 6),
    ('Chiapas', 7),
    ('Chihuahua', 8),
    ('Ciudad de México', 9),
    ('Durango', 10),
    ('Guanajuato', 11),
    ('Guerrero', 12),
    ('Hidalgo', 13),
    ('Jalisco', 14),
    ('México', 15),
    ('Michoacán de Ocampo', 16),
    ('Morelos', 17),
    ('Nayarit', 18),
    ('Nuevo León', 19),
    ('Oaxaca', 20),
    ('Puebla', 21),
    ('Querétaro', 22),
    ('Quintana Roo', 23),
    ('San Luis Potosí', 24),
    ('Sinaloa', 25),
    ('Sonora', 26),
    ('Tabasco', 27),
    ('Tamaulipas', 28),
    ('Tlaxcala', 29),
    ('Veracruz de Ignacio de la Llave', 30),
    ('Yucatán', 31),
    ('Zacatecas', 32)
) AS data(nombre, clave_estado)
WHERE NOT EXISTS (
    SELECT 1 
    FROM "territorio"."cat_estado" 
    WHERE txtnombre = data.nombre
);

-- Inserción de datos en cat_municipio
INSERT INTO "territorio"."cat_municipio" (txtnombre, iclave_estado, iclave_municipio) 
SELECT nombre, clave_estado, clave_municipio
FROM (VALUES 
   ('Aguascalientes', 1, 1),
    ('San Francisco de los Romo', 1, 11),
    ('El Llano', 1, 10),
    ('Rincón de Romos', 1, 7),
    ('Cosío', 1, 4),
    ('San José de Gracia', 1, 8),
    ('Tepezalá', 1, 9),
    ('Pabellón de Arteaga', 1, 6),
    ('Asientos', 1, 2),
    ('Calvillo', 1, 3),
    ('Jesús María', 1, 5),
    ('Mérida', 31, 50),
    ('Progreso', 31, 59),
    ('Chicxulub Pueblo', 31, 20),
    ('Ixil', 31, 39),
    ('Conkal', 31, 13),
    ('Yaxkukul', 31, 105),
    ('Hunucmá', 31, 38),
    ('Ucú', 31, 100),
    ('Kinchil', 31, 44),
    ('Tetiz', 31, 87),
    ('Celestún', 31, 11),
    ('Kanasín', 31, 41),
    ('Timucuy', 31, 90),
    ('Acanceh', 31, 2),
    ('Tixpéhual', 31, 95),
    ('Umán', 31, 101),
    ('Telchac Pueblo', 31, 82),
    ('Dzemul', 31, 26),
    ('Telchac Puerto', 31, 83),
    ('Cansahcab', 31, 9),
    ('Sinanché', 31, 68),
    ('Yobaín', 31, 106),
    ('Motul', 31, 52),
    ('Baca', 31, 4),
    ('Mocochá', 31, 51),
    ('Muxupip', 31, 54),
    ('Cacalchén', 31, 7),
    ('Bokobá', 31, 5),
    ('Tixkokob', 31, 93),
    ('Hoctún', 31, 35),
    ('Tahmek', 31, 74),
    ('Dzidzantún', 31, 27),
    ('Temax', 31, 84),
    ('Tekantó', 31, 78),
    ('Teya', 31, 88),
    ('Suma', 31, 72),
    ('Tepakán', 31, 86),
    ('Tekal de Venegas', 31, 77),
    ('Izamal', 31, 40),
    ('Hocabá', 31, 34),
    ('Xocchel', 31, 103),
    ('Seyé', 31, 67),
    ('Cuzamá', 31, 15),
    ('Homún', 31, 36),
    ('Sanahcat', 31, 64),
    ('Huhí', 31, 37),
    ('Dzilam González', 31, 29),
    ('Dzilam de Bravo', 31, 28),
    ('Panabá', 31, 57),
    ('San Felipe', 31, 65),
    ('Buctzotz', 31, 6),
    ('Sucilá', 31, 70),
    ('Cenotillo', 31, 12),
    ('Dzoncauich', 31, 31),
    ('Tunkás', 31, 97),
    ('Quintana Roo', 31, 60),
    ('Dzitás', 31, 30),
    ('Kantunil', 31, 42),
    ('Sudzal', 31, 71),
    ('Tekit', 31, 80),
    ('Sotuta', 31, 69),
    ('Tizimín', 31, 96),
    ('Río Lagartos', 31, 61),
    ('Espita', 31, 32),
    ('Temozón', 31, 85),
    ('Calotmul', 31, 8),
    ('Tinum', 31, 91),
    ('Chankom', 31, 17),
    ('Chichimilá', 31, 21),
    ('Tixcacalcupul', 31, 92),
    ('Kaua', 31, 43),
    ('Cuncunul', 31, 14),
    ('Tekom', 31, 81),
    ('Chemax', 31, 19),
    ('Valladolid', 31, 102),
    ('Uayma', 31, 99),
    ('Maxcanú', 31, 48),
    ('Samahil', 31, 63),
    ('Opichén', 31, 55),
    ('Chocholá', 31, 23),
    ('Kopomá', 31, 45),
    ('Tecoh', 31, 76),
    ('Akil', 31, 3)
) AS data(nombre, clave_estado, clave_municipio)
WHERE NOT EXISTS (
    SELECT 1 
    FROM "territorio"."cat_municipio" 
    WHERE txtnombre = data.nombre
);

-- Inserción de datos en cat_colonia
INSERT INTO "territorio"."cat_colonia" (txtnombre, iclave_municipio, icodigo_postal, iclave_colonia) 
SELECT nombre, clave_municipio, codigo_postal, clave_colonia
FROM (VALUES 
    ('Aguascalientes Centro', 1, 20000, 1),
    ('Colinas del Rio', 1, 20010, 5),
    ('Olivares Santana', 1, 20010, 6),
    ('Las Brisas', 1, 20010, 7),
    ('Ramon Romo Franco', 1, 20010, 8),
    ('San Cayetano', 1, 20010, 9),
    ('Colinas de San Ignacio', 1, 20016, 10),
    ('La Fundición', 1, 20016, 11),
    ('Fundición II', 1, 20016, 12),
    ('Los Sauces', 1, 20016, 13),
    ('Línea de Fuego', 1, 20018, 14),
    ('Buenos Aires', 1, 20020, 16),
    ('Circunvalación Norte', 1, 20020, 18),
    ('Las Arboledas', 1, 20020, 19),
    ('Villas de San Francisco', 1, 20020, 20),
    ('Vergel', 50, 97173, 122),
    ('Vergel II', 50, 97173, 123),
    ('Vergel III', 50, 97173, 124),
    ('Vergel IV', 50, 97173, 125),
    ('San Jose Vergel', 50, 97173, 126),
    ('Real San José', 50, 97173, 283),
    ('Misne III', 50, 97173, 1893),
    ('Villas La Macarena', 50, 97174, 127),
    ('Morelos Oriente', 50, 97174, 128),
    ('Amalia Solorzano', 50, 97175, 129),
    ('Misné II', 50, 97176, 278),
    ('San Pablo Oriente', 50, 97176, 682),
    ('Vergel 65', 50, 97176, 859),
    ('San Antonio Kaua', 50, 97176, 911),
    ('El Vergel', 50, 97176, 1006),
    ('Azcorra', 50, 97177, 133)
) AS data(nombre, clave_municipio, codigo_postal, clave_colonia)
WHERE NOT EXISTS (
    SELECT 1 
    FROM "territorio"."cat_colonia" 
    WHERE txtnombre = data.nombre
);

-- Inserción de datos en cat_zona
INSERT INTO "territorio"."cat_zona" (txtnombre) 
SELECT nombre
FROM (VALUES 
    ('Norte'),
    ('Sur'),
    ('Poniente'),
    ('Oriente')
) AS data(nombre)
WHERE NOT EXISTS (
    SELECT 1 
    FROM "territorio"."cat_zona" 
    WHERE txtnombre = data.nombre
);
