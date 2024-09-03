--liquibase formatted sql
--changeset vbbm:6
--Insertar nuevo perfil INSPECTOR_APP

INSERT INTO usuario.perfil (nombre, descripcion) 
VALUES('INSPECTOR_APP', 'Perfíl para visualizar los módulos relacionados a brindar información a inspectores');


                