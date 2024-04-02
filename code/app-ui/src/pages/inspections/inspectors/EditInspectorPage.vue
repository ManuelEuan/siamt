<template>
    <v-container fluid>
        <v-row justify="center">
            <v-col cols="12" class="pa-0">
                <v-card flat>
                    <v-toolbar>
                        <v-toolbar-title>{{ createMode ? "Nuevo" : "Editar" }} Inspector</v-toolbar-title>
                    </v-toolbar>
                </v-card>
            </v-col>
            <v-col cols="12" class="pa-0 mt-2">
                <v-tabs v-model="tab" centered icons-and-text>
                    <v-tabs-slider color="primary" />
                    <v-tab href="#generaltab">
                        Datos Generales
                        <v-icon> mdi-clipboard-text </v-icon>
                    </v-tab>

                </v-tabs>
                <v-tabs-items v-model="tab">
                    <v-card flat>
                        <v-tab-item :key="1" value="generaltab" class="py-1">
                            <v-card-text>
                                <v-form v-model="valid">
                                    <curp-verification v-if="createMode" @person-info="handlePersonInfo"
                                        ref="curpVerification"></curp-verification>
                                        
                                    <v-row v-if="!createMode">
                                        <v-col cols="12" md="4">
                                            <v-text-field v-model="nombreCompleto" label="Nombre Completo*" hide-details="auto"
                                            clearable dense :disabled="!createMode" outlined />
                                        </v-col>
                                        <v-col cols="12" md="4">
                                            <v-text-field v-model="persona.txtcurp" label="CURP*" hide-details="auto"
                                            clearable dense :disabled="!createMode" outlined />
                                        </v-col>
                                        <v-col cols="12" md="4" >
                                            <v-btn color="primary" text @click=showDialogPerson(persona.iidpersona)>Información Completa 2</v-btn>
                                        </v-col>
                                    </v-row>
                                    <v-row v-if="personaEncontrada && personaDisponible || !createMode">
                                        <v-col cols="12" md="6">
                                            <v-select v-model="inspector.iidturno" label="Turno*"
                                                :rules="[rules.required]" :items="shifts" item-text="txtnombre"
                                                item-value="iidturno" hide-details="auto" small-chips clearable dense
                                                outlined />
                                        </v-col>
                                        <v-col cols="12" md="6">
                                            <v-text-field v-model="inspector.txtfolio_inspector" label="Folio*"
                                                hide-details="auto" clearable dense outlined />
                                        </v-col>

                                        <v-col cols="12" md="6">
                                            <v-select v-model="inspector.iidinspector_categoria"
                                                @change="verifyCategorie" label="Categoría*" :rules="[rules.required]"
                                                :items="categories" item-text="txtnombre"
                                                item-value="iidinspector_categoria" hide-details="auto" small-chips
                                                clearable dense outlined />
                                        </v-col>

                                        <v-col cols="12" md="6" v-if="genera_boleta">
                                            <v-text-field v-model="inspector.dvigencia" clearable dense outlined
                                                label="Vigencia" type="date" :min="getDate" :rules="[rules.required]"
                                                :mask="'####/##/##'"></v-text-field>
                                        </v-col>

                                        <v-col cols="12" md="6">
                                            <v-text-field v-model="inspector.dfecha_alta" clearable dense outlined
                                                label="Fecha de alta" type="date" :mask="'####/##/##'"></v-text-field>
                                        </v-col>

                                        <v-col cols="12" md="6" v-if="!createMode">
                                            <v-text-field v-model="inspector.dfecha_baja" clearable dense outlined
                                                label="Fecha de baja" type="date" :mask="'####/##/##'"></v-text-field>
                                        </v-col>

                                        <v-col cols="12">
                                            <v-textarea v-model="inspector.txtcomentarios" label="Comentarios*"
                                                hide-details="auto" clearable dense outlined />
                                        </v-col>
                                    </v-row>
                                </v-form>
                            </v-card-text>
                        </v-tab-item>

                        <v-card-actions>
                            <v-spacer />
                            <v-btn color="error" text @click="exitWindow()"> Cerrar </v-btn>
                            <v-btn color="primary" text :disabled="!valid" @click="saveInspector()"> Guardar </v-btn>
                        </v-card-actions>
                    </v-card>
                </v-tabs-items>
            </v-col>
        </v-row>
        <modal-create-person ref="ModalCreatePerson" :isNewPerson="false" @person-created="handlefromCreatePerson" />

    </v-container>
</template>

<script>
import rules from "@/core/rules.forms";
import services from "@/services";
import CurpVerification from '@/components/common/CurpVerification.vue';
import ModalCreatePerson from "@/components/common/ModalCreatePerson.vue";
import { mapActions } from "vuex";

