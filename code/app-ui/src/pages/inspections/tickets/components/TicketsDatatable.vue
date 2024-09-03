<template>
  <div class="wrapper">
    <tickets-datatable-dialogs ref="dialogs" />
      <!-- {{ tickets }} ---------- {{  ticketsTotalItems}}------{{ ticketsTotalPages }} -->
    <v-data-table
      class="elevation-1"
      loading-text="Cargando información"
      :headers="headers"
      :items="tickets"
      :page-count="ticketsTotalPages"
      :server-items-length="ticketsTotalItems"
      :options.sync="options"
      :loading="loadingTable"
    >
      <template v-slot:item.activo="{ item }">
        <!-- {{ item.bactivo}} -->
        <v-icon v-show="item.activo" size="medium" color="green"> mdi-check </v-icon>
        <v-icon v-show="!item.activo" size="medium" color="red">mdi-close</v-icon>
      </template>

      <template v-slot:item.acciones="{ item }">
        <v-tooltip v-if="permissions.includes('veii')" bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-btn 
              v-bind="attrs" 
              v-on="on" 
              icon 
              small
              @click="actionsHandler(item, 'view')"
            >
              <v-icon small> mdi-eye </v-icon>
            </v-btn>
          </template>
          <span>Ver boleta</span>
        </v-tooltip>

        <v-tooltip v-if="permissions.includes('edii')" bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-btn
              v-bind="attrs" 
              v-on="on" 
              icon 
              small
              @click="actionsHandler(item, 'edit')"
            >
              <v-icon small> mdi-square-edit-outline </v-icon>
            </v-btn>
          </template>
          <span>Editar boleta</span>
        </v-tooltip>

        <v-tooltip v-if="permissions.includes('boii')" bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-btn
              v-bind="attrs" 
              v-on="on" 
              icon 
              small
              @click="actionsHandler(item, 'delete')"
            >
              <v-icon small v-show="item.activo"> mdi-close </v-icon>
              <v-icon small v-show="!item.activo"> mdi-check </v-icon>
            </v-btn>
          </template>
          <span>{{ item.activo ? "Desactivar" : "Activar" }} boleta</span>
        </v-tooltip>

      </template>
    </v-data-table>
  </div>
</template>

<script>
import TicketsDatatableDialogs from "@/pages/inspections/tickets/components/TicketsDatatableDialogs";
import services from "@/services";
import { mapActions, mapState } from "vuex";

export default {
  name: "TicketsDatatable",
  components: {
    TicketsDatatableDialogs,
  },
  data() {
    return {
      permissions: [],
      options: {
        tickets: [],
        page: 1,
        itemsPerPage: 10,
        sortBy: ['nombre_infractor'],//nombre
        sortDesc: [false],
        multiSort: true,
        mustSort: false,
      },
      loadingTable: true,
      headers: [
        {
          text: "Infractor",
          value: "nombre_infractor",
          align: "center",
          class: "font-weight-bold",
        },
        {
          text: "Fecha/Hora Infracción",
          value: "dtfecha_hora_infraccion",
          align: "center",
          class: "font-weight-bold",
        },
        {
          text: "Activo",
          value: "activo",
          align: "center",
          class: "font-weight-bold",
        },
        {
          text: "Acciones",
          value: "acciones",
          align: "center",
          sortable: false,
          width: "196px",
        },
      ],
    };
  },
  computed: {
    ...mapState('app', ['tickets', 'ticketsTotalPages', 'ticketsTotalItems']),
  },
  methods: {
    ...mapActions('app', ['getTickets']),
    async loadTicketsTable() {
      console.log(this.tickets);
      const { page, itemsPerPage, sortBy, sortDesc } = this.options;
      const data = { page, itemsPerPage, sortBy, sortDesc }; 
      this.getTickets({ data });
      console.log('front')
      console.log(data)
      this.loadingTable = false;
    },
    actionsHandler(ticket, action) {
      console.log('actionsHandler')
      console.log(ticket)
      console.log(action)
      this.$refs.dialogs.ticket = ticket;

      switch (action) {
        case 'edit': this.$router.push(`/tickets/${ticket.iidboleta}/edit`); break;
        case 'view': this.$refs.dialogs.viewTicket(); break;
        default: this.$refs.dialogs.show[action] = true;
      }
    },
  },
  watch: {
    options: {
      handler() {
        this.loadTicketsTable();
      },
      deep: true,
    },
  },
  async mounted() {
    const { iin } = await services.security().getPermissions();
    if (iin) this.permissions = iin;
  }
};
</script>
