<template>
  <v-card :loading="loading" class="widget" :class="{ fullscreened: fullscreened, 'ma-1': true}" >
    <v-toolbar flat>
      <v-toolbar-title v-if="title"> {{ title }} </v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn v-if="expandable" icon @click="handleFullscreen">
        <v-icon>mdi-arrow-{{fullscreened? 'collapse':'expand'}}</v-icon>
      </v-btn>
      <v-btn v-if="collapsable" icon @click="handleCollapse">
        <v-icon :class="{'mdi-rotate-180': this.openedPanel === 0 }">mdi-chevron-up</v-icon>
      </v-btn>
    </v-toolbar>

      <v-card-text>
        <v-expansion-panels v-model="openedPanel" flat>
        <v-expansion-panel>
        <v-expansion-panel-content>
          <slot></slot>
        </v-expansion-panel-content>
        </v-expansion-panel>
        </v-expansion-panels>
      </v-card-text>

  </v-card>
</template>

<script>
/*
|---------------------------------------------------------------------
| Copy Label Component
|---------------------------------------------------------------------
|
| Copy to clipboard with the plugin clipboard `this.$clipboard`
|
*/
export default {
  props: {
    title: { type: String, default: '' },
    expandable: { type: [Boolean, String], default: false },
    collapsable: { type: [Boolean, String], default: false },
    loading: { type: [Boolean], default: false },
  },
  data() {
    return {
      show: true,
      openedPanel: 0,
      fullscreened: false
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
  }
}
</script>

<style scoped>
.widget .v-card__text,
.widget .v-expansion-panel-content__wrap {
  padding: 0px;
}
.widget.fullscreened {
    position: fixed;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    margin: 0;
    z-index: 10000;
    overflow-y: scroll;
}
</style>
