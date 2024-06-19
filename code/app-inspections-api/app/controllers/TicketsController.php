<?php

namespace App\Controllers;

use Phalcon\Registry;
use App\Library\Http\Controllers\BaseController;
use App\Library\Db\Db;
use App\Library\Http\Exceptions\HttpUnauthorizedException;
use App\Library\Http\Exceptions\ValidatorBoomException;
// use PhpOffice\PhpSpreadsheet\Spreadsheet;
// use PhpOffice\PhpSpreadsheet\Writer\Xlsx;
// use PhpOffice\PhpWord\IOFactory;
use Fpdf\Fpdf;


//Librerías requeridas
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;
use PhpOffice\PhpSpreadsheet\IOFactory;

class TicketsController extends BaseController
{

    // private function hasClientAuthorized($permission)
    // {

    //     $permissions = $this->token->getPermissions()['iin']; // Obtener permisos del token de usuario
    //     if (!in_array($permission, $permissions)) { // Comprobar si el permiso está presente en los permisos del usuario
    //         if ($permission === 'veii' && in_array('edii', $permissions)) return; // Permitir acceso si es edpe pero no vepe
    //         throw new HttpUnauthorizedException(401, 'Permisos insuficientes.'); // Excepción de no autorizado si no se tienen los permisos necesarios
    //     }
    // }

    // Método para depurar y mostrar datos
    public function dep($data)
    {
        $format  = print_r('<pre>');
        $format .= print_r($data);
        $format .= print_r('</pre>');
        return $format;
    }

    public function getTickets($download = [])
    {
        if ($download) {
            $data =  $download['data']; // Obtener datos de la solicitud HTTP
            // self::dep('$data');
            // self::dep($data['data']);exit;
        } else {
            $data =  $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
            // self::dep($data);exit;
        }
        $itemsPerPage = $data->itemsPerPage; // Obtener número de ítems por página
        $offset = ($data->page - 1) * $itemsPerPage; // Calcular offset
        $sql = "WITH tickets AS (
                SELECT
                b.iid AS iidboleta,
                b.dtfecha_hora_infraccion,
                b.txtlugar_infraccion,
                b.txtdireccion,
                b.imonto_total,
                CONCAT(p_inf.txtnombre, ' ', p_inf.txtapellido_paterno, CASE WHEN p_inf.txtapellido_materno <> '' THEN ' ' || p_inf.txtapellido_materno ELSE '' END) AS nombre_infractor,
                CONCAT(p_emp.txtnombre, ' ', p_emp.txtapellido_paterno, CASE WHEN p_emp.txtapellido_materno <> '' THEN ' ' || p_emp.txtapellido_materno ELSE '' END) AS nombre_empleado,
                br.txtnombre AS nombre_rol,
                b.txtlicencia,
                b.txtunidad,
                b.tarjeta_circulacion_id,
                b.txtreporte_especial_id,
                b.txtinspeccion_fisica,
                b.bretencion_vehiculo,
                b.bretencion_documento,
                b.txtobservaciones,
                b.bapercibimiento,
                b.dapercibimiento_fecha,
                b.dfecha_limite_comparecencia,
                b.dfecha_limite_resolucion,
                b.dfecha_limite_notificacion,
                b.bno_ha_lugar,
                b.bsuspension,
                b.isuspension_dias,
                b.dsuspension_fecha,
                b.bactivo as activo,
                b.dtfecha_creacion,
                b.dtfecha_modificacion
            FROM
                boleta.tbl_boleta b
            INNER JOIN
                persona.tbl_persona p_inf ON b.iidinfractor = p_inf.iid
            INNER JOIN
                persona.tbl_persona p_emp ON b.iidempleado = p_emp.iid
            INNER JOIN
                boleta.tbl_boleta_rol br ON b.iidboleta_rol_id = br.iid
        )";
        $params = array();

