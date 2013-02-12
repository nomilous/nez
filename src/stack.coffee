require 'fing'
Node = require './node'

module.exports = class Stack

    className: 'Stack'

    constructor: (@name) -> 

        @stack = []
        @walker = @tree = []


    pusher: (label, callback) => 

        if label instanceof Function

            #
            # TODO: call validations
            #
            @validate()

            return label()

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


    validate: ->

