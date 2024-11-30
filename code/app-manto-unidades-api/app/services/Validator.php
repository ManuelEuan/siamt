<?php

namespace App\Services;

use Exception;
use Vokuro\GenericSQL\GenericSQL;

class Validator {
    protected $data   = array();
    protected $rules  = array();
    protected $errors = array();

    public function __construct(array $data, array $rules) {
        $this->data = $data;
        $this->rules = $rules;
    }

    public function validate(){
        foreach ($this->rules as $field => $fieldRules) {
            $rules      = explode('|', $fieldRules);
            $continua   = true;
            $atributo   = null;

            foreach ($rules as $rule) {
                $parameters = null;
                $atributo   = $field;

                if (strpos($rule, ':') !== false) {
                    [$rule, $parameters] = explode(':', $rule);
                    $parameters = explode(',', $parameters);
                }

                $methodName = "validate" . ucfirst($rule);
                if($atributo == $field && $continua === true){
                    if($methodName != 'validateNullable') {
                        if (method_exists($this, $methodName)) {
                            $isValid = $this->$methodName($field, $parameters);
        
                            if (!$isValid) {
                                $texto = '';
                                switch ($rule) {
                                    case 'required':
                                        $texto = 'es requerido';  break;
                                    case 'numeric':
                                        $texto = 'debe ser tipo numerico';  break;
                                    case 'exists':
                                        $texto = 'es incorrecto';  break;
                                    case 'in':
                                        $campos = implode(', ', $parameters);
                                        $texto = 'solo permite los valores '.$campos;  break;
                                    default:
                                        # code...
                                        break;
                                }
                                $this->addError($field, $texto);
                                $continua = false;
                            }
        
                        } else {
                            throw new Exception("La regla de validación $rule no es compatible.");
                        }
                    }
                }
            }
        }

        return $this->errors;
    }
    
    ############################## Metodos para las validaciones ##############################
    protected function addError(string $field, string $rule): void {
        $this->errors[$field][] = "El campo $field $rule.";
    }

    protected function validateRequired($field, $parameters): bool {
        return isset($this->data[$field]) && trim($this->data[$field]) !== '';
    }

    protected function validateMin($field, $parameters): bool {
        return isset($this->data[$field]) && strlen($this->data[$field]) >= $parameters[0];
    }

    protected function validateMax($field, $parameters): bool {
        return isset($this->data[$field]) && strlen($this->data[$field]) <= $parameters[0];
    }

    protected function validateNumeric($field, $parameters): bool {
        return is_numeric($this->data[$field] ?? null);
    }

    protected function validateExists($field, $parameters): bool {
        $query = 'SELECT * FROM comun.'.$parameters[0].' where '.$parameters[1].' = '. $this->data[$field];
        $item = GenericSQL::getBySQL($query);
        return sizeof($item) > 0 ? true : false;
    }

    protected function validateIn($field, $parameters): bool {
        return in_array($this->data[$field], $parameters) ? true : false;
    }
}