export default {
    components: {
        CurpVerification,
        ModalCreatePerson,
    },
    data() {
        return {
            click: {
                user: false,
                permission: false,
            },
            valid: false,
            tab: "generaltab",
            permissions: [],

            dialog: false,
            personaEncontrada: false,
            personaDisponible: false,
            stages: [],
            shifts: [],
            categories: [],
            persona: {
                iidpersona: 0,
                bfisica: null,
                txtnombre: '',
                txtapepat: '',
                txtapemat: '',
                txtrfc: '',
                txtcurp: '',
                txtestado_civil: '',
                txtsexo: '',
                activo: true,
                fecha_creacion: null,
                fecha_modificacion: null
            },
            inspector: {
                iidinspector: 0,
                iidpersona: 0,
                iidetapa: 1,
                iidsubetapa: 1,
                txtfolio_inspector: "",
                iidturno: 0,
                iidinspector_categoria: 0,
                dvigencia: '',
                dfecha_alta: '',
                dfecha_baja: '',
                txtcomentarios: '',
                activo: '',
                fecha_creacion: '',
                fecha_modificacion: '',
            },
            nombreCompleto: '',
            curpValida: false,
            curpVerificada: '',
            genera_boleta: false,
            rules: {
                ...rules,
            }
        };
    },
    computed: {
        createMode() {
            return !this.$route.params.id;
        },
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
        async loadSelectableData() {
            try {
                const { id } = this.$route.params;
                console.log(id);
                console.log('idssuhfueihfiejfieojfiej');
                this.categories = await services.inspections().getAllCategoriesInspector();
                this.stages = await services.inspections().getAllStagesInspector();
                this.shifts = await services.inspections().getAllShiftsInspector();

            } catch (error) {
                const message = 'Error al cargar opciones para nuevo inspector.';
                this.showError({ message, error });
            }
        },
        async setEditMode() {
            try {
                const { id } = this.$route.params;
                this.inspector = { ...await services.inspections().getInspectorInfo({ id }) };
                let curp = this.inspector.txtcurp;
                this.persona = { ...await services.inspections().getPersonByCurp({ curp }) };
                let nombreCompleto = '';
                if (this.persona.txtnombre) {
                    nombreCompleto += this.persona.txtnombre + ' ';
                }
                if (this.persona.txtapepat) {
                    nombreCompleto += this.persona.txtapepat + ' ';
                }
                if (this.persona.txtapemat) {
                    nombreCompleto += this.persona.txtapemat + ' ';
                }
                this.nombreCompleto = nombreCompleto.trim();
            } catch (error) {
                const message = 'Error al cargar información de inspector.';
                this.showError({ message, error });
            }
        },
        verifyCategorie() {
            let selectedCategorie = this.categories.find(item => item.iidinspector_categoria === this.inspector.iidinspector_categoria);
            const bgenera_boleta = selectedCategorie.bgenera_boleta;
            if (bgenera_boleta) {
                this.genera_boleta = true;
            } else {
                this.genera_boleta = false;
                this.inspector.dvigencia = null
            }
        },
        handlePersonInfo(isFound, isAvailable, person, curpVerified) {
            this.persona = person
            let tmp_inspector = this.inspector
            this.inspector = {}
            this.inspector = tmp_inspector
            this.inspector.iidpersona = this.persona.iidpersona
            this.personaEncontrada = isFound
            this.personaDisponible = isAvailable
            this.curpVerificada = curpVerified
        },
        async saveInspector() {
            if (!this.maintainCurp()) return this.$refs.curpVerification.$data.dialogCurpChanged = true;
            if (!this.valid) return;
            console.log('this.createMode ' + this.createMode);
            console.log('fue valida')
            console.log('inspector')
            console.log(this.inspector)
            console.log('persona')
            console.log(this.persona)
            try {
                const { message } = await (
                    this.createMode ?
                        services.inspections().createInspector(this.inspector) :
                        services.inspections().updateInspector(this.inspector)
                );
                this.showSuccess(message);
                this.exitWindow();
            } catch (error) {
                const message = 'Error al guardar inspector.';
                this.showError({ message, error });
            }
        },
        maintainCurp() {
            console.log('Curp verificada: ' + this.curpVerificada)
            console.log('Curp actual: ' + this.persona.txtcurp)
            if (this.curpVerificada !== '' && this.curpVerificada !== this.$refs.curpVerification.$data.curp) {
                return false
            }
            return true
        },
        exitWindow() {
            this.$router.push("/inspections/inspectors");
        },
        showDialogPerson(iidpersona) {
            console.log('se mostrará el dialog persona 2')
            console.log(this.persona.txtcurp)
            console.log(iidpersona)
            this.dialogOpen = false
            this.dialog = true;
            if(iidpersona!=0){
                this.$refs.ModalCreatePerson.$data.persona.iidpersona = this.persona.iidpersona;
            }
            this.$refs.ModalCreatePerson.$data.persona.txtcurp = this.persona.txtcurp;
            this.$refs.ModalCreatePerson.$data.dialog = true;
        },
        handlefromCreatePerson(){
            console.log('retorno del modal person')
        }

    },
    async mounted() {
        console.log(this.createMode);
        console.log('createMode');
        await this.loadSelectableData();
        if (!this.createMode) await this.setEditMode();
    }
};
</script>