        if ($data->filters) { // Aplicar filtros si están presentes en la solicitud
            list($sql2, $params2) = $this->filterTickets($data->filters); // Aplicar filtros
            $sql .= $sql2; // Agregar filtros a la consulta principal
            $params += $params2; // Agregar parámetros de los filtros
        } else {
            $sql .= 'SELECT *, COUNT(tickets.iidboleta) OVER() AS total_tickets FROM tickets '; // Obtener perfiles sin filtros
        }
        if ($download) {
            return Db::fetchAll($sql, $params);
        } else {
            $sql .= $this->sortTickets($data->sortBy, $data->sortDesc); // Ordenar inspectores
            // self::dep($itemsPerPage);
            // exit;
            if ($itemsPerPage > 0) { // Si se especifica un número de ítems por página
                $sql .= ' LIMIT :items OFFSET :offset'; // Limitar resultados por página
                $params['items'] = $itemsPerPage; // Añadir parámetro de ítems por página
                $params['offset'] = $offset; // Añadir parámetro de offset
            }
            $tickets = Db::fetchAll($sql, $params); // Ejecutar consulta para obtener inspectores      
            $totalItems = count($tickets) ?? 0; // Obtener total de inspectores
            $totalPages = ceil($totalItems / $itemsPerPage); // Calcular total de páginas
            //    self::dep($sql);
            //         self::dep($totalPages);
            //         exit;
            return array(
                'tickets' => $tickets, // Devolver inspectores
                'totalPages' => $totalPages, // Devolver total de páginas
                'totalItems' => $totalItems, // Devolver total de ítems
            );
        }
    }



    // Método para filtrar inspectores
    private function filterTickets($filters)
    {
        $params = [];
        $sql = "SELECT *, COUNT(tickets.iidboleta) OVER() AS total_tickets FROM tickets ";
        $sql2 = 'WHERE '; // Inicializar fragmento de consulta para filtros
        foreach ($filters as $filter => $value) { // Para cada filtro
            if (empty($value) || $filter == 'type') continue; // Si el valor del filtro está vacío o es para roles, continuar al siguiente filtro
            if ($sql2 !== 'WHERE ') $sql2 .= 'AND '; // Si no es el primer filtro, añadir "AND"

            switch ($filter) { // Según el filtro
                case 'name': // Filtro por nombre
                    $sql2 .= "tickets.txtnombre ILIKE :name "; // Condición para nombre (ignorando mayúsculas y minúsculas)
                    $params['name'] = '%' . $filters->name . '%'; // Parámetro para nombre
                    break;
                case 'active': // Filtro por estado activo
                    $sql2 .= 'tickets.activo = :active '; // Condición para estado activo
                    $params['active'] = $filters->active; // Parámetro para estado activo
                    break;
            }
        }

        if ($sql2 !== 'WHERE ') $sql .= $sql2; // Si se agregaron filtros, añadirlos a la consulta principal
        return array($sql, $params); // Devolver consulta y parámetros
    }

    private function sortTickets($sortBy, $sortDesc)
    {
        $sortCount = count($sortBy); // Contar cantidad de criterios de ordenamiento
        if ($sortCount === 0) return 'ORDER BY tickets.iidboleta '; // Si no hay criterios, ordenar por ID por defecto

        $sql = 'ORDER BY '; // Inicializar fragmento de consulta para ordenamiento
        $comma = $sortCount - 1; // Último índice para agregar coma

        for ($i = 0; $i < $sortCount; $i++) { // Para cada criterio de ordenamiento
            $order = $sortDesc[$i] ? 'DESC ' : 'ASC '; // Determinar orden ascendente o descendente
            $column = $sortBy[$i]; // Obtener columna para ordenamiento

            switch ($column) { // Según la columna
                case 'txtnombre': // Ordenar por nombre completo
                    $sql .= 'tickets.txtnombre '; // Agregar columna de nombre completo
                    break;
                case 'activo': // Ordenar por estado activo
                    $sql .= 'tickets.activo '; // Agregar columna de estado activo
                    break;
                default: // Si no se reconoce la columna
                    $sql .= 'tickets.iidboleta '; // Ordenar por ID
            }

            $sql .= "$order NULLS LAST"; // Añadir orden y manejo de nulos
            $sql .= $i < $comma ? ', ' : ' '; // Agregar coma si no es el último criterio
        }

        return $sql; // Devolver fragmento de consulta para ordenamiento
    }

    // Método para descargar tickets en formato XLSX
    public function downloadTickets()
    {

        $filters = $this->request->get('filters');
        $filtersObj = json_decode($filters);
        $active = $filtersObj->active;
        $type = $filtersObj->type;

        $sortBy = $this->request->getQuery('sortBy', null, 'y');
        $sortDesc = $this->request->getQuery('sortDesc', null, 'y');
        $data = [
            "data" => (object)[
                "filters" => (object)[
                    "active" => $active,
                    "nombre_infractor" => "",
                    "nombre_empleado" => "",
                    "type" => $type
                ],
                "sortBy" => (object)["nombre_infractor"],
                "sortDesc" => (object)[false]
            ]
        ];
        $tickets = $this->getTickets($data);

        // Crear el diccionario de nombres de columnas
        $headers = $this->getHeaders('Boleta');

        switch ($type) { // Según el filtro
            case 'xlsx':
                return $this->downloadXLSX($tickets, $headers);
                break;
            case 'word':
                return $this->downloadWORD($tickets, $headers);
                break;
            case 'pdf':
                return $this->downloadPDF($tickets, $headers);
                break;
            default:
                $message = "Tipo de dato no capturado, contacte al administrador.";
                throw new ValidatorBoomException(422, $message);
                break;
        }
    }

    // Obtener encabezados para los tickets
    private function getHeaders($section)
    {
        if ($section == 'Boleta') {
            $headers  = [
                'dtfecha_hora_infraccion' => 'Fecha/Hora de Infracción',
                'txtlugar_infraccion' => 'Lugar de Infracción',
                'txtdireccion' => 'Dirección',
                'imonto_total' => 'Monto Total',
                'nombre_infractor' => 'Nombre del Infractor',
                // Agrega más claves y encabezados según sea necesario
            ];
        }
        return $headers;
    }


    public function downloadXLSX($tickets, $columnNames)
    {
        // Crear el archivo Excel
        $spreadsheet = new Spreadsheet();
        $spreadsheet->setActiveSheetIndex(0);
        $sheet = $spreadsheet->getActiveSheet();
        $sheet->setTitle('Citas');

        // Agregar encabezados de columnas al archivo Excel
        $columnIndex = 1;
        foreach ($columnNames as $columnName) {
            $sheet->setCellValueByColumnAndRow($columnIndex, 2, $columnName);
            $columnIndex++;
        }

        // Agregar datos de los tickets al archivo Excel
        $rowIndex = 3;
        foreach ($tickets as $ticket) {
            $columnIndex = 1;
            foreach ($columnNames as $columnName => $columnDisplayName) {
                $cellValue = $ticket->$columnName ?? ''; // Obtener el valor de la columna del ticket
                $sheet->setCellValueByColumnAndRow($columnIndex, $rowIndex, $cellValue);
                $columnIndex++;
            }
            $rowIndex++;
        }


        $filename = '7.xlsx'; // Agregué la extensión del archivo
        header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        header('Content-Disposition: attachment;filename="' . $filename . '"');
        header('Cache-Control: max-age=0');
        $objWriter = IOFactory::createWriter($spreadsheet, 'Xlsx');
        $filesDir = $this->config->app->appInspectionsFilesDir;
        $fullPath = $filesDir . $filename; // Ruta completa del archivo
        $fileSaved = $objWriter->save($fullPath);
        if ($fileSaved === false) {
            $message = "Lo sentimos, no se pudo procesar el archivo.";
            throw new ValidatorBoomException(422, $message);
        }
        return [
            'lError' => false,
            'filename' => $filename,
            'ruta' => '/app-inspections/static/files/' . $filename // Retornar la ruta completa del archivo guardado
        ];
    }

    // Método para descargar tickets en formato PDF
    public function downloadPDF($tickets, $columnNames)
    {
        $pdf = new \FPDF('P', 'mm', 'A4', true); // Establecer el parámetro $isUTF8 en true

        // Agregar una nueva página
        $pdf->AddPage();

        // Configurar fuente y tamaño
        $pdf->SetFont('Arial', 'B', 12);

        // Agregar título
        $pdf->Cell(0, 10, 'Tickets', 0, 1, 'C');
        $pdf->Ln(10); // Espacio adicional

        // Agregar encabezados de columnas
        foreach ($columnNames as $columnName) {
            $pdf->Cell(40, 10, utf8_decode($columnName), 1); // Utilizar utf8_decode para los encabezados si es necesario
        }

        // Agregar datos de los tickets
        foreach ($tickets as $ticket) {
            $pdf->Ln(); // Nueva línea
            foreach ($columnNames as $columnName => $columnDisplayName) {
                $cellValue = utf8_decode($ticket->{$columnName} ?? ''); // Utilizar utf8_decode para los datos si es necesario
                $pdf->Cell(40, 10, $cellValue, 1);
            }
        }

        // Guardar el PDF localmente en el servidor
        $filename = 'ejemplo.pdf';
        $filesDir = $this->config->app->appInspectionsFilesDir;
        $fullPath = $filesDir . $filename; // Ruta completa donde deseas guardar el archivo
        $pdf->Output($fullPath, 'F'); // Guardar el PDF en el servidor

        // Verificar si el archivo se ha guardado correctamente
        if (!file_exists($fullPath)) {
            $message = "Lo sentimos, no se pudo procesar el archivo.";
            throw new ValidatorBoomException(422, $message);
        }
        return [
            'lError' => false,
            'filename' => $filename,
            'ruta' => '/app-inspections/static/files/' . $filename // Retornar la ruta completa del archivo guardado
        ];
    }

    // Método para descargar tickets en formato Word
    public function downloadWORD($tickets, $columnNames)
    {
        // Crear una instancia de PHPWord
        $phpWord = new \PhpOffice\PhpWord\PhpWord();
        $section = $phpWord->addSection();

        // Agregar encabezados
        $headers = $this->getHeaders('Boleta');

        // Agregar datos
        foreach ($tickets as $ticket) {
            foreach ($ticket as $key => $value) {
                if(isset($headers[$key])){

                    $section->addText($headers[$key] . ': ' . $value);
                }
            }
            $section->addText('----------------');
        }

        // Nombre y ruta del archivo
        $filename = 'tickets.docx';
        $filesDir = $this->config->app->appInspectionsFilesDir;
        $fullPath = $filesDir . $filename;

        // Guardar el archivo en el servidor
        $objWriter = \PhpOffice\PhpWord\IOFactory::createWriter($phpWord, 'Word2007');
        $objWriter->save($fullPath);

        // Verificar si el archivo se ha guardado correctamente
        if (!file_exists($fullPath)) {
            $message = "Lo sentimos, no se pudo procesar el archivo.";
            throw new ValidatorBoomException(422, $message);
        }

        // Retornar la información del archivo generado
        return [
            'lError' => false,
            'filename' => $filename,
            'ruta' => '/app-inspections/static/files/' . $filename
        ];
    }
}
