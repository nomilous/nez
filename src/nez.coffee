Stack      = require './stack'
prototypes = require './prototypes'

nez = 

    stacks: {}

    create: (name) ->

        nez.stacks[name] = new Stack(name)

    link: (name) -> 

        nez.create name

        Object.defineProperty nez.stacks[name].pusher, 'link' 

            get: -> ->

        return nez.stacks[name].pusher


Object.defineProperty nez, 'test',

    get: ->

        name = '0'
        nez.create name
        prototypes.object.set.expect name
        return nez.link name


module.exports = nez
