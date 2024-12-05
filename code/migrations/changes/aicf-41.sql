--liquibase formatted sql
--changeset aicf:41

INSERT INTO comun.tbl_cat_proceso (iidmodulo, txtnombre, txtaccion, bactivo, dtfecha_creacion, dtfecha_modificacion, vclave)
VALUES ((SELECT id FROM usuario.modulo WHERE siglas = 'mto_pre'), 'Mantenimientos Preventivos', null, true, now(), now(), 'MTOPR'),
       ((SELECT id FROM usuario.modulo WHERE siglas = 'mto_cor'), 'Mantenimientos Correctivos', null, true, now(), now(), 'MTOCO');


INSERT INTO comun.tbl_cat_etapa(iidproceso, vclave, txtnombre, txtdescripcion, txtcolor, bactivo, dtfecha_creacion, dtfecha_modificacion)
VALUES ((SELECT iid FROM comun.tbl_cat_proceso WHERE vclave = 'MTOPR'), 'mtopr', 'Mantenimiento preventivo', 'Proceso de los mantenimientos preventivos', 'black', true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_proceso WHERE vclave = 'MTOCO'), 'mtoco', 'Mantenimiento correctivo', 'Proceso de los mantenimientos correctivos', 'black', true, now(), now());

INSERT INTO comun.tbl_cat_subetapa(iidetapa, vclave, txtnombre, txtdescripcion, txtcolor, txtpermiso, binicial, bfinal, bcancelacion, brequiere_motivo, bactivo, dtfecha_creacion, dtfecha_modificacion)
VALUES ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'mtopr'), 'pendi', 'Pendiente de Programar', 'Estatus pendiente de programar', null, null, true, false, false, false, true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'mtopr'), 'progr', 'Programada', 'Estatus programada', null, null, true, false, false, false, true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'mtopr'), 'pcanc', 'Cancelada', 'Estatus cancelada', null, null, true, false, false, false, true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'mtopr'), 'retra', 'Retrasada', 'Estatus retrasada', null, null, true, false, false, false, true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'mtopr'), 'repro', 'Reprogramada', 'Estatus reprogramada', null, null, true, false, false, false, true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'mtopr'), 'bproc', 'En Proceso', 'Estatus en proceso', null, null, true, false, false, false, true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'mtopr'), 'pparc', 'Parcialmente Realizada', 'Estatus parcialmente realizada', null, null, true, false, false, false, true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'mtopr'), 'pcomp', 'Completada', 'Estatus completada', null, null, true, false, false, false, true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'mtoco'), 'cproc', 'En Proceso', 'Estatus en proceso', null, null, true, false, false, false, true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'mtoco'), 'ccanc', 'Cancelada', 'Estatus cancelada', null, null, true, false, false, false, true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'mtoco'), 'cparc', 'Parcialmente Realizada', 'Estatus parcialmente realizada', null, null, true, false, false, false, true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'mtoco'), 'ccomp', 'Completada', 'Estatus completada', null, null, true, false, false, false, true, now(), now());
