<template>
    <v-container fluid>
        <v-row justify="center">
            <generic-card-dashboard title="Firmas generadas" subtitle="En totalidad de uso" :cant="counts.firm_registers" columnSize=4
                avatarSize="80px" url="/signature/firms" :openInNewTab=false />
            <generic-card-dashboard title="Plantillas generadas" subtitle="Hasta la fecha" :cant="counts.firm_templates" columnSize=4
                avatarSize="80px" url="/signature/templates" :openInNewTab=false />
            <generic-card-dashboard title="Total de usuarios" subtitle="En el sistema" :cant="counts.firm_users" columnSize=4 avatarSize="80px"
                url="https://ejemplo.com" :openInNewTab=false />
        </v-row>
    </v-container>
</template>

<script>
import GenericCardDashboard from "@/components/common/GenericCardDashboard.vue";

import services from "@/services";
// import { mapActions } from "vuex";
export default {
    name: 'Dashboard',
    components: {
        GenericCardDashboard,
    },
    data() {
        return {
            counts:[],
        }
    },
    methods: {
        // GET (BD)
        async getDinamycCount() {
            try {
                this.counts = {...await services.signature().getDinamycCount()};
                console.log(this.counts)
                //this.$refs.urlFrame.href = url;
                // this.$refs.serviceFrame.src = url;
            } catch (error) {
                const message = 'Error al cargar servicio de conteo.';
                alert(message);
            }
        },
    },
    async mounted() {
        await this.getDinamycCount()
    }
}
</script>

<style lang="scss" scoped></style>