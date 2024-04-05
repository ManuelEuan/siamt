<template>
    <v-row class="d-flex align-center justify-center">
        <v-col cols="12" md="12" class="d-flex align-center justify-between" style="height:30px">
            CAUM990224HYNRCC05 ---- CAUM990224S31
        </v-col>
        <label for="">Seleccione una forma de búsqueda:</label>
        {{ search }}
        <v-col cols="12" md="12" class="text-center">
            <v-radio-group v-model="search" row class="p-radio">
                <v-radio label="Nombre" value="NOMBRE" class="mr-4"></v-radio>
                <v-radio label="CURP" value="CURP" class="mr-4"></v-radio>
                <v-radio label="RFC" value="RFC"></v-radio>
            </v-radio-group>
        </v-col>
        <v-col cols="12" md="6" class="d-flex align-center justify-between" style="height:30px"
            v-if="search === 'NOMBRE'">
            <v-text-field v-model="nombre" label="NOMBRE(S)*" style="max-height: 40px;" :rules="[rules.required]"
                hide-details="auto" clearable dense @input="toUpperCase" outlined />
            <v-btn class="d-flex align-center ml-3 search-btn" depressed color="primary" @click="verifyCurp(false)"
                :disabled="!nombreValido">
                Verificar Nombre
            </v-btn>
        </v-col>

        <v-col cols="12" md="6" class="d-flex align-center justify-between" style="height:30px"
            v-if="search === 'CURP'">
            <v-text-field v-model="curp" label="CURP*" style="max-height: 40px;" :rules="[rules.curp]" maxlength="18"
                hide-details="auto" clearable dense @input="toUpperCase" outlined />
            <v-btn class="d-flex align-center ml-3 search-btn" depressed color="primary" @click="verifyCurp(false)"
                :disabled="!curpValida">
                Verificar CURP
            </v-btn>
        </v-col>


        <v-col cols="12" md="6" class="d-flex align-center justify-between" style="height:30px" v-if="search === 'RFC'">
            <v-text-field v-model="rfc" label="RFC*" style="max-height: 40px;" :rules="[rules.rfc]" maxlength="13"
                hide-details="auto" clearable dense @input="toUpperCase" outlined />
            <v-btn class="d-flex align-center ml-3 search-btn" depressed color="primary" @click="verifyCurp(false)"
                :disabled="!rfcValida">
                Verificar RFC
            </v-btn>
        </v-col>
        <v-card-text v-if="personaEncontrada && personaDisponible">
            <v-row>
                <v-col cols="12" md="4">
                    <v-text-field v-model="nombreCompleto" label="Nombre Completo*" hide-details="auto" clearable dense
                        disabled outlined />
                </v-col>
                <v-col cols="12" md="4">
                    <v-text-field v-model="persona.txtcurp" label="CURP*" hide-details="auto" clearable dense disabled
                        outlined />
                </v-col>
                <v-col cols="12" md="4">
                    <v-btn class="d-flex align-center ml-3" depressed color="primary"
                        @click="curp = persona.txtcurp, search = 'CURP', verifyCurp(true)"
                        v-if="personaEncontrada && personaDisponible">
                        Ver información completa 1
                    </v-btn>
                </v-col>
            </v-row>
        </v-card-text>
        <!-- DIALOG REGISTRAR -->
        <template>
            <v-dialog v-model="dialogOpen" transition="dialog-bottom-transition" persistent max-width="600">
                <v-card>
                    <v-card-title>
                        La clave ingresada no se encuentra en el sistema
                    </v-card-title>
                    {{search}}
                    <v-card-text v-if="search === 'NOMBRE'">
                        Para poder registrar al inspector deberá registrar su CURP
                        <v-text-field v-model="nombreCurp" label="CURP*" style="max-height: 40px;" :rules="[rules.curp]"
                            maxlength="18" hide-details="auto" clearable dense @input="toUpperCase" outlined />
                    </v-card-text>
                    <v-card-text v-else>
                        ¿Desea registrarlo?
                    </v-card-text>

                    <v-card-actions>
                        <v-spacer />
                        <v-btn color="error" text @click="dialogOpen = false"> Cancelar </v-btn>
                        <v-btn class="" v-if="search === 'NOMBRE'" :disabled="!nombreCurpValido" color="primary" text @click="dialogOpen = false, resetSearch('CURP', nombreCurp, true)"> Registrar </v-btn>
                        <v-btn v-else color="primary" text @click="showDialogPerson(0)"> Aceptar </v-btn>
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
                        <v-btn color="primary" text @click="verifyCurp(false)"> Verificar </v-btn>
                    </v-card-actions>
                </v-card>
            </v-dialog>
        </template>
        <!-- DIALOG INSPECTOR -->
        <template>
            <v-dialog v-model="dialogInspector" transition="dialog-bottom-transition" persistent max-width="600">
                <v-card>
                    <v-card-title>
                        La clave ingresada pertenece a un inspector
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
        <!-- DIALOG MULTIPLE PEOPLE  -->
        <template>
            <v-dialog v-model="dialogPeopleFounds" transition="dialog-bottom-transition" persistent max-width="600">
                <v-card>
                    <v-card-title>
                        Se han encontrado varios registros asociados a la búsqueda
                    </v-card-title>
                    <v-card-text>
                        Favor de seleccionar uno
                        <v-row>
                            <v-col cols="12" md="12">
                                <v-simple-table>
                                    <template v-slot:default>
                                        <thead>
                                            <tr>
                                                <th class="text-left">
                                                    Nombre
                                                </th>
                                                <th class="text-left">
                                                    Fecha de Nacimiento
                                                </th>
                                                <th class="text-left">
                                                    ¿Es inspector?
                                                </th>
                                                <th class="text-left" style="min-width: 140px;">
                                                    Acciones
                                                </th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr v-for="item in peopleFounds" :key="item.iidpersona">
                                                <!-- {{ item }} -->
                                                <td>{{ item.txtnombre }}{{ item.txtapepat }}</td>
                                                <td>{{ item.dfecha_nacimiento }}</td>

                                                <td>
                                                    <template item.isInspector>
                                                        <v-icon v-show="item.isInspector" size="medium" color="green">
                                                            mdi-check
                                                        </v-icon>
                                                        <v-icon v-show="!item.isInspector" size="medium"
                                                            color="red">mdi-close</v-icon>
                                                    </template>
                                                </td>
                                                <td>
                                                    <template>
                                                        <v-tooltip bottom v-if="!item.isInspector">
                                                            <template v-slot:activator="{ on, attrs }">
                                                                <v-btn v-bind="attrs" v-on="on" icon small
                                                                    @click="peopleSelected(item)">
                                                                    <v-icon small v-show="item.isInspector"> mdi-close
                                                                    </v-icon>
                                                                    <v-icon small v-show="!item.isInspector"> mdi-check
                                                                    </v-icon>
                                                                </v-btn>
                                                            </template>
                                                            <span>Seleccionar persona</span>
                                                        </v-tooltip>
                                                    </template>
                                                </td>
                                            </tr>
                                        </tbody>

                                    </template>
                                </v-simple-table>
                            </v-col>
                        </v-row>
                    </v-card-text>
                    <v-card-actions>
                        <v-spacer />
                        <v-btn color="error" text @click="dialogPeopleFounds = false"> Cancelar </v-btn>
                        <v-btn color="primary" text @click="redirectInspector"> Aceptar </v-btn>
                    </v-card-actions>
                </v-card>
            </v-dialog>
        </template>

        <modal-create-person ref="ModalCreatePerson" :isNewPerson="true" @person-created="handlefromCreatePerson" />
    </v-row>
