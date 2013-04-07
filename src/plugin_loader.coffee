Node           = require './node' 
Exception      = require './exception'
PluginRegister = require './plugin_register'

module.exports = PluginFactory = 

    load: (runtime, stack, config) -> 

        if typeof config._module == 'undefined'

            if module = config._class.match(/^(.*):(.*)/)[1..2]

                #
                # _class was defined as 'module:Class'
                #
                
                plugin = require(module[0])[module[1]]

        else

            #
            # _module was defined
            #

            plugin = require config._module


        plugin = PluginFactory.validate plugin

        scaffold = 

            #
            # plugin receives reference to stack label
            #

            label: stack.label

            #
            # plugin receives reference to the stack array
            #

            stack: stack.stack

            #
            # plugin receives referrence to the stack pusher
            #

            pusher: stack.stacker


        plugin.configure runtime, scaffold, config

        #
        # register the plugin
        #

        PluginRegister.register plugin


        #
        # subscribe to edge events
        #

        stack.on 'edge', plugin.edge

        return plugin


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

