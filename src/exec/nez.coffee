#
# nez cli
#

program = require 'commander'
colors  = require 'colors'

program.option '-d, --dev [flavour]',     'Run development environment. [coffee|js]'
program.option '-u, --uplink [hostname]', 'Uplink to your Nimbal instance'
program.option '-n, --noautospec',        'Disable autogeneration of missing specs'

program.parse process.argv


module.exports = ExecNez = 

    exec: (objective, config) ->

        #
        # Eyes on the target!
        # (Show the objective at startup)
        #

        console.log '\n' + "(objective) " + objective.bold

        ExecNez.objective = objective

        return ExecNez.start unless config

        ExecNez.start config


    start: (config) ->

        ExecNez.config = config

        # for meta of config

        #     continue if meta == 'nimbal'
        #     continue if meta == 'description'

        #     console.log "(#{meta}) " + ExecNez.config[meta].bold 

        console.log config['description'].bold if config['description']


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

            