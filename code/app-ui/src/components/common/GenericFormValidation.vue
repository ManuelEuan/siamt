<template>
    <v-container fluid>
        <v-form v-model="isFormValid">
            <v-row>
                <v-col v-for="(field, index) in genericFormFields" :key="index" :cols="field.cols" :md="field.md">
                    <template v-if="field.type === 'text'">
                        <v-text-field v-model="field.model" :label="field.label" hide-details="auto" clearable dense
                            outlined :rules="getFieldRules(field)" v-mask="getMask(field)" />
                    </template>
                    <template v-else-if="field.type === 'autocomplete'">
                        <v-autocomplete v-if="field.array.type == 'list'" v-model="field.model" :label="field.label"
                            :items="field.array.info" dense outlined :rules="getFieldRules(field)" />
                        <v-autocomplete v-else style="display: flex; align-items:center;" :rules="getFieldRules(field)"
                            v-model="field.model" label="Seleccione su plantilla" :items="field.array.info" dense
                            outlined :item-text="field.array.item_text" :item-value="field.array.item_value" />
                    </template>
                </v-col>
            </v-row>
        </v-form>
    </v-container>
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
            console.log('typesdwedw***********')
            console.log(type)
            if (type.maskType) {
                console.log(this.modelosMascaras[type.maskType].mask)
                return this.modelosMascaras[type.maskType].mask
            } else {
                return null
            }
        }
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
