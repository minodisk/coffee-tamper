{ extname, resolve } = require 'path'
{ readFile, exists } = require 'fs'
{ waterfall } = require 'async'
CSON = require 'cson'
{ assign } = require 'lodash'


module.exports =
class CoffeeTamper

  constructor: ->


  run: (options) ->
    tamperOptions = {}

    waterfall [
      (next) =>
        @loadConfig options.config, next
    ], (err, configOptions) ->
      unless err?
        assign tamperOptions, configOptions
      console.log tamperOptions
      console.log 'done'


  loadConfig: (path, callback) ->
    unless path?
      callback null, {}
      return

    switch extname path
      when '.coffee'
        try
          callback null, require resolve './', path
        catch err
          callback err
      when '.json'
        try
          callback null, JSON.parse readFileSync path
        catch err
          callback err
      when '.cson'
        CSON.parseFile path, callback
