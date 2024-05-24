<template>
    <transition name="fade">
        <v-form v-model="isFormValid">
            <v-row>
                <template v-for="(field, index) in genericFormFields">
                    <!-- <v-col  :key="index" :cols="field.cols" :md="field.md"  >
                        {{ index }}<br>
                        <template>(v-if): {{ dinamycRemoveFields.includes(index)  ? 'Se removerá' : 'Existirá'}}</template><br>
<template>(clase): Tendrá la clase: {{ dinamycHiddenFields.includes(index)? 'd-none' : 'd-block'  }}</template><br>
<template>(disabled): Estará: {{ dinamycDisabledFields.includes(index)? 'deshabilitado' : 'habilitado' }}</template><br>
</v-col> -->
                    <v-col v-if="!dinamycRemoveFields.includes(index)" :key="index" :cols="field.cols" :md="field.md"
                        :class="dinamycHiddenFields.includes(index) ? 'd-none' : 'd-block'">
                        <template v-if="field.type === 'text'">
                            <v-text-field v-model="field.model" :label="field.label" hide-details="auto" clearable dense
                                outlined :rules="getFieldRules(field)" :disabled="dinamycDisabledFields.includes(index)"
                                v-mask="getMask(field)" />
                        </template>
                        <template v-else-if="field.type === 'autocomplete'">
                            <v-autocomplete v-if="field.array.type == 'list'" v-model="field.model" :label="field.label"
                                :items="field.array.info" clearable dense outlined :rules="getFieldRules(field)"
                                :disabled="dinamycDisabledFields.includes(index)" />
                            <v-autocomplete v-else :rules="getFieldRules(field)" :class="field.inputClass"
                                :style="field.inputStyle" v-model="field.model" :label="field.label"
                                :items="field.array.info" clearable dense outlined :item-text="field.array.item_text"
                                :item-value="field.array.item_value"
                                :disabled="dinamycDisabledFields.includes(index)" />
                        </template>
                        <template v-else-if="field.type === 'textarea'">
                            <v-textarea v-model="field.model" :label="field.label" hide-details="auto" clearable dense
                                outlined />
                        </template>
                        <template v-if="field.type === 'color'">
                            <v-text-field v-model="field.model" :label="field.label" hide-details="auto" clearable dense
                                outlined type="color" :rules="getFieldRules(field)" v-mask="getMask(field)"
                                :disabled="dinamycDisabledFields.includes(index)" />
                        </template>
                        <template v-else-if="field.type === 'boolean'">
                            <v-switch v-model="field.model" inset
                                :label="field.label + ':' + (field.model ? '✔️' : '❌')"></v-switch>
                        </template>
                        <template v-else-if="field.type === 'date'">
                            {{ field }}
                            <v-menu v-model="field[index]" :close-on-content-click="false" :nudge-right="40"
                                transition="scale-transition" offset-y min-width="auto">
                                <template v-slot:activator="{ on, attrs }">
                                    <v-text-field v-model="field.model" :label="field.label" prepend-icon="mdi-calendar"
                                        readonly v-bind="attrs" v-on="on" clearable dense outlined
                                        :rules="getFieldRules(field)" v-mask="getMask(field)"
                                        :disabled="dinamycDisabledFields.includes(index)"></v-text-field>
                                </template>
                                <v-date-picker  :min="field.min" :max="field.max" v-model="field.model" @input="field[index] = false"></v-date-picker>
                            </v-menu>
                        </template>

                        <template v-else-if="field.type === 'time'">
                            <!-- <v-text-field type="time" v-model="field.model" :label="field.label"
                                :rules="getFieldRules(field)" hide-details="auto" clearable dense outlined /> -->
                            <v-menu :ref="index" v-model="field[index]" :close-on-content-click="false"
                                :nudge-right="40" :return-value.sync="field.model" transition="scale-transition"
                                offset-y max-width="290px" min-width="290px">
                                <template v-slot:activator="{ on, attrs }">
                                    <v-text-field v-model="field.model" :label="field.label"
                                        prepend-icon="mdi-clock-time-four-outline" readonly v-bind="attrs" clearable
                                        dense outlined v-on="on" :rules="getFieldRules(field)" v-mask="getMask(field)"
                                        :disabled="dinamycDisabledFields.includes(index)"></v-text-field>
                                </template>
                                <v-time-picker v-if="field[index]" v-model="field.model" ampm-in-title format="24hr"
                                    full-width scrollable @click:minute="saveModel(index, field.model)"></v-time-picker>
                            </v-menu>
                        </template>

                        <template v-else-if="field.type === 'datetime'">
                            <v-datetime-picker v-model="field.model" :label="field.label" :rules="getFieldRules(field)"
                                v-mask="getMask(field)" :disabled="dinamycDisabledFields.includes(index)"
                                @input="handleDateTime(field)" :textFieldProps="{
                                    prependIcon: 'mdi-calendar-clock-outline ',
                                    clearable: true,
                                    dense: true,
                                    outlined: true,
                                }">
                                <template slot="dateIcon">
                                    <v-icon>mdi-calendar-range</v-icon>
                                </template>
                                <template slot="timeIcon">
                                    <v-icon>mdi-clock-time-eight-outline</v-icon>
                                </template>
                            </v-datetime-picker>
                        </template>

                    </v-col>

                </template>
            </v-row>
        </v-form>
    </transition>
