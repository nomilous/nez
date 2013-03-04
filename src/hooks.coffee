require 'fing'

#
# Private class
#

class Hooks

    constructor: (subscribe) -> 

        subscribe 'edge', @handle


    set: (node, config) -> 

        for key of config

            if key == 'beforeEach' or key == 'afterEach'

                node.hooks[key] = config[key]

            if key == 'beforeAll' or key == 'afterAll'

                node.hooks[key] = config[key]



    handle: (placeholder, nodes) -> 

        #
        # This is called from an EventEmitter
        # and has lost all sence of self...  
        # 
        #  ie. @ == 'The node process'
        # 
        # TODO: Look into whether or not that is 
        #       to be expected / or / is it my fault? 
        #
        # For now... Limit all further functionality to
        #            this one function.  (grrr)
        # 
        #            Nodes (Arg) already has all the 
        #            necessary variables
        # 

        switch nodes.tree

            when 'down'

                #
                # Going 'deeper' into the tree.
                # 
                # - Run beforeEach hooks in all ancestors
                # - Run beforAll (only once!)
                # 

                node     = nodes.from
                eachHook = 'beforeEach'
                allHook  = 'beforeAll'


            when 'up'

                #
                # Returning from 'deeper'
                # 
                # - Run afterEach hooks in all ancestors
                # - Run afterAll (only once!)
                #

                node     = nodes.to
                eachHook = 'afterEach'
                allHook  = 'afterAll'



        if typeof node.hooks[allHook] != 'undefined'

            #
            # Run and delete the hook.  
            #
            # It's safe to delete 
            # 
            #  - will never need to run again
            #  - best ensureance that is does not run again
            #    is delete
            #  

            node.hooks[allHook]()
            delete node.hooks[allHook]


        ancestors = node.stack.ancestorsOf node

        for ancestor in ancestors

            #
            # Run all (before|after)Each hooks present 
            # in the ancestor sequence
            #

            if typeof ancestor.hooks[eachHook] != 'undefined'

                ancestor.hooks[eachHook]()

        #
        # Then run the local (before|after)Each on the local node
        #

        if typeof node.hooks[eachHook] != 'undefined'

            node.hooks[eachHook]()


#
# Public Factory
#

hooks = {}
module.exports = 

    #
    # store/bind new stack or return existing
    #

    getFor: (stack) -> 

        hooks[stack.fing.ref] ||= new Hooks stack.on
