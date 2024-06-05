-- Creación de la tabla 'inspecciones_tipos_puntos_revision'
CREATE TABLE inspecciones_tipos_puntos_revision (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    activo BOOLEAN DEFAULT true,
    fecha_creacion TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Creación de la tabla 'inspecciones_puntos_revision'
CREATE TABLE inspecciones_puntos_revision (
    id SERIAL PRIMARY KEY,
    inspecciones_tipos_puntos_revision_id INTEGER REFERENCES inspecciones_tipos_puntos_revision(id),
    nombre VARCHAR(50) NOT NULL,
    alias_uno VARCHAR(20),
    alias_dos VARCHAR(20),
    critico BOOLEAN DEFAULT false,
    activo BOOLEAN DEFAULT true,
    fecha_creacion TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Creación de la tabla 'inspecciones_detalle_puntos_revision'
CREATE TABLE inspecciones_detalle_puntos_revision (
    id SERIAL PRIMARY KEY,
    inspeccion_fisica_id INTEGER,
    inspeccion_punto_revision_id INTEGER,
    cumple BOOLEAN,
    observaciones TEXT,
    activo BOOLEAN DEFAULT true,
    fecha_creacion TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


-- Para el tipo de inspección 1
INSERT INTO inspecciones_puntos_revision (inspecciones_tipos_puntos_revision_id, nombre, alias_uno, alias_dos, critico)
VALUES 
    (1, 'Cinturon de seguridad', 'si', 'no', true),
    (1, 'Asiento del perador', 'Bueno', 'Malo', true),
    (1, 'Estado físico del parabrisas', 'Roto', 'Completo', true),
    (1, 'Limpia parabrisas', 'buen estado', 'mal estado', true),
    (1, 'Cepillos limpia parabrisas', 'bueno', 'malo', true),
    (1, 'Espejo retrovisor izquierdo', 'Bueno', 'Malo', true),
    (1, 'Espejo retrovisor derecho', 'Bueno', 'Malo', true),
    (1, 'Claxon', 'Funciona', 'No funciona', true),
    (1, 'Escape', 'Bueno', 'Malo', false);

-- Para el tipo de inspección 2
INSERT INTO inspecciones_puntos_revision (inspecciones_tipos_puntos_revision_id, nombre, alias_uno, alias_dos, critico)
VALUES 
    (2, 'Luces altas y bajas', 'Si', 'No', true),
    (2, 'Cuartos', 'Si', 'No', true),
    (2, 'Intermitentes', 'Si', 'No', true),
    (2, 'Direccionales', 'Si', 'No', true),
    (2, 'Frenado', 'Si', 'No', true),
    (2, 'Reversa', 'Si', 'No', true),
    (2, 'Alarma de reversa', 'Si', 'No', true);

-- Para el tipo de inspección 3
INSERT INTO inspecciones_puntos_revision (inspecciones_tipos_puntos_revision_id, nombre, alias_uno, alias_dos, critico)
VALUES 
    (3, 'Alarma de reversa', 'Bueno', 'Malo', false),
    (3, 'Defensa trasera', 'Bueno', 'Malo', false),
    (3, 'Carrocería', 'Bueno', 'Malo', false),
    (3, 'Piso', 'Bueno', 'Malo', false),
    (3, 'Asientos de pasajeros', 'Bueno', 'Malo', false),
    (3, 'Ventanillas', 'Bueno', 'Malo', true),
    (3, 'Llantas (no. llantas buenas)', 'Bueno', 'Malo', true),
    (3, 'Puerta delantera', 'Malo', NULL, true),
    (3, 'Puerta trasera', 'Bueno', 'Malo', true);
