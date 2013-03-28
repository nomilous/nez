Node           = require './node' 
Exception      = require './exception'
PluginRegister = require './plugin_register'

module.exports = PluginFactory = 

    load: (config) -> 

        plugin = module = require config._module

        unless typeof config.class == 'undefined'

            plugin = module[config._class]

        plugin = PluginFactory.validate plugin


        #
        # pass the stacker through the plugin configurer
        # for 3rd party extensions
        #

        stack = require('./nez').stack
        stack.name = '___OBJECTIVE___NAME___'


        plugin.configure stack.stacker, config

        #
        # register the plugin
        #

        PluginRegister.register plugin


        #
        # subscribe to edge events
        #

        stack.on 'edge', plugin.edge



        return stack.stacker

    validate: (plugin) ->

        unless typeof plugin.configure == 'function'

            throw Exception.create 'INVALID_PLUGIN', "INVALID_PLUGIN - Undefined Plugin.configure()"

        unless typeof plugin.edge == 'function'

            throw Exception.create 'INVALID_PLUGIN', 'INVALID_PLUGIN - Undefined Plugin.edge()'

        unless plugin.handles instanceof Array

            throw Exception.create 'INVALID_PLUGIN', 'INVALID_PLUGIN - Undefined Plugin.handles:[] array'

        for nodeType in plugin.handles

            unless typeof plugin[nodeType] == 'function'

                throw Exception.create 'INVALID_PLUGIN', "INVALID_PLUGIN - Undefined Plugin.#{ nodeType  }() handler"

        unless plugin.matches instanceof Array

            throw Exception.create 'INVALID_PLUGIN', 'INVALID_PLUGIN - Undefined Plugin.matches:[] array'

        for keyMatch in plugin.matches

            unless typeof plugin[keyMatch] == 'function'

                throw Exception.create 'INVALID_PLUGIN', "INVALID_PLUGIN - Undefined Plugin.#{ keyMatch  }() matcher"

        unless typeof plugin.hup == 'function'

            throw Exception.create 'INVALID_PLUGIN', 'INVALID_PLUGIN - Undefined Plugin.hup()'

        return plugin

