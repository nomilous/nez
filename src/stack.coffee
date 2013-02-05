require 'fing'

class Stack

    className: 'Stack'

    constructor: (@name) -> 

        @stack = []
        @walker = @tree = []


    pusher: (label, callback) => 

        return @push arguments if label
        return @end()


    push: (args) -> 

        callback = args[1]  # TODO: as last arg

        node = 

            callback: callback
            class:    @pendingClass || @name
            label:    args[0]
            children: []
        
        if callback and callback.fing.args.length > 0
        
            @pendingClass = callback.fing.args[0].name 

        #
        # push new node before walking
        # 

        @stack.push node
        @walker.push node

        if node.callback

            #
            # walk the callback
            #

            @walker = node.children
            node.callback @pusher

        else

            #
            # cul-de-sac-le-pop
            #

            @end()
    
    end: ->

        node = @stack.pop()

        @walker       = @stack[@stack.length - 1].children
        @pendingClass = node.class

        #console.log 'end() popped:', node



module.exports = stack = 

    stacks: {}

    create: (name) -> 

        newStack = new Stack(name)

        stack.stacks[name] = newStack

        return newStack.pusher

    get: (name) -> 

        return stack.stacks[name]

