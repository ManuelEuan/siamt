<template>
  <div style="width: 100% !important;">
    <!-- selected register {{!!typeRegister ? typesRegister : ''}} <br> -->
    {{ form }}
    {{ picker }}
    <!-- <v-date-picker v-model="picker"></v-date-picker> -->
    <generic-form-validation :formFields="formFields" @form-valid="handleGenericFormValidationConfirm"
      :formFieldsWithValues="sendFieldsWithValues" 
      :dinamycRemoveFields="dinamycRemoveFields"  :dinamycHiddenFields="dinamycHiddenFields" :dinamycDisabledFields="dinamycDisabledFields"  
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
      // picker: '',
      picker: (new Date(Date.now() - (new Date()).getTimezoneOffset() * 60000)).toISOString().substr(0, 10),
      sendFieldsWithValues: {},
      form: {
        autocomplete_list: [],
        typeRegister: ['process'],
        txttitulo: '',
        txttelefono: '',
      },
      permisos: ['California', 'Colorado', 'Florida', 'Georgia', 'Texas', 'Wyoming'],
      templates: [
        {
          "iidfirma_plantilla": 1,
          "txtnombre": "Agencia de Transporte de Yucat\u00e1n (ATY)",
          "txtplantilla": "%3Cimg%20style%3D%22margin-top%3A%205rem%3B%20padding%3A%200px%202rem%200px%201rem%3B%20float%3A%20left%3B%20width%3A%2035%25%3B%22%20src%3D%22..%2Fimages%2Faty.png%22%20alt%3D%22%22%20%2F%3E%0A%3Cdiv%20class%3D%22px-4%20pt-1%22%20style%3D%22border-left%3A%203px%20solid%20%23444444%3B%20float%3A%20left%3B%20max-width%3A%2065%25%3B%20height%3A%20195px%3B%22%3E%0A%3Cdiv%20class%3D%22pb-4%22%20style%3D%22font-weight%3A%20800%3B%20font-size%3A%201.8em%3B%20color%3A%20%23242f5d%3B%20font-family%3A%20'Helvetica%20Neue'%3B%22%3E%7B%25%25NOMBRE_COMPLETO%25%25%7D%3C%2Fdiv%3E%0A%3Cdiv%20class%3D%22pb-3%22%20style%3D%22font-weight%3A%20bold%3B%20font-size%3A%201.6em%3B%20color%3A%20%23242f5d%3B%20font-family%3A%20'Helvetica%20Neue'%3B%22%3E%3Cspan%20style%3D%22color%3A%20%2359af31%3B%20font-family%3A%20Panton%3B%22%3E%7B%25%25DEPENDENCIA%25%25%7D%3C%2Fspan%3E%3C%2Fdiv%3E%0A%3Cdiv%20class%3D%22pb-1%22%20style%3D%22font-weight%3A%20bold%3B%20font-size%3A%2014pt%3B%20color%3A%20%23242f5d%3B%20font-family%3A%20'Helvetica%20Neue'%3B%22%3E%7B%25%25PUESTO%25%25%7D%3C%2Fdiv%3E%0A%3Cdiv%20class%3D%22pb-1%22%20style%3D%22font-weight%3A%20bold%3B%20font-size%3A%2014pt%3B%20color%3A%20%23242f5d%3B%20font-family%3A%20'Helvetica%20Neue'%3B%22%3E%7B%25%25DEPARTAMENTO%25%25%7D%3C%2Fdiv%3E%0A%3Cdiv%20class%3D%22pb-1%22%20style%3D%22font-weight%3A%20bold%3B%20font-size%3A%2014pt%3B%20color%3A%20%23242f5d%3B%20font-family%3A%20'Helvetica%20Neue'%3B%22%3E%7B%25%25OFICINA%25%25%7D%20--%20%7B%25%25TELEFONO%25%25%7D%3C%2Fdiv%3E%0A%3C%2Fdiv%3E",
          "bactivo": true,
          "dtfecha_creacion": "2024-05-08 09:01:55",
          "dtfecha_modificacion": "2024-05-09 12:41:52.194842"
        }
      ],
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
      dinamycRemoveFields:[ 'iidetapa', 'txtnombre', 'txtdescripcion', 'txtsigla',  'txtcolor', 'txtpermiso', 'binicial', 'bfinal', 'bcancelacion', 'brequiere_motivo', 'bactivo', 'dtfecha_creacion', 'dtfecha_modificacion'],  // Decide quita el campo,
      dinamycHiddenFields: [], // Decide si estará oculto el campo,
      dinamycDisabledFields: [], // Decide si estará visible el campo pero deshabilitado,
    }
  },

  computed: {
    // formFields() {
    //   return {
        
    //   }
    // }
  },
  methods: {
    dataFirstForm(){
      this.formFields={
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
        iidmodulo: {
          label: 'Seleccione el módulo*',
          type: 'autocomplete',
          model: 'iidmodulo',
          rules: 'required',
          cols: 12,
          md: 6,
          array: { type: 'object', info: this.typesRegister, item_text: 'name', item_value: 'type' }
        },
        iidproceso: {
          label: 'Seleccione el proceso*',
          type: 'autocomplete',
          model: 'iidproceso',
          rules: 'required',
          cols: 12,
          md: 6,
          array: { type: 'object', info: this.typesRegister, item_text: 'name', item_value: 'type' }
        },
        iidetapa: {
          label: 'Seleccione la etapa*',
          type: 'autocomplete',
          model: 'iidetapa',
          rules: 'required',
          cols: 12,
          md: 6,
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
        // txtdescripcion: {
        //   label: 'Descripción',
        //   type: 'text',
        //   model: 'txtdescripcion',
        //   rules: null,
        //   cols: 12,
        //   md: 6
        // },
        // txtsigla: {
        //   label: 'Siglas',
        //   type: 'text',
        //   model: 'txtsigla',
        //   rules: null,
        //   cols: 12,
        //   md: 6
        // },
        // txtcolor: {
        //   label: 'Color',
        //   type: 'text',
        //   model: 'txtcolor',
        //   rules: null,
        //   cols: 12,
        //   md: 6
        // },
        // txtpermiso: {
        //   label: 'Permiso',
        //   type: 'text',
        //   model: 'txtpermiso',
        //   rules: null,
        //   cols: 12,
        //   md: 6
        // },
        // binicial: {
        //   label: 'Inicial',
        //   type: 'boolean',
        //   model: 'binicial',
        //   rules: null,
        //   cols: 12,
        //   md: 6
        // },
        // bfinal: {
        //   label: 'Final',
        //   type: 'boolean',
        //   model: 'bfinal',
        //   rules: null,
        //   cols: 12,
        //   md: 6
        // },
        // bcancelacion: {
        //   label: 'Cancelacion',
        //   type: 'boolean',
        //   model: 'bcancelacion',
        //   rules: null,
        //   cols: 12,
        //   md: 6
        // },
        // brequiere_motivo: {
        //   label: 'Motivo',
        //   type: 'boolean',
        //   model: 'brequiere_motivo',
        //   rules: null,
        //   cols: 12,
        //   md: 6
        // },
        bactivo: {
          label: 'Activo',
          type: 'boolean',
          model: 'bactivo',
          rules: null,
          cols: 12,
          md: 6
        },
        bactivo_demo: {
          label: 'Activo',
          type: 'boolean',
          model: 'bactivo_demo',
          rules: null,
          cols: 6,
          md: 2
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
        dtdatetime: {
          label: 'dtdatetime demo',
          type: 'datetime',
          model: 'dtdatetime',
          rules: null,
          cols: 12,
          md: 6
        },
        ddate_two: {
          label: 'Date demo 2',
          type: 'date',
          model: 'ddate_two',
          rules: null,
          min: '',
          max: '',
          cols: 12,
          md: 6
        },
        ttime_two: {
          label: 'Time demo 2',
          type: 'time',
          model: 'ttime_two',
          rules: null,
          cols: 12,
          md: 6
        },
        dtdatetime_two: {
          label: 'dtdatetime_two demo 2',
          type: 'datetime',
          model: 'dtdatetime_two',
          rules: null,
          cols: 12,
          md: 6
        },
        // txttelefono_mask_phone: { label: 'Teléfono*', type: 'text', model: 'txttelefono_mask_phone', rules: 'required|telefono', cols: 12, md: 6, maskType: 'phone' },
      }
    },
    handleGenericFormValidationNewValues(key, value) {
      console.log('Retorno de generic-form-validation')
      console.log(key, value)
      if(key=='typeRegister'){
        this.typeRegister = value
      }
      this.form[key] = value
      if (this.form.typeRegister === 'process') {
        this.dinamycRemoveFields = ['iidproceso', 'iidetapa', 'txtcolor', 'txtpermiso', 'binicial', 'bfinal', 'bcancelacion', 'brequiere_motivo', 'bactivo', 'dtfecha_creacion', 'dtfecha_modificacion']
      } else if (this.form.typeRegister === 'stage') {
        this.dinamycRemoveFields = ['iidmodulo', 'iidetapa']
      } else if (this.form.typeRegister === 'substage') {
        this.dinamycRemoveFields = ['iidproceso', 'iidmodulo']
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