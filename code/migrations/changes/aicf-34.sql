--changeset aicf:34
--Proceso de inspeccion

DO $$
DECLARE
id_modulo integer;
    id_proceso integer;
    id_etapa_inspeccion integer;
    id_etapa_juridico integer;
    id_subetapa_actual integer;
    id_subetapa_siguiente integer;
    id_subetapa_auxiliar integer;
BEGIN


    SELECT id INTO id_modulo FROM usuario.modulo WHERE activo AND siglas = 'itr';


    --validar que no exista proceso
    IF EXISTS (SELECT iid FROM comun.tbl_cat_proceso WHERE bactivo AND vclave = 'INBOL' AND iidmodulo = id_modulo) THEN
    SELECT iid INTO id_proceso FROM comun.tbl_cat_proceso WHERE bactivo AND vclave = 'INBOL';
    DELETE FROM comun.tbl_seguimiento WHERE iidproceso = id_proceso;
    DELETE FROM comun.tbl_flujo WHERE iidetapa IN (
        SELECT iid
        FROM comun.tbl_cat_etapa
        WHERE iidproceso = id_proceso
    );
    DELETE FROM comun.tbl_cat_subetapa WHERE iidetapa IN (
        SELECT iid
        FROM comun.tbl_cat_etapa
        WHERE iidproceso = id_proceso
    );
    DELETE FROM comun.tbl_cat_etapa WHERE iidproceso = id_proceso;
    DELETE FROM comun.tbl_cat_proceso WHERE iid = id_proceso;
    END IF;


    INSERT INTO comun.tbl_cat_proceso (iidmodulo, txtnombre, txtaccion, vclave, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_modulo, 'BOLETAS DE INFRACCION', NULL, 'INBOL', TRUE, NOW(), NOW()) RETURNING iid INTO id_proceso;


    INSERT INTO comun.tbl_cat_etapa (iidproceso, txtnombre, txtdescripcion, vclave, txtcolor, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_proceso, 'INSPECCION', 'Etapa perteneciente a departamento de inspeccion', 'BINSP', 'blue', TRUE, NOW(), NOW()) RETURNING iid INTO id_etapa_inspeccion;


    --creacion de una boleta por parte del departamento de inspecciones (un inspector nombrado)
    INSERT INTO comun.tbl_cat_subetapa (iidetapa, txtnombre, txtdescripcion, vclave, txtcolor, txtpermiso, binicial, bfinal, bcancelacion, brequiere_motivo, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_inspeccion, 'ALTA', 'Subetapa perteneciente a departamento de inspeccion - alta de la boleta', 'BIALT', 'blue', NULL, TRUE, FALSE, FALSE, TRUE, TRUE, NOW(), NOW()) RETURNING iid INTO id_subetapa_actual;


    --se valida si se aprueba, cancela o requiere ser modificada una boleta
    INSERT INTO comun.tbl_cat_subetapa (iidetapa, txtnombre, txtdescripcion, vclave, txtcolor, txtpermiso, binicial, bfinal, bcancelacion, brequiere_motivo, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_inspeccion, 'VALIDACION', 'Subetapa perteneciente a departamento de inspeccion - validacion de la boleta', 'BIVAL', 'blue', NULL, FALSE, FALSE, FALSE, TRUE, TRUE, NOW(), NOW()) RETURNING iid INTO id_subetapa_siguiente;


    INSERT INTO comun.tbl_flujo (iidetapa, iidsubetapa, iidsubetapa_siguiente, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_inspeccion, id_subetapa_actual, id_subetapa_siguiente, TRUE, NOW(), NOW());


    id_subetapa_actual := id_subetapa_siguiente;


        --se modifica la boleta para afinar detalles
    INSERT INTO comun.tbl_cat_subetapa (iidetapa, txtnombre, txtdescripcion, vclave, txtcolor, txtpermiso, binicial, bfinal, bcancelacion, brequiere_motivo, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_inspeccion, 'MODIFICACION', 'Subetapa perteneciente a departamento de inspeccion - modificacion de la boleta', 'BIMOD', 'blue', NULL, FALSE, FALSE, FALSE, TRUE, TRUE, NOW(), NOW()) RETURNING iid INTO id_subetapa_siguiente;


    INSERT INTO comun.tbl_flujo (iidetapa, iidsubetapa, iidsubetapa_siguiente, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_inspeccion, id_subetapa_actual, id_subetapa_siguiente, TRUE, NOW(), NOW());


    id_subetapa_auxiliar := id_subetapa_siguiente;


        --se aprueba la boleta ya sea desde que se valido o se modifico algun detalle
    INSERT INTO comun.tbl_cat_subetapa (iidetapa, txtnombre, txtdescripcion, vclave, txtcolor, txtpermiso, binicial, bfinal, bcancelacion, brequiere_motivo, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_inspeccion, 'APROBADA', 'Subetapa perteneciente a departamento de inspeccion - aprobacion de la boleta', 'BIAPR', 'blue', NULL, FALSE, FALSE, FALSE, TRUE, TRUE, NOW(), NOW()) RETURNING iid INTO id_subetapa_siguiente;


    INSERT INTO comun.tbl_flujo (iidetapa, iidsubetapa, iidsubetapa_siguiente, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_inspeccion, id_subetapa_actual, id_subetapa_siguiente, TRUE, NOW(), NOW());


    INSERT INTO comun.tbl_flujo (iidetapa, iidsubetapa, iidsubetapa_siguiente, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_inspeccion, id_subetapa_auxiliar, id_subetapa_siguiente, TRUE, NOW(), NOW());


    id_subetapa_actual := id_subetapa_siguiente;


        --se entrega la boleta y se recibe un acuse de entrega
    INSERT INTO comun.tbl_cat_subetapa (iidetapa, txtnombre, txtdescripcion, vclave, txtcolor, txtpermiso, binicial, bfinal, bcancelacion, brequiere_motivo, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_inspeccion, 'ENTREGADA', 'Subetapa perteneciente a departamento de inspeccion - entrega de la boleta a departamento juridico', 'BIENT', 'blue', NULL, FALSE, FALSE, FALSE, TRUE, TRUE, NOW(), NOW()) RETURNING iid INTO id_subetapa_siguiente;


    INSERT INTO comun.tbl_flujo (iidetapa, iidsubetapa, iidsubetapa_siguiente, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_inspeccion, id_subetapa_actual, id_subetapa_siguiente, TRUE, NOW(), NOW());


    id_subetapa_actual := id_subetapa_siguiente;


    INSERT INTO comun.tbl_cat_etapa (iidproceso, txtnombre, txtdescripcion, vclave, txtcolor, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_proceso, 'JURIDICO', 'Etapa perteneciente a departamento de juridico', 'BJUCO', 'green', TRUE, NOW(), NOW()) RETURNING iid INTO id_etapa_juridico;


    --entregan un acuse de entregado y reciben las boletas
    INSERT INTO comun.tbl_cat_subetapa (iidetapa, txtnombre, txtdescripcion, vclave, txtcolor, txtpermiso, binicial, bfinal, bcancelacion, brequiere_motivo, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, 'RECEPCION', 'Subetapa perteneciente a departamento de juridico - recepcion de la boleta de departamento inspeccion', 'BJREC', 'green', NULL, FALSE, FALSE, FALSE, TRUE, TRUE, NOW(), NOW()) RETURNING iid INTO id_subetapa_siguiente;


    INSERT INTO comun.tbl_flujo (iidetapa, iidsubetapa, iidsubetapa_siguiente, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, id_subetapa_actual, id_subetapa_siguiente, TRUE, NOW(), NOW());


    id_subetapa_actual := id_subetapa_siguiente;


        --el presunto infractor no comparencio en la fecha que debia, se debe calcular fecha, se procede al pago, se crea acuerdo de comparecencia
    INSERT INTO comun.tbl_cat_subetapa (iidetapa, txtnombre, txtdescripcion, vclave, txtcolor, txtpermiso, binicial, bfinal, bcancelacion, brequiere_motivo, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, 'NO COMPARECIO', 'Subetapa perteneciente a departamento de juridico - no hay comparecencia de la boleta', 'BJNCM', 'red', NULL, FALSE, FALSE, FALSE, TRUE, TRUE, NOW(), NOW()) RETURNING iid INTO id_subetapa_siguiente;


    INSERT INTO comun.tbl_flujo (iidetapa, iidsubetapa, iidsubetapa_siguiente, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, id_subetapa_actual, id_subetapa_siguiente, TRUE, NOW(), NOW());


    id_subetapa_auxiliar := id_subetapa_siguiente;


        --el presunto infractor comparecio, se crea acuerdo de comparecencia
    INSERT INTO comun.tbl_cat_subetapa (iidetapa, txtnombre, txtdescripcion, vclave, txtcolor, txtpermiso, binicial, bfinal, bcancelacion, brequiere_motivo, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, 'COMPARECIO', 'Subetapa perteneciente a departamento de juridico - comparecencia de la boleta', 'BJCOM', 'green', NULL, FALSE, FALSE, FALSE, TRUE, TRUE, NOW(), NOW()) RETURNING iid INTO id_subetapa_siguiente;


    INSERT INTO comun.tbl_flujo (iidetapa, iidsubetapa, iidsubetapa_siguiente, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, id_subetapa_actual, id_subetapa_siguiente, TRUE, NOW(), NOW());


    id_subetapa_actual := id_subetapa_siguiente;


        --se determina si procede o no la boleta
    INSERT INTO comun.tbl_cat_subetapa (iidetapa, txtnombre, txtdescripcion, vclave, txtcolor, txtpermiso, binicial, bfinal, bcancelacion, brequiere_motivo, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, 'RESOLUCION', 'Subetapa perteneciente a departamento de juridico - resolucion de la boleta', 'BJRES', 'green', NULL, FALSE, FALSE, FALSE, TRUE, TRUE, NOW(), NOW()) RETURNING iid INTO id_subetapa_siguiente;


    INSERT INTO comun.tbl_flujo (iidetapa, iidsubetapa, iidsubetapa_siguiente, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, id_subetapa_auxiliar, id_subetapa_siguiente, TRUE, NOW(), NOW());


    INSERT INTO comun.tbl_flujo (iidetapa, iidsubetapa, iidsubetapa_siguiente, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, id_subetapa_actual, id_subetapa_siguiente, TRUE, NOW(), NOW());


    id_subetapa_actual := id_subetapa_siguiente;


        --por pruebas se determina que no procede la boleta
    INSERT INTO comun.tbl_cat_subetapa (iidetapa, txtnombre, txtdescripcion, vclave, txtcolor, txtpermiso, binicial, bfinal, bcancelacion, brequiere_motivo, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, 'NO PROCEDE PAGO', 'Subetapa perteneciente a departamento de juridico - no procede pago de la boleta', 'BJNPP', 'red', NULL, FALSE, FALSE, FALSE, TRUE, TRUE, NOW(), NOW()) RETURNING iid INTO id_subetapa_siguiente;


    INSERT INTO comun.tbl_flujo (iidetapa, iidsubetapa, iidsubetapa_siguiente, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, id_subetapa_actual, id_subetapa_siguiente, TRUE, NOW(), NOW());


    id_subetapa_auxiliar := id_subetapa_siguiente;


        --ya sea por que no comparecio o porque no aporto pruebas de peso, o acepto la culpa se procede al pago
    INSERT INTO comun.tbl_cat_subetapa (iidetapa, txtnombre, txtdescripcion, vclave, txtcolor, txtpermiso, binicial, bfinal, bcancelacion, brequiere_motivo, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, 'PROCEDE PAGO', 'Subetapa perteneciente a departamento de juridico - procede pago de la boleta', 'BJPRP', 'green', NULL, FALSE, FALSE, FALSE, TRUE, TRUE, NOW(), NOW()) RETURNING iid INTO id_subetapa_siguiente;


    INSERT INTO comun.tbl_flujo (iidetapa, iidsubetapa, iidsubetapa_siguiente, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, id_subetapa_actual, id_subetapa_siguiente, TRUE, NOW(), NOW());


    id_subetapa_actual := id_subetapa_siguiente;


        --se califica infraccion por infraccion para determinar la orden de pago
    INSERT INTO comun.tbl_cat_subetapa (iidetapa, txtnombre, txtdescripcion, vclave, txtcolor, txtpermiso, binicial, bfinal, bcancelacion, brequiere_motivo, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, 'CALIFICACION', 'Subetapa perteneciente a departamento de juridico - calificacion de la boleta', 'BJCAL', 'green', NULL, FALSE, FALSE, FALSE, TRUE, TRUE, NOW(), NOW()) RETURNING iid INTO id_subetapa_siguiente;


    INSERT INTO comun.tbl_flujo (iidetapa, iidsubetapa, iidsubetapa_siguiente, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, id_subetapa_actual, id_subetapa_siguiente, TRUE, NOW(), NOW());


    id_subetapa_actual := id_subetapa_siguiente;


        --se crea la orden de pago, con el monto calificado
    INSERT INTO comun.tbl_cat_subetapa (iidetapa, txtnombre, txtdescripcion, vclave, txtcolor, txtpermiso, binicial, bfinal, bcancelacion, brequiere_motivo, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, 'ORDEN PAGO', 'Subetapa perteneciente a departamento de juridico - orden de pago de la boleta', 'BJODP', 'green', NULL, FALSE, FALSE, FALSE, TRUE, TRUE, NOW(), NOW()) RETURNING iid INTO id_subetapa_siguiente;


    INSERT INTO comun.tbl_flujo (iidetapa, iidsubetapa, iidsubetapa_siguiente, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, id_subetapa_actual, id_subetapa_siguiente, TRUE, NOW(), NOW());


    id_subetapa_actual := id_subetapa_siguiente;


        --se crea la cedula de notificacion y se notifica al infractor
    INSERT INTO comun.tbl_cat_subetapa (iidetapa, txtnombre, txtdescripcion, vclave, txtcolor, txtpermiso, binicial, bfinal, bcancelacion, brequiere_motivo, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, 'CEDULA NOTIFICACION', 'Subetapa perteneciente a departamento de juridico - cedula de notificacion de la boleta', 'BJCDN', 'green', NULL, FALSE, FALSE, FALSE, TRUE, TRUE, NOW(), NOW()) RETURNING iid INTO id_subetapa_siguiente;


    INSERT INTO comun.tbl_flujo (iidetapa, iidsubetapa, iidsubetapa_siguiente, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, id_subetapa_actual, id_subetapa_siguiente, TRUE, NOW(), NOW());


    INSERT INTO comun.tbl_flujo (iidetapa, iidsubetapa, iidsubetapa_siguiente, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, id_subetapa_auxiliar, id_subetapa_siguiente, TRUE, NOW(), NOW());


    id_subetapa_actual := id_subetapa_siguiente;


        --posterior ha cierto tiempo sin haber pagado, para notificaciones invitando a pagar
    INSERT INTO comun.tbl_cat_subetapa (iidetapa, txtnombre, txtdescripcion, vclave, txtcolor, txtpermiso, binicial, bfinal, bcancelacion, brequiere_motivo, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, 'NO PAGADO', 'Subetapa perteneciente a departamento de juridico - no se ha pagodo la boleta', 'BJNHP', 'red', NULL, FALSE, FALSE, FALSE, TRUE, TRUE, NOW(), NOW()) RETURNING iid INTO id_subetapa_siguiente;


    INSERT INTO comun.tbl_flujo (iidetapa, iidsubetapa, iidsubetapa_siguiente, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, id_subetapa_actual, id_subetapa_siguiente, TRUE, NOW(), NOW());


    id_subetapa_auxiliar := id_subetapa_siguiente;


        --ya sea por el proceso o por notificaciones el infractor paga
    INSERT INTO comun.tbl_cat_subetapa (iidetapa, txtnombre, txtdescripcion, vclave, txtcolor, txtpermiso, binicial, bfinal, bcancelacion, brequiere_motivo, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, 'PAGADO', 'Subetapa perteneciente a departamento de juridico - se ha pagodo la boleta', 'BJHPD', 'green', NULL, FALSE, FALSE, FALSE, TRUE, TRUE, NOW(), NOW()) RETURNING iid INTO id_subetapa_siguiente;


    INSERT INTO comun.tbl_flujo (iidetapa, iidsubetapa, iidsubetapa_siguiente, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, id_subetapa_actual, id_subetapa_siguiente, TRUE, NOW(), NOW());


    INSERT INTO comun.tbl_flujo (iidetapa, iidsubetapa, iidsubetapa_siguiente, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, id_subetapa_auxiliar, id_subetapa_siguiente, TRUE, NOW(), NOW());


    id_subetapa_actual := id_subetapa_siguiente;


        --una vez realizado el pago si el vehiculo esta en el corralon se genera una carta para liberacion de la unidad
    INSERT INTO comun.tbl_cat_subetapa (iidetapa, txtnombre, txtdescripcion, vclave, txtcolor, txtpermiso, binicial, bfinal, bcancelacion, brequiere_motivo, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, 'LIBERACION UNIDAD', 'Subetapa perteneciente a departamento de juridico - liberacion de la unidad', 'BJLDU', 'green', NULL, FALSE, FALSE, FALSE, TRUE, TRUE, NOW(), NOW()) RETURNING iid INTO id_subetapa_siguiente;


    INSERT INTO comun.tbl_flujo (iidetapa, iidsubetapa, iidsubetapa_siguiente, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, id_subetapa_actual, id_subetapa_siguiente, TRUE, NOW(), NOW());


    id_subetapa_auxiliar := id_subetapa_siguiente;

        --una vez que se pago se genera una conclusion del proceso como acuse de pago ante la agencia, se menciona la liberacion de unidad si es que existio retencion
    INSERT INTO comun.tbl_cat_subetapa (iidetapa, txtnombre, txtdescripcion, vclave, txtcolor, txtpermiso, binicial, bfinal, bcancelacion, brequiere_motivo, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, 'CONCLUSION', 'Subetapa perteneciente a departamento de juridico - conclusion de la boleta', 'BJCSN', 'green', NULL, FALSE, TRUE, FALSE, TRUE, TRUE, NOW(), NOW()) RETURNING iid INTO id_subetapa_siguiente;


    INSERT INTO comun.tbl_flujo (iidetapa, iidsubetapa, iidsubetapa_siguiente, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, id_subetapa_actual, id_subetapa_siguiente, TRUE, NOW(), NOW());


    INSERT INTO comun.tbl_flujo (iidetapa, iidsubetapa, iidsubetapa_siguiente, bactivo, dtfecha_creacion, dtfecha_modificacion)
    VALUES (id_etapa_juridico, id_subetapa_auxiliar, id_subetapa_siguiente, TRUE, NOW(), NOW());


END $$;



