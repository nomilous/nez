AssertionError = require('assert').AssertionError
require 'fing'

class Realizer

    # 
    # Realizer creates or overrides functions or properties
    # on a specified object / prototype ('class')
    # 

    @realizers: {

        #
        # It keeps a reference to each created override
        #

    }

    #
    # **createFunction()** Create a function expectation.
    # 
    # `name` The name of the function
    # 
    # `object` The object / 'class' to create the fuction on.
    #
    # `configuration` To further configure the actions to take when
    # the function is called.
    # 
    # `realization` The callback to fire when the function is called.
    # 

    @createFunction: (name, object, configuration, realization) ->

        key = object.fing.ref + ':' + name

        if object.fing.type == 'prototype'

            originalFunction = object.prototype[name]

        else 

            originalFunction = object[name]

        if typeof @realizers[key] == 'undefined'

            #
            # To support multiple expectations on the same
            # <instance>.functionName / <prototype>.functionName
            # store each realization callback in a stack.
            # 
            # The stack will be popped. 
            # 
            # SIDEEFFECT: Out of order expectations will cause
            #             test failures... (a good thing)
            #

            @realizers[key] = 

                object:       object
                original:     originalFunction
                config:       configuration
                realizations: []

            #
            # Realizer is a spy() that replaces the original
            # function to callback with the realizations.
            # 
            #

            realizer = ->

                object = Realizer.realizers[key].object
                config = Realizer.realizers[key].config
                realizerCallback = Realizer.realizers[key].realizations.shift()

                if typeof realizerCallback == 'undefined'
                    throw new AssertionError
                        message: 'Unexpected call to ' + key


                realizerCallback 
                       
                    object: object
                    args: arguments


                return config.returning


            #
            # create the function
            #
            # TODO: temporary replace, prototype if
            # TODO: tailor this function / and how it 
            #       ataches per the configuration

            if object.fing.type == 'prototype'

                object.prototype[name] = realizer

            else 

                object[name] = realizer

            


        @realizers[key].realizations.push realization

    
module.exports = Realizer
