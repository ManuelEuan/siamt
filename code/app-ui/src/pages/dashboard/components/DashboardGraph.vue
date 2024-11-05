<template>
  <v-card>
    <!-- <v-card-title>
    </v-card-title> -->
    <v-card-text>
      <figure>
        <highcharts
            :options="chartOptions">
        </highcharts>
      </figure>
    </v-card-text>
  </v-card>

</template>
<script>
//import services from "@/services";
//import VueApexCharts from 'vue-apexcharts';



export default {
  props : {
    info : Object
  },
  components : {
  },
  data() {
    return {
      chartOptions: {},
    }
  },
  mounted() {
    this.chartOptions = JSON.parse(this.info.data.t);
  },
  methods: {

  }
}
</script>
<style>

</style>