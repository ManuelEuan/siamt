<template>
  <div>
    <v-dialog transition="dialog-top-transition" max-width="900" v-model="tracingVisibleProp">
      <v-card>
        <v-card-title class="text-uppercase primary--text text-h6 py-2">Seguimiento</v-card-title>
        <v-divider></v-divider>
        <v-card-text>
          <v-row>
            <v-col cols="12" class="d-flex justify-end">
              <v-text-field
                v-model="search"
                append-icon="mdi-magnify"
                label="Buscar"
                class="small-search"
              ></v-text-field>
            </v-col>
          </v-row>
          <v-data-table
            :headers="headers"
            :items="filteredTracingData"
            item-key="id"
            class="elevation-1"
            no-data-text="No data available"
          >
            <template v-slot:item="{ item }">
              <tr>
                <td>{{ item.nombreEtapa }}</td>
                <td>{{ item.nombreSubetapa }}</td>
                <td>{{ item.motivo }}</td>
                <td>{{ item.usuario }}</td>
                <td>{{ item.fecha }}</td>
              </tr>
            </template>
          </v-data-table>
        </v-card-text>
        <v-divider></v-divider>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="error" text @click="tracingVisibleProp = false">Cerrar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import AdminService from "@/services/admin.service";

export default {
  name: "TracingView",
  props: {
    vclave: {
      type: String,
      required: true
    },
    iidfolio: {
      type: Number,
      required: true
    },
    tracingVisible: {
      type: Boolean,
      required: true
    }
  },
  data() {
    return {
      tracingData: [],
      search: "",
      headers: [
        { text: 'Etapa', value: 'nombreEtapa' },
        { text: 'Subetapa', value: 'nombreSubetapa' },
        { text: 'Motivo', value: 'motivo' },
        { text: 'Usuario', value: 'usuario' },
        { text: 'Fecha', value: 'fecha' }
      ]
    };
  },
  computed: {
    tracingVisibleProp: {
      get() {
        return this.tracingVisible;
      },
      set(value) {
        this.$emit('update:tracingVisible', value);
      }
    },
    filteredTracingData() {
      if (!this.search) return this.tracingData;
      const searchLower = this.search.toLowerCase();
      return this.tracingData.filter(item =>
        item.nombreEtapa.toLowerCase().includes(searchLower) ||
        item.nombreSubetapa.toLowerCase().includes(searchLower) ||
        item.motivo.toLowerCase().includes(searchLower) ||
        item.usuario.toLowerCase().includes(searchLower)
      );
    }
  },
  mounted() {
    this.fetchTracingData();
  },
  methods: {
    async fetchTracingData() {
      try {
        const adminService = new AdminService('/api/admin');
        this.tracingData = await adminService.getTracing(this.vclave, this.iidfolio);
        console.log('Tracing data:', this.tracingData);
      } catch (error) {
        console.error('Error tracing data:', error);
      }
    }
  }
};
</script>

