plugins  = []
handlers = {}
matchers = {}

module.exports = PluginRegister =

    register: (plugin) -> 

        #
        # Plugins register their handlers and matchers
        #

        for handler in plugin.handles

            handlers[handler] ||= []
            handlers[handler].push plugins.length

        for match in plugin.matches

            matchers[match] ||= []
            matchers[match].push plugins.length


        plugins.push plugin

        return PluginRegister

    hup: -> 

        for plugin in plugins

            plugin.hup()


    handle: (node) ->

        #
        # Process the node though each matching plugin.
        # 
        # NOTE: This should be a syncronous operation!
        # 
        #       Any asyncronous calls performed
        #       in the plugin handlers will very
        #       likely callback after the node
        #       has already been emitted over 
        #       the edge.
        #  
        
        unless typeof handlers[node.class] == 'undefined'

            handlerFnName = node.class

            for addr in handlers[ handlerFnName ]

                plugin = plugins[ addr ]

                plugin[handlerFnName] node



        if typeof node.label == 'object' 
        
            for key of node.label

                unless typeof matchers[key] == 'undefined'

                    for addr in matchers[key]

                        plugin = plugins[ addr ]

                        handlerFn = plugin[key] node.label[key]

                        handlerFn node

        return node

