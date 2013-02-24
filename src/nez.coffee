Stack      = require './stack'
prototypes = require './prototypes'
Injector   = require './injector'

class Nez

Object.defineProperty Nez, 'realize', 

    get: -> Injector.inject


# Object.defineProperty Nez, 'test',
#     get: ->
#         name = '0'
#         Nez.create name
#         prototypes.object.set.expect name
#         prototypes.object.set.mock()
#         return Nez.link name



Nez.stacks = {}

Nez.create = (name) ->

        Nez.stack = new Stack(name)

Nez.link = (name) -> 

        Nez.create name
        prototypes.object.set.expect()
        prototypes.object.set.mock()

        Object.defineProperty Nez.stack.pusher, 'link' 

            get: -> ->

        return Nez.stack.pusher



module.exports = Nez
