<template>
    <v-container fluid>
        <v-form v-model="isFormValid">
            <v-row>
                <v-col v-for="(field, index) in genericFormFields" :key="index" :cols="field.cols" :md="field.md">
                    <template v-if="field.type === 'text'">
                        <v-text-field v-model="field.model" :label="field.label" hide-details="auto" clearable dense
                            outlined :rules="getFieldRules(field)" />
                    </template>
                    <template v-else-if="field.type === 'autocomplete'">
                        <v-autocomplete v-model="field.model" :label="field.label"
                            :items="['California', 'Colorado', 'Florida', 'Georgia', 'Texas', 'Wyoming']" dense outlined
                            :rules="getFieldRules(field)" />
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
        }
    },
    computed: {
    },
    created() {
    },
    watch: {
        isFormValid: {
            handler() {
                this.$emit('form-valid', this.isFormValid);
            },
            immediate: true
        },
        formFieldsWithValues: {
            handler() {
                console.log('llegando al generico')
                console.log(this.genericFormFields)
                console.log(this.formFieldsWithValues)
                Object.keys(this.genericFormFields).forEach(key => {
                    const field = this.genericFormFields[key];
                    field.model = this.formFieldsWithValues[key];
                });
                // this.genericFormFields = formFieldsWithValues
            },
            immediate: true
        },
    },
    mounted() {
        this.genericFormFields = { ...this.formFields }; // Copiar los campos del objeto formFields a genericFormFields
        Object.keys(this.genericFormFields).forEach(key => {
            const field = this.genericFormFields[key];
            field.model = '';
            this.$watch(() => field.model, (newValue) => {
                this.$emit('new-value', key, newValue);
            });
        });
    }
}
</script>
