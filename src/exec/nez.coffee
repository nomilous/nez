#
# nez cli
#

program = require 'commander'

program.option '-d, --dev [flavour]',     'Run development environment. [coffee|js]'
program.option '-u, --uplink [hostname]', 'Uplink to your Nimbal instance'

program.parse process.argv


module.exports = 

    exec: ->

        #
        # enable dev CLI module by default
        #
        
        program.dev = true unless program.dev



        #
        # list of modules (from lib/exec/*) to load  
        #

        execModules = {}



        if program.uplink

            #
            # uplink is enabled, default to personal instance
            #

            hostname = 'localhost'

            if typeof program.uplink == 'string'

                hostname = program.uplink


            execModules['./uplink'] = hostname: hostname      




        
        if program.dev

            #
            # developer CLI was enabled
            #

            if typeof program.dev == 'boolean'

                #
                # default to coffee
                #

                flavour = 'coffee'

            else

                flavour = program.dev


            execModules["./dev/#{flavour}"] = program: program



        #
        # activate all enabled modules
        #

        for name of execModules

            ( 

                new ( require name ) execModules[name] 

            ).start()
            