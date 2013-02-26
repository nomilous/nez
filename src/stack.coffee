require 'fing'

Node      = require './node'
Notifyier = require './notifier'

stack     = undefined
notifier  = undefined


module.exports = class Stack
    
    constructor: (@name) -> 

        @stack   = []
        @classes = []
        @node    = new Node 'root'
        @end     = false


        #
        # TODO: move the tree out of here
        # TODO: add an event emitter, the tree builder can subscribe
        #

        notifier = Notifyier.create @name,

            #
            # Stack is an EventEmitter
            # Events:
            # 

            begin: description: 'Enters root node'
            push:  description: 'Enters a node'
            pop:   description: 'Exits a node'
            end:   description: 'Exits root node'

        @walker  = @tree = @node.edges

        stack = @


    stacker: (label, callback) -> 

        stack.push arguments


    on: (event, callback) -> 

        notifier.on event, callback

    once: (event, callback) ->

        notifier.once event, callback
        

    push: (args) -> 

        


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

            @stack.push @node
            @walker.push @node
            @walker = @node.edges
            @classes.push klass

            try

                @node.callback @stacker if callback

            catch error

                if error.name = 'AssertionError'

                    #
                    # assumes that no AssertionError will
                    # be thrown enywhere but at a leaf node
                    # on the test tree
                    # 

                    @validate()

                else

                    throw error
            


            node = @stack.pop()

            notifier.emit 'pop', '', node

            if @stack.length == 0

                notifier.emit 'end', '', node


            if @stack.length > 0

                @node   = @stack[@stack.length - 1]
                @walker = @node.edges


            
                


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

