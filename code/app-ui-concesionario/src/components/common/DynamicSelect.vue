<template>

  <v-select 
    :items="items" 
    :label="label" 
    :item-value="itemId" 
    :item-text="itemLabel"
    :item-disabled="itemDisabled"
    :loading="loading" 
    :value="item" 
    @input="itemSelected($event)"
    :no-data-text="noDataLabel"
    :clearable="clearable"
    :rules="rules"
    :readonly="readonly"
  ></v-select>

</template>

<script>
// import services from '@/services';
// import rules from '@/core/rules.forms';

export default {
  props: {
    source: {
      type: Object,
      default: () => { return {}; },
      required: false
    },
    label: {
      type: String,
      default: '',
      required: false
    },
    clearable: {
      type: Boolean,
      default: false,
      required: false
    },
    readonly: {
      type: Boolean,
      default: false,
      required: false
    },
    disabled: {
      type: Boolean,
      default: false,
      required: false
    },
    rules: {
      type: Array,
      default: () => [],
      required: false
    }
  },
  data() {
    return {
      loading: false,
      items: null,
      itemId: this.source.itemId,
      itemLabel: this.source.itemLabel,
      itemDisabled: this.source.itemDisabled,
      item: null,
      
      noDataLabel: "No hay datos disponibles",
    }
  },
  watch: {
    source(val){
      console.log("WATCH",val);

      this.updateSource();
    }
  },
  beforeDestroy() {
  },
  methods: {
    itemSelected(itemId){
      let item = this.items.find(e => e[this.source.itemId] === itemId)
      this.$emit('input', item);
    },
    async updateSource() {

      if(this.source.data){
        this.loading = true;
        this.items = await this.source.data();
        this.loading = false;
      }
    }
  },
  async created() {
    this.updateSource();
  }
}
</script>

<style scoped>
</style>
