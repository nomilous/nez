class Stack

    className: 'Stack'

    constructor: (@name) -> 

    pusher: -> 


module.exports = stack = 

    stacks: {}

    create: (name) -> 

        newStack = new Stack(name)

        stack.stacks[name] = newStack

        return newStack.pusher

    get: (name) -> 

        return stack.stacks[name]