</template>
<style>
.p-radio .v-input--radio-group__input {
    display: flex;
    justify-content: center;
}
</style>

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
            search: 'CURP',
            nombre: '',
            curp: '',
            rfc: '',
            nombreCurp: '',
            nombreValido: false,
            curpValida: false,
            rfcValida: false,
            nombreCurpValido: false,

            dialogOpen: false,
            dialogCurpChanged: false,
            dialogInspector: false,
            dialogPeopleFounds: false,
            personaEncontrada: false,
            personaDisponible: false,
            curpVerificada: '',
            rutaInspector: '',
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
            nombreCompleto: '',
            rules: {
                ...rules,
            },
            peopleFounds: [],
        }
    },
    methods: {
        ...mapActions('app', ['showError', 'showSuccess']),
        toUpperCase() {
            this.nombre = this.nombre.toUpperCase();
            this.curp = this.curp.toUpperCase();
            this.rfc = this.rfc.toUpperCase();
            this.nombreCurp = this.nombreCurp.toUpperCase();
        },
        showDialogPerson(iidpersona) {
            this.dialogOpen = false
            this.dialog = true;
            console.log('se mostrará el dialog persona 1')
            console.log(iidpersona) //0
            console.log(this.curp) //CAUM990224HYNRCC06
            this.$refs.ModalCreatePerson.$data.persona.iidpersona = iidpersona;
            this.$refs.ModalCreatePerson.$data.persona.txtcurp = this.curp;
            if (iidpersona == 0) {
                this.$refs.ModalCreatePerson.$data.dialog = true;
            }
            // else{
            // this.$refs.ModalCreatePerson.$data.persona.iidpersona = iidpersona;
            // }
        },
        async verifyCurp(needModal) {
            this.dialogCurpChanged = false;
            let curp = this.curp;
            console.log('TIPO DE BÚSQUEDA: ' + this.search)
            console.log('CURP A VERIFICAR 1 ' + curp)
            console.log('NECESITA MODAL' + needModal)

            try {
                let response = ''
                let data = {};
                if (this.search === 'NOMBRE') {
                    console.log('seleccionó nombre')
                    data = {
                        typeSearch: this.search,
                        dataSearch: this.nombre
                    }
                }
                if (this.search === 'CURP') {
                    console.log('seleccionó curp')
                    data = {
                        typeSearch: this.search,
                        dataSearch: this.curp
                    }
                }
                if (this.search === 'RFC') {
                    console.log('seleccionó rfc')
                    data = {
                        typeSearch: this.search,
                        dataSearch: this.rfc
                    }
                }
                response = await services.inspections().getPersonByDinamycSearch({ data });
                console.log(response)
                console.log(response.length)
                console.log(response.length == 1)
                console.log(typeof (response))
                console.log(response[0] == false)
                // SI NO EXISTE SE AGREGA LA PERSONA
                if (response[0] == false || !response) {
                    console.log('CURP A VERIFICAR 5' + curp)
                    console.log('PERSONA NO ENCONTRADA')
                    this.personaEncontrada = false
                    this.personaDisponible = true
                    this.$refs.ModalCreatePerson.$data.persona.iidpersona = 0;
                    this.$refs.ModalCreatePerson.$data.persona.txtcurp = this.persona.txtcurp;
                    this.$emit('person-info', false, true, this.persona, this.persona.txtcurp, this.persona.isInspector);
                    this.dialogOpen = true;
                } else if (typeof (response) === 'object' && response.length > 1) {
                    // alert('fue búsqueda por nombre y hay más registros')
                    this.peopleFounds = response
                    this.dialogPeopleFounds = true
                    // SI SOLO SE ENCONTRÓ UNA SEA POR NOMBRE, RFC O CURP SE VERIFICA SI ES INSPECTOR
                } else {
                    response = response[0]
                    if (response.isInspector === false) { //Si la persona no es inspector(esta disponible) devuelve la persona encontrada
                        this.personaEncontrada = true
                        this.personaDisponible = true
                        this.persona = { ...response }
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
                        this.curpVerificada = this.persona.txtcurp
                        this.$emit('person-info', this.personaEncontrada, this.personaDisponible, this.persona, this.persona.txtcurp, this.persona.isInspector);

                        this.$refs.ModalCreatePerson.$data.dialog = needModal;
                        this.$refs.ModalCreatePerson.$data.persona.iidpersona = this.persona.iidpersona;
                        this.$refs.ModalCreatePerson.$data.persona.txtcurp = this.persona.txtcurp;
                    } else if (response.isInspector === true) {  // Si la persona ya es inspector mostrará un modal de redirección
                        this.personaEncontrada = true
                        this.personaDisponible = false
                        this.persona = { ...response }
                        this.curpVerificada = this.persona.txtcurp
                        this.$emit('person-info', this.personaEncontrada, this.personaDisponible, this.persona, this.persona.txtcurp, this.persona.isInspector);
                        this.rutaInspector = `/inspectors/${response.iidinspector}/edit`;
                        this.dialogInspector = true;
                    }
                }
            } catch (error) {
                const message = 'Error al procesar curp.';
                this.showError({ message, error });
            }
        },
        peopleSelected(persona) {
            // console.log('se ha seleccionado esta perosna')
            // console.log(persona)
            console.log(persona)
            this.persona = persona
            console.log(this.persona)
            this.personaEncontrada = true
            this.personaDisponible = true
            this.persona = { ...persona }
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
            this.curpVerificada = this.persona.txtcurp
            this.$emit('person-info', this.personaEncontrada, this.personaDisponible, this.persona, this.persona.txtcurp, this.persona.isInspector);

            // this.$refs.ModalCreatePerson.$data.dialog = needModal;
            this.$refs.ModalCreatePerson.$data.persona.iidpersona = this.persona.iidpersona;
            this.$refs.ModalCreatePerson.$data.persona.txtcurp = this.persona.txtcurp;
            this.dialogPeopleFounds = false

        },
        redirectInspector() {
            this.$router.push(this.rutaInspector);
            setTimeout(() => {
                window.location.reload()
            }, 100);
        },
        resetSearch(typeSearch, dataSearch, needModal){
            this.search = typeSearch
            if(this.search == 'CURP'){
                this.curp = dataSearch
            }
            this.verifyCurp(needModal)
        },
        handlefromCreatePerson(personCreated, curp) {
            if (personCreated) {
                this.curp = curp
                this.verifyCurp(false)
                this.$emit('person-info', this.personaEncontrada, this.personaDisponible, this.persona, curp);
            } else {
                alert('no se pudo crear')
            }
        },
        // Método para manejar el evento keydown
        handleEnterKey: function (event) {
            if (event.keyCode === 13) {
                event.preventDefault();
                // this.$refs.verificarCurpBtn.click();
                const button = document.querySelector('.search-btn');
                if (button) {
                    button.click();
                }
            }
        }
    },
    watch: {
        'curp': function () {
            const curpRules = this.rules.curp;
            this.personaEncontrada = false
            if (curpRules) {
                this.curpValida = curpRules(this.curp) === true;
            }
        },
        'rfc': function () {
            const rfcRules = this.rules.rfc;
            if (rfcRules) {
                this.rfcValida = rfcRules(this.rfc) === true;
            }
        },
        'nombre': function () {
            const nombreRules = this.rules.required;
            if (nombreRules) {
                this.nombreValido = nombreRules(this.nombre) === true;
            }
        },
        'nombreCurp': function () {
            const curpRules = this.rules.curp;
            this.personaEncontrada = false
            if (curpRules) {
                this.nombreCurpValido = curpRules(this.nombreCurp) === true;
            }
        },
    },
    mounted() {
        // Agrega un event listener para el evento keydown en el documento
        document.addEventListener('keydown', this.handleEnterKey);
    },
    beforeDestroy() {
        // Limpia el event listener cuando el componente se destruye
        document.removeEventListener('keydown', this.handleEnterKey);
    }

}
</script>