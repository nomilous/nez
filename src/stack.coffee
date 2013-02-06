require 'fing'
Node = require './node'

class Stack

    className: 'Stack'

    constructor: (@name) -> 

        @stack = []
        @walker = @tree = []


    pusher: (label, callback) => 

        @push arguments


    push: (args) -> 

        label    = args[0]
        callback = args[1]  # TODO: as last arg
        klass    = @pendingClass || @name
 
        if callback and callback.fing.args.length > 0
        
            @pendingClass = callback.fing.args[0].name 


        if label

            node = new Node label,
            
                callback: callback
                class:    klass

            @stack.push node
            @walker.push node
            @walker = node.edges


            node.callback @pusher if callback
            

            node = @stack.pop()

            if @stack.length > 0

                parent = @stack[@stack.length - 1]
                @walker = parent.edges

            @pendingClass = node.class


module.exports = stack = 

    stacks: {}

    create: (name) -> 

        newStack = new Stack(name)

        stack.stacks[name] = newStack

        return newStack.pusher

    get: (name) -> 

        return stack.stacks[name]

