require 'fing'

class Stack

    className: 'Stack'

    constructor: (@name) -> 

        @stack = []


    pusher: (label, callback) => 

        return @push arguments if label
        return @end()


    push: (args) -> 

        callback = args[1]  # TODO: as last arg

        node = 

            callback: callback
            class:    @pendingClass || @name
            label:    args[0]
        
        if callback and callback.fing.args.length > 0
        
            @pendingClass = callback.fing.args[0].name 

        @stack.push node

        node.callback @pusher if node.callback
    

    end: ->

        node = @stack.pop()

        console.log 'end() popped:', node

        node.callback( @pusher ) if node.callback

    argName: (fn) -> 






module.exports = stack = 

    stacks: {}

    create: (name) -> 

        newStack = new Stack(name)

        stack.stacks[name] = newStack

        return newStack.pusher

    get: (name) -> 

        return stack.stacks[name]

