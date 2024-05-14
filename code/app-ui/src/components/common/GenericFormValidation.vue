<template>
    <v-form v-model="isFormValid">
        <v-row>
            <template v-for="(field, index) in genericFormFields">
                <!-- <v-col  :key="index" :cols="field.cols" :md="field.md"  >
                    {{ index }}<br>
                    <template>(v-if): {{ dinamycRemoveFields.includes(index)  ? 'Se removerá' : 'Existirá'}}</template><br>
<template>(clase): Tendrá la clase: {{ dinamycHiddenFields.includes(index)? 'd-none' : 'd-block'  }}</template><br>
<template>(disabled): Estará: {{ dinamycDisabledFields.includes(index)? 'deshabilitado' : 'habilitado' }}</template><br>
</v-col> -->
                <v-col :key="index" :cols="field.cols" :md="field.md" v-if="!dinamycRemoveFields.includes(index)"
                    :class="dinamycHiddenFields.includes(index) ? 'd-none' : 'd-block'">
                    <template v-if="field.type === 'text'">
                        <v-text-field v-model="field.model" :label="field.label" hide-details="auto" clearable dense
                            outlined :rules="getFieldRules(field)" :disabled="dinamycDisabledFields.includes(index)"
                            v-mask="getMask(field)" />
                    </template>
                    <template v-else-if="field.type === 'autocomplete'">
                        <v-autocomplete v-if="field.array.type == 'list'" v-model="field.model" :label="field.label"
                            :items="field.array.info" dense outlined :rules="getFieldRules(field)"
                            :disabled="dinamycDisabledFields.includes(index)" />
                        <v-autocomplete v-else :rules="getFieldRules(field)" :class="field.inputClass"
                            :style="field.inputStyle" v-model="field.model" :label="field.label"
                            :items="field.array.info" dense outlined :item-text="field.array.item_text"
                            :item-value="field.array.item_value" :disabled="dinamycDisabledFields.includes(index)" />
                    </template>
                    <template v-else-if="field.type === 'textarea'">
                        <v-textarea v-model="field.model" :label="field.label" hide-details="auto" clearable dense
                            outlined />
                    </template>
                    <template v-else-if="field.type === 'date'">
                        <!-- <v-text-field v-model="field.model" type="date" :label="field.label"
                            :disabled="dinamycDisabledFields.includes(index)" :min="field.min" :max="field.max"
                            small-chips clearable dense outlined>
                        </v-text-field> -->
                        <v-menu v-model="field[index]" :close-on-content-click="false" :nudge-right="40"
                            transition="scale-transition" offset-y min-width="auto">
                            <template v-slot:activator="{ on, attrs }">
                                <v-text-field v-model="field.model" :label="field.label" prepend-icon="mdi-calendar"
                                    readonly v-bind="attrs" v-on="on" clearable dense outlined></v-text-field>
                            </template>
                            <v-date-picker v-model="field.model" @input="field[index] = false"></v-date-picker>
                        </v-menu>
                    </template>

                    <template v-else-if="field.type === 'time'">
                        <!-- <v-text-field type="time" v-model="field.model" :label="field.label"
                            :rules="getFieldRules(field)" hide-details="auto" clearable dense outlined /> -->
                        <v-menu :ref="index" v-model="field[index]" :close-on-content-click="false" :nudge-right="40"
                            :return-value.sync="field.model" transition="scale-transition" offset-y max-width="290px"
                            min-width="290px">
                            <template v-slot:activator="{ on, attrs }">
                                <v-text-field v-model="field.model" :label="field.label"
                                    prepend-icon="mdi-clock-time-four-outline" readonly v-bind="attrs" clearable dense
                                    outlined v-on="on"></v-text-field>
                            </template>
                            <v-time-picker v-if="field[index]" v-model="field.model" ampm-in-title format="24hr"
                                full-width scrollable @click:minute="saveModel(index, field.model)"></v-time-picker>
                        </v-menu>
                    </template>
                    <template v-if="field.type === 'color'">
                        <v-text-field v-model="field.model" :label="field.label" hide-details="auto" clearable dense type="color"
                            outlined :rules="getFieldRules(field)" :disabled="dinamycDisabledFields.includes(index)"
                            v-mask="getMask(field)" />
                    </template>
                    <template v-else-if="field.type === 'boolean'">
                        <v-switch v-model="field.model" inset
                            :label="field.label + ':' + (field.model ? '✔️' : '❌')"></v-switch>
                    </template>
                    <template v-else-if="field.type === 'datetime'">
                        <v-datetime-picker v-model="field.model" date-format="MM/dd/yyyy" :label="field.label"
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

                        <!-- <GenericDateTimePicker :textFieldProps="textFieldProps"></GenericDateTimePicker> -->
                        <!-- <slot name="dateIcon">
                            <v-icon> mdi-plus </v-icon>
                          </slot> -->
                        <!-- <v-text-field type="datetime-local" v-model="field.model" :label="field.label"
                            :rules="getFieldRules(field)" hide-details="auto" clearable dense outlined /> -->
                    </template>
                </v-col>

            </template>
        </v-row>
    </v-form>
</template>

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
            // DATETIME
            // textFieldProps: {
            // appendIcon: 'mdi-calendar-clock-outline ',
            // prependIcon: 'mdi-calendar-clock-outline ',
            // clearable: true,
            // dense: true,
            // outlined: true,
            // },
            // nullDatetime: null,
            // datetime: new Date(),
            // datetimeString: '2019-01-01 12:00',
            // formattedDatetime: '09/01/2019 12:00',
            // textFieldProps: {
            //     appendIcon: 'event'
            // },
            // dateProps: {
            //     headerColor: 'red'
            // },
            // timeProps: {
            //     useSeconds: true,
            //     ampmInTitle: true
            // },
            genericFormFields: {},
            isFormValid: false,
            mascara: null,
            // date: (new Date(Date.now() - (new Date()).getTimezoneOffset() * 60000)).toISOString().substr(0, 10),
            // menu: false,
            // modal: false,
            // menu2: false,
            // time: null,
            menu2: false,
            // modal2: false,
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
            console.log('Valor formateado:', format);
            // console.log(format);
            console.log(field);
            field.model = format
            console.log('otro valor');
            console.log(field);
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
            for (const key in this.genericFormFields) {
                const field = this.genericFormFields[key];
                field.model = this.formFieldsWithValues[key] || '';
            }
        },
        formFields() {
            console.log('this.formFields formValidation')
            console.log(this.formFields)

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
    },
    mounted() {
        // this.genericFormFields = { ...this.formFields };
        // for (const key in this.genericFormFields) {

        //     const field = this.genericFormFields[key];
        //     field.model = ''
        //     this.$watch(() => field.model, (value) => {
        //         const maskIndex = key.indexOf("_mask_");
        //         if (maskIndex > 1) {
        //             const maskType = key.substring(maskIndex + 6);
        //             const returnValue = value.replace(this.modelosMascaras[maskType].regexMask, '');
        //             this.$emit('new-value', key.substring(0, maskIndex), returnValue);
        //         } else {
        //             this.$emit('new-value', key, value);
        //         }
        //     });
        // }
    }
}
</script>
