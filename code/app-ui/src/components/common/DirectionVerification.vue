<template>
    <div>
        <v-card-text>
            <!-- CAMPOS DE EVENTOS -->
            <div class="row d-flex justify-space-around align-center mx-auto" v-if="!newRegisterPerson">
                <p class="col-md-6 my-0">Direcciones</p>
                <v-col cols="12" md="3" v-if="!newAddress && !editAddress">
                    <v-btn depressed color="primary" @click="newAddress = true">
                        Nueva dirección
                    </v-btn>
                </v-col>
                <v-col cols="12" md="3" v-if="newAddress || editAddress">
                    <v-btn depressed color="info" @click="showAddresses()"
                        ref="refShowAddress">
                        Ver direcciones
                    </v-btn>
                </v-col>
                <v-col cols="12" md="3" v-if="newAddress || editAddress">
                    <v-btn depressed color="primary" :disabled="!directionValidation" @click="saveDirection()">
                        {{ editAddress ? 'Actualizar' : 'Guardar' }}
                    </v-btn>
                </v-col>
            </div>

            <!-- TABLA DE DIRECCIONES -->
            <v-row v-if="personaAddresses && Object.keys(personaAddresses).length > 0 && !newAddress && !editAddress">
                <v-col cols="12" md="12">
                    <v-simple-table>
                        <template v-slot:default>
                            <thead>
                                <tr>
                                    <th class="text-left">
                                        Dirección
                                    </th>
                                    <th class="text-left">
                                        Actual
                                    </th>
                                    <th class="text-left" style="min-width: 140px;">
                                        Acciones
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="item in personaAddresses" :key="item.iiddireccion">
                                    <!-- {{ item }} -->
                                    <td>{{ item.direccion_completa }}</td>
                                    <td>
                                        <template item.bactual>
                                            <v-icon v-show="item.bactual" size="medium" color="green"> mdi-check
                                            </v-icon>
                                            <v-icon v-show="!item.bactual" size="medium" color="red">mdi-close</v-icon>
                                        </template>
                                    </td>
                                    <td>
                                        <template>
                                            <v-tooltip bottom>
                                                <template v-slot:activator="{ on, attrs }">
                                                    <v-btn v-bind="attrs" v-on="on" icon small
                                                        @click="actionsHandlerOfTable(item, 'editAddress')">
                                                        <v-icon small> mdi-square-edit-outline </v-icon>
                                                    </v-btn>
                                                </template>
                                                <span>Editar dirección</span>
                                            </v-tooltip>
                                            <v-tooltip bottom v-if="!item.bactual">
                                                <template v-slot:activator="{ on, attrs }">
                                                    <v-btn v-bind="attrs" v-on="on" icon small
                                                        @click="actionsHandlerOfTable(item, 'newCurrentAddress')">
                                                        <v-icon small v-show="item.bactivo"> mdi-close </v-icon>
                                                        <v-icon small v-show="!item.bactivo"> mdi-check </v-icon>
                                                    </v-btn>
                                                </template>
                                                <span>Activar dirección</span>
                                            </v-tooltip>
                                            <v-tooltip bottom v-if="!item.bactual">
                                                <template v-slot:activator="{ on, attrs }">
                                                    <v-btn v-bind="attrs" v-on="on" icon small
                                                        @click="actionsHandlerOfTable(item, 'deleteAddress')">
                                                        <v-icon small v-show="item.bactivo"> mdi-delete </v-icon>
                                                        <v-icon small v-show="!item.bactivo"> mdi-check </v-icon>
                                                    </v-btn>
                                                </template>
                                                <span>Eliminar dirección</span>
                                            </v-tooltip>
                                        </template>
                                    </td>
                                </tr>
                            </tbody>

                        </template>
                    </v-simple-table>
                </v-col>
            </v-row>

            <!-- CAMPOS DE AGREGAR - MODIFICAR -->
            <v-form v-model="directionValidation" v-if="newAddress || newRegisterPerson || editAddress">
                <v-row>
                    <v-col cols="12" md="4">
                        <v-select v-model="codePostal" label="Código postal*" :items="postalCodes"
                            item-text="icodigo_postal" item-value="icodigo_postal" hide-details="auto" small-chips
                            clearable dense :rules="[rules.required]" outlined />
                    </v-col>
                    <v-col cols="12" md="4" v-if="codePostal">
                        <v-text-field v-model="entity" label="Estado" hide-details="auto" clearable dense outlined
                            disabled />
                    </v-col>
                    <v-col cols="12" md="4" v-if="codePostal">
                        <v-text-field v-model="municipality" label="Municipio*" hide-details="auto" clearable dense
                            outlined disabled />
                    </v-col>
                    <v-col cols="12" md="12" class="text-center" v-if="codePostal">
                        <v-radio-group v-model="direction.itipo_direccion" row class="p-radio"
                            :rules="[rules.required]">
                            <v-radio v-for="(directionOption, index) in typeDirections" :key="index"
                                :label="directionOption.txtnombre" :value="directionOption.itipo_direccion"></v-radio>
                        </v-radio-group>
                    </v-col>
                </v-row>

                <v-row v-if="codePostal">
                    <v-col cols="12" md="6">
                        <v-select v-model="direction.iidcolonia" label="Colonia*" :items="colonies"
                            item-text="txtnombre" item-value="iidcolonia" hide-details="auto" small-chips clearable
                            dense :rules="[rules.required]" outlined :disabled="!codePostal" />
                    </v-col>
                    <v-col cols="12" md="6" v-if="codePostal && direction.itipo_direccion === 1">
                        <v-select v-model="direction.itipo_vialidad" label="Tipo vialidad*" :items="vialidadTypes"
                            item-text="txtnombre" item-value="itipo_vialidad" hide-details="auto" small-chips clearable
                            dense :rules="[rules.required]" outlined :disabled="!codePostal" />
                    </v-col>
                    <v-col cols="12" md="6" v-if="codePostal && direction.itipo_direccion === 2">
                        <v-text-field v-model="direction.txttablaje" label="Tablaje*" hide-details="auto" clearable
                            dense outlined :rules="[rules.required]" />
                    </v-col>
                    <v-col cols="12" md="6" v-if="codePostal && direction.itipo_direccion === 3">
                        <v-text-field v-model="direction.txtdescripcion_direccion" label="Descripción dirección*"
                            hide-details="auto" clearable dense outlined :rules="[rules.required]" />
                    </v-col>
                </v-row>
                <v-row v-if="codePostal && direction.itipo_direccion === 1">
                    <v-col cols="12" md="6" v-if="direction.itipo_vialidad === 1">
                        <v-text-field v-model="direction.txtcalle" label="Calle principal/s*" hide-details="auto"
                            clearable dense outlined :rules="[rules.required]" />
                    </v-col>
                    <v-col cols="12" md="6" v-if="direction.itipo_vialidad === 1">
                        <v-text-field v-model="direction.txtcalle_letra" label="Calle letra" hide-details="auto"
                            clearable dense outlined />
                    </v-col>
                    <v-col cols="12" md="6" v-if="direction.itipo_vialidad === 2">
                        <v-text-field v-model="direction.txtavenida_kilometro" label="Avenida o Km*" hide-details="auto"
                            clearable dense outlined />
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="direction.inumero_exterior" label="Número exterior*" hide-details="auto"
                            clearable dense outlined :rules="[rules.required]" />

                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="direction.txtnumero_exterior_letra" label="Numero exterior letra"
                            hide-details="auto" clearable dense outlined />
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="direction.inumero_interior" label="Número interior" hide-details="auto"
                            clearable dense outlined :rules="[rules.ifNotEmptyInt]" />
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="direction.txtnumero_interior_letra" label="Número interior letra"
                            hide-details="auto" clearable dense outlined />
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="direction.txtcruzamiento_uno" label="Cruzamiento uno" hide-details="auto"
                            clearable dense outlined />
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="direction.txtcruzamiento_uno_letra" label="Cruzamiento uno letra"
                            hide-details="auto" clearable dense outlined />
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="direction.txtcruzamiento_dos" label="Cruzamiento dos" hide-details="auto"
                            clearable dense outlined />
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="direction.txtcruzamiento_dos_letra" label="Cruzamiento dos letra"
                            hide-details="auto" clearable dense outlined />
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="direction.txtreferencia" label="Referencia" hide-details="auto" clearable
                            dense outlined />
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="direction.flatitud" label="Latitud" hide-details="auto" clearable dense
                            maxlength="15" outlined :rules="[rules.latitud]" />
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="direction.flongitud" label="Longitud" hide-details="auto" clearable dense
                            maxlength="15" outlined :rules="[rules.longitud]" />
                    </v-col>
                    <v-col cols="12" md="6" v-if="direction.flatitud && direction.flongitud">
                        <v-btn color="primary" text @click="verifyDirection()"> Verificar </v-btn>

                    </v-col>
                </v-row>


            </v-form>
        </v-card-text>

        <!-- DIALOG GENERIC ACTUALIZAR DIRECCION ACTUAL -->
        <generic-dialog :dialogVisible="dialogNewCurrentAddress"
            dialogTitle="Actualizar dirección principal"
            @update:dialogVisible="dialogNewCurrentAddress = $event" @confirm="updateCurrentAddress">
            <template v-slot:default>
                Este cambio implica que esta es la nueva dirección actual ¿Desea seguir con el proceso?
            </template>
        </generic-dialog>

        <!-- DIALOG ACTUALIZAR DESACTIVAR DIRECCIÓN -->
        <generic-dialog :dialogVisible="dialogDeleteAddress"
            dialogTitle="Eliminar dirección"
            @update:dialogVisible="dialogDeleteAddress = $event" @confirm="deleteDirection">
            <template v-slot:default>
                ¿Estás seguro de que deseas Eliminar esta dirección?
            </template>
        </generic-dialog>
    </div>
