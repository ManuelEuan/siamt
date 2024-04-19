<template>
    <v-row class="d-flex align-center justify-center">
        <v-col cols="12" md="12" class="d-flex align-center justify-between" style="height:30px">
            CAUM990224HYNRCC05 ---- CAUM990224S31
            Permisos módulo personas {{ peopleModulePermissions }}
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
            <v-btn class="d-flex align-center ml-3 search-btn" depressed color="primary" @click="verifyCurp()"
                :disabled="!nombreValido">
                Verificar Nombre
            </v-btn>
        </v-col>

        <v-col cols="12" md="6" class="d-flex align-center justify-between" style="height:30px"
            v-if="search === 'CURP'">
            <v-text-field v-model="curp" label="CURP*" style="max-height: 40px;" :rules="[rules.curp]" maxlength="18"
                hide-details="auto" clearable dense @input="toUpperCase" outlined />
            <v-btn class="d-flex align-center ml-3 search-btn" depressed color="primary" @click="verifyCurp()"
                :disabled="!curpValida">
                Verificar CURP
            </v-btn>
        </v-col>


        <v-col cols="12" md="6" class="d-flex align-center justify-between" style="height:30px" v-if="search === 'RFC'">
            <v-text-field v-model="rfc" label="RFC*" style="max-height: 40px;" :rules="[rules.rfc]" maxlength="13"
                hide-details="auto" clearable dense @input="toUpperCase" outlined />
            <v-btn class="d-flex align-center ml-3 search-btn" depressed color="primary" @click="verifyCurp()"
                :disabled="!rfcValida">
                Verificar RFC
            </v-btn>
        </v-col>
        <v-card-text v-if="personaEncontrada && personaDisponible">
            <v-row>
                <v-col cols="12" md="4">
                    <v-text-field v-model="nombreCompleto" label="Nombre Completo" hide-details="auto" clearable dense
                        disabled outlined />
                </v-col>
                <v-col cols="12" md="4" v-if="persona.bfisica">
                    <v-text-field v-model="persona.txtcurp" label="CURP" hide-details="auto" clearable dense disabled
                        outlined />
                </v-col>
                <v-col cols="12" md="4" v-else>
                    <v-text-field v-model="persona.txtrfc" label="RFC" hide-details="auto" clearable dense disabled
                        outlined />
                </v-col>
                <v-col cols="12" md="4">
                    <v-btn class="d-flex align-center ml-3" depressed color="primary"
                        @click="curp = persona.txtcurp, search = 'CURP', showDialogPerson(persona.iidpersona)"
                        v-if="personaEncontrada && personaDisponible">
                        Ver información completa 1
                    </v-btn>
                </v-col>
            </v-row>
        </v-card-text>
        <!-- DIALOG REGISTRAR -->
        <generic-dialog :dialogVisible="dialogRegisterPerson" dialogTitle="No se han encontrado registros en el sistema"
            :showButtons=false @update:dialogVisible="dialogRegisterPerson = $event" @confirm="showDialogPerson(0)">
            <template v-slot:default>
                <div v-if="search === 'NOMBRE'">
                    Para poder registrar a la persona es necesario proporcionar el tipo de persona y sus datos
                    requeridos
                    <p class="col-md-2 my-0 mx-0 px-0 py-0">Tipo de persona</p>
                    {{ typePersonFisica }}
                    {{ curpRegisterFieldValido }}
                    {{ rfcRegisterFieldValido }}
                    <v-radio-group cols="12" md="4" v-model="typePersonFisica" mandatory row>
                        <v-radio color="success" label="Física" :value="true" style="max-width:80px"></v-radio>
                        <v-radio color="success" label="Moral" :value="false" style="max-width:80px"></v-radio>
                    </v-radio-group>
                    <v-text-field v-if="typePersonFisica" v-model="curpRegisterField" label="CURP*"
                        style="max-height: 40px;" :rules="[rules.curp]" maxlength="18" hide-details="auto" clearable
                        dense @input="toUpperCase" outlined />
                    <v-text-field v-else v-model="rfcRegisterField" label="RFC*" style="max-height: 40px;"
                        :rules="[rules.rfc]" maxlength="13" hide-details="auto" clearable dense @input="toUpperCase"
                        outlined />
                    <v-card-actions class="justify-end" style="margin-bottom: -1rem; margin-top: 1rem;">
                        <v-btn color="error" text @click="dialogRegisterPerson = false">Cancelar</v-btn>
                        <v-btn color="primary"
                            :disabled="typePersonFisica && !curpRegisterFieldValido || !typePersonFisica && !rfcRegisterFieldValido"
                            text @click="showDialogPerson(0)">Aceptar</v-btn>
                    </v-card-actions>
                </div>
                <div v-else class="mb-3">
                    ¿Desea registrarlo?
                    <v-card-actions class="justify-end" style="margin-bottom: -2.5rem;">
                        <v-btn color="error" text @click="dialogRegisterPerson = false">Cancelar</v-btn>
                        <v-btn color="primary" text @click="showDialogPerson(0)">Aceptar</v-btn>
                    </v-card-actions>
                </div>
            </template>

        </generic-dialog>

        <!-- DIALOG SIN PERMISOS PARA CREAR PERSONA -->
        <generic-dialog :dialogVisible="dialogNoPermissionsToCreate"
            dialogTitle="No se han encontrado registros en el sistema"
            @update:dialogVisible="dialogNoPermissionsToCreate = $event" @confirm="dialogNoPermissionsToCreate = false">
            <template v-slot:default>
                No cuenta con permisos suficientes para crear un registro de persona, favor de contactar al
                administrador del sitio.
            </template>
        </generic-dialog>

        <!-- DIALOG CAMBIO DE CURP -->
        <generic-dialog :dialogVisible="dialogCurpChanged" dialogTitle="Se ha detectado un cambio en el CURP verificado"
            @update:dialogVisible="dialogCurpChanged = $event" @confirm="verifyCurp()">
            <template v-slot:default>
                Favor de verificar de nuevo
            </template>
        </generic-dialog>

        <!-- DIALOG INSPECTOR -->
        <generic-dialog :dialogVisible="dialogInspector" dialogTitle="La clave ingresada pertenece a un inspector"
            @update:dialogVisible="dialogInspector = $event" @confirm="redirectInspector">
            <template v-slot:default>
                ¿Desea verificar la información?
            </template>
        </generic-dialog>

        <!-- DIALOG MULTIPLE PEOPLE  -->
        <generic-dialog :dialogVisible="dialogPeopleFounds"
            dialogTitle="Se han encontrado varios registros asociados a la búsqueda"
            @update:dialogVisible="dialogPeopleFounds = $event" @confirm="redirectInspector">
            <template v-slot:default>
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
                                        <th class="text-left" v-if="typeOfRequest">
                                            ¿Es inspector?
                                        </th>
                                        <th class="text-left" style="min-width: 140px;">
                                            Acciones
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="item in peopleFounds" :key="item.iidpersona">
                                        <td>{{ item.txtnombre }}{{ item.txtapepat }}</td>
                                        <td>{{ item.dfecha_nacimiento }}</td>
                                        <td v-if="typeOfRequest">
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
                                                <v-tooltip bottom v-if="!item.foundRequestSearched">
                                                    <template v-slot:activator="{ on, attrs }">
                                                        <v-btn v-bind="attrs" v-on="on" icon small
                                                            @click="peopleSelected(item)">
                                                            <v-icon small v-show="item.foundRequestSearched"> mdi-close
                                                            </v-icon>
                                                            <v-icon small v-show="!item.foundRequestSearched"> mdi-check
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
            </template>
        </generic-dialog>

        <modal-create-person ref="ModalCreatePerson" 
            :iidpersona=iidpersona :curp=curp
            :dataPersonFromCurpVerification=persona 
            @person-created="handlefromCreatePerson" 
        />
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
import GenericDialog from '@/components/common/GenericDialog.vue';

