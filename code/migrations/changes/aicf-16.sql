--liquibase formatted sql
--changeset aicf:16
-- Extension dblink

CREATE EXTENSION IF NOT EXISTS dblink;