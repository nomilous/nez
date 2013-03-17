program = require 'commander'
colors  = require 'colors'

program.option '-s, --scan [headRepo]',  'Scan for nested git repos'

program.parse process.argv

