<template>
    <div>
        <v-card-text>
            <div class="row d-flex justify-space-around align-center mx-auto">
                <p class="col-md-6 my-0">Direcciones</p>
                <v-col cols="12" md="3" v-if="!newDirection">
                    <v-btn depressed color="primary" @click="newDirection = true">
                        Nueva dirección
                    </v-btn>
                </v-col>
                <v-col cols="12" md="3" v-if="newDirection">
                    <v-btn depressed color="primary" @click="codePostal = 0, newDirection = false">
                        Ver direcciones
                    </v-btn>
                </v-col>
                <v-col cols="12" md="3" v-if="newDirection">
                    <v-btn depressed color="primary" :disabled="!directionValidation" @click="saveDirection()">
                       Agregar dirección
                    </v-btn>
                </v-col>
            </div>
            <!-- TABLA DE DIRECCIONES -->
            <!-- {{ Object.keys(personaAddresses).length }} -->
            <v-row v-if="personaAddresses && Object.keys(personaAddresses).length > 0 && !newDirection">
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
                                                        @click="actionsHandler(item, 'edit')">
                                                        <v-icon small> mdi-square-edit-outline </v-icon>
                                                    </v-btn>
                                                </template>
                                                <span>Editar dirección</span>
                                            </v-tooltip>
                                            <v-tooltip bottom v-if="!item.bactual">
                                                <template v-slot:activator="{ on, attrs }">
                                                    <v-btn v-bind="attrs" v-on="on" icon small
                                                        @click="actionsHandler(item, 'newCurrentAddress')">
                                                        <v-icon small v-show="item.bactivo"> mdi-close </v-icon>
                                                        <v-icon small v-show="!item.bactivo"> mdi-check </v-icon>
                                                    </v-btn>
                                                </template>
                                                <span>Activar dirección</span>
                                            </v-tooltip>
                                            <v-tooltip bottom v-if="!item.bactual">
                                                <template v-slot:activator="{ on, attrs }">
                                                    <v-btn v-bind="attrs" v-on="on" icon small
                                                        @click="actionsHandler(item, 'delete')">
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

            <!-- CAMPOS DE DIRECCIÓN -->
            <v-form v-model="directionValidation" v-if="newDirection">
                <v-row>
                    <v-col cols="12" md="6" v-if="codePostal">
                        <v-text-field v-model="entity" label="Estado" hide-details="auto" clearable dense outlined
                            disabled />
                    </v-col>
                    <v-col cols="12" md="6" v-if="codePostal">
                        <v-text-field v-model="municipality" label="Municipio*" hide-details="auto" clearable dense
                            outlined disabled />
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-select v-model="codePostal" label="Código postal*" :items="postalCodes"
                            item-text="icodigo_postal" item-value="icodigo_postal" hide-details="auto" small-chips
                            clearable dense :rules="[rules.required]" outlined />
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-select v-model="direction.iidcolonia" label="Colonia*" :items="colonies"
                            item-text="txtnombre" item-value="iidcolonia" hide-details="auto" small-chips clearable
                            dense :rules="[rules.required]" outlined :disabled="!codePostal" />
                    </v-col>
                </v-row>
                <v-row v-if="codePostal">
                    <v-col cols="12" md="6">
                        <v-text-field v-model="direction.txtcalle" label="Calle principal/s*" hide-details="auto"
                            clearable dense outlined :rules="[rules.required]" />
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="direction.txtcalle_letra" label="Calle letra*" hide-details="auto"
                            clearable dense outlined />
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="direction.inumero_exterior" label="Número exterior*" hide-details="auto"
                            clearable dense outlined :rules="[rules.number]" />

                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="direction.txtnumero_exterior_letra" label="Numero exterior letra*"
                            hide-details="auto" clearable dense outlined />
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="direction.inumero_interior" label="Número interior*" hide-details="auto"
                            clearable dense outlined :rules="[rules.number]" />
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="direction.txtnumero_interior_letra" label="Número interior letra*"
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
                        <v-text-field v-model="direction.flatitud" label="Latitud" hide-details="auto" clearable dense maxlength="15" 
                            outlined :rules="[rules.latitud]" />
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="direction.flongitud" label="Longitud" hide-details="auto" clearable dense maxlength="15" 
                            outlined :rules="[rules.longitud]" />
                    </v-col>
                    <v-col cols="12" md="6" v-if="direction.flatitud && direction.flongitud">
                        <v-btn color="primary" text @click="verifyDirection()"> Verificar </v-btn>

                    </v-col>


                </v-row>
            </v-form>
        </v-card-text>
        <!-- DIALOG ACTUALIZAR DIRECCION ACTUAL -->
        <template>
            <v-dialog v-model="dialogNewCurrentAddress" transition="dialog-bottom-transition" persistent
                max-width="600">
                <v-card>
                    <v-card-title class="text-uppercase primary--text text-h6 py-2">
                        Actualizar dirección principal
                    </v-card-title>
                    <v-card-text>
                        Este cambio implica que esta es la nueva dirección actual ¿Desea seguir con el proceso?
                    </v-card-text>

                    <v-card-actions>
                        <v-spacer />
                        <v-btn color="error" text @click="updateCurrentAddress = 0, dialogNewCurrentAddress = false">
                            Cancelar </v-btn>
                        <v-btn color="primary" text @click="updateCurrentAddressMethod"> Aceptar </v-btn>
                    </v-card-actions>
                </v-card>
            </v-dialog>
        </template>
        <!-- DIALOG ACTUALIZAR DESACTIVAR DIRECCIÓN -->

        <template>
            <v-dialog transition="dialog-top-transition" max-width="600" v-model="dialogDelete">
                <v-card>
                    <v-card-title class="text-uppercase primary--text text-h6 py-2">
                        Eliminar dirección
                    </v-card-title>
                    <v-divider></v-divider>
                    <v-card-text class="text-lowercase text-body-1 py-2">
                        ¿est&aacute;s seguro de que deseas Eliminar este
                        dirección?
                    </v-card-text>
                    <v-divider></v-divider>
                    <v-card-actions class="py-2">
                        <v-spacer></v-spacer>
                        <v-btn color="error" text @click="dialogDelete = false"> Cerrar </v-btn>
                        <v-btn color="primary" text @click="deleteDirection">
                            Eliminar
                        </v-btn>
                    </v-card-actions>
                </v-card>
            </v-dialog>
        </template>
    </div>
