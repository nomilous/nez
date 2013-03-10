require 'fing'

Node      = require './node'
Notifyier = require './notifier'
Injector  = require './injector'
Hooks     = require './hooks'
Link      = require './link'

stack     = undefined
notifier  = undefined


module.exports = class Stack
    
    constructor: (@name) -> 

        @stack   = []
        @classes = []
        @root    = new Node 'root', stack: this
        @node    = @root
        @end     = false

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

                get: -> Link.linker


    stacker: (label, callback) -> 

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

        unless typeof label == 'string'


            console.log label
        
            @hooks.set from, label
            return

 
        if callback and callback.fing.args.length > 0

            @pendingClass = callback.fing.args[0].name 


        if label

            @node = new Node label,

                callback: callback
                stack:    stack
                class:    klass


            notifier.emit 'edge', null,

                class: 'Tree.Leafward'
                from: from
                to: @node


            @stack.push @node
            @classes.push klass

            try

                Injector.inject [@stacker], callback if callback

            catch error

                if error.name = 'AssertionError'

                    #
                    # assumes that no AssertionError will
                    # be thrown enywhere but at a leaf node
                    # on the test tree
                    # 

                    # console.log error.message.red

                    @validate null, error

                else

                    console.log error

                    throw error
            


            
            from = @stack.pop()
            


            if @stack.length == 0

                @node = @root                

            else

                @node = @stack[@stack.length - 1]


            notifier.emit 'edge', null,

                class: 'Tree.Rootward'
                from: from
                to: @node

            @pendingClass = @classes.pop()


    validator: (done) ->

        stack.validate done


    validate: (done, error) ->

        # return if done == 'end'

        testString = ''
        leafNode   = undefined

        if @stack

            for node in @stack

                testString += "#{node.class} #{node.label.bold} "
                leafNode = node
            
            if error

                console.log 'FAILED:'.red, testString
                console.log error.message.red

            else

                console.log 'PASSED:'.green, testString

            # leafNode.callback 'end'
        
        done() if done

