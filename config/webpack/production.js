process.env.NODE_ENV = process.env.NODE_ENV || 'production'

const environment = require('./environment')
const swiperConfig = require('./swiper_config')

environment.config.merge(swiperConfig);

module.exports = environment.toWebpackConfig()
