Stack      = require './stack'
prototypes = require './prototypes'

module.exports = nez = 

    stacks: {}

    link: (name) -> 

        nez.stacks[name] = new Stack(name)

        Object.defineProperty nez.stacks[name].pusher, 'link' 

            get: -> ->

        return nez.stacks[name].pusher

    test: (name) ->

        prototypes.object.set.expect()
        prototypes.object.set.expectSet()
        prototypes.object.set.expectGet()

        nez.link name
