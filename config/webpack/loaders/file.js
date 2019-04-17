var path = require('path');

module.exports = {
  test: /\.(woff(2)?|eot|otf|ttf|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
  exclude: path.resolve(__dirname, '../../../app/assets'),
  use: {
    loader: 'file-loader',
    options: {
      outputPath: 'fonts/',
      useRelativePath: false
    }
  }
}
