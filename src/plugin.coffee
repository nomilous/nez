#
# Example Plugin
#

module.exports = Plugin =


    #
    # Plugin should define `configure()`
    # 
    #  - To optionally extend the stacker 
    #    with additional functionality.
    # 
    #  - To receive its configuration.
    #

    configure: (stacker, config) -> 



    #
    # Plugin should define `edge()`
    #
    #  - To receive edge events when the
    #    thread traverses between nodes.
    # 
    # 
    #    `placeholder` = { 'a pending thing' }
    # 
    #    `nodes` = {
    # 
    #        from: { 'the node that this edge departs from' }
    #        to:   { 'the node this this edge arrives at'   }
    #       
    #        #
    #        # and furthar classification of the 
    #        # edge traversal as follows
    #        #
    #       
    #        class: 'Tree.Rootward' # or 'Tree.Leafward'
    #     
    #    }
    #

    edge: (placeholder, nodes) -> 


    #
    # Plugin should define the list of node classes that it
    # handles:
    # 
    # eg. 
    # 
    # In the following edge definition... 
    # 
    #    fox 'jumps over', (dog) -> 
    #
    # ...fox and dog are node classes and the following
    #    plugin property declares to the plugin loader
    #    this this plugin handles the specified node 
    #    classes.
    #

    handles: ['fox', 'dog']

    #
    # And the corresponding functions should exist
    #

    fox: -> 
    dog: ->

    # 
    # The following nodes on the tree should each be handled by
    # the 'Requirements' plugin...
    # 
    #    Session
    # 
    #        as:    'user of the system'
    #        need:  'logout button'
    #        to:    'safely leave my workstation unattended' 
    #        title: 'logout', (specs) ->
    #         
    #    Session
    # 
    #        as:    'user of the system'
    #        want:  'lock session button'
    #        to:    'secure my workstation and still keep my work in progress'
    #        title: 'lock', (specs) ->
    #
    # 
    # ...but the node class: 'Session' was not declared as handled by 
    #    the 'Requirements' plugin so the walker will attempt to match
    #    a plugin from the keys of the node properties hash.
    # 
    #     
    # Plugins should therefore define the list of key matches. 
    # (which may be an empty array)
    # 

    matches: ['speed','colour','disposition']

    #
    # And for each a passthough function that (can do 
    # other things but) should return reference to a 
    # handler when appropriate
    #

    speed: (value) -> 

        return Plugin.fox if value is 'quick'

    colour: (value) -> 

        return Plugin.fox if value is 'brown'

    disposition: (value) -> 

        return Plugin.dog if value is 'lazy'



