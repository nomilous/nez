Stack      = require './stack'
prototypes = require './prototypes'
Injector   = require './injector'
Inflection = require 'inflection'

class Nez

Object.defineProperty Nez, 'realize', 

    get: -> ->

        klass  = arguments[0]

        for key of arguments

            #
            # function is the last argument
            #

            func = arguments[key]



        module = Injector.findModule klass
        pusher = Nez.stacks['0'].pusher
        validator = pusher 

        func require(module), pusher, validator





Object.defineProperty Nez, 'test',

    get: ->

        name = '0'
        Nez.create name
        prototypes.object.set.expect name
        prototypes.object.set.mock()
        return Nez.link name



Nez.stacks = {}

Nez.create = (name) ->

        Nez.stacks[name] = new Stack(name)

Nez.link = (name) -> 

        Nez.create name

        Object.defineProperty Nez.stacks[name].pusher, 'link' 

            get: -> ->

        return Nez.stacks[name].pusher



module.exports = Nez
