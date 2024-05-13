<template>
    <v-form v-model="isFormValid">
        <v-row>
            <v-col cols="12">Uno</v-col>
            {{ removeFieldsArray }}
            <template v-for="(field, index) in genericFormFields">
                <v-col :key="index" :cols="field.cols" :md="field.md">
                    {{ index }} <br>
                    <template>(v-if): {{ removeFieldsArray.includes(index)  ? 'Se removerá' : 'Existirá'}}</template><br>
                    <template>(clase): Tendrá la clase: {{ hiddenFieldsArray.includes(index)? 'd-none' : 'd-block'  }}</template><br>
                    <template>(disabled): Estará: {{ disabledFieldsArray.includes(index)? 'deshabilitado' : 'habilitado' }}</template><br>
                </v-col>
            </template>
            <v-col cols="12">Dos</v-col>

            <template v-for="(field, index2) in genericFormFields">
                <v-col :key="index2" :cols="field.cols" :md="field.md">
                    {{ index2 }} <br>
                    <template>(v-if): {{ removeFields[index2] ? 'Se removerá' : 'Existirá' }}</template> <br>
                    <template>(clase): Tendrá la clase: {{ hiddenFields[index2] ? 'd-none' : 'd-block' }}</template> <br>
                    <template>(disabled): Estará: {{ disabledFields[index2] ? 'deshabilitado' : 'habilitado' }}</template>
                </v-col>
            </template>

        </v-row>
    </v-form>
</template>

<script>
import rules from "@/core/rules.forms";

export default {
    name: 'GenericFormValidation',
    props: {
        formFieldsWithValues: {
            type: Object,
            required: false
        },
        formFields: {
            type: Object,
            required: true
        },
        removeFieldsArray: {
            type: Array,
            default: () => ([])
        },
        hiddenFieldsArray: {
            type: Array,
            default: () => ([])
        },
        disabledFieldsArray: {
            type: Array,
            default: () => ([])
        },
        removeFields: {
            type: Object,
            default: () => ({})
        },
        hiddenFields: {
            type: Object,
            default: () => ({})
        },
        disabledFields: {
            type: Object,
            default: () => ({})
        },
    },
    data() {
        return {
            genericFormFields: {},
            isFormValid: false,
            mascara: null,
            modelosMascaras: {
                phone:
                {
                    mask: '(###) ###-####',
                    regexMask: /\D/g
                },
                rfc: '##-##-##'
            }
        }
    },
    methods: {
        getFieldRules(field) {
            const rulesArray = [];
            if (field.rules) {
                const fieldRules = field.rules.split('|');
                fieldRules.forEach(rule => {
                    if (rules[rule]) {
                        rulesArray.push(rules[rule]);
                    }
                });
            }
            return rulesArray;
        },
        getMask(type) {
            if (type.maskType) {
                // console.log(this.modelosMascaras[type.maskType].mask)
                return this.modelosMascaras[type.maskType].mask
            } else {
                return null
            }
        },
        isFieldDisabled(fieldName) {
            console.log('viendo disabled')
            console.log(fieldName + '--' + this.disabledFields[fieldName])
            return this.disabledFields[fieldName] || false;
        },
        // isShowField(fieldName){
        //     console.log(this.showFields)
        //     console.log('el valor de : ' + fieldName + ' es: ' + this.showFields[fieldName])
        //     if(this.showFields[fieldName]){
        //         return true
        //     }
        //     // else{
        //     //     // console.log('el valor de : ' + fieldName + ' es: ' + this.showFields[fieldName])
        //     //     return 'd-block'

        //     // }
        // },
        // isHiddenField(fieldName) {
        //     console.log('el valor de : ' + fieldName + ' es: ' + this.removeFields[fieldName])
        //     if (this.removeFields[fieldName]) {
        //         return true
        //     } else {
        //         // console.log('el valor de : ' + fieldName + ' es: ' + this.removeFields[fieldName])
        //         return 'd-block'

        //     }
        // }
    },
    computed: {
        atributosCampo() {
            return {
                // 'v-mask': this.mascara(this.modelo) // Asignar dinámicamente el v-mask según el modelo seleccionado
            };
        },
    },
    watch: {
        isFormValid() {
            this.$emit('form-valid', this.isFormValid);
        },
        formFieldsWithValues() {
            for (const key in this.genericFormFields) {
                const field = this.genericFormFields[key];
                field.model = this.formFieldsWithValues[key] || '';
            }
        }


    },
    mounted() {
        this.genericFormFields = { ...this.formFields };
        for (const key in this.genericFormFields) {

            const field = this.genericFormFields[key];
            field.model = ''
            this.$watch(() => field.model, (value) => {
                const maskIndex = key.indexOf("_mask_");
                if (maskIndex > 1) {
                    const maskType = key.substring(maskIndex + 6);
                    const returnValue = value.replace(this.modelosMascaras[maskType].regexMask, '');
                    this.$emit('new-value', key.substring(0, maskIndex), returnValue);
                } else {
                    this.$emit('new-value', key, value);
                }
            });
        }
    }
}
</script>
