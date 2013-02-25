Stack      = require './stack'
prototypes = require './prototypes'
Injector   = require './injector'
Objective  = require './objective'



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
# **Nez.objective(`config`)**
# 

Object.defineProperty Nez, 'objective', 

    get: -> Objective.validate
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

            unless typeof stack.stacker.link == 'function'

                Object.defineProperty stack.stacker, 'link' 

                    get: -> ->

            return stack

        enumerable: enumerable


module.exports = Nez