</template>

<script>
import rules from "@/core/rules.forms";
import services from "@/services";
import { mapActions } from "vuex";
export default {
    props: {
        iidpersona: {
            type: Number,
            default: 0 // Valor predeterminado
        },
    },
    data() {
        return {
            newDirection: false,
            directionValidation: false,
            entity: '',
            municipality: '',
            codePostal: 0,
            postalCodes: [],
            colonies: [],
            dialogDelete: false,
            dialogNewCurrentAddress: false,
            updateCurrentAddress: 0,
            // iidpersona: null,
            // iidpersona: 84,
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
            },
            bactual: true,
            rules: {
                ...rules,
                number: v => v === '' || v === null || v === undefined || /^\d+$/.test(v) || 'El campo solo puede contener números',
                float: v => v === '' || v === null || v === undefined || /^\d+(\.\d+)?$/.test(v) || 'El campo solo puede contener números'
            },
            personaAddresses: [],

        };
    },
    computed: {

    },
    methods: {
        ...mapActions('app', ['showError', 'showSuccess']),
        async getCodePostals() {
            try {
                this.postalCodes = await services.inspections().getAllPostalCodes();
            } catch (error) {
                const message = 'Error al cargar opciones para nuevo inspector.';
                this.showError({ message, error });
            }
        },
        async loadDirectionsTable() {
            try {
                console.log('LOAD DIRECTIONS')
                let response = await services.inspections().getPersonAddresses(this.iidpersona);
                this.personaAddresses = { ...response }
            } catch (error) {
                const message = 'Error al cargar las direcciones asociadas.';
                this.showError({ message, error });
            }
        },
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
        async saveDirection() {
            console.log('Guardando Direction');
            try {
                let data = {
                    iidpersona: this.iidpersona,
                    direction: this.direction,
                    bactual: this.bactual
                }
                console.log(data)
                if (!this.direction.iiddireccion) {
                    let response = await services.inspections().createDirection(data);
                    console.log('response del create')
                    console.log(response)
                    this.showSuccess(response.message);
                } else {
                    console.log('es edicion')
                    let response = await services.inspections().updateAddress(data);
                    console.log('response del update')
                    console.log(response)
                    this.showSuccess(response.message);

                }
                this.newDirection = false
                await this.loadDirectionsTable();
                // this.$emit('direction-created', 'Esta es la dirección creada: ', this.direction);
                this.dialog = false
            } catch (error) {
                const message = 'Error al guardar persona.';
                this.showError({ message, error });
            }
        },
        verifyDirection(){
            const url = `https://www.google.com/maps?q=${this.direction.flatitud},${this.direction.flongitud}`;
            window.open(url);
        },
        actionsHandler(direction, action) {
            console.log('actionsHandler')
            console.log(direction)
            console.log(action)
            switch (action) {
                case 'edit':
                    this.direction = { ...direction }
                    this.codePostal = direction.icodigo_postal
                    this.newDirection = true
                    break;
                case 'newCurrentAddress':
                    this.dialogNewCurrentAddress = true;
                    this.selectedAddress = direction.iiddireccion
                    break;
                case 'delete':
                    this.dialogDelete = true;
                    this.selectedAddress = direction.iiddireccion
                    break;
                default: this.$refs.dialogs.show[action] = true;
            }
        },
        async updateCurrentAddressMethod() {
            try {
                let data = {
                    iidpersona: this.iidpersona,
                    selectedAddress: this.selectedAddress
                }
                console.log('data para update')
                let response = await services.inspections().updateCurrentAddress(data);
                console.log(response)
                await this.loadDirectionsTable();
                this.dialogNewCurrentAddress = false
                this.showSuccess(response.message);
            } catch (error) {
                const message = 'Error al actualizar.';
                this.showError({ message, error });
            }
        },
        async deleteDirection() {
            try {
                let data = {
                    iidpersona: this.iidpersona,
                    selectedAddress: this.selectedAddress
                }
                const { message } = await services.inspections().deleteAddress(data);
                // await this.loadInspectorsTable();
                await this.loadDirectionsTable();
                this.dialogDelete = false
                this.showSuccess(message);
                // this.showSuccess(response.message);

                // this.dialogDelete ? false
            } catch (error) {
                const message = 'Error al activar/desactivar inspector.';
                this.showError({ message, error });
            }

        },

    },
    watch: {
        'codePostal': function () {
            console.log('hsuhuihiu')
            console.log(this.codePostal)
            if (this.codePostal === 0) {
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
                }
            } else {
                this.getMunicipalityAndEntityByPostalCode()
            }
        },
        'directionValidation': function (){
        // directionValidation(newValidation) {
            console.log('validación dirección')
            console.log(this.directionValidation)
            this.$emit('direction-validation', this.directionValidation);
        }
    },
    async mounted() {
        await this.getCodePostals();
        await this.loadDirectionsTable();
    }
};
</script>

<style scoped>
/* Estilos específicos para el componente DirectionVerification.vue */
</style>