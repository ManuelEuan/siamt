<template>
    <div>

        <v-card-text>
            <div class="row d-flex justify-space-around align-center mx-auto">
                <p class="col-md-6 my-0">Teléfonos</p>
                <v-col cols="12" md="6" v-if="!newPhone">
                    <v-btn depressed color="primary" @click="newPhone = true">
                        Nuevo teléfono
                    </v-btn>
                </v-col>
                <v-col cols="12" md="3" v-if="newPhone">
                    <v-btn depressed color="secondary" @click="codePostal = 0, newPhone = false">
                        Ver teléfonos
                    </v-btn>
                </v-col>
            </div>
            Nuevo: {{ newPhone }}
            Cant: {{ Object.keys(personaPhones).length }}+--
            <v-form v-model="phoneValidation" v-if="newPhone">
                <v-row>
                    <v-col cols="12" md="4">
                        <v-select v-model="phone.iidtelefono_tipo" label="Tipo*" :items="typePhones"
                            item-text="txtnombre" item-value="iidtelefono_tipo" hide-details="auto" small-chips
                            clearable dense outlined />
                    </v-col>

                    <!-- <v-col cols="12" md="4">
                        <v-select v-model="phone.ilada" label="Lada*" :items="ladaIdentifiers" item-text="txtnombre"
                            item-value="iidlada" hide-details="auto" small-chips clearable dense outlined />
                    </v-col> -->
                    <v-col cols="12" md="4">
                        <v-text-field v-model="phone.ilada" label="Lada" hide-details="auto" clearable dense outlined
                            maxlength="10" />
                    </v-col>

                    <v-col cols="12" md="4">
                        <v-text-field v-model="phone.inumero" label="Número" hide-details="auto" clearable dense
                            outlined maxlength="10" />
                    </v-col>


                </v-row>
            </v-form>
            <v-row v-if="personaPhones && Object.keys(personaPhones).length > 0 && !newPhone">
                <v-col cols="12" md="12">

                    <v-simple-table>
                        <template v-slot:default>
                            <thead>
                                <tr>
                                    <th class="text-left">
                                        Tipo
                                    </th>
                                    <th class="text-left">
                                        Lada
                                    </th>
                                    <th class="text-left">
                                        Teléfono
                                    </th>
                                    <th class="text-left">
                                        Actual
                                    </th>
                                    <th class="text-left">
                                        Acciones
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="item in personaPhones" :key="item.name">
                                    <td>{{ item.txttelefono_tipo }}</td>
                                    <td>+{{ item.ilada }}</td>
                                    <td>{{ item.inumero }}</td>
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
                                                <span>Editar teléfono</span>
                                            </v-tooltip>
                                            <v-tooltip bottom v-if="!item.bactual">
                                                <template v-slot:activator="{ on, attrs }">
                                                    <v-btn v-bind="attrs" v-on="on" icon small
                                                        @click="actionsHandler(item, 'newCurrentAddress')">
                                                        <v-icon small v-show="item.bactivo"> mdi-close </v-icon>
                                                        <v-icon small v-show="!item.bactivo"> mdi-check
                                                        </v-icon>
                                                    </v-btn>
                                                </template>
                                                <span>Activar teléfono</span>
                                            </v-tooltip>
                                            <v-tooltip bottom v-if="!item.bactual">
                                                <template v-slot:activator="{ on, attrs }">
                                                    <v-btn v-bind="attrs" v-on="on" icon small
                                                        @click="actionsHandler(item, 'delete')">
                                                        <v-icon small v-show="item.bactivo"> mdi-delete
                                                        </v-icon>
                                                        <v-icon small v-show="!item.bactivo"> mdi-check
                                                        </v-icon>
                                                    </v-btn>
                                                </template>
                                                <span>Eliminar teléfono</span>
                                            </v-tooltip>
                                        </template>
                                    </td>
                                </tr>
                            </tbody>
                        </template>
                    </v-simple-table>
                    <!-- </template> -->
                </v-col>
            </v-row>
        </v-card-text>

        <v-card-actions v-if="newPhone">
            <v-spacer />
            <v-btn color="error" text @click="dialog = false"> Cerrar </v-btn>
            <v-btn color="primary" text :disabled="!phoneValidation" @click="savePhone()"> Guardar
            </v-btn>
        </v-card-actions>
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
            newPhone: false,
            phoneValidation: false,
            dialogDelete: false,
            dialogNewCurrentAddress: false,
            updateCurrentAddress: 0,
            // iidpersona: null,
            // iidpersona: 84,
            phone: {
                iidtelefono: 0,
                ilada: '',
                inumero: '',
                iidtelefono_tipo: null,
                bactivo: null,
                dtfecha_creacion: null,
                dtfecha_modificacion: null,
            },
            bactual: true,
            rules: {
                ...rules,
            },
            typePhones: [],
            ladaIdentifiers: [],
            personaPhones: [],
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
        async loadPhonesTable() {
            try {
                console.log('LOAD PHONES')
                let response = await services.inspections().getPersonPhones(this.iidpersona);
                this.typePhones = await services.inspections().getAllTypePhones()
                // 
                console.log(response)
                console.log(this.typePhones)
                this.personaPhones = { ...response }
            } catch (error) {
                const message = 'Error al cargar las direcciones asociadas.';
                this.showError({ message, error });
            }
        },
        async savePhone() {
            console.log('Guardando teléfono');
            try {
                let data = {
                    iidpersona: this.iidpersona,
                    phone: this.phone,
                    bactual: this.bactual
                }
                console.log(data)
                if (!this.phone.iidtelefono) {
                    let response = await services.inspections().createPhone(data);
                    console.log('response del create')
                    console.log(response)
                    this.showSuccess(response.message);
                } else {
                    console.log('es edicion')
                    let response = await services.inspections().updatePhone(data);
                    console.log('response del update')
                    console.log(response)
                    this.showSuccess(response.message);

                }
                this.newPhone = false
                await this.loadPhonesTable();
                // this.$emit('direction-created', 'Esta es la dirección creada: ', this.direction);
                this.dialog = false
            } catch (error) {
                const message = 'Error al guardar phone.';
                this.showError({ message, error });
            }
        },
        actionsHandler(direction, action) {
            console.log('actionsHandler')
            console.log(direction)
            console.log(action)
            switch (action) {
                case 'edit':
                    this.direction = { ...direction }
                    this.codePostal = direction.icodigo_postal
                    this.newPhone = true
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
                await this.loadPhonesTable();
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
                await this.loadPhonesTable();
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
    },
    async mounted() {
        await this.getCodePostals();
        await this.loadPhonesTable();
    }
};
</script>

<style scoped>
/* Estilos específicos para el componente DirectionVerification.vue */
</style>