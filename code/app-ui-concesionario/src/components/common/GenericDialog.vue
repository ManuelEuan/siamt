<template>
    <v-dialog v-model="dialogVisibleProp" :max-width="maxWidth">
      <v-card>
        <v-card-title class="text-uppercase primary--text text-h6 py-2">{{ dialogTitle }}</v-card-title>
        <v-card-text>
            <slot></slot> <!-- Insertamos el contenido del slot -->
        </v-card-text>
        <v-divider></v-divider>
        <v-card-actions class="justify-end" v-if="showButtons">
          <!-- <v-spacer /> -->
          <v-btn color="error" text @click="cancelAction">Cancelar</v-btn>
          <v-btn color="primary" text :disabled=!disabledButtonConfirm @click="confirmAction">Aceptar</v-btn>
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
      showButtons: {
        type: Boolean,
        required: false,
        default: true
      },
      disabledButtonConfirm: {
        type: Boolean,
        required: false,
        default: true
      },
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
  