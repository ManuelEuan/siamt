<template>
  <div class="d-flex text-center flex-column flex-md-row flex-grow-1 strip-background">
    <div class="pa-2 pa-md-4 flex-grow-1 align-center justify-center d-flex flex-column">
      <div class="layout-content ma-auto w-full">
        <slot></slot>
      </div>
      <div class="overline mt-4">{{ product.name }} - {{ product.version }}</div>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'

export default {
  computed: {
    ...mapState('app', ['product'])
  }
}
</script>

<style scoped>
.layout-side {
  width: 420px;
}

.layout-content {
  max-width: 480px;
}

.strip-background {
  background-image: url(@/assets/images/strip-pattern.png);
  background-size: cover;
  height: 100%;
}
</style>
