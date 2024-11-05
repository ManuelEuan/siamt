<template>
  <div>
    <v-card-title v-if="payload.name ? true : false">
      <span class="text--secondary font-weight-medium">{{payload.name}}</span>
      <v-spacer></v-spacer>
    </v-card-title>
    <v-card
      flat
      tile
      color="transparent"
      :class="'d-flex ' + (config.direction ?? 'flex-row') + ' flex-wrap justify-center align-center'"
    >
      <v-card
        v-for="item in items"
        :key="item.id"
        class="fill-height ma-1"
        max-width="300"
        elevation="12"
        :color="item.bgColor ?? ''"
      >
        <v-list-item two-line>
          <v-list-item-content>
            <v-list-item-title 
              class="text-h5" 
              :style="{color: item.cssTitleColor ?? ''}"
              v-html="item.title"
            >
            </v-list-item-title>
            <v-list-item-subtitle 
              class="text-wrap"
              :style="{color: item.cssSubtitleColor ?? ''}"
              v-html="item.subtitle"
            >
            </v-list-item-subtitle>
          </v-list-item-content>
        </v-list-item>

        <v-card-text class="pt-0">
          <v-row
            dense
            no-gutters
            style="flex-wrap: nowrap;"
          >
            <v-col
              align="start"
              class="text-h4 flex-grow-1 flex-shrink-0"
            >
            <span :style="{color: item.cssValueColor ?? ''}" v-html="item.value"></span>
            </v-col>
            <v-col align="end" class="flex-grow-0 flex-shrink-1">
              <v-icon
                v-if="item.icon ? true : false"
                small
                :color="item.color ?? (item.iconColor ?? '')"
              >
                {{item.icon + ' mdi-48px'}}
              </v-icon>
              <v-img
                v-else-if="item.image ? true : false"
                :src="item.image"
                alt="Item image"
                width="48"
                class="ml-auto"
              ></v-img>
            </v-col>
          </v-row>
        </v-card-text>
      </v-card>
    </v-card>
  </div>
</template>

<script>
// import moment from 'moment';
import services from '@/services';

export default {
  components: {},
  props: {
    payload: {
      type: Object,
      default: () => ({}),
      required: false
    },
    parentFilter: {
      type: Object,
      default: () => ({}),
      required: false
    },
  },
  data() {
    return {
      items: [],
      config: {},
      loading: false,
    };
  },
  computed: {
    isLoading() {
      return true === this.loading;
    }
  },
  methods: {
    hasPermission(permission) {
      return services.security().hasPermission(this.$route.meta.code, permission);
    },
  },
  async created() {
    this.loading = true;
    this.data = JSON.parse(this.payload.data.t);
    this.items = this.data.items;
    this.config = JSON.parse(this.payload.config);
    this.loading = false;
  },
  mounted() {}
}
</script>

<style lang="scss" scoped></style>