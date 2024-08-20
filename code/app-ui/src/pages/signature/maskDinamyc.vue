<template>
  <div>
    <v-container>
      <v-text-field v-mask="formatear ? mask : null" v-model="formattedValue" hide-details="auto" clearable dense
        outlined />
      Sin formato: {{ rawValue }}
      Con formato: {{ formattedValue }}
    </v-container>
  </div>
</template>

<script>
export default {
  data() {
    return {
      formatear: true,
      mask: '(###)-###-####',
      formattedValue: '',
    }
  },
  computed: {
    rawValue() {
      const maskedValue = this.formattedValue.replace(/\D/g, '');
      return maskedValue
    }
  },
  methods: {
    sinFormato(value, type){
      console.log(value)
      console.log(type)
      let valuer=''
      if(type == 'phone'){
        valuer = value.replace(/\D/g, '');
      }
      console.log(valuer)
      return valuer
    }
  },
  mounted() {
    const valor_demo = '(123)-147-5159';
    const str = "txtoficina_mask_phone_/D/g";
    const indexMask = str.indexOf("_mask_");

    if (indexMask !== -1) {
      const modelo = str.substring(0, indexMask);
      const tipo = str.substring(indexMask + 6); // Sumamos 4 para omitir "mask" y el guión bajo que le sigue
      const destructureMask = tipo.split("_");

      // Procesar las palabras en la modelo y la tipo para mantener los guiones bajos
      // const modeloFormateada = modelo.split('_').join(' ');
      // const tipoFormateada = tipo.split('_').join(' ');

      console.log("Palabras a la modelo:", modelo);
      console.log("Palabras a la tipo:", tipo);
      console.log("destructure Mask:", destructureMask);
      console.log("valor demo Mask:", valor_demo);
      console.log("valor demo rawMask:", this.sinFormato(valor_demo, destructureMask[0]));
      // this.sinFormato(valor_demo, destructureMask[0])
      
      // const destructureMask = str.indexOf("_mask_");

    } else {
      console.log("La cadena no contiene la palabra 'mask'.");
    }
  }
}
</script>
