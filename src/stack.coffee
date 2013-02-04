class Stack

    className: 'Stack'

    constructor: (@name) -> 


    pusher: (label, callback) => 

        return @push arguments if label
        return @end()


    push: (args) -> 

        console.log "push( #{args.toString()} )"


    end: ->

        console.log "end()"




module.exports = stack = 

    stacks: {}

    create: (name) -> 

        newStack = new Stack(name)

        stack.stacks[name] = newStack

        return newStack.pusher

    get: (name) -> 

        return stack.stacks[name]

