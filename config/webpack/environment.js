const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
const { VueLoaderPlugin } = require('vue-loader')
const customConfig = require('./custom')
const vue = require('./loaders/vue')
// const file = require('./loaders/file')

environment.plugins.append('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  jquery: 'jquery',
  Popper: ['popper.js', 'default']
}))

// environment.loaders.prepend('file', file)

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)

environment.config.merge(customConfig)

module.exports = environment
