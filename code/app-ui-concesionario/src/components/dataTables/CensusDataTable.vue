<template>
    <v-data-table
        :page="page"
        :page-count="numberOfPages"
        :headers = "surveyHeaders"
        :items = "surveyItems"
        class="elevation-1 mx-1"
        :options.sync = "options"
        :server-items-length = totalItems
        :loading = "loadingTable"
        :sort-by.sync="sortBy"
        :sort-desc.sync="sortDesc"
        loading-text ="Cargando información"
        multi-sort
    >
    <template v-slot:top>
     

<!--* Dialog para agregar editar Persona -->
<v-container fluid>
    <v-row justify = "center">
        <v-col cols = "12" lg = "10" class = "pa-0 ps-1">
            <v-dialog
                      v-model="newEditDialog"
                      width="70%"
                    >
                     <g-census-add-person
                        :data = "data"
                        @savedrow = "savedNewRow"
                        @closenewmodal = "closeModal"
                     ></g-census-add-person> 
                    </v-dialog> 
            
            <!--* Termina Dialog de edición-->
            
            <!--* Dialog para edición -->
            <v-dialog
                v-model="editDialog"
                width="70%"
            >
                <edit-census-row
                    :edititem = "editItemData"
                    :config = "config"
                    :schema = "schema"
                    :table = "table"
                    :type = "type"
                    @closedialog = "closeDialog"
                    @updatedrow = "updatedRow"
                    @savedrow = "savedRow"
                ></edit-census-row>
            </v-dialog>
            
            <!--* Termina Dialog de edición-->
            <!--* Dialog para visita -->
                <v-dialog
                      v-model="visitDialog"
                      width="70%"
                    >
                        <visit-page
                            :theperson = "person"
                            :census = "filters.census"
                            @storedvisit = "storedVisit"
                            @cancelvisit = "cancelVisit"
                        />
                </v-dialog>
            
            <!--* Termina Dialog de visita-->
            
                    <v-chip-group
                       class="pa-0" 
                    >
                        <v-tooltip
                            top
                            v-for="total in totals" :key ="total.id"
                        >
                            <template v-slot:activator="{on, attrs}">
                            <v-chip
                                class="me-2"
                                color = "primary"
                                text-color = "white"
                                v-bind="attrs"
                                v-on="on"
                            >
                            <v-icon left>
                                {{status.find(item => item.nombre == total.id)?status.find(item => item.nombre == total.id).vicon:"mdi-account-cancel "}}
                            </v-icon>
                            {{status.find(item => item.nombre == total.id).vicon != null?"":total.id}} : {{total.value}}
                            </v-chip>
                            </template>
                            <span>{{status.find(item => item.nombre == total.id)?status.find(item => item.nombre == total.id).nombre:total.id}}</span>
                       </v-tooltip>
                    </v-chip-group>
                </v-col>
                    <v-col cols = "12" lg = "2" align-self = "center" class = "pa-0" style = "padding-top: 4px;">
                        <v-btn
                            color = "primary"
                            class = "me-1"
                            @click="downloadXlsx"
                        >
                            <v-icon>
                                mdi-file-excel
                            </v-icon>
                        </v-btn>
                        <!--Oculto temporalmente-->
                        <v-btn
                            color = "primary"
                            @click="showVisitDialog(item)"
                            style="display:none"
                        >
                            <v-icon>
                                mdi-plus
                            </v-icon>
                            Nuevo
                        </v-btn> 
                    </v-col>
       
    </v-row> 