export default {
    components: {
        ModalCreatePerson,
        GenericDialog,
    },
    props: {
        iidpersona: {
            type: Number,
            default: 0 // Valor predeterminado
        },
        typeOfRequest: {
            type: String,
            default: ''
        },
        requestInfoComplete: {
            type: Object,
            default: function () {
                return {}; // Objeto vacío como valor predeterminado
            }
        }
    },
    data() {
        return {
            // ENVIAR A MODAL DE PERSONAS
            curp: '',
            activateModalPerson: true,

            // DATA DEL COMPONENTE
            search: 'CURP',
            nombre: '',
            rfc: '',
            nombreValido: false,
            curpValida: false,
            rfcValida: false,
            curpRegisterField: '',
            curpRegisterFieldValido: false,
            rfcRegisterField: '',
            rfcRegisterFieldValido: false,
            dialogRegisterPerson: false,
            dialogNoPermissionsToCreate: false,
            // DINAMYC DIALOGS 
            dialogCurpChanged: false,
            dialogInspector: false,
            dialogPeopleFounds: false,
            personaEncontrada: false,
            personaDisponible: false,
            typePersonFisica: 'true',
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

            // Permisos para personas
            peopleModulePermissions: [],
        }
    },
    methods: {
        ...mapActions('app', ['showError', 'showSuccess']),
        toUpperCase() {
            this.nombre = this.nombre.toUpperCase();
            this.curp = this.curp.toUpperCase();
            this.rfc = this.rfc.toUpperCase();
            this.curpRegisterField = this.curpRegisterField.toUpperCase();
            this.rfcRegisterField = this.rfcRegisterField.toUpperCase();

        },

        showDialogPerson(iidpersona) {
            console.log(iidpersona)
            this.dialogRegisterPerson = false
            this.dialog = true;
            console.log('se mostrará el dialog persona 1')
            if (iidpersona == 0) {
                localStorage.setItem('newPerson', true);
                this.verifyCurp(true)
            } else {
                localStorage.setItem('newPerson', false);
                this.$refs.ModalCreatePerson.dialog = true
            }
        },

        async verifyCurp(fromDialogRegister = false, onlyInformation = false) {
            this.dialogCurpChanged = false;
            try {
                let response = ''
                let data = {};
                if (fromDialogRegister) {
                    if (this.typePersonFisica) {
                        this.search = 'CURP'
                        this.curp = this.curpRegisterField
                    } else {
                        this.search = 'RFC'
                        this.rfc = this.rfcRegisterField
                    }
                }

                console.log('*************typeOfSearch*************')
                console.log(this.search)
                if (this.search === 'NOMBRE') {
                    console.log('seleccionó nombre')
                    data = {
                        typeSearch: this.search,
                        dataSearch: this.nombre,
                        typeOfRequest: this.typeOfRequest
                    }
                }
                if (this.search === 'CURP') {
                    console.log('seleccionó curp')
                    data = {
                        typeSearch: this.search,
                        dataSearch: this.curp,
                        typeOfRequest: this.typeOfRequest
                    }
                }
                if (this.search === 'RFC') {
                    console.log('seleccionó rfc')
                    data = {
                        typeSearch: this.search,
                        dataSearch: this.rfc,
                        typeOfRequest: this.typeOfRequest
                    }
                }

                console.log('*************typeOfRequest*************')
                console.log(this.typeOfRequest)

                console.log('*************data*************')
                console.log(data)


                response = await services.inspections().getPersonByDinamycSearch({ data });
                console.log('*************response by dinamyc search*************')
                console.log(response)

                // SI NO EXISTE SE AGREGA LA PERSONA
                if (!response || !response[0]) {
                    console.log('PERSONA NO ENCONTRADA')
                    this.personaEncontrada = false
                    this.personaDisponible = true
                    console.log('1')
                    localStorage.setItem('newPerson', true);
                    if (fromDialogRegister) {
                        this.$refs.ModalCreatePerson.dialog = true
                        if (this.typePersonFisica) {
                            this.persona = {
                                iidpersona: 0,
                                bfisica: true,
                                txtnombre: this.nombre,
                                txtcurp: this.curpRegisterField
                            }
                        } else {
                            this.persona = {
                                iidpersona: 0,
                                bfisica: false,
                                txtnombre: this.nombre,
                                txtrfc: this.rfcRegisterField
                            }
                        }
                        this.$refs.ModalCreatePerson.$data.informationForGeneralDataPerson = this.persona

                    }
                    else if (onlyInformation) {
                        console.log(this.persona)
                        alert('aqui')
                    } else {
                        this.peopleModulePermissions.includes('crmp') ? this.dialogRegisterPerson = true : this.dialogNoPermissionsToCreate = true
                    }

                } else if (response.length > 1) {
                    console.log('MÁS DE UN REGISTRO ENCONTRADO')
                    this.peopleFounds = response
                    this.dialogPeopleFounds = true
                } else {
                    console.log('BIEN, SOLO UN REGISTRO')
                    if (fromDialogRegister) {
                        this.dialogRegisterPerson = false
                        this.search = 'NOMBRE'
                        this.dialogRegisterPerson = true
                        let message = 'Error, el parámetro de búsqueda ya se encuentra capturado'
                        this.showSuccess(message);
                        // return alert('error, ya capturado')
                    }
                    response = response[0]
                    this.personaEncontrada = true
                    this.persona = response

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
                    localStorage.setItem('newPerson', false);
                    this.personaDisponible = true
                    if (onlyInformation) {
                        this.$refs.ModalCreatePerson.dialog = true
                    }
                    this.persona.bfisica = response.bfisica

                    if (this.typeOfRequest) {
                        if (response.foundRequestSearched === true && !onlyInformation) {  // Si la persona ya es inspector mostrará un modal de redirección
                            this.personaDisponible = false
                            this.curpVerificada = this.persona.txtcurp
                            this.rutaInspector = `/inspectors/${response.iidOfSearchedRequest}/edit`;
                            this.dialogInspector = true;
                        }
                        this.$emit('person-info', this.personaEncontrada, this.personaDisponible, this.persona, this.persona.txtcurp, this.persona.foundRequestSearched);
                    } else {
                        this.$emit('person-info', this.personaEncontrada, this.personaDisponible, this.persona, this.persona.txtcurp, this.persona.foundRequestSearched);
                    }
                  
                }
            } catch (error) {
                const message = 'Error al procesar curp.';
                this.showError({ message, error });
            }
        },
        peopleSelected(persona) {
            this.persona = persona
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
            this.txtcurp = this.persona.txtcurp;
            this.dialogPeopleFounds = false

        },
        redirectInspector() {
            this.$router.push(this.rutaInspector);
            setTimeout(() => {
                window.location.reload()
            }, 100);
        },
        handlefromCreatePerson(personCreated, curp) {
            if (personCreated) {
                console.log(personCreated, curp, 'retorno desde el modal create person')
                // this.curp = curp
                this.verifyCurp()
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
        'curpRegisterField': function () {
            this.rfcRegisterField = ''
            const curpRules = this.rules.curp;
            this.personaEncontrada = false
            if (curpRules) {
                this.curpRegisterFieldValido = curpRules(this.curpRegisterField) === true;
            }
        },
        'rfcRegisterField': function () {
            this.curpRegisterField = ''
            const rfcRules = this.rules.rfc;
            this.personaEncontrada = false
            if (rfcRules) {
                this.rfcRegisterFieldValido = rfcRules(this.rfcRegisterField) === true;
            }
        },
        // 'receivedCurp': function () {
        // this.curp = this.receivedCurp
        // },
        'iidpersona': function () {
            console.log('cambio del this.iidpersona')
            console.log(this.iidpersona)
        },
        'requestInfoComplete': function () {
            if (this.requestInfoComplete) {
                // SE ASIGNA TIPO DE PERSONA
                this.typePersonFisica = this.requestInfoComplete.bfisica
                // SE UTILIZA LA BÚSQUEDA DINÁMICA SEGÚN EL TIPO DE PERSONA
                if (this.typePersonFisica) {
                    this.search = 'CURP'
                    // this.curpRegisterField = this.requestInfoComplete.dataSearch
                    this.curp = this.requestInfoComplete.dataSearch
                } else {
                    this.search = 'RFC'
                    // this.rfcRegisterField = this.requestInfoComplete.dataSearch
                    this.rfc = this.requestInfoComplete.dataSearch
                }
                console.log('cambio en this.requestInfoComplete')
                console.log(this.typePersonFisica)
                console.log(this.curpRegisterField)
                console.log(this.rfcRegisterField)
                console.log(this.curp)
                console.log(this.rfc)
                this.verifyCurp(false, true)
            }
        },
    },
    async mounted() {
        // Agrega un event listener para el evento keydown en el documento
        document.addEventListener('keydown', this.handleEnterKey);
        const { pel } = await services.security().getPermissions();
        console.log('permisos para el módulo persona')
        console.log(pel)
        if (pel) this.peopleModulePermissions = pel;
    },
    beforeDestroy() {
        // Limpia el event listener cuando el componente se destruye
        document.removeEventListener('keydown', this.handleEnterKey);
    }

}
</script>