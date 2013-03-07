#
# Example Plugin
#

module.exports = Plugin =

    configure: (stacker, config) -> 

        #
        # Plugin should define `configure()`
        # 
        #  - To optionally extend the stacker 
        #    with additional functionality.
        # 
        #  - To receive its configuration.
        #

    edge: (placeholder, nodes) -> 

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
        #        # if the edge is part of a tree
        #        # 
        #        #   `up`   - a rootward traversal
        #        #   'down' - a leafward traversal
        #        # 
        #    
        #        tree: 'up|down'
        #     
        #    }
        #
        
