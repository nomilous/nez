require 'fing' if typeof fing == 'undefined'

Node      = require './node'
Notifyier = require './notifier'
injector  = require('nezcore').injector
Hooks     = require './hooks'
Link      = require './link'
Plugins   = require './plugin_register'

stack     = undefined  #
                       #  I dont like this... 
                       #  And how it's used below... 
                       # 
                       #  It limits things to only 1 running stack...
                       #  
                       #  TODO: Why the above and can it be corrected?
                       # 
                       #        Bit closer to fixing this
                       # 

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

        @name = @activeNode.label

        try
        
            @validate = @activeNode.plugin.validate

        catch error

            #
            # TODO: handle no validator on realizer
            #
            # ! assume then all valid for now !
            # 


        @stack    = []
        @classes  = []
        @root     = new Node 'root', stack: this
        @node     = @root
        @end      = false

        notifier = Notifyier.create @name,

            #
            # Stack is an EventEmitter
            # Events:
            # 

            begin: description: 'Enters root node'
            push:  description: 'Enters a node'
            pop:   description: 'Exits a node'
            end:   description: 'Exits root node'
            edge:  description: 'Edge traversal'

        stack = @


        #
        # hooks binds to the eevnt emitter to 
        # fire before and after hooks
        #

        @hooks = Hooks.getFor stack


        #
        # stacker provides access to linker
        # 

        unless typeof @stacker.link == 'function'

            Object.defineProperty @stacker, 'link',

                get: -> 
                    
                    Link.linker


    stacker: (label, callback) => 

        stack.push arguments

    ancestorsOf: (node) ->

        ancestors = []
        for ancestor in @stack
            break if node == ancestor
            ancestors.push ancestor
        return ancestors


    on: (event, callback) -> 

        notifier.on event, callback

    once: (event, callback) ->

        notifier.once event, callback
        

    push: (args) -> 

        
        from     = @node

        label    = args[0]
        callback = args[1]  # TODO: as last arg
        klass    = @pendingClass || @name


        return if typeof label == 'undefined'
        #
        # called test done (or no args to stacker)
        #


        unless typeof label == 'string'

            return if @hooks.set from, label
            #
            # proceeed no further if label was a before 
            # or after hook config
            #



        #
        # Create new node and pass syncronously
        # through all matching plugins.
        # 
        # This affords each plugin the opportunity
        # to tailer the node and its behaviour
        # ahead of the async edge event.
        # 

        @node = new Node label,

            callback: callback
            stack:    stack
            class:    klass


        Plugins.handle @node

        if callback and callback.fing.args.length > 0

            @pendingClass = callback.fing.args[0].name 


        if label

            notifier.emit 'edge',  null ,

                class: 'Tree.Leafward'
                from: from
                to: @node


            @stack.push @node
            @classes.push klass

            try

                injector.inject [@stacker], callback if callback

            catch error

                if error.name = 'AssertionError'

                    @validate null, error

                else

                    console.log error.red
                    console.log error.stack
                    throw error

            
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


    # validator: (done) ->

    #     stack.validate done


    # validate: (done, error) ->

    #     # return if done == 'end'

    #     testString = ''
    #     leafNode   = undefined

    #     if @stack

    #         for node in @stack

    #             testString += "#{node.class} #{node.label.bold} "
    #             leafNode = node
            
    #         if error

    #             console.log 'FAILED:'.red, testString
    #             console.log error.red
    #             console.log error.stack
    #             # console.log error.message.red

    #         else

    #             console.log 'PASSED:'.green, testString

    #         # leafNode.callback 'end'
        
    #     done() if done

