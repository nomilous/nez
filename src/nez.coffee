Stack      = require './stack'
prototypes = require './prototypes'

module.exports = nez = 

    stacks: {}

    create: (name) ->

        nez.stacks[name] = new Stack(name)

    link: (name) -> 

        nez.create name

        Object.defineProperty nez.stacks[name].pusher, 'link' 

            get: -> ->

        return nez.stacks[name].pusher

    test: (name) ->

        nez.create name

        prototypes.object.set.expect name
        prototypes.object.set.expectSet name
        prototypes.object.set.expectGet name

        return nez.link name
