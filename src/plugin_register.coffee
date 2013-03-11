module.exports = PluginRegister =

    register: (plugin) -> 

        #
        # Plugins register their handlers and matchers
        #

        console.log 'registering plugin:', plugin


    handle: (node) ->

        #
        # Process the node though each matching plugin.
        # 
        # NOTE: This is a syncronous operation!
        # 
        #       Any asyncronous calls performed
        #       in the plugin handlers will very
        #       likely callback after the node
        #       has already been emitted over 
        #       the edge.
        #  