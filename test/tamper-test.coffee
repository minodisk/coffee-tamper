{ exec } = require 'child_process'
{ resolve } = require 'path'
expect = require 'expect.js'

tamper = resolve __dirname, '../bin/tamper'
fixtures = resolve __dirname, 'fixtures'

describe 'tamper', ->

  it 'should accept command', (done) ->
    exec tamper, cwd: fixtures, (err, stdout, stderr) ->
      if err? or stderr isnt ''
        expect().fail()
      if stdout isnt ''
        console.log stdout
      done()
