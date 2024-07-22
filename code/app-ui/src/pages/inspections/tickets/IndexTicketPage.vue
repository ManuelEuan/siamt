<template>
    <v-container fluid>
        <v-row justify="center">
            <v-col cols="12" class="pa-0">
                <tickets-filters />
            </v-col>
            <v-col cols="12" class="pa-0 mt-2">
                <tickets-datatable />
            </v-col>
        </v-row>
    </v-container>
    </template>
    
    <script>
    // import services from '@/services';  
    import TicketsFilters from "@/pages/inspections/tickets/components/TicketsFilters.vue";
    import TicketsDatatable from "@/pages/inspections/tickets/components/TicketsDatatable.vue";
    export default {
        name: 'TicketsPage',
        components: {
            TicketsFilters,
            TicketsDatatable
        },
        data() {
            return {
                data: ''
            }
        },
    //     async mounted(){
    //         this.data = await services.inspections().getTickets();
    
    //   }
    }
    </script>
    
    <style lang="scss" scoped>
    
    </style>
    