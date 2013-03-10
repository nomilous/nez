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

