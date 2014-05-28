{ resolve } = require 'path'
{ readFileSync } = require 'fs'
{ puts } = require 'util'
CoffeeTamper = require resolve __dirname, '../lib/CoffeeTamper'
program = require 'commander'

pkgFile = resolve __dirname, '../package.json'
{ version } = JSON.parse readFileSync pkgFile, encoding: 'utf8'

console.log version

# commander
# .version version

# tamper = new CoffeeTamper
# tamper.run
