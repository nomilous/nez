class Stack

    className: 'Stack'

    constructor: (@name) -> 

        @stack = []


    pusher: (label, callback) => 

        return @push arguments if label
        return @end()


    push: (args) -> 

        node = 

            label:    args[0]
            callback: args[1]  # TODO: as last arg

        @stack.push node

        node.callback @pusher if node.callback
    

    end: ->

        node = @stack.pop()

        console.log 'end() popped:', node

        node.callback( @pusher ) if node.callback




module.exports = stack = 

    stacks: {}

    create: (name) -> 

        newStack = new Stack(name)

        stack.stacks[name] = newStack

        return newStack.pusher

    get: (name) -> 

        return stack.stacks[name]

