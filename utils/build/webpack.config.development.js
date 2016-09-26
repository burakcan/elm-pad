const webpack = require('webpack');
const baseConfig = require('./webpack.config.base');

const srcPath = baseConfig.__srcPath__;
const outPath = baseConfig.__outPath__;

module.exports = Object.assign(baseConfig, {
  debug: true,
  devtool: false,
});
