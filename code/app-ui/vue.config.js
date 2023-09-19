const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  productionSourceMap: false,
  
  devServer: {
    host: '0.0.0.0',
    hot: true,
    liveReload: true,
    watchFiles: {
      paths: ["src/**/*", "public/**/*"],
      options: {
        usePolling: true,
      },
    },
    allowedHosts: 'all',
    port: 3000,
    client: {
      webSocketURL: 'auto://localhost/ws'
    }
  },
  
  css: {
    extract: { ignoreOrder: true },
    loaderOptions: {
      sass: {
        additionalData: '@import \'~@/assets/scss/vuetify/variables\''
      },
      scss: {
        additionalData: '@import \'~@/assets/scss/vuetify/variables\';'
      }
    }
  },
  
  chainWebpack: (config) => {
    // Remove the following lines to add Vue Prefetch and Preload on index.html
    // https://cli.vuejs.org/guide/html-and-static-assets.html#disable-index-generation
    config.plugins.delete('preload')
    config.plugins.delete('prefetch')
  },
  
  transpileDependencies: [
    'vue-echarts',
    'resize-detector',
    'vuetify'
  ]
})
