<!-- DIALOG  -->
<template>
    <!-- Validación de direcciones -->
    <!-- Validación de teléfono -->
    <div class="">
        <v-dialog v-model="dialog" max-width="800">
            <v-card prepend-icon="mdi-account" title="Captura de persona">

                <v-col cols="12" class="pa-0 mt-2">
                    <v-tabs v-model="tab" centered icons-and-text>
                        <v-tabs-slider color="primary" />
                        <v-tab href="#generaltab">
                            Datos Generales
                            <v-icon> mdi-clipboard-text </v-icon>
                        </v-tab>
                        <v-tab href="#direccionestab" v-if="persona.iidpersona">
                            Dirección
                            <v-icon> mdi-card-account-details </v-icon>
                        </v-tab>
                        <v-tab href="#telefonostab" v-if="persona.iidpersona">
                            Telefono
                            <v-icon> mdi-card-account-details </v-icon>
                        </v-tab>

                    </v-tabs>
                    <v-tabs-items v-model="tab">
                        <v-card flat>
                            <v-tab-item :key="1" value="generaltab" class="py-1">
                                <v-card-text>
                                    <v-form v-model="generalValidation">
                                        <p>Tipo de persona</p> (si es moral el RFC debe ser obligatorio)
                                        <v-radio-group v-model="persona.bfisica" mandatory @change="validarRFC">
                                            <v-radio color="success" label="Física" value="true"
                                                style="max-width:80px"></v-radio>
                                            <v-radio color="success" label="Moral" value="false"
                                                style="max-width:80px"></v-radio>
                                        </v-radio-group>
                                        <v-row>
                                            <v-col cols="12" md="6">
                                                <v-text-field v-model="persona.txtnombre" label="Nombre/s*"
                                                    hide-details="auto" clearable dense outlined
                                                    :rules="[rules.required]" />
                                            </v-col>
                                            <v-col cols="12" md="6">
                                                <v-text-field v-model="persona.txtapepat" label="Apellido paterno"
                                                    hide-details="auto" clearable dense outlined />
                                            </v-col>
                                            <v-col cols="12" md="6">
                                                <v-text-field v-model="persona.txtapemat" label="Apellido materno"
                                                    hide-details="auto" clearable dense outlined />
                                            </v-col>

                                            <v-col cols="12" md="6">
                                                <v-text-field v-model="persona.dfecha_nacimiento" clearable dense
                                                    outlined label="Fecha de nacimiento" type="date" :max="getDate"
                                                    :mask="'####/##/##'"></v-text-field>
                                            </v-col>

                                            <v-col cols="12" md="6">
                                                <v-text-field v-model="persona.txtrfc" label="RFC" hide-details="auto"
                                                    clearable dense outlined maxlength="13" :rules="[rfcValido]" />
                                            </v-col>


                                            <v-col cols="12" md="6">
                                                <v-text-field v-model="persona.txtcurp" label="CURP*"
                                                    :rules="[rules.curp]" maxlength="18" hide-details="auto" clearable
                                                    dense outlined disabled />
                                            </v-col>

                                            <v-col cols="12" md="6">
                                                <v-text-field v-model="persona.txtine" label="INE" hide-details="auto"
                                                    clearable dense outlined maxlength="19" />
                                            </v-col>

                                            <v-col cols="12" md="6">
                                                <v-select v-model="persona.iidestado_civil" label="Estado civil*"
                                                    :items="civilStatus" item-text="txtnombre"
                                                    item-value="iidestado_civil" hide-details="auto" small-chips
                                                    clearable dense outlined />
                                            </v-col>

                                            <v-col cols="12" md="6">
                                                <v-select v-model="persona.iidsexo" label="Género*" :items="sexes"
                                                    item-text="txtnombre" item-value="iidsexo" hide-details="auto"
                                                    small-chips clearable dense outlined />
                                            </v-col>
                                            <v-col cols="12" md="6">
                                                <v-text-field v-model="persona.txtcorreo" label="Correo electrónico"
                                                    hide-details="auto" clearable dense outlined
                                                    :rules="[validarCorreo]" />
                                            </v-col>
                                        </v-row>
                                    </v-form>
                                </v-card-text>
                                <v-card-actions>
                                    <v-spacer />
                                    <v-btn color="error" text @click="dialog = false"> Cerrar </v-btn>
                                    <v-btn color="primary" text :disabled="!generalValidation" @click="savePersona()">
                                        Guardar
                                    </v-btn>
                                </v-card-actions>
                            </v-tab-item>
                            <v-tab-item :key="2" value="direccionestab" class="py-1">
                                <direction-verification :iidpersona="persona.iidpersona"></direction-verification>
                            </v-tab-item>
                            <v-tab-item :key="3" value="telefonostab" class="py-1">
                                <phone-verification :iidpersona="persona.iidpersona"></phone-verification>
                            </v-tab-item>

                        </v-card>
                    </v-tabs-items>
                </v-col>

            </v-card>
        </v-dialog>
    </div>
</template>

