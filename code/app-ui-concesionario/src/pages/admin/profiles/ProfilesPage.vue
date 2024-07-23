<template>
<v-container fluid>
    <v-row justify="center">
        <v-col cols="12" class="pa-0">
            <profiles-filters />
        </v-col>
        <v-col cols="12" class="pa-0 mt-2">
            <profiles-datatable />
        </v-col>
    </v-row>
</v-container>
</template>

<script>
import ProfilesFilters from "@/pages/admin/profiles/components/ProfilesFilters.vue";
import ProfilesDatatable from "@/pages/admin/profiles/components/ProfilesDatatable.vue";
export default {
    name: 'ProfilesPage',
    components: {
        ProfilesFilters,
        ProfilesDatatable
    },
    data() {
        return {

        }
    }
}
</script>

<style lang="scss" scoped>

</style>
