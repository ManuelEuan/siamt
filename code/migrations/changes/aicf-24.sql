--liquibase formatted sql
--changeset aicf:24
--proceso, etapa y flujo de operadores


INSERT INTO comun.tbl_cat_proceso (iidmodulo, txtnombre, txtaccion, bactivo, dtfecha_creacion, dtfecha_modificacion, vclave)
VALUES ((SELECT id FROM usuario.modulo WHERE siglas = 'op_adm'), 'Capacitación Nuevo Ingreso', null, true, now(), now(), 'OPCNI');


INSERT INTO comun.tbl_cat_etapa(iidproceso, vclave, txtnombre, txtdescripcion, txtcolor, bactivo, dtfecha_creacion, dtfecha_modificacion)
VALUES ((SELECT iid FROM comun.tbl_cat_proceso WHERE vclave = 'OPCNI'), 'admis', 'Admisión', 'Recopilar información y documentación del aspirante.', 'black', true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_proceso WHERE vclave = 'OPCNI'), 'clini', 'Clínica', 'Aplicar examenes clínicos.', 'black', true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_proceso WHERE vclave = 'OPCNI'), 'capac', 'Capacitación', 'Capacitar y evaluar al aspirante.', 'black', true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_proceso WHERE vclave = 'OPCNI'), 'cierr', 'Cierre', 'Concluir proceso de capacitación de nuevo ingreso.', 'black', true, now(), now());


INSERT INTO comun.tbl_cat_subetapa(iidetapa, vclave, txtnombre, txtdescripcion, txtcolor, txtpermiso, binicial, bfinal, bcancelacion, brequiere_motivo, bactivo, dtfecha_creacion, dtfecha_modificacion)
VALUES ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'admis'), 'adini', 'Inicial', 'Inicio de proceso de capacitación de nuevo ingreso.', null, null, true, false, false, false, true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'admis'), 'adreg', 'Captura de información', 'Datos generales, curso, experiencia.', null, null, false, false, false, false, true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'admis'), 'adval', 'Validación de requisitos', 'Verificar la autenticidad y validez de los documentos presentados por el aspirante.', null, null, false, false, false, false, true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'clini'), 'cllab', 'Examen de laboratorio', 'Aplicación de examen de laboratorio.', null, null, false, false, false, false, true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'clini'), 'clpsi', 'Evaluación psicológica', 'Evaluar los valores y actitudes del aspirante.', null, null, false, false, false, false, true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'clini'), 'clnut', 'Evaluación nutricional', 'Evaluar la salud del aspirante en términos nutricionales.', null, null, false, false, false, false, true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'clini'), 'cloft', 'Evaluación oftalmológica', 'Evaluar la capacidad visual del aspirante.', null, null, false, false, false, false, true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'capac'), 'cateo', 'Capacitación Teórica', 'Capacitar al aspirante en educación vial y trato amable', null, null, false, false, false, false, true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'capac'), 'capra', 'Capacitación Práctica', 'Capacitar  al aspirante en la conducción de unidad de transporte público en campo.', null, null, false, false, false, false, true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'capac'), 'casim', 'Capacitación en Simulador', 'Capacitar  al aspirante en la conducción de unidad de tranporte público por medio de simulador.', null, null, false, false, false, false, true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'cierr'), 'cifin', 'Cierre del proceso de capacitación', 'Finalizar proceso de capacitación de nuevo ingreso.', null, null, false, true, false, false, true, now(), now());

INSERT INTO comun.tbl_flujo(iidetapa, iidsubetapa, iidsubetapa_siguiente, bactivo, dtfecha_creacion, dtfecha_modificacion)
VALUES ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'admis'), (SELECT iid FROM comun.tbl_cat_subetapa WHERE vclave = 'adini'),(SELECT iid FROM comun.tbl_cat_subetapa WHERE vclave = 'adreg'), true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'admis'), (SELECT iid FROM comun.tbl_cat_subetapa WHERE vclave = 'adreg'),(SELECT iid FROM comun.tbl_cat_subetapa WHERE vclave = 'adval'), true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'admis'), (SELECT iid FROM comun.tbl_cat_subetapa WHERE vclave = 'adval'),(SELECT iid FROM comun.tbl_cat_subetapa WHERE vclave = 'cllab'), true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'clini'), (SELECT iid FROM comun.tbl_cat_subetapa WHERE vclave = 'cllab'),(SELECT iid FROM comun.tbl_cat_subetapa WHERE vclave = 'clpsi'), true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'clini'), (SELECT iid FROM comun.tbl_cat_subetapa WHERE vclave = 'clpsi'),(SELECT iid FROM comun.tbl_cat_subetapa WHERE vclave = 'clnut'), true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'clini'), (SELECT iid FROM comun.tbl_cat_subetapa WHERE vclave = 'clnut'),(SELECT iid FROM comun.tbl_cat_subetapa WHERE vclave = 'cloft'), true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'clini'), (SELECT iid FROM comun.tbl_cat_subetapa WHERE vclave = 'cloft'),(SELECT iid FROM comun.tbl_cat_subetapa WHERE vclave = 'cateo'), true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'capac'), (SELECT iid FROM comun.tbl_cat_subetapa WHERE vclave = 'cateo'),(SELECT iid FROM comun.tbl_cat_subetapa WHERE vclave = 'capra'), true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'capac'), (SELECT iid FROM comun.tbl_cat_subetapa WHERE vclave = 'capra'),(SELECT iid FROM comun.tbl_cat_subetapa WHERE vclave = 'casim'), true, now(), now()),
       ((SELECT iid FROM comun.tbl_cat_etapa WHERE vclave = 'capac'), (SELECT iid FROM comun.tbl_cat_subetapa WHERE vclave = 'casim'),(SELECT iid FROM comun.tbl_cat_subetapa WHERE vclave = 'cifin'), true, now(), now())