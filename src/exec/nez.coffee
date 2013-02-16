#
# nez cli
#

program = require 'commander'

program.option '-d, --dev', 'Run development environment.'

program.parse process.argv

module.exports = 

    exec: ->

        if program.dev

            #
            # --dev 
            #

            run = './dev'


        #
        # for now - make dev the default
        #

        run = './dev'



        app = new ( require run ) program
        app.start()
            
