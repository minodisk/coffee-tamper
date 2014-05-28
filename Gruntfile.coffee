{ readdirSync } = require 'fs'
{ inspect } = require 'util'
{ resolve, dirname, basename, extname, sep } = require 'path'
{ exec, spawn } = require 'child_process'


firstDirname = (filepath) ->
  filepath.split(sep)[0]
secondDirname = (filepath) ->
  filepath.split(sep)[1]


module.exports = (grunt) ->
  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    esteWatch:
      options:
        dirs: [
          'src/**/'
          'lib/**/'
          'test/**/'
        ]
        livereload:
          enabled: false
      coffee: (filepath) ->
        switch firstDirname filepath
          when 'src'
            switch basename filepath
              when 'tamper.coffee'
                [
                  'coffee:bin'
                  'concat'
                  'clean:bin'
                  'test'
                  'clean:test'
                ]
              when 'CoffeeTamper.coffee'
                [
                  'coffee:lib'
                  'test'
                  'clean:test'
                ]
          when 'test'
            [
              'coffee:test'
              'test'
              'clean:test'
            ]

    coffee:
      bin:
        options:
          bare: true
        files  : [
          expand: true
          cwd   : 'src'
          src   : [ 'tamper.coffee' ]
          dest  : 'bin'
          ext   : '.js'
        ]
      lib:
        files: [
          expand: true
          cwd   : 'src'
          src   : [ 'CoffeeTamper.coffee' ]
          dest  : 'lib'
          ext   : '.js'
        ]
      test:
        files: [
          expand: true
          src   : [ 'test/*.coffee' ]
          ext   : '.js'
        ]

    concat:
      bin:
        options:
          banner: '#!/usr/bin/env node\n\n'
        src    : [ 'bin/tamper.js' ]
        dest   : 'bin/tamper'

    simplemocha:
      options:
        reporter: 'tap'
      tests: [ 'test/*-test.js' ]

    clean:
      bin: [ 'bin/*.js' ]
      test: [ 'test/*.js' ]


  grunt.loadNpmTasks 'grunt-este-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-release'

  grunt.registerTask 'test', ->
    done = @async()
    exec 'npm test', (err, stdout, stderr) ->
      grunt.log.write stdout
      grunt.log.write stderr
      done()

  grunt.registerTask 'default', [
    'coffee'
    'concat'
    'test'
    'clean'
    'esteWatch'
  ]
