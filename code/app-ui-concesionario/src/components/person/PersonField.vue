<template>
  
  <v-text-field v-if="textFields.includes(type)" :label="label" :value="data" @input="$emit('update:data', $event)" :rules="[].concat(rules? rules:[], rulesm[type]? rulesm[type]: [])" clearable></v-text-field>
  <!-- <v-date-picker v-else-if="datePicker.includes(type)" :value="data" @input="$emit('update:data', $event)"
    :max="(new Date(Date.now() - (new Date()).getTimezoneOffset() * 60000)).toISOString().substr(0, 10)"
    min="1900-01-01"
  ></v-date-picker> -->
  <v-menu v-else-if="datePicker.includes(type)" ref="menu" v-model="menu" :close-on-content-click="false"
    transition="scale-transition" offset-y min-width="auto"
  >
    <template v-slot:activator="{ on, attrs }">
      <v-text-field v-model="date" :label="label" v-bind="attrs" v-on="on" @change="saveDate" readonly clearable></v-text-field>
    </template>
    <v-date-picker v-model="date" :active-picker.sync="activePicker" @change="saveDate"
      min="1900-01-01" :max="getDateMax()"
    ></v-date-picker>
  </v-menu>
  <v-select v-else-if="type in selects" :items="selectItems" :label="label" :item-value="selects[type].itemId" :item-text="selects[type].itemText" :loading="loading" :value="data" @input="$emit('update:data', $event)" clearable></v-select>
  <div v-else>Type {{type}} not supported</div>
</template>

<script>
import services from '@/services';
import rules from '@/core/rules.forms';

export default {
  props: {
    type: {
      type: String,
      default: '',
      required: true
    },
    label: {
      type: String,
      default: '',
      required: true
    },
    data: {},
    channel: {},
    rules: [],
    extras: {}
  },
  data() {
    return {
      loading: false,
      selectItems: null,
      activePicker: null,
      menu: false,
      date: null,
      textFields: ["vnombre", "vapellidopaterno", "vapellidomaterno", "vcurp", "vrfc", "vine","facebook","twitter","instagram"],
      datePicker: ["dtfechanacimiento", "dtfechadefuncion", "dtfechaestadocivil", "dtvigenciaine"],
      selects: {
        id_dim_genero: {
          source: async () => services.dwh().getGenders(),
          itemId: "id_dim_genero",
          itemText: "vgenero",
          itemProperty: "genero"
        },
        id_dim_estado_civil: {
          source: async () => services.dwh().getMaritalStatus(),
          itemId: "id_dim_estado_civil",
          itemText: "vestadocivil",
          itemProperty: "estado_civil"
        },
        id_lugarnacimiento: {
          source: async () => services.dwh().getStates(),
          itemId: "id_cat_entidad_federativa",
          itemText: "ventidad",
          itemProperty: "estado_nacimiento"
        },
        idestado: {
          source: async () => services.dwh().getStates(),
          itemId: "id_cat_entidad_federativa",
          itemText: "ventidad",
          itemProperty: "estado"
        },
        idmunicipio: {
          source: async () => services.dwh().getMunicipalities(),
          itemId: "municipioid",
          itemText: "municipio",
          itemProperty: "municipio"
        },
        idlocalidad: {
          source: async () => services.dwh().getLocalities(),
          itemId: "localidadid",
          itemText: "localidad",
          itemProperty: "localidad"
        },
        id_dim_nivel_estudio: {
          source: async () => services.dwh().getEducationLevels(),
          itemId: "id_dim_grado_estudio",
          itemText: "vgradoestudio",
          itemProperty: "grado_estudio"
        },
        id_dim_discapacidad: {
          source: async () => services.dwh().getDisabilities(),
          itemId: "id_dim_discapicidad",
          itemText: "vdiscapicidad",
          itemProperty: "discapacidad"
        },
        id_dim_estado_vida: {
          source: async () => services.dwh().getLifeStates(),
          itemId: "id_dim_estado_vida",
          itemText: "vestadovida",
          itemProperty: "estado_vida"
        }
      },
      rulesm: {
        vnombre: [rules.max300chars],
        vapellidopaterno: [rules.max300chars],
        vapellidomaterno: [rules.max300chars],
        vcurp: [rules.max18chars],
        vrfc: [rules.max13chars],
        vine: [rules.max20chars],
        
      }
    }
  },
  watch: {
    menu (val) {
      val && setTimeout(() => (this.activePicker = 'YEAR'))
    },
    data(val){
      if(this.datePicker.includes(this.type)){
        this.date = val;
      }else if(this.type in this.selects){
        const selectType = this.selects[this.type];
        if(this.selectItems){
          if(val){
            const e = this.selectItems.find(e => e[selectType.itemId] === val);
            this.channel(selectType.itemProperty, e[selectType.itemText])
          }else{
            this.channel(selectType.itemProperty, null)  
          }
        }
      }
      
    }
  },
  beforeDestroy() {

  },
  methods: {
    getDateMax(){
      let max = this.extras?.max;
      return max? max : (new Date(Date.now() - (new Date()).getTimezoneOffset() * 60000)).toISOString().substr(0, 10);
    },
    saveDate (date) {
      console.log("saveDate");
      this.$refs.menu.save(date)
      this.$emit('update:data', date);
    },
  },
  async created() {
    if(this.type in this.selects){
      this.loading = true;
      this.selectItems = await this.selects[this.type].source();
      if(this.data){
        const selectType = this.selects[this.type];
        const e = this.selectItems.find(e => e[selectType.itemId] == this.data);
        this.channel(selectType.itemProperty, e[selectType.itemText])
      }

      this.loading = false;
    }
  }
}
</script>

<style scoped>
</style>
