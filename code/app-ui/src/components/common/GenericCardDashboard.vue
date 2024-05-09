<template>
    <v-col :cols="columnSize" class="">
        <v-card class="mx-auto" outlined>
            <v-list-item>
                <v-list-item-content>
                    <v-list-item-avatar tile color="primary" :style="{ maxWidth: avatarSize, height: avatarSize, margin: '0 auto' }">
                        <span style="font-size: 1.8rem; font-weight: bold; color: white;">{{ cant }}</span>
                    </v-list-item-avatar>
                    <v-list-item-title class="mt-2 text-center">
                        {{ title }}
                    </v-list-item-title>
                    <v-list-item-subtitle class="mt-1 text-center">{{ subtitle }}</v-list-item-subtitle>
                </v-list-item-content>
            </v-list-item>
            <!-- <v-divider></v-divider> -->
            <!-- <v-card-actions class="d-flex justify-end">
                <v-btn class="px-2" @click="openUrl">
                    <v-icon small class="mr-1">mdi-eye</v-icon> Visualizar
                </v-btn>
            </v-card-actions> -->
        </v-card>
    </v-col>
</template>
<script>
export default {
    props: {
        title: {
            type: String,
            required: true
        },
        subtitle: {
            type: String,
            required: true
        },
        cant: {
            type: Number,
            default: 0
        },
        columnSize: {
            type: Number,
            default: 4
        },
        avatarSize: {
            type: String,
            default: '80px'
        },
        url: {
            type: String,
            default: '#' // URL por defecto, puede ser cambiada
        },
        openInNewTab: {
            type: Boolean,
            default: false // Abre en la misma pestaña por defecto
        }
    },
    methods: {
        openUrl() {
            if (this.openInNewTab) {
                window.open(this.url, '_blank');
            } else {
                window.location.href = this.url;
            }
        }
    }
};
</script>
