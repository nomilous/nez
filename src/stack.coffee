require 'fing'
Node = require './node'

module.exports = class Stack

    className: 'Stack'

    constructor: (@name) -> 

        @stack = []
        @node = new Node 'root'
        @walker = @tree = @node.edges


    pusher: (label, callback) => 

        if label instanceof Function

            #
            # mocha done was passed in as label
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

        for node in @node.edges

            node.validate failed if node.validate

        done failed[0]
