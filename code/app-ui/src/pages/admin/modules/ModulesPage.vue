<template>
  <div class="d-flex flex-column flex-grow-1">
    <div class="d-flex align-center py-1">
      <div>
        <div class="display-1">Módulos</div>
        <v-breadcrumbs :items="breadcrumbs" class="pa-0 py-2"></v-breadcrumbs>
      </div>
      <v-spacer></v-spacer>
      <v-btn color="primary" @click="newItem()">
        Agregar
      </v-btn>
    </div>

    <v-card>
      <!-- users list -->
      <v-row dense class="pa-2 align-center">
        <v-col cols="12" sm="4" md="3" lg="2" xl="1" class="d-flex">
          <v-menu offset-y left>
            <template v-slot:activator="{ on }">
              <transition name="slide-fade" mode="out-in">
                <v-btn :disabled="selectedData.length == 0" v-on="on">
                  Acciones
                  <v-icon right>mdi-menu-down</v-icon>
                </v-btn>
              </transition>
            </template>
            <v-list dense>
              <v-list-item v-for="(option, index) in batchOptions" :key="option.op" @click="batchOperation(option)" link>
                <v-list-item-title v-text="option.label"></v-list-item-title>
              </v-list-item>
            </v-list>
          </v-menu>

        </v-col>
        <v-col cols="12" sm="8" md="9" lg="10" xl="11" class="d-flex text-right align-center">
          <v-text-field
            v-model="searchQuery"
            append-icon="mdi-magnify"
            class="flex-grow-1 mr-md-2"
            solo
            hide-details
            dense
            clearable
            placeholder="Ej. Filtre por nombre, descripción, siglas, sección"
            @keyup.enter="search(searchQuery)"
            @click:append="search(searchQuery)"
            @click:clear="clearSearch"
          ></v-text-field>
          
          <v-tooltip bottom>
            <template v-slot:activator="{ on, attrs }">
              <v-btn icon small class="ml-2" :loading="isLoading" @click="updateTable()">
                <v-icon v-bind="attrs" v-on="on">mdi-refresh</v-icon>
              </v-btn>
            </template>
            <span>Actualizar</span>
          </v-tooltip>
        </v-col>
      </v-row>
      
      <v-data-table
        v-model="selectedData"
        show-select
        
        :items="data"
        :headers="headers"
        :options.sync="options"
        :items-per-page="itemsPerPage"
        :server-items-length="totalItems"
        :search="searchQuery"
        :loading="isLoading"
        :footer-props="footerProps"
        loading-text="Cargando... Espere un momento."
        no-data-text="No hay registros disponibles."
        class="flex-grow-1"
      >
      
        <template v-slot:item.id="{ item }">
          <copy-label :text="item.id.toString()" />
        </template>
        
        <template v-slot:item.siglas="{ item }">
          <copy-label :text="item.siglas" />
        </template>
        
        <template v-slot:item.activo="{ item }">
            <v-icon small color="success" v-if="item.activo">mdi-check-circle</v-icon>
            <v-icon small color="error" v-else>mdi-close-circle-outline</v-icon>
        </template>
        
        <template v-slot:item.actions="{ item }">
          <v-tooltip bottom>
            <template v-slot:activator="{ on, attrs }">
              <v-btn icon v-bind="attrs" v-on="on" @click="editItem(item)">
                <v-icon small>mdi-pencil</v-icon>
              </v-btn>
            </template>
            <span>Editar</span>
          </v-tooltip>
          
          <v-tooltip bottom v-if="item.activo">
            <template v-slot:activator="{ on, attrs }">
              <v-btn icon v-bind="attrs" v-on="on" @click="deactivateItem(item)">
                <v-icon small>mdi-toggle-switch-off-outline</v-icon>
              </v-btn>
            </template>
            <span>Desactivar</span>
          </v-tooltip>
          <v-tooltip bottom v-else>
            <template v-slot:activator="{ on, attrs }">
              <v-btn icon v-bind="attrs" v-on="on" @click="activateItem(item)">
                <v-icon small>mdi-toggle-switch-outline</v-icon>
              </v-btn>
            </template>
            <span>Activar</span>
          </v-tooltip>
          
          <v-tooltip bottom>
            <template v-slot:activator="{ on, attrs }">
              <v-btn icon v-bind="attrs" v-on="on" @click="deleteItem(item)">
                <v-icon small>mdi-delete</v-icon>
              </v-btn>
            </template>
            <span>Eliminar</span>
          </v-tooltip>
        </template>
      </v-data-table>
      
      <v-dialog v-model="dialogState" max-width="500px">
        <v-card elevation="2" outlined>
          <v-card-title class="text-h6 grey lighten-4">Confirmación</v-card-title>
          
          <v-card-text class="pa-3">¿Estás seguro de que quieres {{dialogAction}} el(los) registro(s) seleccionado(s)?</v-card-text>
          
          <v-divider></v-divider>
          
          <v-card-actions class="grey lighten-4">
            <v-spacer></v-spacer>
            <v-btn color="blue darken-1" text @click="closeDialog()">Cancelar</v-btn>
            <v-btn color="blue darken-1" text @click="dialogConfirm()">Aceptar</v-btn>
            <v-spacer></v-spacer>
          </v-card-actions>
          
        </v-card>
      </v-dialog>
    </v-card>
  </div>
