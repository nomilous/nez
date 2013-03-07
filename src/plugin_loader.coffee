Stack     = require './stack'
Exception = require './exception'

module.exports = PluginFactory = 

    load: (name, config) -> 

        plugin = PluginFactory.validate require name

        #
        # init a new stack
        #

        stack = new Stack name

        #
        # pass the stacker through the plugin configurer
        # for 3rd party extensions
        #

        plugin.configure stack.stacker, config
        
        return stack.stacker

    validate: (plugin) ->

        unless typeof plugin.configure == 'function'

            throw Exception.create 'INVALID_PLUGIN', 'Undefined Plugin.configure()'

        return plugin

