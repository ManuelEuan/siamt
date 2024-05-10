<template>
  <div style="width: 100% !important;">
    <generic-form-validation :formFields="formFields" @form-valid="handleGenericFormValidation2"
      :formFieldsWithValues="sendFieldsWithValues" @new-value="handleGenericFormValidation"></generic-form-validation>
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
        permisos_autocomplete_list: [],
        permisos_autocomplete_object: [],
        txttitulo: '',
        txttelefono: '',
      },
      oficinas: [
        { id: 'ID', value: 'id' },
        { text: 'Nombre', value: 'nombre' },
        { text: 'Descripción', value: 'descripcion' },
        { text: 'Siglas', value: 'siglas' }
      ],
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
    }
  },

  computed: {
    formFields() {
      return {
        permisos_autocomplete_list: {
          label: 'Permisos*', type: 'autocomplete', model: 'permisos_autocomplete_list', rules: 'required', cols: 12, md: 6, array: { type: 'list', info: this.permisos }
        },
        permisos_autocomplete_object: {
          label: 'Permisos*', type: 'autocomplete', model: 'permisos_autocomplete_object', rules: 'required', cols: 12, md: 6, array: { type: 'object', info: this.templates, item_text: 'txtnombre', item_value: 'iidfirma_plantilla' }
        },
        txttitulo: { label: 'Título', type: 'text', model: 'txttitulo', rules: null, cols: 12, md: 6 },
        txttelefono_mask_phone: { label: 'Teléfono*', type: 'text', model: 'txttelefono_mask_phone', rules: 'required|telefono', cols: 12, md: 6, maskType: 'phone' },
      }
    }
  },
  methods: {
    handleGenericFormValidation(key, value) {
      console.log('LLLLLLLLLLLLLLLLLLLLLLLLLLLLLL')
      console.log(key, value)
      this.form[key] = value

    },
    handleGenericFormValidation2(valid) {
      this.validForm = valid
    },
  },
  mounted() {
    // let firm = {
    //     txttitulo: '',
    //     txttelefono_mask_phone: 7889,
    //   }
    // this.sendFieldsWithValues = firm
  }
}
</script>