</template>

<style>
.v-dialog__container+* {
    /* Estilos para el elemento hermano de .v-dialog__container */
    margin-top: 1rem !important;
}

.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.5s;
}

.fade-enter,
.fade-leave-to {
    opacity: 0;
}
</style>

<script>
import rules from "@/core/rules.forms";
// import GenericDateTimePicker from "@/components/common/GenericDateTimePicker.vue";
export default {
    name: 'GenericFormValidation',
    components: {
        // GenericDateTimePicker,
    },
    props: {
        formFieldsWithValues: {
            type: Object,
            required: false
        },
        formFields: {
            type: Object,
            required: true
        },
        dinamycRemoveFields: {
            type: Array,
            default: () => ([])
        },
        dinamycHiddenFields: {
            type: Array,
            default: () => ([])
        },
        dinamycDisabledFields: {
            type: Array,
            default: () => ([])
        },
    },
    data() {
        return {
            switch1: false,
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
        handleDateTime(field) {
            let format = this.formatDateTime(field.model)
            console.log('handleeee');
            console.log('Valor normal:', field.model);
            console.log('Valor formateado:', format);
            field.model = format
        },
        formatDateTime(value) {
            const date = new Date(value);
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');
            const hours = String(date.getHours()).padStart(2, '0');
            const minutes = String(date.getMinutes()).padStart(2, '0');
            const seconds = String(date.getSeconds()).padStart(2, '0');

            const formattedDateTime = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;

            // Ahora puedes hacer lo que quieras con el valor formateado, como emitir un evento o actualizar una variable en tu componente.
            // console.log('Valor formateado:', formattedDateTime);
            return formattedDateTime
        },

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
        saveModel(index, time) {
            console.log('ver time')
            console.log(index)
            // console.log(ref)
            // console.log(model)
            console.log(time)

            console.log(this.$refs[index][0].save(time))
            // $refs.menu[index-1].save(time)
        }
    },
    watch: {
        isFormValid() {
            this.$emit('form-valid', this.isFormValid);
        },
        formFieldsWithValues() {
            console.log('this.formFieldsWithValues ')
            console.log(this.formFieldsWithValues)
            console.log(this.formFields)

            this.genericFormFields = { ...this.formFields };
            console.log(this.genericFormFields)

            for (const key in this.formFieldsWithValues) {
                let value = this.formFieldsWithValues[key];
                if (Object.prototype.hasOwnProperty.call(this.genericFormFields, key)) {
                    this.genericFormFields[key].model = value;
                }
            }

        },
        formFields() {
            console.log('this.formFields formValidation')
            console.log(this.formFields)
            this.genericFormFields = { ...this.formFields };
            for (const key in this.genericFormFields) {
                const field = this.genericFormFields[key];
                if (field.model === key) {
                    field.model = ''
                }
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
    },
    mounted() {
        this.genericFormFields = { ...this.formFields };
        if (this.formFieldsWithValues) {
            for (const key in this.genericFormFields) {
                const field = this.genericFormFields[key];
                field.model = this.formFieldsWithValues[key] || '';
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

}
</script>
