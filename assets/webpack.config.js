const path = require('path')
const glob = require('glob')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const CssMinimizerPlugin = require('css-minimizer-webpack-plugin')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const { ESBuildMinifyPlugin } = require('esbuild-loader')

module.exports = (env, options) => {
  const devMode = options.mode !== 'production'

  return {
    entry: {
      app: glob.sync('./vendor/**/*.js').concat(['./js/app.js'])
    },
    output: {
      path: path.resolve(__dirname, '../priv/static/js'),
      filename: '[name].js',
      publicPath: '/js/'
    },
    module: {
      rules: [
        {
          test: /\.js$/,
          loader: 'esbuild-loader',
          options: {
            target: 'es2015'
          }
        },
        {
          test: /\.css$/,
          use: [
            MiniCssExtractPlugin.loader,
            {
              loader: 'css-loader',
              options: {
                url: false
              }
            },
            'postcss-loader'
          ]
        }
      ]
    },
    plugins: [
      new MiniCssExtractPlugin({ filename: '../css/app.css' }),
      new CopyWebpackPlugin({
        patterns: [{ from: 'static/', to: '../' }]
      })
    ],
    optimization: {
      minimizer: [
        '...',
        new CssMinimizerPlugin(),
        new ESBuildMinifyPlugin({
          target: 'es2015'
        })
      ]
    },
    devtool: devMode ? 'source-map' : undefined
  }
}
