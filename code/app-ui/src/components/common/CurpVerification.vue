<template>
    <v-row class="d-flex align-center justify-center">
        <v-col cols="12" md="6" class="d-flex align-center justify-between" style="height:30px">
            <v-text-field v-model="curp" label="CURP*" style="max-height: 40px;" :rules="[rules.curp]" maxlength="18"
                hide-details="auto" clearable dense @input="toUpperCase" outlined />
            <v-btn class="d-flex align-center ml-3" depressed color="primary" @click="verifyCurp"
                :disabled="!curpValida">
                Verificar CURP
            </v-btn>
        </v-col>
        <v-card-text v-if="personaEncontrada && personaDisponible">
            <v-row>
                <v-col cols="12" md="6">
                    <v-text-field v-model="persona.txtnombre" label="Nombre/s" hide-details="auto" clearable dense
                        outlined disabled />
                </v-col>
                <v-col cols="12" md="6">
                    <v-text-field v-model="persona.txtapepat" label="Apellido paterno" hide-details="auto" clearable
                        dense outlined disabled />
                </v-col>
                <v-col cols="12" md="6">
                    <v-text-field v-model="persona.txtapemat" label="Apellido materno" hide-details="auto" clearable
                        dense outlined disabled />
                </v-col>
                <v-col cols="12" md="6">
                    <v-text-field v-model="persona.txtrfc" label="RFC" hide-details="auto" clearable dense outlined
                        disabled />
                </v-col>

                <v-col cols="12" md="6">
                    <v-text-field v-model="persona.txtestado_civil" label="Estado civil" hide-details="auto" clearable
                        dense outlined disabled />
                </v-col>
                <v-col cols="12" md="6">
                    <v-text-field v-model="persona.txtsexo" label="Sexo" hide-details="auto" clearable dense outlined
                        disabled />
                </v-col>
            </v-row>
        </v-card-text>
        <!-- DIALOG REGISTRAR -->
        <template>
            <v-dialog v-model="dialogOpen" transition="dialog-bottom-transition" persistent max-width="600">
                <v-card>
                    <v-card-title>
                        El CURP ingresado no se encuentra en el sistema
                    </v-card-title>
                    <v-card-text>
                        ¿Desea registrarlo?
                    </v-card-text>

                    <v-card-actions>
                        <v-spacer />
                        <v-btn color="error" text @click="dialogOpen = false"> Cancelar </v-btn>
                        <v-btn color="primary" text @click="showDialogPerson"> Aceptar </v-btn>
                    </v-card-actions>
                </v-card>
            </v-dialog>
        </template>
        <!-- DIALOG CAMBIO DE CURP -->
        <template>
            <v-dialog v-model="dialogCurpChanged" transition="dialog-bottom-transition" persistent max-width="600">
                <v-card>
                    <v-card-title>
                        Se ha detectado un cambio en el curp verificado
                    </v-card-title>
                    <v-card-text>
                        Favor de verificar de nuevo
                    </v-card-text>

                    <v-card-actions>
                        <v-spacer />
                        <v-btn color="error" text @click="dialogCurpChanged = false"> Cancelar </v-btn>
                        <v-btn color="primary" text @click="verifyCurp"> Verificar </v-btn>
                    </v-card-actions>
                </v-card>
            </v-dialog>
        </template>
        <!-- DIALOG INSPECTOR -->
        <template>
            <v-dialog v-model="dialogInspector" transition="dialog-bottom-transition" persistent max-width="600">
                <v-card>
                    <v-card-title>
                        El CURP ingresado pertenece a un inspector
                    </v-card-title>
                    <v-card-text>
                        ¿Desea verificar la información?
                    </v-card-text>
                    <v-card-actions>
                        <v-spacer />
                        <v-btn color="error" text @click="dialogInspector = false"> Cancelar </v-btn>
                        <v-btn color="primary" text @click="redirectInspector"> Aceptar </v-btn>
                    </v-card-actions>
                </v-card>
            </v-dialog>
        </template>
        <modal-create-person ref="ModalCreatePerson" @person-created="handlefromCreatePerson" />
    </v-row>
</template>

<script>
import services from "@/services";
import rules from "@/core/rules.forms";
import { mapActions } from "vuex";
import ModalCreatePerson from "@/components/common/ModalCreatePerson.vue";

export default {
    components: {
        ModalCreatePerson,
    },
    props: {
    },
    data() {
        return {
            curp: '',
            curpValida: false,
            dialogOpen: false,
            dialogCurpChanged: false,
            dialogInspector: false,
            personaEncontrada: false,
            personaDisponible: false,
            curpVerificada: '',
            rutaInspector: '',
            nombreCompleto: '',
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
            rules: {
                ...rules,
            }
        }
    },
    methods: {
        ...mapActions('app', ['showError', 'showSuccess']),
        toUpperCase() {
            this.curp = this.curp.toUpperCase();
        },
        showDialogPerson() {
            this.dialogOpen = false
            this.dialog = true;
            this.$refs.ModalCreatePerson.$data.dialog = true;
            this.$refs.ModalCreatePerson.$data.persona.txtcurp = this.curp;
        },
        async verifyCurp() {
            this.dialogCurpChanged = false;
            let curp = this.curp;
            console.log('CURP A VERIFICAR 1 ' + curp)
            try {
                let curp = this.curp;
                let response = await services.inspections().getPersonByCurp({ curp });
                console.log(response)

                if (response.isInspector === false) { // Si la persona no es inspector (esta disponible) muestra su información
                    this.personaEncontrada = true
                    this.personaDisponible = true
                    this.persona = { ...response }
                    this.curpVerificada = this.persona.txtcurp
                    this.$emit('person-info', this.personaEncontrada, this.personaDisponible, this.persona, this.persona.txtcurp, this.persona.isInspector);
                } else if (response.isInspector === true) { // Si la persona ya es inspector mostrará un modal de redirección
                    this.personaEncontrada = true
                    this.personaDisponible = false
                    this.persona = { ...response }
                    this.curpVerificada = this.persona.txtcurp
                    this.$emit('person-info', this.personaEncontrada, this.personaDisponible, this.persona, this.persona.txtcurp, this.persona.isInspector);
                    this.rutaInspector = `/inspectors/${response.iidinspector}/edit`;
                    this.dialogInspector = true;
                } else { // Si no existe el curp puede registrarlo (una persona)
                    console.log('CURP A VERIFICAR 5' + curp)
                    this.personaEncontrada = false
                    this.personaDisponible = true
                    this.$emit('person-info', false, true, this.persona, this.persona.txtcurp, this.persona.isInspector);
                    this.dialogOpen = true;
                }
            } catch (error) {
                const message = 'Error al procesar curp.';
                this.showError({ message, error });
            }
        },
        redirectInspector() {
            this.$router.push(this.rutaInspector);
            setTimeout(() => {
                window.location.reload()
            }, 100);
        },
        handlefromCreatePerson(personCreated, curp) {
            if (personCreated) {
                this.curp = curp
                this.verifyCurp()
                this.$emit('person-info', this.personaEncontrada, this.personaDisponible, this.persona, curp);
            } else {
                alert('no se pudo crear')
            }
        }
    },
    watch: {
        'curp': function () {
            const curpRules = this.rules.curp;
            if (curpRules) {
                this.curpValida = curpRules(this.curp) === true;
            } else {
                this.curpValida = true; // Otra opción es asignar un valor predeterminado válido
            }
        }
    }
}
</script>