<template>
    <div>
        <v-card-text>
            {{ showPersonPhones }}--  {{ showFields }}
            {{ !!newRegisterPerson }}--  {{ newRegisterPerson }}
            <div class="row d-flex justify-space-around align-center mx-auto"  v-if="!newRegisterPerson">
                <p class="col-md-6 my-0">Teléfonos</p>

                <v-col cols="12" md="6" v-if="showPersonPhones">
                    <v-btn depressed color="primary" @click="resetPhone()">
                        Nuevo teléfono
                    </v-btn>
                </v-col>
                <v-col cols="12" md="3" v-if="showFields">
                    <v-btn depressed color="info" @click="showPersonPhones = true, showFields= false">
                        Ver teléfonos
                    </v-btn>
                </v-col>
                <v-col cols="12" md="3" v-if="showFields">
                    <v-btn depressed color="primary" :disabled="!phoneValidation" @click="savePhone()">
                        {{ showFields && newPhone ? "Guardar" : "Actualizar" }}
                    </v-btn>
                </v-col>
            </div>
            <!-- Telefono en : {{ newPhone ? 'Modo nuevo' : 'modo editar' }}
            Cant: {{ Object.keys(personaPhones).length }} -->
            <v-form v-model="phoneValidation" v-if="showFields || newRegisterPerson">
                <v-row>
                    <v-col cols="12" md="6">
                        <v-select v-model="phone.iidtelefono_tipo" label="Tipo*" :items="typePhones"
                            item-text="txtnombre" item-value="iidtelefono_tipo" hide-details="auto" small-chips
                            clearable dense outlined :rules="[rules.required]" />
                    </v-col>

                    <!-- <v-col cols="12" md="6">
                        <v-select v-model="phone.ilada" label="Lada*" :items="ladas" item-text="txtnombre"
                            item-value="iidlada" hide-details="auto" small-chips clearable dense outlined
                            :rules="[rules.required]" />
                    </v-col> -->
                    <v-col cols="12" md="6">
                        <v-text-field v-model="phone.inumero" label="Número*" hide-details="auto" clearable dense
                            :rules="[rules.telefono]" outlined maxlength="10" />
                    </v-col>
                </v-row>
            </v-form>
            <v-row v-if="personaPhones && Object.keys(personaPhones).length > 0 && showPersonPhones">
                <v-col cols="12" md="12">
                    <v-simple-table>
                        <template v-slot:default>
                            <thead>
                                <tr>
                                    <th class="text-left">
                                        Tipo
                                    </th>
                                    <!-- <th class="text-left">
                                        Lada
                                    </th> -->
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
                                    <!-- <td>+{{ item.ilada }}</td> -->
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
                                                        @click="actionsHandler(item, 'newCurrentPhone')">
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

        <!-- DIALOG ACTUALIZAR TELÉFONO ACTUAL -->
        <template>
            <v-dialog v-model="dialogNewCurrentPhone" transition="dialog-bottom-transition" persistent
                max-width="600">
                <v-card>
                    <v-card-title class="text-uppercase primary--text text-h6 py-2">
                        Actualizar teléfono principal
                    </v-card-title>
                    <v-card-text>
                        Este cambio implica que este es el nuevo teléfono actual ¿Desea seguir con el proceso?
                    </v-card-text>

                    <v-card-actions>
                        <v-spacer />
                        <v-btn color="error" text @click="updateCurrentPhone = 0, dialogNewCurrentPhone = false">
                            Cancelar </v-btn>
                        <v-btn color="primary" text @click="updateCurrentPhoneMethod"> Aceptar </v-btn>
                    </v-card-actions>
                </v-card>
            </v-dialog>
        </template>
        <!-- DIALOG ACTUALIZAR DESACTIVAR TELÉFONO -->
        <template>
            <v-dialog transition="dialog-top-transition" max-width="600" v-model="dialogDelete">
                <v-card>
                    <v-card-title class="text-uppercase primary--text text-h6 py-2">
                        Eliminar teléfono
                    </v-card-title>
                    <v-divider></v-divider>
                    <v-card-text class="text-lowercase text-body-1 py-2">
                        ¿est&aacute;s seguro de que deseas Eliminar este
                        teléfono?
                    </v-card-text>
                    <v-divider></v-divider>
                    <v-card-actions class="py-2">
                        <v-spacer></v-spacer>
                        <v-btn color="error" text @click="dialogDelete = false"> Cerrar </v-btn>
                        <v-btn color="primary" text @click="deletePhone">
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
        newRegisterPerson: {
            type: Boolean,
            default: false // Valor predeterminado
        },
        iidpersona: {
            type: Number,
            default: 0 // Valor predeterminado
        },
    },
    data() {
        return {
            newPhone: true,
            showPersonPhones:true,
            showFields:false,
            phoneValidation: false,
            dialogDelete: false,
            dialogNewCurrentPhone: false,
            updateCurrentPhone: 0,
            // iidpersona: null,
            // iidpersona: 84,
            phone: {
                iidtelefono: 0,
                // ilada: '',
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
            // ladas: [],
            ladaIdentifiers: [],
            personaPhones: [],
        };
    },
    computed: {

    },
    methods: {
        ...mapActions('app', ['showError', 'showSuccess']),
        async loadPhonesTable() {
            try {
                console.log('LOAD PHONES')
                this.showFields = false
                this.showPersonPhones = true
                this.newPhone = false
                let response = await services.inspections().getPersonPhones(this.iidpersona);
                this.typePhones = await services.inspections().getAllTypePhones()
                // 
                console.log(response)
                console.log(this.typePhones)
                this.personaPhones = { ...response }
            } catch (error) {
                const message = 'Error al cargar los teléfonos asociadas.';
                this.showError({ message, error });
            }
        },
        resetPhone(){
            this.showPersonPhones=false
            this.showFields=true
            this.newPhone = true
            this.phone= {
                iidtelefono: 0,
                // ilada: '',
                inumero: '',
                iidtelefono_tipo: null,
                bactivo: null,
                dtfecha_creacion: null,
                dtfecha_modificacion: null,
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
               
                await this.loadPhonesTable();
                this.dialog = false
            } catch (error) {
                const message = 'Error al guardar phone.';
                this.showError({ message, error });
            }
        },
        actionsHandler(phone, action) {
            console.log('actionsHandler')
            console.log(phone)
            console.log(action)
            switch (action) {
                case 'edit':
                    this.phone = { ...phone }
                    this.showFields = true
                    this.showPersonPhones = false
                    this.newPhone = false
                    break;
                case 'newCurrentPhone':
                    this.dialogNewCurrentPhone = true;
                    this.selectedPhone = phone.iidtelefono
                    break;
                case 'delete':
                    this.dialogDelete = true;
                    this.selectedPhone = phone.iidtelefono
                    break;
                default: this.$refs.dialogs.show[action] = true;
            }
        },
        async updateCurrentPhoneMethod() {
            try {
                let data = {
                    iidpersona: this.iidpersona,
                    selectedPhone: this.selectedPhone
                }
                console.log('data para update')
                let response = await services.inspections().updateCurrentPhone(data);
                console.log(response)
                await this.loadPhonesTable();
                this.dialogNewCurrentPhone = false
                this.showSuccess(response.message);
            } catch (error) {
                const message = 'Error al actualizar.';
                this.showError({ message, error });
            }
        },
        async deletePhone() {
            try {
                let data = {
                    iidpersona: this.iidpersona,
                    selectedPhone: this.selectedPhone
                }
                const { message } = await services.inspections().deletePhone(data);
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
        'phoneValidation': function () {
            // phoneValidation(newValidation) {
            console.log('validación teléfono')
            console.log(this.phoneValidation)
            console.log(this.phone)
            this.$emit('phone-validation', this.phoneValidation, this.phone);
        },
        'persona.inumero': function(){
            this.persona.inumero = parseInt(this.persona.inumero);
        },
        'newRegisterPerson': function(){
            if(this.newRegisterPerson){
                this.showFields = true
                this.showPersonPhones = false
                this.resetPhone()
            }
        },
        'iidpersona': function(){
            this.loadPhonesTable()
        },
    },
    async mounted() {
        await this.loadPhonesTable();
    }
};
</script>

<style scoped>
</style>