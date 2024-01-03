<template>
  <div class="d-flex flex-column flex-grow-1">
<!--    <div class="d-flex align-center py-1">-->
<!--      <div>-->
<!--        <div class="display-1">Debitaciones</div>-->
<!--        <v-breadcrumbs :items="breadcrumbs" class="pa-0 py-2"></v-breadcrumbs>-->
<!--      </div>-->

<!--    </div>-->


    <iframe class="embed-responsive-item" src="https://vnd-balance-tool.vinden.cloud/?client_id=PTbV7govNXW2HJX&authorize=fwZfyDyz7pOReFujepJWkxAEvel0XSfo" style="height: 100%; width: 100%"
            allowfullscreen>

    </iframe>

  </div>
</template>


<script>
// import CopyLabel from '@/components/common/CopyLabel'

export default {
  components: {
    // CopyLabel
  },
  data() {
    return {
      isLoading: false,
      breadcrumbs: [{
        text: 'Debitaciones',
        disabled: false,
        href: 'debitacion'
      }],
    }
  }
}
</script>


<style lang="scss" scoped>
.slide-fade-enter-active {
  transition: all 0.3s ease;
}
.slide-fade-leave-active {
  transition: all 0.3s cubic-bezier(1, 0.5, 0.8, 1);
}
.slide-fade-enter,
.slide-fade-leave-to {
  transform: translateX(10px);
  opacity: 0;
}
</style>