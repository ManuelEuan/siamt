<template>
<v-card flat>
  <v-toolbar>
    <v-toolbar-title>Usuarios</v-toolbar-title>
    <v-spacer></v-spacer>
    <v-tooltip top>
      <template v-slot:activator="{ on, attrs }">
        <v-btn
            color="primary"
            class="me-1"
            @click="newUser"
            v-bind="attrs"
            v-on="on"
        >
          <v-icon>
            mdi-account-plus
          </v-icon>
        </v-btn>
      </template>
      <span>Nuevo usuario</span>
    </v-tooltip>
    <v-divider vertical class="mx-2"></v-divider>
    <v-badge
        overlap
        :content = "numberOfActiveFilters"
        :value = "numberOfActiveFilters"
    >
      <v-dialog
          v-model = "filterDialog"
          width = "500"
      >
        <template v-slot:activator="{on, attrs}">
          <v-btn
              fab
              color = "secondary"
              v-bind = "attrs"
              v-on = "on"
              small
          >
            <v-icon>mdi-filter</v-icon>
          </v-btn>
        </template>

        <v-card>
          <v-card-title class = "text-h5 pa-1">
            Filtros
          </v-card-title>
          <v-card-text>
            <v-container>
              <v-row>
                <v-col
                    cols = "12"
                    md = "6"
                    xl = "6"
                    class = "pa-1"
                >

                </v-col>
                <v-col
                    cols = "12"
                    md = "6"
                    xl = "6"
                    class = "pa-1"
                >

                </v-col>
                <v-col
                    cols = "12"
                    md = "6"
                    xl = "4"
                    class = "pa-1"
                >

                </v-col>
              </v-row>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn
                color ="warning"
                text
                @click="cleanFilters"
            >
              Borrar filtros
            </v-btn>
            <v-btn
                color ="danger"
                text
                @click="filterDialog = false"
            >
              Cancelar
            </v-btn>
            <v-btn
                color ="primary"
                text
                @click="applyFilters()"
            >
              Aplicar
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-badge>
  </v-toolbar>
</v-card>
</template>

<script>
export default {
  name: "UsersFilters",
  data () {
    return {
      numberOfActiveFilters : 0,
      filterDialog : false,
    }
  },
  methods : {
    cleanFilters() {

    },
    applyFilters() {

    },
    newUser() {
      this.$router.push('/users/new');
    }
  }
}
</script>

<style scoped>

</style>