<template>
    <div>
        <!-- CAMPOS DE EVENTOS -->
        <v-row class="mx-auto" v-if="!newRegisterPerson">
            <v-col cols="12" md="12" class="d-flex justify-end py-1"
                v-if="!newAddress && !editAddress && peopleModulePermissions.includes('crdp')">
                <v-btn depressed color="primary" @click="newAddress = true">
                    Nueva dirección
                </v-btn>
            </v-col>
            <v-col cols="12" sm="6" class="d-flex justify-end py-1" v-if="newAddress || editAddress">
                <v-btn depressed color="info" @click="showAddresses()">
                    Ver direcciones
                </v-btn>
            </v-col>
            <v-col cols="12" sm="6" class="d-flex justify-end py-1" v-if="newAddress || editAddress">
                <v-btn v-if="editAddress && peopleModulePermissions.includes('eddp')" depressed color="primary"
                    :disabled="!addressValidation" @click="saveAddress()">
                    Actualizar
                </v-btn>
                <v-btn v-else-if="!editAddress && peopleModulePermissions.includes('crdp')" depressed color="primary"
                    :disabled="!addressValidation" @click="saveAddress()">
                    Guardar
                </v-btn>
            </v-col>
        </v-row>

        <!-- TABLA DE DIRECCIONES -->
        <v-data-table :headers="headers" :items="personAddresses"
            v-if="personAddresses && Object.keys(personAddresses).length > 0 && !newAddress && !editAddress">
            <template v-slot:item.bactual="{ item }">
                <v-icon v-show="item.bactual" size="medium" color="green">mdi-check</v-icon>
                <v-icon v-show="!item.bactual" size="medium" color="red">mdi-close</v-icon>
            </template>
            <template v-slot:item.actions="{ item }">
                <div v-if="peopleModulePermissions.includes('eddp')" style="min-width: 85px;">
                    <v-tooltip bottom>
                        <template v-slot:activator="{ on, attrs }">
                            <v-btn v-bind="attrs" v-on="on" icon small
                                @click="actionsHandlerOfTable(item, 'editAddress')">
                                <v-icon small>mdi-square-edit-outline</v-icon>
                            </v-btn>
                        </template>
                        <span>Editar dirección</span>
                    </v-tooltip>
                    <v-tooltip bottom v-if="!item.bactual">
                        <template v-slot:activator="{ on, attrs }">
                            <v-btn v-bind="attrs" v-on="on" icon small
                                @click="actionsHandlerOfTable(item, 'newCurrentAddress')">
                                <v-icon small v-show="item.bactivo">mdi-close</v-icon>
                                <v-icon small v-show="!item.bactivo">mdi-check</v-icon>
                            </v-btn>
                        </template>
                        <span>Activar dirección</span>
                    </v-tooltip>
                    <v-tooltip bottom v-if="!item.bactual">
                        <template v-slot:activator="{ on, attrs }">
                            <v-btn v-bind="attrs" v-on="on" icon small
                                @click="actionsHandlerOfTable(item, 'deleteAddress')">
                                <v-icon small v-show="item.bactivo">mdi-delete</v-icon>
                                <v-icon small v-show="!item.bactivo">mdi-check</v-icon>
                            </v-btn>
                        </template>
                        <span>Eliminar dirección</span>
                    </v-tooltip>
                </div>
                <div v-else>
                    Sin permisos
                </div>
            </template>
        </v-data-table>

        <!-- CAMPOS DE AGREGAR - MODIFICAR -->
        <v-form v-model="addressValidation" v-if="newAddress || newRegisterPerson || editAddress">
            <v-row>
                <v-col cols="12" md="4">
                    <v-autocomplete v-model="codePostal" label="Código postal*" :items="postalCodes"
                        item-text="icodigo_postal" item-value="icodigo_postal" hide-details="auto" small-chips clearable
                        dense :rules="[rules.required]" outlined />
                </v-col>
                <v-col cols="12" md="4" v-if="codePostal">
                    <v-text-field v-model="entity" label="Estado" hide-details="auto" clearable dense outlined
                        disabled />
                </v-col>
                <v-col cols="12" md="4" v-if="codePostal">
                    <v-text-field v-model="municipality" label="Municipio*" hide-details="auto" clearable dense outlined
                        disabled />
                </v-col>
                <v-col cols="12" md="12" class="text-center" v-if="codePostal">
                    <v-radio-group v-model="address.iidtipo_direccion" row class="p-radio" :rules="[rules.required]">
                        <v-radio v-for="(addressOption, index) in typesAddress" :key="index"
                            :label="addressOption.txtnombre" :value="addressOption.iidtipo_direccion"></v-radio>
                    </v-radio-group>
                </v-col>
            </v-row>

            <v-row v-if="codePostal">
                <v-col cols="12" md="6">
                    <!-- <v-autocomplete v-model="address.iidcolonia" :items="colonies" item-text="txtasentamiento"
                        item-value="iidcolonia" label="Colonia*" hide-details="auto" small-chips clearable dense
                        :rules="[rules.required]" outlined :disabled="!codePostal"></v-autocomplete> -->
                    <v-text-field v-model="address.txtcolonia" label="Colonia*" hide-details="auto" clearable dense
                        outlined :rules="[rules.required]" />
                </v-col>
                <v-col cols="12" md="6" v-if="codePostal && address.iidtipo_direccion === 1">
                    <v-autocomplete v-model="address.iidtipo_vialidad" label="Tipo vialidad*" :items="typesRoads"
                        item-text="txtnombre" item-value="iidtipo_vialidad" hide-details="auto" small-chips clearable
                        dense :rules="[rules.required]" outlined :disabled="!codePostal" />
                </v-col>
                <!-- <v-col cols="12" md="6" v-if="address.iidtipo_vialidad === 1">
                    <v-text-field v-model="address.txtcalle" label="Calle principal/s*" hide-details="auto" clearable
                        dense outlined :rules="[rules.required]" />
                </v-col> -->
                <!-- <v-col cols="12" md="6" v-if="codePostal && address.iidtipo_direccion === 2">
                    <v-text-field v-model="address.txttablaje" label="Tablaje*" hide-details="auto" clearable dense
                        outlined :rules="[rules.required]" />
                </v-col> -->
                <!-- <v-col cols="12" md="6" v-if="codePostal && address.iidtipo_direccion === 3">
                    <v-text-field v-model="address.txtdescripcion_direccion" label="Descripción dirección*"
                        hide-details="auto" clearable dense outlined :rules="[rules.required]" />
                </v-col> -->
                <v-col cols="12" md="6" v-if="codePostal && address.iidtipo_direccion === 2">
                    <v-text-field v-model="address.txtcalle" label="Tablaje*" hide-details="auto" clearable dense
                        outlined :rules="[rules.required]" />
                </v-col>
                <v-col cols="12" md="6" v-if="codePostal && address.iidtipo_direccion === 3">
                    <v-text-field v-model="address.txtcalle" label="Descripción dirección*" hide-details="auto"
                        clearable dense outlined :rules="[rules.required]" />
                </v-col>
            </v-row>
            <v-row v-if="codePostal && address.iidtipo_direccion === 1">
                <v-col cols="12" md="6" v-if="address.iidtipo_vialidad === 1">
                    <v-text-field v-model="address.txtcalle" label="Calle principal/s*" hide-details="auto" clearable
                        dense outlined :rules="[rules.required]" />
                </v-col>
                <v-col cols="12" md="6" v-if="address.iidtipo_vialidad === 1">
                    <v-text-field v-model="address.txtcalle_letra" label="Calle letra" hide-details="auto" clearable
                        dense outlined />
                </v-col>
                <v-col cols="12" md="6" v-if="address.iidtipo_vialidad === 2">
                    <v-text-field v-model="address.txtavenida_kilometro" label="Avenida o Km*" hide-details="auto"
                        clearable dense outlined />
                </v-col>
                <v-col cols="12" md="6">
                    <v-text-field v-model="address.inumero_exterior" label="Número exterior*" hide-details="auto"
                        clearable dense outlined :rules="[rules.required]" />

                </v-col>
                <v-col cols="12" md="6">
                    <v-text-field v-model="address.txtnumero_exterior_letra" label="Numero exterior letra"
                        hide-details="auto" clearable dense outlined />
                </v-col>
                <v-col cols="12" md="6">
                    <v-text-field v-model="address.inumero_interior" label="Número interior" hide-details="auto"
                        clearable dense outlined :rules="[rules.ifNotEmptyInt]" />
                </v-col>
                <v-col cols="12" md="6">
                    <v-text-field v-model="address.txtnumero_interior_letra" label="Número interior letra"
                        hide-details="auto" clearable dense outlined />
                </v-col>
                <v-col cols="12" md="6">
                    <v-text-field v-model="address.txtcruzamiento_uno" label="Cruzamiento uno" hide-details="auto"
                        clearable dense outlined />
                </v-col>
                <v-col cols="12" md="6">
                    <v-text-field v-model="address.txtcruzamiento_uno_letra" label="Cruzamiento uno letra"
                        hide-details="auto" clearable dense outlined />
                </v-col>
                <v-col cols="12" md="6">
                    <v-text-field v-model="address.txtcruzamiento_dos" label="Cruzamiento dos" hide-details="auto"
                        clearable dense outlined />
                </v-col>
                <v-col cols="12" md="6">
                    <v-text-field v-model="address.txtcruzamiento_dos_letra" label="Cruzamiento dos letra"
                        hide-details="auto" clearable dense outlined />
                </v-col>
                <v-col cols="12" md="6">
                    <v-text-field v-model="address.txtreferencia" label="Referencia" hide-details="auto" clearable dense
                        outlined />
                </v-col>
                <v-col cols="12" md="6">
                    <v-text-field v-model="address.nlatitud" label="Latitud" hide-details="auto" clearable dense
                        maxlength="15" outlined :rules="[rules.latitud]" />
                </v-col>
                <v-col cols="12" md="6">
                    <v-text-field v-model="address.nlongitud" label="Longitud" hide-details="auto" clearable dense
                        maxlength="15" outlined :rules="[rules.longitud]" />
                </v-col>
                <v-col cols="12" md="6" v-if="address.nlatitud && address.nlongitud">
                    <v-btn color="primary" text @click="verifyAddress()"> Verificar </v-btn>

                </v-col>
            </v-row>


        </v-form>
        <!-- </v-card-text> -->

        <!-- DIALOG GENERIC ACTUALIZAR DIRECCION ACTUAL -->
        <generic-dialog :dialogVisible="dialogNewCurrentAddress" dialogTitle="Actualizar dirección principal"
            @update:dialogVisible="dialogNewCurrentAddress = $event" @confirm="updateCurrentAddress">
            <template v-slot:default>
                Este cambio implica que esta es la nueva dirección actual ¿Desea seguir con el proceso?
            </template>
        </generic-dialog>

        <!-- DIALOG ACTUALIZAR DESACTIVAR DIRECCIÓN -->
        <generic-dialog :dialogVisible="dialogDeleteAddress" dialogTitle="Eliminar dirección"
            @update:dialogVisible="dialogDeleteAddress = $event" @confirm="deleteAddress()">
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
            addressValidation: false, // SE VERIFICA QUE LOS CAMPOS SEAN VÁLIDOS EN CASO DE SER NUEVOS O ESTAR EN MODO EDICIÓN

            // VIENEN DE SERVICIOS
            postalCodes: [],
            colonies: [],
            personAddresses: [],
            headers: [
                // { text: 'ID', value: 'id' },
                { text: 'Dirección', value: 'direccion_completa' },
                { text: 'Actual', value: 'bactual' },
                { text: 'Acciones', value: 'actions' }
            ],

            // MODALES
            dialogDeleteAddress: false,
            dialogNewCurrentAddress: false,

            // ARREGLOS
            typesAddress: [
                // {
                //     "iidtipo_direccion": 1,
                //     "txtnombre": "Predio",
                // },
                // {
                //     "iidtipo_direccion": 2,
                //     "txtnombre": "Tablaje"
                // },
                // {
                //     "iidtipo_direccion": 3,
                //     "txtnombre": "Domicilio Conocido"
                // }
            ],
            typesRoads: [
                // {
                //     "iidtipo_vialidad": 1,
                //     "txtnombre": "Calle",
                // },
                // {
                //     "iidtipo_vialidad": 2,
                //     "txtnombre": "Avenida o Km"
                // }
            ],
            address: {
                // iidcolonia: 0,
                txtcolonia: '',
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
                nlatitud: null,
                nlongitud: null,
                bactivo: null,
                dtfecha_creacion: null,
                dtfecha_modificacion: null,
                iidtipo_direccion: null,
                iidtipo_vialidad: 0,
                txtavenida_kilometro: '',
                txttablaje: '',
                txtdescripcion_direccion: '',
            },
            peopleModulePermissions: [],

            // REGLAS
            rules: {
                ...rules,
            },
        };
    },
    methods: {
        ...mapActions('app', ['showError', 'showSuccess']),


        // GET (BD)
        async getAddressTypes() {
            try {
                this.typesAddress = await services.admin().getAllTypesOfAddress();
            } catch (error) {
                const message = 'Error al cargar los tipos de dirección.';
                this.showError({ message, error });
            }
        },

        // GET (BD)
        async getTypesOfRoads() {
            try {
                this.typesRoads = await services.admin().getAllTypesOfRoad();
            } catch (error) {
                const message = 'Error al cargar opciones de códigos postales.';
                this.showError({ message, error });
            }
        },

        // GET (BD)
        async getCodePostals() {
            try {
                this.postalCodes = await services.admin().getAllPostalCodes();
            } catch (error) {
                const message = 'Error al cargar opciones de códigos postales.';
                this.showError({ message, error });
            }
        },

        // CARGA DE LAS DIRECCIONES ASOCIADAS A LA PERSONA (BD)
        async loadAddressesTable() {
            try {
                console.log('LOAD DIRECTIONS')
                this.newRegisterPerson = localStorage.getItem('newPerson');
                this.newRegisterPerson = this.newRegisterPerson === 'true';
                if (this.newRegisterPerson) {
                    this.newAddress = true
                } else {
                    this.newAddress = false
                }
                this.personAddresses = await services.admin().getPersonAddresses(this.iidpersona);
            } catch (error) {
                const message = 'Error al cargar las direcciones asociadas.';
                this.showError({ message, error });
            }
        },

        // OBTENER ESTADO Y MUNICIPIO SEGÚN CÓDIGO POSTAL (BD)
        async getMunicipalityAndEntityByPostalCode() {
            try {
                let { entity, municipality } = await services.admin().getMunicipalityAndEntityByPostalCode(this.codePostal);
                this.entity = entity;
                this.municipality = municipality;
                this.colonies = await services.admin().getColoniesByPostalCode(this.codePostal);
            } catch (error) {
                const message = 'Error al cargar opciones para nuevo inspector.';
                this.showError({ message, error });
            }
        },

        // INSERTAR O ACTUALIZAR INDEPENDIENTE (BD)
        async saveAddress() {
            console.log('Guardando dirección');
            try {
                let data = {
                    iidpersona: this.iidpersona,
                    address: this.address,
                }
                console.log(data)
                if (!this.address.iiddireccion) {
                    this.address.icodigo_postal = this.codePostal;
                    let response = await services.admin().createAddress(data);
                    console.log('address create')
                    this.showSuccess(response.message);
                    this.newAddress = true
                } else {
                    let response = await services.admin().updateAddress(data);
                    console.log('address update')
                    this.showSuccess(response.message);
                    this.editAddress = false
                }
                await this.loadAddressesTable();
            } catch (error) {
                const message = 'Error al guardar la dirección.';
                this.showError({ message, error });
            }
        },

        // ACTUALIZAR DIRECCIÓN ACTUAL (BD)
        async updateCurrentAddress() {
            try {
                let data = {
                    iidpersona: this.iidpersona,
                    selectedAddress: this.selectedAddress
                }
                let response = await services.admin().updateCurrentAddress(data);
                await this.loadAddressesTable();
                this.dialogNewCurrentAddress = false
                this.showSuccess(response.message);
            } catch (error) {
                const message = 'Error al actualizar la dirección solicitada.';
                this.showError({ message, error });
            }
        },

        // BORRAR DIRECCIÓN (BD)
        async deleteAddress() {
            try {
                let data = {
                    iidpersona: this.iidpersona,
                    selectedAddress: this.selectedAddress
                }
                const { message } = await services.admin().deleteAddress(data);
                await this.loadAddressesTable();
                this.dialogDeleteAddress = false
                this.showSuccess(message);
            } catch (error) {
                const message = 'Error al borrar la dirección.';
                this.showError({ message, error });
            }
        },

        // RESETEO EN CASO DE NUEVO REGISTRO
        resetAddress() {
            this.codePostal = 0
            this.address = {
                // iidcolonia: 0,
                txtcolonia: '',
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
                nlatitud: null,
                nlongitud: null,
                bactivo: null,
                dtfecha_creacion: null,
                dtfecha_modificacion: null,
                iidtipo_direccion: null,
                iidtipo_vialidad: 0,
                icodigo_postal: 0,
                txtavenida_kilometro: '',
                txttablaje: '',
                txtdescripcion_direccion: '',
            }
        },

        // MOSTRAR REGISTROS, CAMBIO DE VALORES PARA MODO CAPTURA Y MODO EDICIÓN
        showAddresses() {
            this.newAddress = false
            this.editAddress = false
            this.resetAddress()
            this.emitToParentComponent()
        },

        // MANEJADOR DE ACCIONES EN LA TABLA
        actionsHandlerOfTable(address, action) {
            switch (action) {
                case 'editAddress':
                    console.log('presion')
                    console.log(this.address)
                    this.address = { ...address }
                    this.codePostal = address.icodigo_postal
                    console.log(this.address)

                    this.editAddress = true
                    break;
                case 'newCurrentAddress':
                    this.dialogNewCurrentAddress = true;
                    this.selectedAddress = address.iiddireccion
                    break;
                case 'deleteAddress':
                    this.dialogDeleteAddress = true;
                    this.selectedAddress = address.iiddireccion
                    break;
                default: this.$refs.dialogs.show[action] = true;
            }
        },

        // ACA SE PUEDE PONER LA GEOLOCALIZACIÓN
        verifyAddress() {
            const url = `https://www.google.com/maps?q=${this.address.nlatitud},${this.address.nlongitud}`;
            window.open(url);
        },

        // EMITIR A COMPONENTE PADRE
        emitToParentComponent() {
            console.log('🚀 ~ emitToParentComponent ~ 🚀 sending editing mode, address, validation 🚀')
            let newOrEdit = false
            if (this.newAddress || this.editAddress) {
                newOrEdit = true
            }
            this.$emit('address-validation', newOrEdit, this.address, this.addressValidation);
        }
    },
    watch: {
        // WATCHERS PROP
        'iidpersona': function () {
            console.log('watch iidpersona')
            this.loadAddressesTable()
        },

        // WATCHERS DATA
        'newRegisterPerson': function () {
            if (this.newRegisterPerson) {
                this.resetAddress()
                this.newAddress = true
            } else {
                this.showAddresses()
            }
        },
        'newAddress': function () {
            if (this.newAddress) {
                this.resetAddress()
                this.address.iidtipo_direccion = this.typesAddress[0].iidtipo_direccion;
            }
        },
        'codePostal': function () {
            if (this.codePostal !== 0) {
                this.getMunicipalityAndEntityByPostalCode()
            }
        },
        'addressValidation': function () {
            this.emitToParentComponent()
        },
    },
    async mounted() {
        await this.getCodePostals();
        await this.getAddressTypes();
        await this.getTypesOfRoads();
        await this.loadAddressesTable();
        let user = await services.app().getUserConfig();
        this.newRegisterPerson = localStorage.getItem('newPerson') === 'true';
        let getActivePermissionsFromUser = await services.admin().getActivePermissionsFromUser(user[0].id);
        this.peopleModulePermissions = getActivePermissionsFromUser.map(permission => permission.siglas);
    }
};
</script>