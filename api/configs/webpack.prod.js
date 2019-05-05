const webpack = require('webpack');
const merge = require('webpack-merge');
const baseConfig = require('./webpack.base');

const prod = {
  mode: 'production',
  optimization: {
    minimize: false
  },
  plugins: [
    new webpack.LoaderOptionsPlugin({
      debug: false,
    }),
  ],
};

module.exports = merge(baseConfig, prod);
