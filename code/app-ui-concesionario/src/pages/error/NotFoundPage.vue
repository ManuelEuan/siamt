<template>
  <v-card class="text-center w-full error-page pa-3">
    <v-img src="/images/illustrations/404-illustration.svg" max-height="400" contain />
    <div class="display-2 mt-10">¿Cómo llegaste aquí?</div>
    <div class="mt-3 mb-6">Lo sentimos, no podemos encontrar la página que estás buscando.</div>
    
    <v-btn to="/" block large color="primary">Regresar</v-btn>
  </v-card>
</template>

<style>
.error-page {
  max-width: 500px;
}
</style>
