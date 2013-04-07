require 'fing'

Node      = require './node'
Notifyier = require './notifier'
injector  = require('nezcore').injector
Hooks     = require './hooks'
Link      = require './link'
Plugins   = require './plugin_register'

notifier  = undefined


module.exports = class Stack
    
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
        @root     = new Node 'root', stack: this
        @node     = @root
        @end      = false

        notifier = Notifyier.create @label,

            #
            # Stack is an EventEmitter
            # Events:
            # 

            edge:   description: 'Edge traversal'
            begin:  description: 'Walker enters the branch'
            end:    description: 'Walker exits the branch or Exception'


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


    stacker: (label, callback) =># <= this concerns me! 

        @push label, callback

    # ancestorsOf: (node) ->

    #     ancestors = []
    #     for ancestor in stack
    #         break if node == ancestor
    #         ancestors.push ancestor
    #     return ancestors


    on: (event, callback) -> 

        notifier.on event, callback

    once: (event, callback) ->

        notifier.once event, callback
        


    push: (label, fn) -> 

        if @stack.length == 0

            notifier.emit 'begin', null, @

        
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
            class:    klass


        Plugins.handle @node

        if fn and fn.fing.args.length > 0

            @pendingClass = fn.fing.args[0].name 


        if label

            notifier.emit 'edge',  null ,

                class: 'Tree.Leafward'
                from: from
                to: @node


            @stack.push @node
            @classes.push klass

            try

                injector.inject [@stacker], fn if fn

            catch error

                @validate null, error

                notifier.emit 'end', error, @

                #
                # NB:doc
                #

                return

            
            from = @stack.pop()
            

            if @stack.length == 0

                @node = @root


            else

                @node = @stack[@stack.length - 1]


            notifier.emit 'edge',  null ,

                class: 'Tree.Rootward'
                from: from
                to: @node

            @pendingClass = @classes.pop()

            if @stack.length == 0

                notifier.emit 'end', null, @


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
