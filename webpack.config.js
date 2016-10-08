'use strict';

const path = require('path');
const webpack = require('webpack');
const CopyWebpackPlugin = require('copy-webpack-plugin');

function join(dest) { return path.resolve(__dirname, dest); }

function web(dest) { return join('web/static/' + dest); }

const config = module.exports = {
  entry: './web/static/js/app.js',
  output: {
    path: './priv/static',
    filename: 'js/app.js',
  },

  resolve: {
    extensions: ['', '.js', '.jsx'],
    modulesDirectories: ['node_modules'],
  },

  module: {
    noParse: /vendor\/phoenix/,
    loaders: [
      {
        test: /\.jsx?$/,
        exclude: /node_modules/,
        loader: 'babel',
        query: {
          cacheDirectory: true,
          presets: ['react', 'es2015'],
        },
      }
    ],
  },

  plugins: [
    new CopyWebpackPlugin([{
      context: './web/static/assets/',
      from: '**/*'
    }]),
    new CopyWebpackPlugin([{
      context: './web/static/',
      from: 'css/**/*'
    }])
  ]
};

if (process.env.NODE_ENV === 'production') {
  config.plugins.push(
    new webpack.optimize.DedupePlugin(),
    new webpack.optimize.UglifyJsPlugin({ minimize: true })
  );
}