</template>

<script>
import rules from "@/core/rules.forms";
import services from "@/services";
import { mapActions } from "vuex";
import GenericDialog from '@/components/common/GenericDialog.vue';

export default {
    components: {
        GenericDialog,
    },
    props: {
        iidpersona: {
            type: Number,
            default: 0 // Valor predeterminado
        },
    },
    data() {
        return {
            // DATOS INFORMATIVOS
            entity: '',
            municipality: '',
            editAddress: false, // SI ES MODO EDICIÓN SE MUESTRAN CAMPOS DE DIRECCIÓN Y BOTÓN DE EVENTO ES ACTUALIZAR
            
            // WATCHERS FUNCIONALIDAD
            newRegisterPerson: false, // SI ES UN NUEVO REGISTRO NO MUESTRA BOTONES DE EVENTOS Y DIRECTO MANDA A CAPTURA DE DIRECCIÓN
            newAddress: false, // SI ES NUEVA DIRECCIÓN SE RESETEAN LOS VALORES
            codePostal: 0, // SI CAMBIA EL C.P. TARERÁ EL ESTADO Y MUNICIPIO
            directionValidation: false, // SE VERIFICA QUE LOS CAMPOS SEAN VÁLIDOS EN CASO DE SER NUEVOS O ESTAR EN MODO EDICIÓN

            // VIENEN DE SERVICIOS
            postalCodes: [],
            colonies: [],
            personaAddresses: [],

            // MODALES
            dialogDeleteAddress: false,
            dialogNewCurrentAddress: false,

            // ARREGLOS
            typeDirections: [
                {
                    "itipo_direccion": 1,
                    "txtnombre": "Predio",
                },
                {
                    "itipo_direccion": 2,
                    "txtnombre": "Tablaje"
                },
                {
                    "itipo_direccion": 3,
                    "txtnombre": "Domicilio Conocido"
                }
            ],
            vialidadTypes: [
                {
                    "itipo_vialidad": 1,
                    "txtnombre": "Calle",
                },
                {
                    "itipo_vialidad": 2,
                    "txtnombre": "Avenida o Km"
                }
            ],
            direction: {
                iidcolonia: 0,
                txtcalle: '',
                txtcalle_letra: '',
                inumero_exterior: null,
                txtnumero_exterior_letra: '',
                inumero_interior: null,
                txtnumero_interior_letra: '',
                txtcruzamiento_uno: '',
                txtcruzamiento_uno_letra: '',
                txtcruzamiento_dos: '',
                txtcruzamiento_dos_letra: '',
                txtreferencia: '',
                flatitud: null,
                flongitud: null,
                bactivo: null,
                dtfecha_creacion: null,
                dtfecha_modificacion: null,
                itipo_direccion: null,
                itipo_vialidad: 0,
                txtavenida_kilometro: '',
                txttablaje: '',
                txtdescripcion_direccion: '',
            },
            
            // REGLAS
            rules: {
                ...rules,
            },
        };
    },
    methods: {
        ...mapActions('app', ['showError', 'showSuccess']),

        // OBTENER CÓDIGOS POSTALES
        async getCodePostals() {
            try {
                this.postalCodes = await services.inspections().getAllPostalCodes();
            } catch (error) {
                const message = 'Error al cargar opciones de códigos postales.';
                this.showError({ message, error });
            }
        },

        // OBTENER ESTADO Y MUNICIPIO SEGÚN CÓDIGO POSTAL
        async getMunicipalityAndEntityByPostalCode() {
            try {
                let { entity, municipality } = await services.inspections().getMunicipalityAndEntityByPostalCode(this.codePostal);
                this.entity = entity;
                this.municipality = municipality;
                this.colonies = await services.inspections().getColoniesByPostalCode(this.codePostal);
            } catch (error) {
                const message = 'Error al cargar opciones para nuevo inspector.';
                this.showError({ message, error });
            }
        },

        // CARGA DE LAS DIRECCIONES ASOCIADAS A LA PERSONA
        async loadDirectionsTable() {
            try {
                console.log('LOAD DIRECTIONS')
                this.newRegisterPerson = localStorage.getItem('newPerson');
                this.newRegisterPerson = this.newRegisterPerson === 'true';
                if (this.newRegisterPerson) {
                    this.newAddress = true
                } else {
                    this.newAddress = false
                }
                await this.getCodePostals();
                this.personaAddresses = await services.inspections().getPersonAddresses(this.iidpersona);
                //  = { ...response }
            } catch (error) {
                const message = 'Error al cargar las direcciones asociadas.';
                this.showError({ message, error });
            }
        },

        // RESETEO DE DIRECCIÓN EN CASO DE SER NUEVA
        resetDirection() {
            this.codePostal = 0,
            this.direction = {
                iidcolonia: 0,
                txtcalle: '',
                txtcalle_letra: '',
                inumero_exterior: null,
                txtnumero_exterior_letra: '',
                inumero_interior: null,
                txtnumero_interior_letra: '',
                txtcruzamiento_uno: '',
                txtcruzamiento_uno_letra: '',
                txtcruzamiento_dos: '',
                txtcruzamiento_dos_letra: '',
                txtreferencia: '',
                flatitud: null,
                flongitud: null,
                bactivo: null,
                dtfecha_creacion: null,
                dtfecha_modificacion: null,
                itipo_direccion: null,
                itipo_vialidad: 0,
                txtavenida_kilometro: '',
                txttablaje: '',
                txtdescripcion_direccion: '',
            }
        },

        showAddresses(){
            this.newAddress = false, 
            this.editAddress = false,
            this.resetDirection()
            this.emitToParentComponent()
        },

        // GUARDADO DE DIRECCIÓN INDEPENDIENTE
        async saveDirection() {
            console.log('Guardando Direction');
            try {
                let data = {
                    iidpersona: this.iidpersona,
                    direction: this.direction,
                }
                console.log(data)
                if (!this.direction.iiddireccion) {
                    let response = await services.inspections().createDirection(data);
                    console.log('direction create')
                    this.showSuccess(response.message);
                    this.newAddress = true
                } else {
                    let response = await services.inspections().updateAddress(data);
                    console.log('direction update')
                    this.showSuccess(response.message);
                    this.editAddress = false
                }
                await this.loadDirectionsTable();
            } catch (error) {
                const message = 'Error al guardar persona.';
                this.showError({ message, error });
            }
        },

        // ACA SE PUEDE PONER LA GEOLOCALIZACIÓN
        verifyDirection() {
            const url = `https://www.google.com/maps?q=${this.direction.flatitud},${this.direction.flongitud}`;
            window.open(url);
        },

        // MANEJADOR DE ACCIONES
        actionsHandlerOfTable(direction, action) {
            switch (action) {
                case 'editAddress':
                    this.direction = { ...direction }
                    this.codePostal = direction.icodigo_postal
                    this.editAddress = true
                    break;
                case 'newCurrentAddress':
                    this.dialogNewCurrentAddress = true;
                    this.selectedAddress = direction.iiddireccion
                    break;
                case 'delete':
                    this.dialogDeleteAddress = true;
                    this.selectedAddress = direction.iiddireccion
                    break;
                default: this.$refs.dialogs.show[action] = true;
            }
        },

        // ACTUALIZAR A DIRECCIÓN ACTUAL (BD)
        async updateCurrentAddress() {
            try {
                let data = {
                    iidpersona: this.iidpersona,
                    selectedAddress: this.selectedAddress
                }
                console.log('Carga de nuevos datos para dirección actual')
                let response = await services.inspections().updateCurrentAddress(data);
                await this.loadDirectionsTable();
                this.dialogNewCurrentAddress = false
                this.showSuccess(response.message);
            } catch (error) {
                const message = 'Error al cargar los datos dirección actual.';
                this.showError({ message, error });
            }
        },

        // BORRAR DIRECCIÓN (BD)
        async deleteDirection() {
            try {
                let data = {
                    iidpersona: this.iidpersona,
                    selectedAddress: this.selectedAddress
                }
                const { message } = await services.inspections().deleteAddress(data);
                await this.loadDirectionsTable();
                this.dialogDeleteAddress = false
                this.showSuccess(message);
            } catch (error) {
                const message = 'Error al activar/desactivar inspector.';
                this.showError({ message, error });
            }
        },

        // EMITIR A COMPONENTE PADRE
        emitToParentComponent(){
            console.log('🚀 ~ emitToParentComponent ~ 🚀 sending editing mode, address, validation 🚀')
            let newOrEdit = false
            if(this.newAddress || this.editAddress){
                newOrEdit = true
            }
            this.$emit('direction-validation', newOrEdit, this.direction, this.directionValidation);
        }
    },
    watch: {
        // WATCHERS PROP
        'iidpersona': function () {
            console.log('watch iidpersona')
            this.loadDirectionsTable()
        },

        // WATCHERS DATA
        'newRegisterPerson': function () {
            console.log('watch newRegisterPerson')
            if (this.newRegisterPerson) {
                this.resetDirection()
                this.newAddress = true
            } else {
                this.$refs.refShowAddress.click()
            }
        },
        'newAddress': function () {
            console.log('watch newAddress')
            if (this.newAddress) {
                this.resetDirection()
                this.direction.itipo_direccion = this.typeDirections[0].itipo_direccion;
            }
        },
        'codePostal': function () {
            console.log('watch codePostal')
            if (this.codePostal !== 0) {
                this.getMunicipalityAndEntityByPostalCode()
            }
        },
        'directionValidation': function () {
            console.log('watch directionValidation')
            this.emitToParentComponent()
        },
    },
    async mounted() {
        await this.loadDirectionsTable();
    }
};
</script>