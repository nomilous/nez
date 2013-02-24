Stack      = require './stack'
prototypes = require './prototypes'
Injector   = require './injector'



class Nez

#
# Public
# 

enumerable = true


# 
# **Nez.realize(`ObjectiveClass`, `options`, `testFunction`)**
#

Object.defineProperty Nez, 'realize', 

    get: ->

        #
        # Property 'realize' returns Injector.inject (function)
        # 

        Injector.inject


    enumerable: enumerable




#
# Private
#

enumerable = false
stack      = undefined


Object.defineProperty Nez, 'stack',

    get: -> stack
    enumerable: enumerable


Object.defineProperty Nez, 'link',

    get: -> (name) ->

        stack = new Stack(name)
        prototypes.object.set.expect()
        prototypes.object.set.mock()

        Object.defineProperty Nez.stack.pusher, 'link' 

            get: -> ->

        return @stack.pusher

    enumerable: enumerable


module.exports = Nez
