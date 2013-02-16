require 'fing'
Node = require './node'

module.exports = class Stack

    className: 'Stack'

    constructor: (@name) -> 

        @stack   = []
        @node    = new Node 'root'

        #
        # TODO: move the tree out of here
        # TODO: add an event emitter, the tree builder can subscribe
        #

        @walker  = @tree = @node.edges


    pusher: (label, callback) => 

        # if label == @pusher
        if label instanceof Function

            #
            # Encountered a call to validate the current
            # stack.
            # 
            # ie. 
            # <pre>
            # 
            # test 'A Thing', (it) ->
            # 
            #   it 'does stuff', (that) ->
            # 
            #     that 'is important', (done) ->
            # 
            #       # make some expectations
            # 
            #       # do something that should cause
            #       # the expectations to be met
            #  
            #       test done  # <--- this call was made
            #        
            #      
            #

            return @validate label

        @push arguments


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

            @stack.push @node
            @walker.push @node
            @walker = @node.edges

            @node.callback @pusher if callback
            

            node = @stack.pop()

            if @stack.length > 0

                @node   = @stack[@stack.length - 1]
                @walker = @node.edges

            @pendingClass = @node.class


    validate: (done) ->

        failed = []

        #
        # TODO: populate all beforeEach
        # 

        for node in @node.edges

            node.validate failed if node.validate



        done failed[0]