</template>

<script>
import CopyLabel from '@/components/common/CopyLabel'
import services from '@/services';

export default {
  components: {
    CopyLabel
  },
  data() {
    return {
      itemAction: null,
      dialogState: false,
      dialogAction: null,
      dialogConfirm: null,
      isLoading: false,
      breadcrumbs: [{
        text: 'Módulos',
        disabled: false,
        href: '#'
      }],

      
      searchQuery: '',
      selectedData: [],
      options: {},
      headers: [
        { text: 'Id', value: 'id', align: 'left'},
        { text: 'Nombre', value: 'nombre', align: 'left'},
        { text: 'Descripción', value: 'descripcion', align: 'center' },
        { text: 'Siglas', value: 'siglas', align: 'center' },
        { text: 'Seccion', value: 'seccion', align: 'center' },
        { text: 'Orden', value: 'orden', align: 'center' },
        { text: 'Padre', value: 'idpadre', align: 'center' },
        { text: 'Activo', value: 'activo', align: 'center'},
        { text: 'Acciones', value: 'actions', sortable: false }
      ],
      data: [],
      itemsPerPage: 5,
      totalItems: null,
      footerProps: {
        'items-per-page-options': [5, 10, 15, 20],
        'items-per-page-text': "Registros por página"
      },
      batchOptions: [
        { op: 'activate', label: 'Activar' },
        { op: 'deactivate', label: 'Desactivar' },
        { op: 'delete', label: 'Eliminar' }
      ]
    }
  },
  watch: {
    options: {
      handler() {
        this.loadData(this.searchQuery);
      }
    },
    selectedData(val) {
      console.log("selected", val);
    }
  },
  methods: {
    search(searchQuery) { 
      console.log("Search"); 
      this.loadData(searchQuery);
    },
    clearSearch() {
      this.search('');
    },
    editItem(item) { 
      this.$router.push({ name: 'admin-edit-module', params: { id: item.id}});
    },
    newItem() { 
      this.$router.push({ name: 'admin-new-module' });
    },
    async loadData(searchQuery) {
      console.log("loadUsers", this.options);
      this.isLoading = true;
      const { page, itemsPerPage, sortBy, sortDesc } = this.options;
      
      let paginated = await services.admin().getModules({ search: searchQuery, page, limit: itemsPerPage, sortBy: sortBy[0], sortDesc: sortBy.length === 0? null : sortDesc[0] });
      
      this.data = paginated.data;
      this.totalItems = paginated.totalItems;
      
      this.isLoading = false;
    },
    updateTable() {
      this.loadData(this.searchQuery);
    },
    activateItem(item) {
      this.itemAction = item;
      this.dialogAction = 'activar';
      this.dialogState = true;
      this.dialogConfirm = this.activateItemConfirm;
    },
    deactivateItem(item) {
      this.itemAction = item;
      this.dialogAction = 'desactivar';
      this.dialogState = true;
      this.dialogConfirm = this.deactivateItemConfirm;
    },
    async activateItemConfirm() {
      await services.admin().activateModule(this.itemAction.id);
      
      this.loadData();
      this.closeDialog();
    },
    async deactivateItemConfirm() {
      await services.admin().deactivateModule(this.itemAction.id);
      
      this.loadData();
      this.closeDialog();
    },
    deleteItem(item) {
      this.itemAction = item;
      this.dialogAction = 'eliminar';
      this.dialogState = true;
      this.dialogConfirm = this.deleteItemConfirm;
      
    },
    async deleteItemConfirm() {
      try{
        await services.admin().deleteModule(this.itemAction.id);
      } catch(exception){
        let error = exception.message.indexOf("Foreign key violation") !== -1? 'El registro esta siendo usado.' : exception.message;
        if (this.$store && this.$store.dispatch) this.$store.dispatch('app/showError',{message: '', error: {message: error} });
      }
      
      this.loadData();
      this.closeDialog();
    },
    closeDialog(){
      console.log("closeDeleye")
      this.dialogState = false;
      this.itemAction = null;
      this.dialogAction = null;
      this.dialogConfirm = null;
    },
    batchOperation(option) {
      this.itemAction = null;
      this.dialogAction = option.label.toLowerCase();
      this.dialogState = true;
      this.dialogConfirm = () => this.batchOperationConfirm(option.op);
      
    },
    async batchOperationConfirm(operation) {
      try{
        await services.admin().batchModules({ operation: operation, data: this.selectedData.map( (item) => { return item.id; } )});
      } catch(exception) {
        let error = exception.message.indexOf("Foreign key violation") !== -1? 'El registro esta siendo usado.' : exception.message;
        if (this.$store && this.$store.dispatch) this.$store.dispatch('app/showError',{message: '', error: {message: error} });
      }
      this.loadData();
      this.closeDialog();
    }
  }
}
</script>

<style lang="scss" scoped>
.slide-fade-enter-active {
  transition: all 0.3s ease;
}
.slide-fade-leave-active {
  transition: all 0.3s cubic-bezier(1, 0.5, 0.8, 1);
}
.slide-fade-enter,
.slide-fade-leave-to {
  transform: translateX(10px);
  opacity: 0;
}
</style>
