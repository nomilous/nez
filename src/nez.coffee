Stack = require './stack'

module.exports = nez = 

    stacks: {}

    link: (name) -> 

        nez.stacks[name] = new Stack(name)

        Object.defineProperty nez.stacks[name].pusher, 'link' 

            get: -> ->


        return nez.stacks[name].pusher
