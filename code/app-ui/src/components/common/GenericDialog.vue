<template>
    <v-dialog v-model="dialogVisibleProp" :max-width="maxWidth">
      <v-card>
        <v-card-title>{{ dialogTitle }}</v-card-title>
        <!-- <v-card-text>{{ dialogText }}</v-card-text> -->
        <!-- Aquí usamos v-html para interpretar HTML -->
        <!-- <v-card-text v-html="dialogText"></v-card-text>  -->
        <v-card-text>
            <slot></slot> <!-- Insertamos el contenido del slot -->
        </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn color="error" text @click="cancelAction">Cancelar</v-btn>
          <v-btn color="primary" text @click="confirmAction">Aceptar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </template>
  
  <script>
  export default {
    props: {
      dialogVisible: {
        type: Boolean,
        required: true
      },
      dialogTitle: {
        type: String,
        required: true
      },
      // dialogText: {
      //   type: String,
      //   required: true
      // },
      maxWidth: {
        type: [Number, String],
        default: 600
      }
    },
    computed: {
      dialogVisibleProp: {
        get() {
          return this.dialogVisible;
        },
        set(value) {
          this.$emit('update:dialogVisible', value);
        }
      }
    },
    methods: {
      cancelAction() {
        this.dialogVisibleProp = false;
      },
      confirmAction() {
        this.dialogVisibleProp = false;
        this.$emit('confirm');
      }
    }
  };
  </script>
  