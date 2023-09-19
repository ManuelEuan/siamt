<template>
  <div class="flex-grow-1">
    <div class="d-flex align-center py-1">
      <div>
        <div class="display-1">Módulo {{ data.nombre && `- ${data.nombre}` }}</div>
        <v-breadcrumbs :items="breadcrumbs" class="pa-0 py-2"></v-breadcrumbs>
      </div>
      <!-- <v-spacer></v-spacer>
      <v-btn icon>
        <v-icon>mdi-refresh</v-icon>
      </v-btn> -->
    </div>
    
    <v-tabs v-model="tab" :show-arrows="false" background-color="transparent">
      <v-tab to="#general">General</v-tab>
      <v-tab to="#config">Configuración</v-tab>
    </v-tabs>
    
    <v-tabs-items v-model="tab">
      <v-tab-item value="general">
        <v-card ref="general" class="my-2" :loading="loading">
            <v-card-text>
              <v-form ref="form">
                <v-row>
                  <v-col cols="12" md="6">
                    <v-text-field v-model="data.nombre" label="Nombre" :rules="[rules.required, rules.max50chars]"></v-text-field>
                    <v-text-field v-model="data.descripcion" label="Descripcion" :rules="[rules.max250chars]"></v-text-field>
                    <v-text-field v-model="data.siglas" label="Siglas" :rules="[rules.required, rules.max3chars]"></v-text-field>
                    <v-text-field v-model="data.seccion" label="Sección" :rules="[rules.max50chars]"></v-text-field>
                  </v-col>
          
                  <v-col cols="12" md="6">
                    <v-text-field v-model="data.icono" label="Icono" :rules="[rules.max50chars]"></v-text-field>
                    <v-text-field v-model="data.orden" label="Orden" :rules="[rules.intNumber]"></v-text-field>
                    <v-text-field v-model="data.idpadre" label="ID Padre" :rules="[rules.intNumber]"></v-text-field>
                  </v-col>
                </v-row>
          
                <div class="d-flex">
                  <v-btn @click="back()">Regresar</v-btn>
                  <v-spacer></v-spacer>
                  <v-btn color="primary" @click="save()" :disabled="loading" :loading="loading">Guardar</v-btn>
                </div>
              </v-form>
            </v-card-text>
        </v-card>
      </v-tab-item>
      
      <v-tab-item value="config">
        <v-card ref="config" class="my-2" :loading="loading">
          <v-card-text>
          <v-form ref="form">
            <v-textarea outlined label="JSON" v-model="data.configuracion" :rules="[rules.json]"></v-textarea>  
                <div class="d-flex">
              <v-btn @click="back()">Regresar</v-btn>
              <v-spacer></v-spacer>
              <v-btn color="primary" @click="save()" :disabled="loading" :loading="loading">Guardar</v-btn>
            </div>
          </v-form>
          </v-card-text>
        </v-card>
        
      </v-tab-item>
      
    </v-tabs-items>
  </div>
</template>

<script>
import services from '@/services';
import rules from '@/core/rules.forms';
// import CopyLabel from '@/components/common/CopyLabel'

export default {
  components: {
    // CopyLabel,
  },
  data() {
    return {
      tab: null,
      loading: false,
      editMode: null,
      id: null,
      data: {
        seccion: null,
        nombre: null,
        descripcion: null,
        siglas: null,
        icono: null,
        orden: null,
        idpadre: null,
        configuracion: null,
      },
      rules: rules,
      breadcrumbs: [
        { text: 'Modulos', to: '/admin/modules', exact: true }
      ]
    }
  },
  methods: {
    async save () {
      console.log(this.data);
      
      if(!this.validateFields()) return;
      this.loading = true;
      if(this.editMode){
        await services.admin().updateModule(this.id, this.data);  
      } else {
        await services.admin().saveModule(this.data);
      }
      this.loading = false;
      this.back();
    },
    back() {
      this.$router.push({ path: '/admin/modules'});
    },
    async loadData(id) {
      let data = await services.admin().getModule(id);
      Object.keys(this.data).forEach((key) => {
        this.data[key] = data[key];
      });
      
      this.id = data.id;
    },
    validateFields(){
      return this.$refs.form.validate();
    }
  },

  created() {
    let id = this.$route.params.id;
    console.log("EDM", id);
    if(id){
      this.editMode = true;
      this.loadData(this.$route.params.id);
      this.breadcrumbs.push({ text: 'Editar'});
    } else {
      this.editMode = false;
      this.breadcrumbs.push({ text: 'Nuevo'});
    }
  }
}
</script>
