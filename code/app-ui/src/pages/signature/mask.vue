<template>
    <div>
      <v-container>
        <!-- Utiliza una propiedad computada o un valor local para rawValue -->
        <v-text-field v-mask="'(###)-###-####'" :value="rawValue" @input="handleInput" />
        <!-- Muestra el valor formateado -->
        Con formato: {{ rawValue }}
        <!-- Muestra el valor normal -->
        Sin formato: {{ formattedValue }}
      </v-container>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        // Define la propiedad "rawValue" en el objeto de data del componente
        rawValue: ''
      }
    },
    methods: {
      // Define el método handleInput para manejar el evento input
      handleInput(value) {
        // Actualiza la propiedad "rawValue" con el valor del campo de texto
        this.rawValue = value
      }
    },
    computed: {
      // Define una propiedad computada para formatear el valor actual según la máscara
      formattedValue() {
        const maskedValue = this.rawValue.replace(/\D/g, '');
        return maskedValue
        // return maskedValue.replace(/(\d{3})(\d{3})(\d{4})/, '($1)-$2-$3');
      }
    }
  }
  </script>
  