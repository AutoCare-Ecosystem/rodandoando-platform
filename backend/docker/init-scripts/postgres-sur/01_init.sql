CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE usuario (
    id_usuario      SERIAL PRIMARY KEY,
    nombre          VARCHAR(120) NOT NULL,
    email           VARCHAR(150) NOT NULL UNIQUE,
    password_hash   TEXT         NOT NULL,
    rol             VARCHAR(20)  NOT NULL CHECK (rol IN ('CONDUCTOR', 'TALLER')),
    region_id       INTEGER      NOT NULL,
    fecha_registro  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE vehiculo (
    id_vehiculo         SERIAL PRIMARY KEY,
    id_usuario          INTEGER      NOT NULL REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    vin                 VARCHAR(17)  NOT NULL UNIQUE,
    marca               VARCHAR(60)  NOT NULL,
    modelo              VARCHAR(60)  NOT NULL,
    anio                SMALLINT     NOT NULL CHECK (anio >= 1950 AND anio <= 2030),
    kilometraje_actual  INTEGER      NOT NULL DEFAULT 0 CHECK (kilometraje_actual >= 0),
    region_id           INTEGER      NOT NULL
);

CREATE TABLE taller (
    id_taller       SERIAL PRIMARY KEY,
    id_usuario      INTEGER       NOT NULL REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    nombre          VARCHAR(120)  NOT NULL,
    direccion       TEXT          NOT NULL,
    latitud         NUMERIC(9, 6) NOT NULL,
    longitud        NUMERIC(9, 6) NOT NULL,
    region_id       INTEGER       NOT NULL,
    telefono        VARCHAR(20)
);

CREATE TABLE bitacora_personal (
    id_registro     SERIAL PRIMARY KEY,
    id_vehiculo     INTEGER        NOT NULL REFERENCES vehiculo(id_vehiculo) ON DELETE CASCADE,
    fecha           DATE           NOT NULL DEFAULT CURRENT_DATE,
    kilometraje     INTEGER        NOT NULL CHECK (kilometraje >= 0),
    categoria       VARCHAR(30)    NOT NULL CHECK (categoria IN ('GASOLINA', 'REFACCION', 'MANTENIMIENTO_PROPIO', 'SEGURO')),
    monto           NUMERIC(10, 2) NOT NULL CHECK (monto > 0),
    notas           TEXT,
    region_id       INTEGER        NOT NULL
);

CREATE TABLE servicio_taller (
    id_servicio         SERIAL PRIMARY KEY,
    id_vehiculo         INTEGER        NOT NULL REFERENCES vehiculo(id_vehiculo) ON DELETE CASCADE,
    id_taller           INTEGER        NOT NULL REFERENCES taller(id_taller) ON DELETE RESTRICT,
    fecha               TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    kilometraje         INTEGER        NOT NULL CHECK (kilometraje >= 0),
    tipo_servicio       VARCHAR(100)   NOT NULL,
    costo_total         NUMERIC(10, 2) NOT NULL CHECK (costo_total >= 0),
    diagnostico_tecnico TEXT,
    estatus             VARCHAR(20)    NOT NULL DEFAULT 'PENDIENTE' CHECK (estatus IN ('PENDIENTE', 'EN_PROCESO', 'FINALIZADO')),
    hash_integridad     VARCHAR(64)    NOT NULL,
    region_id           INTEGER        NOT NULL
);

CREATE INDEX idx_usuario_region    ON usuario(region_id);
CREATE INDEX idx_vehiculo_usuario  ON vehiculo(id_usuario);
CREATE INDEX idx_vehiculo_region   ON vehiculo(region_id);
CREATE INDEX idx_taller_region     ON taller(region_id);
CREATE INDEX idx_bitacora_vehiculo ON bitacora_personal(id_vehiculo);
CREATE INDEX idx_bitacora_region   ON bitacora_personal(region_id);
CREATE INDEX idx_servicio_vehiculo ON servicio_taller(id_vehiculo);
CREATE INDEX idx_servicio_taller   ON servicio_taller(id_taller);
CREATE INDEX idx_servicio_region   ON servicio_taller(region_id);