<script>
import rules from "@/core/rules.forms";
import services from "@/services";
import { mapActions } from "vuex";
import DirectionVerification from '@/components/common/DirectionVerification.vue';
import PhoneVerification from '@/components/common/PhoneVerification.vue';

export default {
    name: 'ModalCreatePerson',
    components: {
        DirectionVerification,
        PhoneVerification,
    },
    data() {
        return {
            tab: "generaltab",
            data: '',
            generalValidation: false,
            phoneValidation: false,
            dialog: false,
            civilStatus: [],
            sexes: [],
            rules: {
                ...rules,
            },
            rfcValido: true,
            showDialog: false,
            persona: {
                iidpersona: 0,
                bfisica: 'true',
                txtnombre: '',
                txtapepat: '',
                txtapemat: '',
                dfecha_nacimiento: '',
                txtrfc: '',
                txtcurp: '',
                txtine: '',
                iidestado_civil: null,
                iidsexo: null,
                txtcorreo: '',
                bactivo: true,
                fecha_creacion: '',
                fecha_modificacion: ''
            },
            desserts: [
                {
                    name: 'Nombre 12',
                    coordinator: 'Coor 1',
                },
                {
                    name: 'Nombre 1',
                    coordinator: 'Coor 2',
                }
            ],
        }
    },
    computed: {
        getDate() {
            const today = new Date();
            const year = today.getFullYear();
            const month = (today.getMonth() + 1).toString().padStart(2, '0');
            const day = today.getDate().toString().padStart(2, '0');
            return `${year}-${month}-${day}`;
        }
    },
    methods: {
        ...mapActions('app', ['showError', 'showSuccess']),

        async savePersona() {
            console.log('Guardando persona');
            console.log(this.persona);
            console.log(this.$parent.personaEncontrada = true)

            try {
                if (this.persona.iidpersona != 0) {
                    console.log('se va a editar ')
                    // let { message } = await services.inspections().updatePerson(this.persona);
                    // this.showSuccess(message);
                } else {
                    console.log('se va a crear')
                    // let { message } = await services.inspections().createPerson(this.persona);
                    // this.showSuccess(message);

                }
                // console.log('entre')
                // this.$emit('person-created', true, this.persona.txtcurp);
                // this.dialog = false
            } catch (error) {
                const message = 'Error al guardar persona.';
                this.showError({ message, error });
            }
        },
        async loadSelectableData() {
            try {
                this.sexes = await services.inspections().getAllSexesPerson();
                this.civilStatus = await services.inspections().getAllCivilStatusPerson();
            } catch (error) {
                const message = 'Error al cargar opciones para nuevo inspector.';
                this.showError({ message, error });
            }
        },
        validarRFC() {
            this.persona.txtrfc = this.persona.txtrfc.toUpperCase()
            let rfc = this.persona.txtrfc.trim();
            if (rfc.length === 0 && this.persona.bfisica === "true") {
                this.$set(this, 'rfcValido', true); // RFC vacío, se considera válido
                return;
            }
            const regexPersonaFisica = /^[A-Z]{4}[0-9]{6}[A-Z0-9]{3}$/;
            const regexPersonaMoral = /^[A-Z]{3}[0-9]{6}[A-Z0-9]{3}$/;
            let regex = this.persona.bfisica === "true" ? regexPersonaFisica : regexPersonaMoral;
            let rfcValido = regex.test(rfc);
            this.$set(this, 'rfcValido', rfcValido ? true : 'RFC inválido');
        },
        validarCorreo(value) {
            if (value && value.trim().length > 0) {
                const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/; // Expresión regular para validar correo electrónico
                return regex.test(value) || 'Correo electrónico inválido';
            }
            return true;
        },
        async verifyCurp(curp, needModal) {
            this.persona = { ...await services.inspections().getPersonByCurp({ curp }) };
            console.log('el curp que viene desde edit inspector es de esta persona: ')
            console.log(this.persona)
            console.log('NECESITA ABRIR ' + needModal)
            // this.showDialog = true
        }
    },
    watch: {
        'persona.txtrfc': function () {
            this.validarRFC()
        },
        'persona.txtcurp': function () {
            console.log('se cambió persona a: ')
            console.log(this.persona.iidpersona)
            console.log('trajo el curp: ')
            console.log(this.persona.txtcurp)
            if (this.persona.iidpersona) {
                this.verifyCurp(this.persona.txtcurp, true)
                console.log('existe esta')
                // if(showDialog){
                // this.dialog=this.showDialog
                // }

            } else {
                console.log('se agregará persona')
                this.persona = {
                    iidpersona: 0,
                    bfisica: 'true',
                    txtnombre: '',
                    txtapepat: '',
                    txtapemat: '',
                    dfecha_nacimiento: '',
                    txtrfc: '',
                    txtcurp: this.persona.txtcurp,
                    txtine: '',
                    iidestado_civil: null,
                    iidsexo: null,
                    txtcorreo: '',
                    bactivo: true,
                    fecha_creacion: '',
                    fecha_modificacion: ''
                }
            }

        }
    },
    async mounted() {
        await this.loadSelectableData();
    }
}
</script>