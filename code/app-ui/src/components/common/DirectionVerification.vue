<template>
    <v-form v-model="valid">
        <p>Direcciones</p>
        <v-row>
            <!-- <v-col cols="12" md="4">
          <v-select v-model="persona.iidestado_civil" label="Estado*" :items="civilStatus" item-text="txtnombre"
            item-value="iidestado_civil" hide-details="auto" small-chips clearable dense outlined />
        </v-col>
  
        <v-col cols="12" md="4">
          <v-select v-model="persona.iidsexo" label="Municipio*" :items="sexes" item-text="txtnombre"
            item-value="iidsexo" hide-details="auto" small-chips clearable dense outlined />
        </v-col> -->
            <v-col cols="12" md="6">
                <v-select v-model="direction.iidestado" label="Código postal*" :items="postalCodes"
                    item-text="txtnombre" item-value="iidcolonia" hide-details="auto" small-chips clearable dense :rules="[rules.required]" 
                    outlined />
            </v-col>
        </v-row>
        <v-row>
            <v-col cols="12" md="6">
                <v-text-field v-model="direction.txtcalle" label="Calle principal/s*" hide-details="auto" clearable
                    dense outlined :rules="[rules.required]" />
            </v-col>
            <v-col cols="12" md="6">
                <v-text-field v-model="direction.txtcalle_letra" label="Calle letra*" hide-details="auto" clearable
                    dense outlined />
            </v-col>
            <v-col cols="12" md="6">
                <v-text-field v-model="direction.inumero_exterior" label="Número exterior*" hide-details="auto"
                    clearable dense outlined />
            </v-col>
            <v-col cols="12" md="6">
                <v-text-field v-model="direction.txtnumero_exterior_letra" label="Numero exterior letra*"
                    hide-details="auto" clearable dense outlined />
            </v-col>
            <v-col cols="12" md="6">
                <v-text-field v-model="direction.inumero_interior" label="Número interior*" hide-details="auto"
                    clearable dense outlined />
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
                <v-text-field v-model="direction.txtreferencia" label="Referencia" hide-details="auto" clearable dense
                    outlined />
            </v-col>
            <v-col cols="12" md="6">
                <v-text-field v-model="direction.flatitud" label="Latitud" hide-details="auto" clearable dense
                    outlined />
            </v-col>
            <v-col cols="12" md="6">
                <v-text-field v-model="direction.flongitud" label="Longitud" hide-details="auto" clearable dense
                    outlined />
            </v-col>
        </v-row>
    </v-form>
</template>

<script>
import rules from "@/core/rules.forms";
import services from "@/services";
import { mapActions } from "vuex";
export default {
    data() {
        return {
            valid: false,
            postalCodes: [],
            direction: {
                iidcolonia: 0,
                txtcalle: '',
                txtcalle_letra: '',
                inumero_exterior: '',
                txtnumero_exterior_letra: '',
                inumero_interior: '',
                txtnumero_interior_letra: '',
                txtcruzamiento_uno: '',
                txtcruzamiento_uno_letra: '',
                txtcruzamiento_dos: '',
                txtcruzamiento_dos_letra: '',
                txtreferencia: '',
                flatitud: '',
                flongitud: '',
                bactivo: null,
                dtfecha_creacion: null,
                dtfecha_modificacion: null,
            },
            directions: [], 
            rules: {
                ...rules,
            },
            
        };
    },
    computed: {

    },
    methods: {
        ...mapActions('app', ['showError', 'showSuccess']),
        async loadSelectableData() {
            try {
                this.postalCodes = await services.inspections().getAllPostalCodes();
                console.log(this.postalCodes);
            } catch (error) {
                const message = 'Error al cargar opciones para nuevo inspector.';
                this.showError({ message, error });
            }
        },
    },
    async mounted() {
        await this.loadSelectableData();
    }
};
</script>

<style scoped>
/* Estilos específicos para el componente DirectionVerification.vue */
</style>