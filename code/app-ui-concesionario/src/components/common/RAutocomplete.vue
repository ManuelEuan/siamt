<template>
  <v-autocomplete
    v-model="selectedItemId"
    :items="items"
    :auto-select-first="autoSelectAll"
    :label="label" 
    :item-value="itemId" 
    :item-text="itemLabel" 
    :item-disabled="itemDisabled" 
    :loading="isLoading" 
    :value="item"
    :hide-no-data="hideNoData"
    :hide-details="hideDetails"
    :hide-selected="hideSelected"
    :density="density"
    :error-messages="errorMessages"
    :clearable="clearable"
    :disabled="disabled || isDisabled"
    :multiple="multiple"
    :small-chips="smallChips"
    :deletable-chips="deletableChips"
    :chips="chips"
    :placeholder="placeholder"
    :prepend-icon="prependIcon"
    @input="itemSelected($event)"
    @focus="handleFocus"
    ref="control"
  ></v-autocomplete>
</template>

<script>

export default {
  name: 'r-autocomplete',
  // $_veeValidate: {
  //   name() {
  //     return this.label;
  //   },
  //   value() {
  //     return this.item;
  //   }
  // },
  props: {
    value: {
      required: false
    },
    autoSelectAll: {
      type: Boolean,
      default: false,
      required: false
    },
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
    placeholder: {
      type: String,
      default: '',
      required: false
    },
    clearable: {
      type: Boolean,
      default: false,
      required: false
    },
    hideNoData: {
      type: Boolean,
      default: false,
      required: false
    },
    hideDetails: {
      default: 'auto',
      required: false
    },
    hideSelected: {
      type: Boolean,
      default: false,
      required: false
    },
    density: {
      type: String,
      default: 'default',
      required: false
    },
    disabled: {
      type: Boolean,
      default: false,
      required: false
    },
    simple: {
      type: Boolean,
      default: false,
      required: false
    },
    prependIcon: {
      type: String,
      default: 'mdi-magnify',
      required: false
    },
    multiple: {
      type: Boolean,
      default: false,
      required: false
    },
    chips: {
      type: Boolean,
      default: false,
      required: false
    },
    smallChips: {
      type: Boolean,
      default: false,
      required: false
    },
    deletableChips: {
      type: Boolean,
      default: false,
      required: false
    },
    selectedId: {
      type: Number,
      default: null,
      required: false
    },
    parentId: {
      // type: Number,
      default: null,
      required: false
    },
    requiredParent: {
      type: Boolean,
      default: false,
    },
    parentId2: {
      // type: Number,
      default: null,
      required: false
    },
    requiredParent2: {
      type: Boolean,
      default: false,
    },
    errorMessages: {
      type: Array,
      default: () => [],
      required: false
    },
    errors: {
      type: Array,
      default: () => [],
      required: false
    }
  },
  data() {
    return {
      loading: false,
      items: [],
      itemId: this.source.itemId,
      itemLabel: this.source.itemLabel,
      itemDisabled: this.source.itemDisabled,
      selectedItemId: null,
      item: null,
      isFirstLoad: true,
      noDataLabel: "No hay datos disponibles",
    }
  },
  computed: {
    valid() {
      return this.$refs.control.valid;
    },
    isDisabled() {
      return (
        (this.requiredParent && this.parentId === null)
        || (this.requiredParent2 && this.parentId2 === null)
      );
    }
  },
  watch: {
    source() {
      this.updateSource();
    },
    value(val) {
      if(!val) {
        this.selectedItemId = this.simple ? null: [];
      } else if (this.multiple) {
        if (this.simple) {
          this.selectedItemId = val;
        } else {
          this.selectedItemId = val.map((e) => e[this.source.itemId]);
        }
      } else {
        if (this.simple) {
          this.selectedItemId = val;
        } else {
          this.selectedItemId =  val[this.source.itemId];
        }
      }
    },
    async selectedId(val) {
      this.selectedItemId = val;
      // this.itemSelected(this.selectedItemId);
      // if (this.requiredParent && this.parentId) {
      //   await this.updateSource();
      // } else if (!this.requiredParent) {
      //   await this.updateSource();
      // }
      await this.updateSource();

      // this.itemSelected(this.selectedItemId);
      if (this.selectedItemId) {
        this.itemSelected(this.selectedItemId);
      } else {
        this.$emit('input', null);
      }
    },
    async parentId(val, oldVal) {
      // this.selectedItemId = oldVal === null ? this.selectedItemId : null;
      this.selectedItemId = oldVal === null ? this.selectedItemId : null;
      await this.updateSource();

      if (this.selectedItemId) {
        this.itemSelected(this.selectedItemId);
      } else {
        this.$emit('input', null);
      }
      // if (this.requiredParent) {
      //   this.selectedItemId = null;
      //   this.updateSource();
      // }
    },
    async parentId2(val, oldVal) {
      // this.selectedItemId = oldVal === null ? this.selectedItemId : null;
      this.selectedItemId = oldVal === null ? this.selectedItemId : null;
      await this.updateSource();

      if (this.selectedItemId) {
        this.itemSelected(this.selectedItemId);
      } else {
        this.$emit('input', null);
      }
    }
  },
  beforeDestroy() {
  },
  methods: {
    itemSelected(itemId) {
      if (this.multiple) {
        if (this.simple) {
          this.item = itemId;
        } else {
          this.item = this.items.filter((e) => itemId.includes(e[this.source.itemId]));
        }
      } else {
        if (this.simple) {
          this.item = itemId;
        } else {
          this.item = this.items.find((e) => e[this.source.itemId] === itemId);
        }
      }

      this.$emit('input', this.item);
    },
    handleFocus() {
      if (!this.items || this.items.length == 0) {
        this.updateSource();
      }
    },
    focus() {
      this.$refs.control.focus();
    },
    async updateSource() {
      
      try {
        if (!this.source.data) {
          this.items = [];
          return;
        }

        this.isLoading = true;
        if(this.requiredParent 
            && this.parentId
            && this.requiredParent2 
            && this.parentId2) {
          this.items = await this.source.data(this.parentId, this.parentId2);
        } else if(this.requiredParent 
            && this.parentId
            && !this.requiredParent2) {
          this.items = await this.source.data(this.parentId);
        } else if(!this.requiredParent) {
          this.items = await this.source.data();
        } else {
          this.items = [];
        }

        if (this.autoSelectAll && this.isFirstLoad && this.multiple) {
          if (this.simple) {
            this.item = this.items.map((e) => e[this.source.itemId]);
          } else {
            this.item = [...this.items.map(({ [this.source.itemId]: itemId, [this.source.itemName]: itemName }) => ({ id: itemId, name: itemName }))];
          }

          this.$emit('input', this.item);
        }

        this.isFirstLoad = false;
      } catch {
        this.items = [];
      } finally {
        this.isLoading = false;
      }
    }
    // async updateSource() {
    //   try {
    //     this.isLoading = true;
    //     if(this.source.data 
    //         && this.requiredParent 
    //         && this.parentId) {
    //       this.items = await this.source.data(this.parentId, this.requiredParent);
    //     } else if(this.source.data 
    //         && this.requiredParent 
    //         && this.parentId) {
    //       this.items = await this.source.data(this.parentId, this.requiredParent);
    //     } else if(this.source.data && !this.requiredParent) {
    //       this.items = await this.source.data();
    //     } else {
    //       this.item = [];
    //     }

    //   } catch {
    //     // 
    //     this.items = [];
    //   } finally {
    //     this.isLoading = false;
    //   }
    // }
  },
  async created() {
    await this.updateSource();
    if (this.selectedItemId) {
      this.$nextTick(() => {
        this.itemSelected(this.selectedItemId);
      });
    }
  }
}
</script>

<style scoped>
</style>
