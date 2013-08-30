program = require 'commander'
fs      = require 'fs'
coffee  = require 'coffee-script'

 
program.version JSON.parse( fs.readFileSync __dirname + '/../../package.json', 'utf8' ).version
program.usage '[options] [realizerFile]'
program.parse process.argv


try
    
    filename = program.args[0]
    unless filename? 
        console.log 'missing realizerFile'
        process.exit 1

    realizer = fs.readFileSync filename, 'utf8'

    if filename.match /[coffee|litcoffee]$/
        realizer = coffee.compile realizer, bare: true

    realizer = eval realizer

catch error
    
    console.log error.message
    process.exit 2
