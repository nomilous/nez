class Stack

    className: 'Stack'

    constructor: (@name) -> 

        @stack = []


    pusher: (label, callback) => 

        return @push arguments if label
        return @end()


    push: (args) -> 

        @stack.push 

            label:    args[0]
            callback: args[1]  # TODO: as last arg
    

    end: ->

        console.log 'end() popped:', @stack.pop()




module.exports = stack = 

    stacks: {}

    create: (name) -> 

        newStack = new Stack(name)

        stack.stacks[name] = newStack

        return newStack.pusher

    get: (name) -> 

        return stack.stacks[name]

