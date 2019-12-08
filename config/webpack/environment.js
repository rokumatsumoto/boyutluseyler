const { environment } = require('@rails/webpacker')
const erb = require('./loaders/erb')
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

// resolve-url-loader must be used before sass-loader
environment.loaders.get('sass').use.splice(-1, 0, {
  loader: 'resolve-url-loader'
});

// environment.loaders.prepend('file', file)

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)

environment.config.merge(customConfig)

environment.loaders.prepend('erb', erb)
module.exports = environment
