const { environment } = require('@rails/webpacker')
// const webpack = require('webpack')
// environment.plugins.prepend('Provide',
//     new webpack.ProvidePlugin({
//         $: 'jquery/src/jquery',
//         jQuery: 'jquery/src/jquery',
//         Popper: 'popper.js'
//     })
// )

// ここから
// jQueryとBootstapのJSを使えるように
const webpack = require('webpack')
environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: 'popper.js'
  })
)
// ここまで

module.exports = environment