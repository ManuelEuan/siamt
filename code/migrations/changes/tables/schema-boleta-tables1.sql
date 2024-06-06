-- Creación de esquema si no existe
CREATE SCHEMA IF NOT EXISTS boleta;

-- Creación de secuencias si no existen
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'boleta' AND sequencename = 'tbl_boleta_iidboleta_seq') THEN
        CREATE SEQUENCE "boleta"."tbl_boleta_iidboleta_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'boleta' AND sequencename = 'tbl_boleta_rol_iidboleta_rol_seq') THEN
        CREATE SEQUENCE "boleta"."tbl_boleta_rol_iidboleta_rol_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;
    END IF;
END$$;

-- Creación de tabla tbl_boleta_rol
CREATE TABLE IF NOT EXISTS boleta.tbl_boleta_rol (
    iidboleta_rol SERIAL PRIMARY KEY,
    txtnombre TEXT NOT NULL,
    bactivo BOOLEAN DEFAULT true,
    dtfecha_creacion TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    dtfecha_modificacion TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);

-- Creación de tabla tbl_boleta
CREATE TABLE IF NOT EXISTS boleta.tbl_boleta (
    iidboleta INTEGER PRIMARY KEY DEFAULT nextval('boleta.tbl_boleta_iidboleta_seq'),
    dtfecha_hora_infraccion TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    txtlugar_infraccion TEXT NOT NULL,
    -- direccion_id INTEGER NOT NULL REFERENCES direcciones(id),
    txtdireccion TEXT NOT NULL,
    imonto_total FLOAT NOT NULL,
    iidinfractor INTEGER NOT NULL, -- REFERENCES persona.tbl_persona(iidpersona),
    iidboleta_rol_id INTEGER NOT NULL, -- REFERENCES boleta.tbl_boleta_rol(iidboleta_rol),
    -- licencia_id INTEGER NOT NULL REFERENCES licencias(id),
    txtlicencia TEXT NOT NULL,
    -- unidad_id INTEGER NOT NULL REFERENCES unidades(id),
    txtunidad TEXT NOT NULL,
    -- tarjeta_circulacion_id INTEGER NOT NULL REFERENCES tarjetas_circulacion(id),
    tarjeta_circulacion_id TEXT NOT NULL,
    iidempleado INTEGER NOT NULL, -- REFERENCES persona.tbl_persona(iidpersona),
    -- reporte_especial_id INTEGER NOT NULL REFERENCES reportes_especiales(id),
    txtreporte_especial_id TEXT NOT NULL,
    -- inspeccion_fisica_id INTEGER NOT NULL REFERENCES inspecciones_fisicas(id),
    txtinspeccion_fisica TEXT NOT NULL,
    bretencion_vehiculo BOOLEAN DEFAULT false,
    bretencion_documento BOOLEAN DEFAULT false,
    txtobservaciones TEXT,
    bapercibimiento BOOLEAN DEFAULT false,
    dapercibimiento_fecha TIMESTAMP WITHOUT TIME ZONE,
    dfecha_limite_comparecencia TIMESTAMP WITHOUT TIME ZONE,
    dfecha_limite_resolucion TIMESTAMP WITHOUT TIME ZONE,
    dfecha_limite_notificacion TIMESTAMP WITHOUT TIME ZONE,
    bno_ha_lugar BOOLEAN DEFAULT false,
    bsuspension BOOLEAN DEFAULT false,
    isuspension_dias INTEGER,
    dsuspension_fecha DATE,
    bactivo BOOLEAN DEFAULT true,
    dtfecha_creacion TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    dtfecha_modificacion TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    CONSTRAINT fk_iidinfractor FOREIGN KEY (iidinfractor) REFERENCES persona.tbl_persona(iidpersona),
    CONSTRAINT fk_iidempleado FOREIGN KEY (iidempleado) REFERENCES persona.tbl_persona(iidpersona)
);
