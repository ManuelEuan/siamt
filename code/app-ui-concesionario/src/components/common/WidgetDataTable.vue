<template>
  <div>
    <Widget :title="title" :loading.sync="loading" :collapsable="collapsable" :expandable="expandable">
    </Widget>
  </div>
</template>

<script>
import Widget from '@/components/common/Widget'

export default {
  components: {
    Widget
  },
  props: {
    title: { type: String, default: '', required: false },
    expandable: { type: [Boolean, String], default: false, required: false },
    collapsable: { type: [Boolean, String], default: false, required: false },
    'data-source': {type: Function, default: () => {}, required: false},
  },
  data() {
    return {
      loading: false,
      data: []
    }
  },
  beforeDestroy() {

  },
  computed: {

  },
  methods: {
    handleCollapse(){
      this.openedPanel = this.openedPanel === 0? null : 0;
    },
    handleFullscreen(){
      this.fullscreened = !this.fullscreened;
    }
  },
  async created() {
    this.loading = true;
    this.data = await this.dataSource();
    this.loading = false;
  }
}
</script>

<style scoped>

</style>
