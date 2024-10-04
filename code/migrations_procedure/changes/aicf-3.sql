--liquibase formatted sql
--changeset aicf:3
--Creación del trámite de inspeccion y derechos


INSERT INTO comun.tbl_cat_tramite (vclave, txtnombre, txtdescripcion)
SELECT 'BOLINSP', 'Trámite para Boletas de Inspección', 'Trámite para Boletas de Inspección'
    WHERE NOT EXISTS (
    SELECT 1 FROM comun.tbl_cat_tramite WHERE bactivo AND vclave = 'BOLINSP'
);

WITH insert_data AS (
INSERT INTO comun.tbl_cat_derecho (vclave, txtnombre, txtdescripcion, txtcuenta_contable, numa_minimo, numa_maximo)
VALUES
    ('ATYDGTDP01', 'ARTICULO 208 FRACCIÓN I (LATY)', 'Iniciar su jornada activa en servicio sin escanear el código que permita visualizar el servicio en la aplicación tecnológica que señale la agencia para tal efecto en la autorización del servicio de transporte respectiva o, en su caso, en los lineamientos que emita en la materia', '', 25, 100),
    ('ATYDGTDP02', 'ARTICULO 208 FRACCIÓN II (LATY)', 'Negar la prestación del servicio a las personas usuarias en los paraderos o paradas previamente autorizadas por la agencia, sin causa justificada', '', 25, 100),
    ('ATYDGTDP03', 'ARTICULO 208 FRACCIÓN III (LATY)', 'Insultar o discriminar a las personas pasajeras, conforme a lo previsto en la Constitución Política del Estado de Yucatán y la Ley para Prevenir y Eliminar la Discriminación en el Estado de Yucatán', '', 25, 100),
    ('ATYDGTDP04', 'ARTICULO 208 FRACCIÓN IV (LATY)', 'Prestar el servicio fuera de la ruta o derrotero autorizado por la agencia', '', 25, 100),
    ('ATYDGTDP05', 'ARTICULO 208 FRACCIÓN V (LATY)', 'Modificar o alterar rutas, derroteros, frecuencias, horarios o condiciones para la prestación del servicio en el caso del servicio de transporte público de personas pasajeras, sin autorización de la agencia', '', 25, 100),
    ('ATYDGTDP06', 'ARTICULO 208 FRACCIÓN VI (LATY)', 'No cumplir con el Programa de Operación correspondiente.', '', 25, 100),
    ('ATYDGTDP07', 'ARTICULO 208 FRACCIÓN VII (LATY)', 'No acatar las disposiciones generales establecidas para las personas operadoras', '', 25, 100),
    ('ATYDGTDP08', 'ARTICULO 208 FRACCIÓN VIII (LATY)', 'Carecer de uniforme', '', 25, 100),
    ('ATYDGTDP09', 'ARTICULO 208 FRACCIÓN IX (LATY)', 'No conservar los vehículos en buen estado, conforme a lo previsto en la autorización del servicio de transporte respectiva y en los lineamientos que emita la agencia', '', 25, 100),
    ('ATYDGTDP10', 'ARTICULO 208 FRACCIÓN X (LATY)', 'Prestar el servicio con exceso de personas pasajeras, conforme lo determinen la autorización de transporte correspondiente y las disposiciones que emita la agencia', '', 25, 100),
    ('ATYDGTDP11', 'ARTICULO 208 FRACCIÓN XI (LATY)', 'Conducir los vehículos sin la licencia correspondiente expedida por la autoridad competente, sin la tarjeta de circulación de los vehículos, sin el tarjetón único de persona operadora, o en su caso, cuando alguna de estas se encuentre vencida', '', 25, 100),
    ('ATYDGTDP12', 'ARTICULO 208 FRACCIÓN XII (LATY)', 'Realizar maniobras de ascenso y descenso de personas pasajeras en lugares inseguros y no destinados para tales fines', '', 25, 100),
    ('ATYDGTDP13', 'ARTICULO 208 FRACCIÓN XIII (LATY)', 'Permitir que una persona distinta a él y que no esté autorizada por la agencia conduzca el vehículo que tiene asignado para la prestación del servicio de transporte', '', 25, 100),
    ('ATYDGTDP14', 'ARTICULO 208 FRACCIÓN XIV (LATY)', 'Realizar actividades de recarga de combustible diésel durante la prestación del servicio de transporte', '', 25, 100),
    ('ATYDGTDP15', 'ARTICULO 208 FRACCIÓN XV (LATY)', 'Permitir que aborden a los vehículos personas vendedoras, de entretenimiento, o diversas personas que busquen obtener un lucro al interior de los vehículos, salvo los casos de excepción que determine la agencia, mediante disposiciones de carácter general', '', 25, 100),
    ('ATYDGTDP16', 'ARTICULO 209 FRACCIÓN I (LATY)', 'Realizar el cobro de la tarifa por alguna modalidad distinta a la autorizada por la agencia, incluido el pago en efectivo cuando la forma de pago sea electrónica', '', 100, 500),
    ('ATYDGTDP17', 'ARTICULO 209 FRACCIÓN II (LATY)', 'Exentar el pago de la tarifa a las personas usuarias', '', 100, 500),
    ('ATYDGTDP18', 'ARTICULO 209 FRACCIÓN III (LATY)', 'Conducir a exceso de velocidad, conforme a la Ley de Tránsito y Vialidad del Estado de Yucatán y su reglamento', '', 100, 500),
    ('ATYDGTDP19', 'ARTICULO 209 FRACCIÓN IV (LATY)', 'Negar o discriminar a las personas usuarias del servicio conforme a lo previsto en el artículo 1 de la Constitución Política de los Estados Unidos Mexicanos', '', 100, 500),
    ('ATYDGTDP20', 'ARTICULO 209 FRACCIÓN V (LATY)', 'Prestar el servicio bajo la influencia del alcohol o sustancias psicotrópicas, estupefacientes o que produzcan efectos similares.', '', 100, 500),
    ('ATYDGTDP21', 'ARTICULO 209 FRACCIÓN VI (LATY)', 'Dañar o alterar el Sistema de Control de Personas Pasajeras de los vehículos que le correspondan, en el caso de transporte público de personas pasajeras', '', 100, 500),
    ('ATYDGTDP22', 'ARTICULO 209 FRACCIÓN VII (LATY)', 'Ausentarse o abandonar el vehículo con el que presta el servicio cuando haya ocurrido un accidente', '', 100, 500),
    ('ATYDGTDP23', 'ARTICULO 209 FRACCIÓN VIII (LATY)', 'Realizar, por parte de las personas operadoras del servicio de transporte contratado a través de plataformas tecnológicas, oferta directa en la vía pública del servicio que prestan o base, sitio o similares', '', 100, 500),
    ('ATYDGTDP24', 'ARTICULO 209 FRACCIÓN IX (LATY)', 'Prestar el servicio de transporte a través de medios alternativos o el servicio contratado a través de plataformas tecnológicas en un vehículo no amparado por un certificado vehicular', '', 100, 500),
    ('ATYDGTDP25', 'ARTICULO 209 FRACCIÓN X (LATY)', 'Prestar el servicio de transporte a través de medios alternativos o el servicio contratado a través de plataformas tecnológicas sin los certificados correspondientes o cuando estos no se encuentren vigentes', '', 100, 500),
    ('ATYDGTDP26', 'ARTICULO 209 FRACCIÓN XI (LATY)', 'Obstaculizar las facultades de inspección y verificación de la agencia, sus personas inspectoras de transporte o su centro de monitoreo', '', 100, 500),
    ('ATYDGTDP27', 'ARTICULO 209 FRACCIÓN XII (LATY)', 'Carecer de póliza de seguro vigente', '', 100, 500),
    ('ATYDGTDP28', 'ARTICULO 209 FRACCIÓN XIII (LATY)', 'Por reincidir, dentro del periodo de un año a partir de la comisión de la primera infracción, en cualquiera de las infracciones no graves previstas en el artículo anterior', '', 100, 500),
    ('ATYDGTDP29', 'ARTICULO 212 FRACCIÓN I (LATY)', 'Por prestar el servicio fuera del territorio de operación señalado en la concesión, permiso o constancia, según corresponda, excepto cuando la agencia lo autorice previamente', '', 50, 100),
    ('ATYDGTDP30', 'ARTICULO 212 FRACCIÓN II (LATY)', 'No llevar los vehículos a sus revisiones correspondientes, en términos de lo previsto en esta ley', '', 50, 100),
    ('ATYDGTDP31', 'ARTICULO 212 FRACCIÓN III (LATY)', 'Incumplir con los requisitos previstos en esta ley y en los lineamientos que en la materia emita la agencia, en las visitas de inspección y verificación que realice la agencia', '', 50, 100),
    ('ATYDGTDP32', 'ARTICULO 212 FRACCIÓN IV (LATY)', 'No utilizar o alterar la imagen institucional del servicio de transporte correspondiente', '', 50, 100),
    ('ATYDGTDP33', 'ARTICULO 212 FRACCIÓN V (LATY)', 'Prestar el servicio con personas operadoras distintas a las autorizadas por la agencia', '', 50, 100),
    ('ATYDGTDP34', 'ARTICULO 212 FRACCIÓN VI (LATY)', 'No asumir la responsabilidad solidaria de las personas operadoras contratadas para la prestación del servicio de transporte, respecto a las infracciones en que incurran durante la prestación del servicio de transporte para el que estén autorizadas, siempre que sean imputables a ellos y no a las personas usuarias, por causas fortuitas o por causas imputables a terceros', '', 50, 100),
    ('ATYDGTDP35', 'ARTICULO 212 FRACCIÓN VII (LATY)', 'Ausentarse, sin autorización de la agencia y de las autoridades de tránsito y seguridad vial competentes, cuando acontezca un accidente donde se vea involucrado un vehículo con el que presta el servicio de transporte, para evitar la problemática ocasionada', '', 50, 100),
    ('ATYDGTDP36', 'ARTICULO 212 FRACCIÓN VIII (LATY)', 'No dar el mantenimiento preventivo a los vehículos con las que presta el servicio de transporte, conforme a lo previsto en esta ley y a los lineamientos que emita la agencia', '', 50, 100),
    ('ATYDGTDP37', 'ARTICULO 212 FRACCIÓN IX (LATY)', 'No brindar la capacitación correspondiente a las personas operadoras contratadas para prestar el servicio de transporte, en términos de lo establecido por la agencia en la autorización de transporte respectiva, en esta ley y en los lineamientos que al efecto emita', '', 50, 100),
    ('ATYDGTDP38', 'ARTICULO 212 FRACCIÓN X (LATY)', 'Prestar el servicio de transporte en contravención con la legislación y la normativa aplicable, la propia autorización del servicio de transporte correspondiente o sus anexos, siempre que la conducta no haya sido clasificada como infracción grave', '', 50, 100),
    ('ATYDGTDP39', 'ARTICULO 212 FRACCIÓN XI (LATY)', 'Omitir diariamente crear, planear, cargar y asignar el orden del día, incluidos el establecimiento de los vehículos y personas operadoras asignadas a las rutas, horarios y derroteros establecidos en la autorización de transporte para la adecuada programación del servicio de transporte público de personas pasajeras, conforme a lo previsto en esta ley y en los lineamientos que al efecto emita la agencia', '', 50, 100),
    ('ATYDGTDP40', 'ARTICULO 213 FRACCIÓN I (LATY)', 'Proporcionar un servicio de transporte en el estado sin contar con la autorización del servicio de transporte correspondiente, según sea el caso', '', 100, 500),
    ('ATYDGTDP41', 'ARTICULO 213 FRACCIÓN II (LATY)', 'Proporcionar un servicio de transporte en el estado sin contar con permisos especiales derivado del uso de vehículos procedentes de otras entidades federativas', '', 100, 500),
    ('ATYDGTDP42', 'ARTICULO 213 FRACCIÓN III (LATY)', 'Prestar algún servicio de transporte sin contar con las placas expedidas por la Secretaría de Seguridad Pública del estado', '', 100, 500),
    ('ATYDGTDP43', 'ARTICULO 213 FRACCIÓN IV (LATY)', 'Permitir por parte de las empresas de redes de transporte el uso de sus plataformas tecnológicas a personas que no cuenten con el certificado vehicular o con el certificado de persona operadora titular o adhesivo', '', 100, 500),
    ('ATYDGTDP44', 'ARTICULO 213 FRACCIÓN V (LATY)', 'No contar con las terminales, excepto cuando cuenten con autorización para el uso de sitios', '', 100, 500),
    ('ATYDGTDP45', 'ARTICULO 213 FRACCIÓN VI (LATY)', 'No prestar el servicio en forma gratuita en casos de emergencia, desastre o problema grave, a requerimiento de la agencia, en cumplimiento de un acuerdo de la autoridad competente en materia de protección civil', '', 100, 500),
    ('ATYDGTDP46', 'ARTICULO 213 FRACCIÓN VII (LATY)', 'No proporcionar mensualmente, por parte de las empresas de redes de transporte, el registro de personas operadoras y de vehículos inscritos en sus bases de datos, así como cualquier otra información disponible relacionada con la prestación de sus servicios que le solicite la agencia', '', 100, 500),
    ('ATYDGTDP47', 'ARTICULO 213 FRACCIÓN VIII (LATY)', 'Presentar documentación falsa o declarar falsamente, por parte de las empresas de redes de transporte, para actualizar el registro de personas operadoras y de vehículos inscritos en sus bases de datos, así como cualquier otra información disponible relacionada con la prestación de sus servicios que le solicite la agencia', '', 100, 500),
    ('ATYDGTDP48', 'ARTICULO 213 FRACCIÓN IX (LATY)', 'Dejar de prestar el servicio de transporte sin informar, en los plazos establecidos en esta ley, a la agencia', '', 100, 500),
    ('ATYDGTDP49', 'ARTICULO 213 FRACCIÓN X (LATY)', 'No contar con los seguros y cobertura correspondientes, en términos de la presente Ley, la Ley de Movilidad y demás normativa aplicable', '', 100, 500),
    ('ATYDGTDP50', 'ARTICULO 213 FRACCIÓN XI (LATY)', 'Obstaculizar las facultades de inspección y verificación de la agencia y las personas inspectoras de transporte', '', 100, 500),
    ('ATYDGTDP51', 'ARTICULO 213 FRACCIÓN XII (LATY)', 'No registrar, durante la prestación del servicio, el pago electrónico de la tarifa por el porcentaje que determine la agencia sobre el total del aforo, de acuerdo con la información registrada por el Centro de Control y Monitoreo, a través del sistema de control de personas pasajeras y del sistema de recaudo de tarifa, por causas imputables a las personas concesionarias del servicio de transporte público de personas pasajeras', '', 100, 500),
    ('ATYDGTDP52', 'ARTICULO 213 FRACCIÓN XIII (LATY)', 'Prestar el servicio con vehículos que no cumplan con las características físico mecánicas aprobadas por la agencia en la autorización del servicio de transporte respectiva, que pueda poner en peligro a las personas usuarias', '', 100, 500),
    ('ATYDGTDP53', 'ARTICULO 213 FRACCIÓN XIV (LATY)', 'En caso del servicio de medios alternativos de transporte, brindar el servicio en carreteras estatales o federales, en el periférico de la ciudad de Mérida, así como en avenidas primarias o en aquellas donde exista alguna ruta de transporte de personas pasajeras pública de tipo autobús, o en las intersecciones con carreteras y autopistas de jurisdicción federal, en este último caso, sin guardar la distancia que establezcan las disposiciones aplicables a la regulación de la vialidad, o en lugares distintos a los autorizados', '', 100, 500),
    ('ATYDGTDP54', 'ARTICULO 213 FRACCIÓN XV (LATY)', 'Por reincidir, dentro del periodo de un año a partir de la comisión de la primera infracción, en cualquiera de las infracciones no graves previstas en el artículo anterior', '', 100, 500),
    ('ATYDGTDP55', 'ARTICULO 213 FRACCIÓN XVI (LATY)', 'Omitir notificar o dar aviso en el término establecido por la agencia en los lineamientos que al efecto emita, de las fallas técnicas que presenten los validadores y dispositivos electrónicos y tecnológicos necesarios que permitan la operación de los sistemas informáticos para el transporte público de personas pasajeras', '', 100, 500),
    ('ATYDGTDP56', 'ARTICULO 198 (LATY)', 'La agencia, bajo su más estricta responsabilidad, ordenará fundada y  motivadamente la aplicación de las medidas de seguridad idóneas cuando estime que el servicio de transporte de personas pasajeras se encuentra en riesgo o podría poner en riesgo la seguridad de las personas usuarias o la sociedad en general.', '', 25, 100),
    ('ATYDGTDP57', 'ARTICULO 139 (LATY)', 'Las personas que presten el servicio de transporte público de personas pasajeras deberán contar con una concesión vigente expedida por la agencia.', '', 100, 500)
    RETURNING iid
    )

INSERT INTO comun.tbl_cat_tramite_derecho (iidderecho, iidtramite)
SELECT iid, (SELECT iid FROM comun.tbl_cat_tramite WHERE bactivo AND vclave = 'BOLINSP') FROM insert_data;

