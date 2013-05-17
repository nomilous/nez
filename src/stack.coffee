require 'fing'

Node      = require './node'
injector  = require('nezcore').injector
Hooks     = require './hooks'
Link      = require './link'
Plugins   = require './plugin_register'
Emitter   = require('events').EventEmitter

module.exports = class Stack extends Emitter


    # 
    # Emits Events
    # ------------
    #
    # ### tree:traverse
    # 
    # Walker traverses an edge in a tree. 
    # 
    # `stack.on 'tree:traverse', (traversal) -> 
    # 
    # string - `traversal.as` is 'Leafward' or 'Rootward'
    # object - `traversal.from` is the Node instance just departed
    # object - `traversal.to` is the Node instance just arrived at
    # [LATER probably] object - `traversal.branch` is the Branch identity
    # [LATER probably] function - `traversal.callback`
    # 
    # 
    # ### enter
    # 
    # Walker traverses into a grouped set of nodes (usually a branch) 
    # 
    # `stack.on 'enter', (error, stack) -> 
    # 
    # `error` - null 
    # `stack` - the NodeStack or (later.. NodeGroup) begin entered
    # 
    # 
    # ### exit
    # 
    # Walker departs a grouped set of nodes
    # 
    # `stack.on 'exit', (error, stack) -> 
    # 
    # `error` - null, or populated with the exception that cased the walker to exit
    # `stack` - the NodeStack or (later.. NodeGroup) begin exited
    # 


    
    constructor: (@activeNode) -> 

        # console.log 'TODO: move to nezcore as NodeStack'

                    #
                    # and create/approximate an InjectionStack 
                    # with push and pop evets to enable: 
                    #
                    #   eg. 
                    # 
                    #   spec_run injector (push) 
                    #       needs to define .must() on injected objects 
                    #       to create expectations / validators
                    # 
                    #   spec_run injector (pop)
                    #       needs to validate those expectations
                    #

        @label    = @activeNode.label

        @stack    = []
        @classes  = []
        @root     = new Node 'root', as: 'root'
        @node     = @root
        @end      = false


        #
        # hooks binds to the eevnt emitter to 
        # fire before and after hooks
        #

        # @hooks = Hooks.getFor stack


        #
        # stacker provides access to linker
        # 

        unless typeof @stacker.link == 'function'

            Object.defineProperty @stacker, 'link',

                get: -> 
                    
                    Link.linker


    stacker: (label, fn) =># <= this concerns me! 

        @push label, fn

    # ancestorsOf: (node) ->

    #     ancestors = []
    #     for ancestor in stack
    #         break if node == ancestor
    #         ancestors.push ancestor
    #     return ancestors

    push: (label, fn) -> 

        if @stack.length == 0

            @emit 'enter', null, @

        
        from     = @node

        # label    = args[0]
        # callback = args[1]  # TODO: as last arg
        klass    = @pendingClass || @label


        return if typeof label == 'undefined'
        #
        # called test done (or no args to stacker)
        #


        unless typeof label == 'string'

            return if @hooks.set from, label
        #     #
        #     # proceeed no further if label was a before 
        #     # or after hook config
        #     #



        #
        # Create new node and pass syncronously
        # through all matching plugins.
        # 
        # This affords each plugin the opportunity
        # to tailer the node and its behaviour
        # ahead of the async edge event.
        # 

        @node = new Node label,

            function: fn
            as:    klass


        Plugins.handle @node

        if fn and fn.fing.args.length > 0

            @pendingClass = fn.fing.args[0].name 


        if label

            @emit 'tree:traverse',

                as: 'Leafward'
                from: from
                to: @node


            @stack.push @node
            @classes.push klass

            try

                injector.inject [@stacker], fn if fn

            catch error

                @validate null, error

                @emit 'exit', error, @

                #
                # NB:doc
                #

                return

            
            from = @stack.pop()
            

            if @stack.length == 0

                @node = @root


            else

                @node = @stack[@stack.length - 1]


            @emit 'tree:traverse'

                as: 'Rootward'
                from: from
                to: @node

            @pendingClass = @classes.pop()

            if @stack.length == 0

                @emit 'exit', null, @


    validate: (done, error) ->

        #
        # pass to _realizer Plugin.validate 
        # 
        # Validation is an async step, realizations will 
        # often be interactions to a remote process
        # 

        if @activeNode.plugin and @activeNode.plugin.validate

            #
            # TODO: timeout for validate
            # 

            @activeNode.plugin.validate @stack, error, -> 

                done() if done
