require 'fing'

Node      = require './node'
Notifyier = require './notifier'
Injector  = require './injector'

stack     = undefined
notifier  = undefined


module.exports = class Stack
    
    constructor: (@name) -> 

        @stack   = []
        @classes = []
        @root    = new Node 'root'
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


    stacker: (label, callback) -> 

        stack.push arguments


    on: (event, callback) -> 

        notifier.on event, callback

    once: (event, callback) ->

        notifier.once event, callback
        

    push: (args) -> 

        
        from     = @node

        label    = args[0]
        callback = args[1]  # TODO: as last arg
        klass    = @pendingClass || @name
 
        if callback and callback.fing.args.length > 0

            @pendingClass = callback.fing.args[0].name 


        if label

            @node = new Node label,

                callback: callback
                class:    klass

            if @stack.length == 0

                notifier.emit 'begin', '', @node

            notifier.emit 'push', '', @node
            notifier.emit 'edge', '', from: from, to: @node

            @stack.push @node
            @classes.push klass

            try

                # Injector.inject [@stacker], callback if callback
                callback @stacker if callback

            catch error

                if error.name = 'AssertionError'

                    #
                    # assumes that no AssertionError will
                    # be thrown enywhere but at a leaf node
                    # on the test tree
                    # 

                    @validate()

                else

                    console.log error

                    throw error
            


            
            from = @stack.pop()
            notifier.emit 'pop', '', from


            if @stack.length == 0

                @node = @root
                notifier.emit 'end', '', from
                

            else

                @node = @stack[@stack.length - 1]


            notifier.emit 'edge', '', from: from, to: @node           
            @pendingClass = @classes.pop()


    validator: (done) ->

        stack.validate done


    validate: (done) ->

        # return if done == 'end'

        testString = ''
        leafNode   = undefined

        if @stack

            for node in @stack

                testString += "#{node.class} #{node.label.bold} "
                leafNode = node
                
            console.log testString

            # leafNode.callback 'end'
        
        done() if done

