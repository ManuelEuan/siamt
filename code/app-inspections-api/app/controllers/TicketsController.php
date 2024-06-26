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
// MODELOS INSPECCIONES
use App\Models\Inspection\Tickets;

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
        self::dep('ij');exit;
        if ($download) {
            $data =  $download['data']; 
            // self::dep('$data');
            // self::dep($data['data']);exit;
        } else {
            $data =  $this->request->getJsonRawBody(); // Obtener datos de la solicitud HTTP
            // self::dep($data);exit;
        }
        return Tickets::getAllTickets($data);
    }

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
