Config       = require('nezcore').config
PluginLoader = require './plugin_loader'

module.exports = 

    load: (label, config, injectable) -> 

        console.log '\n\nrun realize with:\n', arguments, '\n\n'

        #
        # Load default realizer config
        #

        defaults            = Config.get 'realizer'
        defaults.label      = label
        defaults.injectable = injectable


        #
        # Override with local config and 
        # register plugin
        #

        for key of config

            defaults[key] = config[key]

        PluginLoader.load defaults

