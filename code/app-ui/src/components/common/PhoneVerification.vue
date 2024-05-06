<template>
    <div>
        <!-- CAMPOS DE EVENTOS -->
        <v-row class="mx-auto" v-if="!newRegisterPerson">
            <v-col cols="12" md="12" class="d-flex justify-end py-1"
                v-if="!newPhone && !editPhone && peopleModulePermissions.includes('crtp')">
                <v-btn depressed color="primary" @click="newPhone = true">
                    Nuevo teléfono
                </v-btn>
            </v-col>
            <v-col cols="12" sm="6" class="d-flex justify-end py-1" v-if="newPhone || editPhone">
                <v-btn depressed color="info" @click="showPhones()">
                    Ver teléfonos
                </v-btn>
            </v-col>
            <v-col cols="12" sm="6" class="d-flex justify-end py-1" v-if="newPhone || editPhone">
                <v-btn v-if="editPhone && peopleModulePermissions.includes('edtp')" depressed color="primary"
                    :disabled="!phoneValidation" @click="savePhone()">
                    Actualizar
                </v-btn>
                <v-btn v-else-if="!editPhone && peopleModulePermissions.includes('crtp')" depressed color="primary"
                    :disabled="!phoneValidation" @click="savePhone()">
                    Guardar
                </v-btn>
            </v-col>
        </v-row>

        <!-- TABLA DE TELÉFONOS -->
        <v-data-table :headers="headers" :items="personPhones"
            v-if="personPhones && Object.keys(personPhones).length > 0 && !newPhone && !editPhone">
            <template v-slot:item.bactual="{ item }">
                <v-icon v-show="item.bactual" size="medium" color="green">mdi-check</v-icon>
                <v-icon v-show="!item.bactual" size="medium" color="red">mdi-close</v-icon>
            </template>
            <template v-slot:item.actions="{ item }">
                <div v-if="peopleModulePermissions.includes('edtp')" style="min-width: 85px;">
                    <v-tooltip bottom>
                        <template v-slot:activator="{ on, attrs }">
                            <v-btn v-bind="attrs" v-on="on" icon small
                                @click="actionsHandlerOfTable(item, 'editPhone')">
                                <v-icon small>mdi-square-edit-outline</v-icon>
                            </v-btn>
                        </template>
                        <span>Editar teléfono</span>
                    </v-tooltip>
                    <v-tooltip bottom v-if="!item.bactual">
                        <template v-slot:activator="{ on, attrs }">
                            <v-btn v-bind="attrs" v-on="on" icon small
                                @click="actionsHandlerOfTable(item, 'newCurrentPhone')">
                                <v-icon small v-show="item.bactivo">mdi-close</v-icon>
                                <v-icon small v-show="!item.bactivo">mdi-check</v-icon>
                            </v-btn>
                        </template>
                        <span>Activar teléfono</span>
                    </v-tooltip>
                    <v-tooltip bottom v-if="!item.bactual">
                        <template v-slot:activator="{ on, attrs }">
                            <v-btn v-bind="attrs" v-on="on" icon small
                                @click="actionsHandlerOfTable(item, 'deletePhone')">
                                <v-icon small v-show="item.bactivo">mdi-delete</v-icon>
                                <v-icon small v-show="!item.bactivo">mdi-check</v-icon>
                            </v-btn>
                        </template>
                        <span>Eliminar teléfono</span>
                    </v-tooltip>
                </div>
                <div v-else>
                    Sin permisos
                </div>
            </template>
        </v-data-table>

        <!-- CAMPOS DE AGREGAR - MODIFICAR -->
        <v-form v-model="phoneValidation" v-if="newPhone || newRegisterPerson || editPhone">
            <v-row>
                <v-col cols="12" md="6">
                    <v-select v-model="phone.iidtelefono_tipo" label="Tipo*" :items="typesPhone" item-text="txtnombre"
                        item-value="iidtelefono_tipo" hide-details="auto" small-chips clearable dense outlined
                        :rules="[rules.required]" />
                </v-col>

                <v-col cols="12" md="6" v-if="requiredLadaIdentifiers">
                    <v-select v-model="phone.txtlada" label="Lada*" :items="ladaIdentifiers" item-text="txtnombre"
                        item-value="iidlada" hide-details="auto" small-chips clearable dense outlined
                        :rules="[rules.required]" />
                </v-col>
                <!-- <v-col cols="12" md="6">
                    <v-text-field v-model="phone.inumero" label="Número*" hide-details="auto" clearable dense
                        :rules="[rules.telefono]" outlined maxlength="10" />
                </v-col> -->
                <v-col cols="12" md="6">
                    <v-text-field v-model="phone.inumero" label="Número*" hide-details="auto" clearable dense outlined
                        maxlength="14" @input="formatPhoneNumber" :rules="[rules.telefono]"></v-text-field>
                </v-col>
            </v-row>
        </v-form>

        <!-- DIALOG ACTUALIZAR TELÉFONO ACTUAL -->
        <generic-dialog :dialogVisible="dialogNewCurrentPhone" dialogTitle="Actualizar teléfono principal"
            @update:dialogVisible="dialogNewCurrentPhone = $event" @confirm="updateCurrentPhoneMethod">
            <template v-slot:default>
                Este cambio implica que este es el nuevo teléfono actual ¿Desea seguir con el proceso?
            </template>
        </generic-dialog>

        <!-- DIALOG ACTUALIZAR DESACTIVAR TELÉFONO -->
        <generic-dialog :dialogVisible="dialogDeletePhone" dialogTitle="Eliminar teléfono"
            @update:dialogVisible="dialogDeletePhone = $event" @confirm="deletePhone">
            <template v-slot:default>
                ¿Estás seguro de que deseas Eliminar este
                teléfono?
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
            requiredLadaIdentifiers: false,
            editPhone: false,

            // WATCHERS FUNCIONALIDAD
            newRegisterPerson: false,
            newPhone: false,
            phoneValidation: false,

            // VIENEN DE SERVICIOS
            typesPhone: [],
            ladaIdentifiers: [],
            personPhones: [],
            headers: [
                // { text: 'ID', value: 'id' },
                { text: 'Tipo', value: 'txttelefono_tipo' },
                { text: 'Teléfono', value: 'inumero' },
                { text: 'Actual', value: 'bactual' },
                { text: 'Acciones', value: 'actions' }
            ],
            peopleModulePermissions: [],

            // MODALES
            dialogDeletePhone: false,
            dialogNewCurrentPhone: false,

            // ARREGLOS
            phone: {
                iidtelefono: 0,
                txtlada: '',
                inumero: null,
                iidtelefono_tipo: null,
            },

            // REGLAS
            rules: {
                ...rules,
            },
        };
    },
    computed: {
    },
    methods: {
        ...mapActions('app', ['showError', 'showSuccess']),

        // GET (BD)
        async getTypesPhone() {
            try {
                this.typesPhone = await services.inspections().getAllTypesPhone()
            } catch (error) {
                const message = 'Error al cargar opciones de tipos de teléfono.';
                this.showError({ message, error });
            }
        },

        // GET (BD)
        async getLadaIdentifiers() {
            try {
                this.ladaIdentifiers = await services.inspections().getAllLadaIdentifiers()
            } catch (error) {
                const message = 'Error al cargar opciones de los identificadores lada.';
                this.showError({ message, error });
            }
        },

        // CARGA DE LOS TELÉFONOS ASOCIADOS A LA PERSONA (BD)
        async loadPhonesTable() {
            try {
                console.log('LOAD PHONES')
                this.newRegisterPerson = localStorage.getItem('newPerson');
                this.newRegisterPerson = this.newRegisterPerson === 'true';
                if (this.newRegisterPerson) {
                    this.newPhone = true
                } else {
                    this.newPhone = false
                }
                this.personPhones = await services.inspections().getPersonPhones(this.iidpersona);
            } catch (error) {
                const message = 'Error al cargar los teléfonos asociados.';
                this.showError({ message, error });
            }
        },

        // INSERTAR O ACTUALIZAR INDEPENDIENTE (BD)
        async savePhone() {
            console.log('Guardando teléfono');
            try {
                let data = {
                    iidpersona: this.iidpersona,
                    phone: this.phone,
                }
                console.log(data)
                if (!this.phone.iidtelefono) {
                    let response = await services.inspections().createPhone(data);
                    console.log('phone create')
                    console.log(response)
                    this.showSuccess(response.message);
                    this.newPhone = true
                } else {
                    console.log('es edicion')
                    let response = await services.inspections().updatePhone(data);
                    console.log('phone update')
                    console.log(response)
                    this.showSuccess(response.message);
                    this.editPhone = false
                }

                await this.loadPhonesTable();
            } catch (error) {
                const message = 'Error al guardar el teléfono.';
                this.showError({ message, error });
            }
        },

        // ACTUALIZAR TELÉFONO ACTUAL (BD)
        async updateCurrentPhoneMethod() {
            try {
                let data = {
                    iidpersona: this.iidpersona,
                    selectedPhone: this.selectedPhone
                }
                let response = await services.inspections().updateCurrentPhone(data);
                await this.loadPhonesTable();
                this.dialogNewCurrentPhone = false
                this.showSuccess(response.message);
            } catch (error) {
                const message = 'Error al actualizar el teléfono solicitado.';
                this.showError({ message, error });
            }
        },

        // BORRAR TELÉFONO (BD)
        async deletePhone() {
            try {
                let data = {
                    iidpersona: this.iidpersona,
                    selectedPhone: this.selectedPhone
                }
                const { message } = await services.inspections().deletePhone(data);
                await this.loadPhonesTable();
                this.dialogDeletePhone = false
                this.showSuccess(message);
            } catch (error) {
                const message = 'Error al borrar el teléfono.';
                this.showError({ message, error });
            }

        },

        // RESETEO EN CASO DE NUEVO REGISTRO
        resetPhone() {
            this.phone = {
                iidtelefono: 0,
                txtlada: '',
                inumero: '',
                iidtelefono_tipo: null,
            }
        },

        // MOSTRAR REGISTROS, CAMBIO DE VALORES PARA MODO CAPTURA Y MODO EDICIÓN
        showPhones() {
            this.newPhone = false
            this.editPhone = false
            this.resetPhone()
            this.emitToParentComponent()
        },
        formatPhoneNumber() {
            // Aplicar la máscara al número de teléfono
            this.phone.inumero = this.phone.inumero
                .replace(/\D/g, '') // Eliminar todos los caracteres no numéricos
                .replace(/(\d{3})(\d{1,3})?(\d{1,4})?/, '($1) $2-$3') // Aplicar la máscara '(###) ###-####'
                .substring(0, 14); // Limitar la longitud a 14 caracteres (incluyendo paréntesis y guiones)
        },
        // MANEJADOR DE ACCIONES EN LA TABLA
        actionsHandlerOfTable(phone, action) {
            switch (action) {
                case 'editPhone':
                    this.phone = { ...phone }
                    this.editPhone = true
                    break;
                case 'newCurrentPhone':
                    this.dialogNewCurrentPhone = true;
                    this.selectedPhone = phone.iidtelefono
                    break;
                case 'deletePhone':
                    this.dialogDeletePhone = true;
                    this.selectedPhone = phone.iidtelefono
                    break;
                default: this.$refs.dialogs.show[action] = true;
            }
        },

        // EMITIR A COMPONENTE PADRE
        emitToParentComponent() {
            console.log('🚀 ~ emitToParentComponent ~ 🚀 sending editing mode, phone, validation 🚀')
            let newOrEdit = false
            console.log('newPhone' + this.newPhone)
            console.log('editPhone' + this.editPhone)
            if (this.newPhone || this.editPhone) {
                newOrEdit = true
            }
            this.$emit('phone-validation', newOrEdit, this.phone, this.phoneValidation);
        }

    },
    watch: {
        // WATCHERS PROP
        'iidpersona': function () {
            console.log('watch iidpersona')
            this.loadPhonesTable()
        },

        // WATCHERS DATA
        'newRegisterPerson': function () {
            console.log('watch newRegisterPerson')
            if (this.newRegisterPerson) {
                this.resetPhone()
                this.newPhone = true
            } else {
                this.showPhones()
            }
        },
        'newPhone': function () {
            console.log('watch newPhone')
            if (this.newPhone) {
                this.resetPhone()
            }
        },
        'phoneValidation': function () {
            console.log('watch phoneValidation')
            this.emitToParentComponent()
        },
        'phone.inumero'() {
            this.formatPhoneNumber();
        }
    },
    async mounted() {
        await this.getTypesPhone();
        await this.loadPhonesTable();
        if (this.requiredLadaIdentifiers) {
            await this.getLadaIdentifiers();
        }
        let user = await services.app().getUserConfig();
        this.newRegisterPerson = localStorage.getItem('newPerson') === 'true';
        let getActivePermissionsFromUser = await services.admin().getActivePermissionsFromUser(user[0].id);
        this.peopleModulePermissions = getActivePermissionsFromUser.map(permission => permission.siglas);
    }
};
</script>
