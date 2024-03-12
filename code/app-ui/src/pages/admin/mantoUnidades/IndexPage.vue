<template>
  <div class="d-flex flex-column flex-grow-1">
        Mantenimiento de Unidades 
        <br>
        Ejemplo de vista consumiendo desde api: {{ data }}
  </div>
</template>


<script>  
import services from '@/services';  
export default {
  
  data() {
    return {
      data: ''
    }
  },
  async mounted(){
    this.data = await services.mantounidades().demo();

  }
}
</script>


<style lang="scss" scoped>

</style>