</v-container>
 
    </template>
    <template v-slot:item.actions="{ item }">

      <v-tooltip bottom

      >
        <template v-slot:activator="{ on, attrs }"
        >
          <v-icon
              small
              class="mr-2"
              @click="seeItem(item)"
              v-bind="attrs"
              v-on="on"
          >
            mdi-eye
          </v-icon>
        </template>
        <span>Ver Persona</span>
      </v-tooltip>
      <v-tooltip bottom >
        <template v-slot:activator="{ on, attrs }">
          <v-icon
              small
              class="mr-2"
              @click="editItem(item)"
              v-bind="attrs"
              v-on="on"
          >
            mdi-pencil
          </v-icon>
        </template>
        <span>Editar Persona</span>
      </v-tooltip>
      <v-tooltip bottom>
        <template v-slot:activator="{ on, attrs }">
          <v-icon
              small
              class="mr-2"
              @click="showSurveys(item)"
              v-bind="attrs"
              v-on="on"
          >
            mdi-help-circle
          </v-icon>
        </template>
        <span>Ver Respuestas</span>
      </v-tooltip>
      <v-tooltip bottom>
         <template v-slot:activator="{ on, attrs }">
           <v-icon
               small
               @click="showVisitDialog(item)"
               v-bind="attrs"
               class="mr-2"
               v-on="on"
           >
             mdi-account-arrow-right
           </v-icon>
         </template>
         <span>Agregar Visita</span>
       </v-tooltip>
      <v-tooltip bottom>
        <template v-slot:activator="{ on, attrs }">
          <v-icon
              small
              @click="showSurveyMarker(item)"
              v-bind="attrs"
              v-on="on"
          >
            mdi-map-marker-account
          </v-icon>
        </template>
        <span>Ver en mapa</span>
      </v-tooltip>
    </template>
    </v-data-table>
</template>
<script>
import services from "@/services";
import EditCensusRow from '../../pages/census/EditCensusRow.vue'
import VisitPage from "@/pages/surveys/VisitPage.vue"
import * as XLSX from 'xlsx'
import GCensusAddPerson from "@/pages/gcensus/components/GCensusAddPerson.vue";

