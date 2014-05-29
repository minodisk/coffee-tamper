{ readdirSync, readFileSync, writeFileSync } = require 'fs'
{ inspect } = require 'util'
{ resolve, dirname, basename, extname, sep } = require 'path'
{ exec, spawn } = require 'child_process'
{ compile } = require 'coffee-script'


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
                  'concat:bin'
                  'test'
                ]
              when 'CoffeeTamper.coffee'
                [
                  'coffee:lib'
                  'test'
                ]
          when 'test'
            [
              'coffee:test'
              'test'
            ]

    coffee:
      bin:
        files:
          'bin/tamper': 'src/tamper.coffee'
        options:
          bare: true
      lib:
        files:
          'lib/CoffeeTamper.js': 'src/CoffeeTamper.coffee'
      test:
        files:
          'test/tamper-test.js': 'test/tamper-test.coffee'
          'test/CoffeeTamper-test.js': 'test/CoffeeTamper-test.coffee'

    concat:
      bin:
        options:
          banner: '#!/usr/bin/env node\n\n'
        src    : [ 'bin/tamper' ]
        dest   : 'bin/tamper'

    clean:
      test: [ 'test/*.js' ]


  grunt.loadNpmTasks 'grunt-este-watch'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-release'

  grunt.registerMultiTask 'coffee', ->
    for dest, src of @data.files
      cs = readFileSync src, encoding: 'utf8'
      js = compile cs, @data.options
      writeFileSync dest, js, encoding: 'utf8'

  grunt.registerTask 'npmTest', ->
    done = @async()
    exec 'npm test', (err, stdout, stderr) ->
      grunt.log.write stdout
      grunt.log.write stderr
      done()

  grunt.registerTask 'test', [
    'coffee:test'
    'npmTest'
    'clean:test'
  ]

  grunt.registerTask 'default', [
    'coffee'
    'concat'
    'test'
    'esteWatch'
  ]
