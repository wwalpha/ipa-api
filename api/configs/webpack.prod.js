const webpack = require('webpack');
const merge = require('webpack-merge');
const baseConfig = require('./webpack.base');

const dev = {
  mode: 'production',
  plugins: [
    new webpack.LoaderOptionsPlugin({
      debug: false,
    }),
  ],
};

module.exports = merge(baseConfig, dev);
