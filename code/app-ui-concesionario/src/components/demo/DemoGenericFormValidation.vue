<template>
  <div style="width: 100% !important;">
    {{ form }}
    <generic-form-validation :formFields="formFields" @form-valid="handleGenericFormValidationConfirm"
      :formFieldsWithValues="sendFieldsWithValues" :dinamycRemoveFields="dinamycRemoveFields"
      :dinamycHiddenFields="dinamycHiddenFields" :dinamycDisabledFields="dinamycDisabledFields"
      @new-value="handleGenericFormValidationNewValues"></generic-form-validation>
  </div>
</template>

<script>
import GenericFormValidation from "@/components/common/GenericFormValidation.vue";
export default {
  components: {
    GenericFormValidation,
  },
  data() {
    return {
      sendFieldsWithValues: {},
      form: {
        typeRegister: [],
      },
      typesRegister: [
        {
          "type": 'process',
          "name": "Nuevo proceso",
        },
        {
          "type": 'stage',
          "name": "Nueva etapa",
        },
        {
          "type": 'substage',
          "name": "Nueva subetapa",
        }
      ],
      formFields: {},
      dinamycRemoveFields: [], // Decide quita el campo,
      dinamycHiddenFields: [], // Decide si estará oculto el campo,
      dinamycDisabledFields: [], // Decide si estará visible el campo pero deshabilitado,
    }
  },

  computed: {
  },
  methods: {
    dataFirstForm() {
      this.formFields = {
        typeRegister: {
          label: 'Seleccione su tipo de registro*',
          type: 'autocomplete',
          model: 'selectedRegister',
          rules: 'required',
          cols: 12,
          md: 12,
          inputClass: 'mx-auto',
          inputStyle: 'max-width: 50%',
          array: { type: 'object', info: this.typesRegister, item_text: 'name', item_value: 'type' }
        },
        txtnombre: {
          label: 'Nombre',
          type: 'text',
          model: 'txtnombre',
          rules: null,
          cols: 12,
          md: 6
        },
        bactivo: {
          label: 'Activo',
          type: 'boolean',
          model: 'bactivo',
          rules: null,
          cols: 12,
          md: 6
        },
        txttextarea: {
          label: 'Text area demo',
          type: 'textarea',
          model: 'txttextarea',
          rules: null,
          cols: 12,
          md: 6
        },
        dtfecha_creacion: {
          label: 'Creación',
          type: 'datetime',
          model: 'dtfecha_creacion',
          rules: null,
          cols: 12,
          md: 6
        },
        dtfecha_modificacion: {
          label: 'Modificación',
          type: 'datetime',
          model: 'dtfecha_modificacion',
          rules: null,
          cols: 12,
          md: 6
        },
        ddate: {
          label: 'Date demo',
          type: 'date',
          model: 'ddate',
          rules: null,
          min: '',
          max: '',
          cols: 12,
          md: 6
        },
        ttime: {
          label: 'Time demo',
          type: 'time',
          model: 'ttime',
          rules: null,
          cols: 12,
          md: 6
        },
        cinturonSeguridad: {
          label: 'Cinturón de seguridad',
          type: 'radiobuttons',
          model: 'Si', // Valor inicial del radiobutton seleccionado
          options: [ // Opciones para los radiobuttons
            { label: 'Sí', value: 'Si' },
            { label: 'No', value: 'No' }
          ],
          cols: 12 // Ancho completo en dispositivos pequeños
        },
        checkboxField1: {
          label: 'Checkbox Field 1',
          type: 'checkbox',
          model: false, // Valor inicial del checkbox
          cols: 12,
          md: 6
        },
        checkboxField2: {
          label: 'Checkbox Field 2',
          type: 'checkbox',
          model: false, // Valor inicial del checkbox
          cols: 12,
          md: 6
        },
        checkboxField3: {
          label: 'Checkbox Field 3',
          type: 'checkbox',
          model: false, // Valor inicial del checkbox
          cols: 12,
          md: 6
        },
        radioField: {
          label: 'Radio Field',
          type: 'radiobuttons',
          model: 'option1', // Valor inicial del radio seleccionado
          options: [ // Opciones para los radiobuttons
            { label: 'Option 1', value: 'option1' },
            { label: 'Option 2', value: 'option2' },
            { label: 'Option 3', value: 'option3' }
          ],
          cols: 12,
          md: 6
        }
        // txttelefono_mask_phone: { label: 'Teléfono*', type: 'text', model: 'txttelefono_mask_phone', rules: 'required|telefono', cols: 12, md: 6, maskType: 'phone' },
      }
    },
    handleGenericFormValidationNewValues(key, value) {
      console.log('Retorno de generic-form-validation')
      console.log(key, value)
      if (key == 'typeRegister') {
        this.typeRegister = value
      }
      this.form[key] = value
      if (this.form.typeRegister === 'process') {
        // this.dinamycRemoveFields = ['iidproceso', 'iidetapa', 'txtcolor', 'txtpermiso', 'binicial', 'bfinal', 'bcancelacion', 'brequiere_motivo', 'bactivo', 'dtfecha_creacion', 'dtfecha_modificacion']
      } else if (this.form.typeRegister === 'stage') {
        // this.dinamycRemoveFields = ['iidmodulo', 'iidetapa']
      } else if (this.form.typeRegister === 'substage') {
        // this.dinamycRemoveFields = ['iidproceso', 'iidmodulo']
      }

      console.log('this.form')
      console.log(this.form)
    },
    handleGenericFormValidationConfirm(valid) {
      this.validForm = valid
    },
  },
  mounted() {
    this.dataFirstForm()
    // let firm = {
    //     txttitulo: '',
    //     txttelefono_mask_phone: 7889,
    //   }
    // this.sendFieldsWithValues = firm
  }
}
</script>