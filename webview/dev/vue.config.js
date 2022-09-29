const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: [
    'vuetify'
  ],
  publicPath: '',
  outputDir: 'docs',
  pwa: {
    name: 'Singapore Population Map'
  }
})