export default {
    
    components : {
        GCensusAddPerson,
        EditCensusRow,
        VisitPage,
    },
    props : {
        filters : Object,
        status : Array
    },
    created() {


    },
    data() {
        return {
            callStatus : [],
            type : "",
            newEditDialog : false,
            editDialog : false,
            visitDialog : false,
            config : null,
            schema : "",
            table : "",
            editItemData : null,
            page : 1,
            totalItems : 0,
            options : {},
            censusItems : [],
            surveyItems : [],
            censusHeaders : [],
            loadingTable : true,
            censusTable : null,
            surveyTable : null,
            totals : [],
            newFilters : {},
            numberOfPages : 0,
            itemsPerPage : 10,
            person : {},
            visitData : {},
            data : {
                type : "new",
                person : {},
                table : "",
                schema : ""
            },
            sortBy: 'estatus_visita_union',
            sortDesc: false,
            surveyHeaders : [
                {
                    text : "Encuestado" ,
                    value : "nombre_persona",
                    align : "center",
                    class : "font-weight-bold"
                },
                {
                    text : "Padrón" ,
                    value : "nombre_padron",
                    align : "center",
                    class : "font-weight-bold"
                },
                {
                    text : "Estatus" ,
                    value : "estatus_visita_union",
                    align : "center",
                    class : "font-weight-bold"
                },
                {
                    text : "Distrito Local" ,
                    value : "dl",
                    align : "center",
                    class : "font-weight-bold"
                },
              {
                text : "Sección" ,
                value : "seccion",
                align : "center",
                class : "font-weight-bold"
              },
              {
                text : "Usuario" ,
                value : "nombre_usuario",
                align : "center",
                class : "font-weight-bold"
              },
              {
                text: "Acciones",
                value: "actions",
                sortable: false,
                width: '132px'
              }
            ]
        }
    },
    watch : {
        options : {
            handler () {
                //this.loadCensusTable();
                this.loadSurveyTable();
            },
            deep : true
        },
        filters :   {
            handler() {
                
                if(this.filters.newFilters && this.filters.survey){
                    //this.loadCensusTable();
                    this.loadSurveyTable();
                    this.$emit('filterapplied',true);
                }
                
            },
            deep: true
        }
    },
    methods: {
      showSurveyMarker (item) {
        console.log('para ver el marcador', item);
        if(item.lat == null || item.lng == null) {
          this.$toastr.e('Esta encuesta no tiene datos geográficos para mostrar')
          return
        }
        let marker = [item.lat,item.lng];
        console.log('marker', marker);
        this.$emit("show-marker-in-map",marker);
        console.log(this.$parent.principalTabs);

      },
        closeModal(data) {
            this.newEditDialog = data;
        },
        async downloadXlsx() {
            const exportData = await services.census().exportData(this.filters);
           const newData = exportData.map(item => {
                var newItem ={};
                this.surveyHeaders.forEach(function(val){
                    if(val.text != "Acciones"){
                        newItem[val.text] = item[val.value];
                    } 
                });
                newItem.Estatus = item['estatus_visita_union'];

                return newItem;
            });
                

            const data = XLSX.utils.json_to_sheet(newData);
            const wb = XLSX.utils.book_new();
            XLSX.utils.book_append_sheet(wb, data, 'datos');
            let date = new Date();
            XLSX.writeFile(wb,date.toISOString().split('T')[0]+'.xlsx')
        },
        newPerson() {
            this.data.table = this.filters.census.nombre;
            this.type = "new"
            this.newEditDialog = true;
        },
        async loadSurveyTable() {
            this.newFilters = this.filters;
            const {page, itemsPerPage, sortBy, sortDesc } = this.options;
            this.newFilters.currentPage = page;
            this.newFilters.itemsPerPage = itemsPerPage;
            this.surveyTable = await services.census().getSurveyTable(this.newFilters);
            console.log("-> this.surveyTable", this.surveyTable);
            let questions = this.surveyTable.questions.filter(item => item.tipo_pregunta != 'abierta');
            this.$emit("surveyfilters",[questions,this.surveyTable.answers]);
            this.numberOfPages = this.surveyTable.pages
         /* let persona;
            for(let i =0; i < this.surveyTable.data.length; i++) {
              if(this.surveyTable.data[i].iddim_persona  && this.surveyTable.data[i].iddim_persona != null || this.surveyTable.data[i].iddim_persona != "")
              persona = await services.dwh().getPerson(this.surveyTable.data[i].iddim_persona);
                this.surveyTable.data[i].nombre_persona = persona.vnombre + " "+ persona.vapellidopaterno + " " + persona.vapellidomaterno;
            }*/
            this.surveyItems = this.surveyTable.data;
            this.totalItems = this.surveyTable.total;
            if (sortBy.length === 1 && sortDesc.length === 1) {
                this.surveyItems = this.surveyTable.data.sort((a, b) => {
                const sortA = a[sortBy[0]]
                const sortB = b[sortBy[0]]

                if (sortDesc[0]) {
                    if (sortA < sortB) return 1
                    if (sortA > sortB) return -1
                    return 0
                } else {
                    if (sortA < sortB) return -1
                    if (sortA > sortB) return 1
                    return 0
                }
                })
            }
            this.loadingTable = false;
            //Calculamos los totales que se van a mostrar
            this.totals = [];
            console.log("🚀 ~ file: CensusDataTable.vue:296 ~ loadSurveyTable ~ this.surveyTable.totals", this.surveyTable.totals)

          if (this.surveyTable.totalesPadron != "") {
            this.surveyTable.totalesPadron.forEach(item => {
              if (item.estatus != 'Pendientes') {
                this.totals.push({
                  id: item.estatus,
                  value: item.total_estatus
                })
              } else {
                this.$emit('actualizapendiente', 'Pendientes : ' + item.total_estatus + " de " + this.surveyTable.totalPadron);
              }
            });
          }
            console.log(this.totals);
        },
        async loadCensusTable() {
            this.newFilters = this.filters
            console.log("🚀 ~ file: CensusDataTable.vue ~ line 171 ~ loadCensusTable ~ this.filters", this.filters)
            const {page, itemsPerPage, sortBy, sortDesc } = this.options;
            this.newFilters.currentPage = page;
            this.newFilters.itemsPerPage = itemsPerPage;
            this.censusTable = await services.census().getCensusTable(this.newFilters);
            console.log("🚀 ~ file: CensusDataTable.vue ~ line 70 ~ loadCensusTable ~ this.censusTable", this.censusTable);
            let questions = this.censusTable.questions.filter(item => item.tipo_pregunta != 'abierta');
            this.$emit("surveyfilters",[questions,this.censusTable.answers]);
            if(this.censusTable != null) {
                this.config = JSON.parse(this.censusTable.data.vconfig);
                this.schema = this.censusTable.data.esquema;
                this.table = this.censusTable.data.tabla;
                this.censusHeaders = this.config.encuestas.columns.map(item => {
                    if(item.visible){
                        return {
                            text : item.text,
                            value : item.name
                        };
                    }
                });
                this.censusHeaders.push({
                    text: "Acciones",
                    value: "actions",
                    sortable: false,
                    width: '132px'
                });
                this.numberOfPages = this.censusTable.items.pages
                this.totalItems = this.censusTable.items.total[0].count;
                this.censusItems = this.censusTable.items.data;
                if (sortBy.length === 1 && sortDesc.length === 1) {
                this.censusItems = this.censusTable.items.data.sort((a, b) => {
              const sortA = a[sortBy[0]]
              const sortB = b[sortBy[0]]

              if (sortDesc[0]) {
                if (sortA < sortB) return 1
                if (sortA > sortB) return -1
                return 0
              } else {
                if (sortA < sortB) return -1
                if (sortA > sortB) return 1
                return 0
              }
            })
          }

                this.loadingTable = false

            //Calculamos los totales que se van a mostrar
            this.totals = [];
                if(this.surveyTable.totalesPadron != "") {


                  for (const prop in this.censusTable.totals) {
                    this.totals.push({
                      id: prop,
                      value: this.censusTable.totals[prop]
                    })
                  }
                }
              console.log("-> this.totals", this.totals);
            }
        },
      hasPermission(permission) {
        let permisos = services.security().hasPermission(this.$route.meta.code, permission);
        console.log("🚀 ~ file: GCensusDataTable.vue:209 ~ hasPermission ~ permisos", permisos)
        return permisos;
      },
      async seeItem(item) {
        let editItem = await services.census().getEditRowInCensus(item);
        this.type = "see";
        if(!editItem.lError){
          this.config = JSON.parse(editItem.config);
          this.schema = editItem.schema;
          this.table = editItem.table;
          this.editItemData = editItem.row
          this.editDialog = true;
        }

      },
      async editItem(item) {
        let editItem = await services.census().getEditRowInCensus(item);
        this.type = "edit";
        if(!editItem.lError){
          this.config = JSON.parse(editItem.config);
          this.schema = editItem.schema;
          this.table = editItem.table;
          this.editItemData = editItem.row
          this.editDialog = true;
        }
      },
      newItem() {
        this.type = "new"
        this.editDialog = true;
      },
      savedNewRow() {
        this.newEditDialog = false;
        this.loadCensusTable();
      },
      closeDialog(data) {
        this.editDialog = !data
      },
      async showVisitDialog(item) {
        console.log("🚀 ~ file: CensusDataTable.vue ~ line 238 ~ showVisitDialog ~ item", item)
        let res = await services.census().getEditRowInCensus(item);
        if(!res.lError){
         // this.config = JSON.parse(res.config);
          //this.schema = editItem.schema;
         // this.table = editItem.table;
         // this.editItemData = editItem.row
         // this.editDialog = true;
          this.person = res.row;
          this.visitDialog = true;
        }


      },
      updatedRow(updateItem) {
        if(!updateItem.updated) {
            this.$toastr.e('No fue posible guardar los cambios, intente mas tarde');
            return
        }

        this.editDialog = false;
        delete updateItem.table;
        delete updateItem.schema;
        delete updateItem.updated;
        this.censusItems.map(item => {
            if(item.iid == updateItem.iid) {
                return item = updateItem;
            }
        });

        this.$toastr.s("Registro actualizado con éxito");
      },
      savedRow(savedItem) {
        if(!savedItem.updated) {
            this.$toastr.e('No fue posible guardar los cambios, intente mas tarde');
            return
        }

        this.editDialog = false;
        delete savedItem.updated;
        this.$toastr.s("Registro guardado con éxito");
        this.getCensusTable();
      },
      async showSurveys(item) {
       // let editItem = await services.census().getEditRowInCensus(item);
        //if(!editItem.lError){
          this.$emit('showsurveys',item);
        //}

      },
      storedVisit(data) {
        console.log("🚀 ~ file: CensusDataTable.vue ~ line 286 ~ storedVisit ~ data", data)
        if(data) {
            this.visitDialog = false;
            this.$toastr.s('Visita guardada con éxito');
            return
        }
        this.$toastr.e('No se pudo guardar la visita');
      },
      cancelVisit(data) {
        if(data) {
            this.visitDialog = false;
        }
    }

}
}
</script>
<style>
    
</style>