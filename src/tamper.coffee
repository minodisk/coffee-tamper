{ resolve } = require 'path'
{ readFileSync } = require 'fs'
CoffeeTamper = require resolve __dirname, '../lib/CoffeeTamper'
program = require 'commander'

pkgFile = resolve __dirname, '../package.json'
{ version } = JSON.parse readFileSync pkgFile, encoding: 'utf8'

program
.version version
.option '-c, --config [file]', 'Set config file path [Tamperfile.coffee]', 'Tamperfile.coffee'
.parse process.argv

tamper = new CoffeeTamper
tamper.run program
