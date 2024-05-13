<template>
    <v-form v-model="isFormValid">
        <v-row>
            <template v-for="(field, index) in genericFormFields">
                <v-col  :key="index" :cols="field.cols" :md="field.md" v-if="!removeFields[index] === true" :class="hiddenFields[index] ? 'd-none' : 'd-block'">
                    <template>Existirá {{index}} -- {{!removeFields[index] === true}}</template>  ||
                    <template>Estará oculto {{index}} -- {{hiddenFields[index] ? 'd-none' : 'd-block'}}</template> ||
                    <template>Estará deshabilitado {{index}} -- {{isFieldDisabled(index)}}</template> 
                    <template v-if="field.type === 'text'">
                        <!-- Existen pero ocultos: {{ index }} -- {{ isShowField(index) }} -->
                        <v-text-field v-model="field.model" :label="field.label" hide-details="auto" clearable dense
                            outlined :rules="getFieldRules(field)" :disabled="isFieldDisabled(index)"
                            v-mask="getMask(field)" />
                    </template>
                    <template v-else-if="field.type === 'autocomplete'">
                        <v-autocomplete v-if="field.array.type == 'list'" v-model="field.model" :label="field.label"
                            :items="field.array.info" dense outlined :rules="getFieldRules(field)"
                            :disabled="isFieldDisabled(index)" />
                        <v-autocomplete v-else :rules="getFieldRules(field)" :class="field.inputClass"
                            :style="field.inputStyle" v-model="field.model" :label="field.label"
                            :items="field.array.info" dense outlined :item-text="field.array.item_text"
                            :item-value="field.array.item_value" :disabled="isFieldDisabled(index)" />
                    </template>
                </v-col>
                <v-col  :key="index" :cols="field.cols" :md="field.md" v-else >
                    <template>No existirán {{index}} -- {{!removeFields[index] === true}}</template> ||
                    <template>Estará oculto {{index}} -- {{isFieldDisabled(index)}}</template> ||
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
        disabledFields: {
            type: Object,
            default: () => ({})
        },
        removeFields: {
            type: Object,
            default: () => ({})
        },
        showFields: {
            type: Object,
            default: () => ({})
        },
        hiddenFields: {
            type: Object,
            default: () => ({})
        }
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
