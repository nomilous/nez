Node      = require './node' 
Exception = require './exception'

module.exports = PluginFactory = 

    load: (pluginName, config) -> 

        plugin = PluginFactory.validate require pluginName

        #
        # pass the stacker through the plugin configurer
        # for 3rd party extensions
        #

        stack = require('./nez').stack
        stack.name = pluginName


        plugin.configure stack.stacker, config


        #
        # register plugin for edge events
        #

        stack.on 'edge', plugin.edge

        return stack.stacker

    validate: (plugin) ->

        unless typeof plugin.configure == 'function'

            throw Exception.create 'INVALID_PLUGIN', 'Undefined Plugin.configure()'

        unless typeof plugin.edge == 'function'

            throw Exception.create 'INVALID_PLUGIN', 'Undefined Plugin.edge()'

        return plugin

