-- SELECT pg_terminate_backend(pg_stat_activity.pid)
-- FROM pg_stat_activity
-- WHERE pg_stat_activity.datname = 'siamt' AND pid <> pg_backend_pid();

-- DROP DATABASE IF EXISTS SIAMT;
-- CREATE DATABASE SIAMT;

CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS postgis;
DROP SCHEMA IF EXISTS "usuario" CASCADE;
DROP SCHEMA IF EXISTS "territorio" CASCADE;
DROP SCHEMA IF EXISTS  "comun" CASCADE;
DROP SCHEMA IF EXISTS "persona" CASCADE;
DROP SCHEMA IF EXISTS "inspeccion" CASCADE;
CREATE SCHEMA "usuario";
CREATE SCHEMA "territorio";
CREATE SCHEMA "comun";
CREATE SCHEMA "persona";
CREATE SCHEMA "inspeccion";