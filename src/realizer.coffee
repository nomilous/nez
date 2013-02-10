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

        #
        # Key is a unique refecence to a function and looks 
        # approximately like this:  
        # 
        #   'instance:NewClass:8:functionName'
        # 
        #   or
        # 
        #   'prototype:NewClass:3:functionName'
        #    
        #
        # It is used to key the Realizer storage uniquely by
        # prototype/instance/functionname
        # 

        key = object.fing.ref + ':' + name

        if @realizers[key]


            #
            # Already have a Realizer on this function,
            # push this new Realization into the stack
            # 

            @realizers[key].realizations.push realization

            return


        #
        # This is the first expectation on this function, 
        # Prime the Realizer and Realizations stack
        #

        originalFunction = @getOriginal name, object

        @realizers[key] = 

            object:       object
            original:     originalFunction
            config:       configuration
            realizations: []


        #
        # Realizer is a spy() that replaces the original
        # function to callback with the realizations.
        #

        realizer = (arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, areYouMad) ->

            object   = Realizer.realizers[key].object
            config   = Realizer.realizers[key].config
            original = Realizer.realizers[key].original

            #
            # realizerCallbacks are shifted() from the stack
            # so that they are called in create order.
            #

            realizerCallback = Realizer.realizers[key].realizations.shift()


            if typeof realizerCallback == 'undefined'

                #
                # There are no more realizations in the 
                # callback stack for this function
                #

                throw new AssertionError

                    message: 'Unexpected call to ' + key


            #
            # Post this call to the realizer callback for 
            # later Expectation Validation
            #

            realizerCallback 
                   
                object: object
                args: arguments


            #
            # Call the original function or mock 
            # according to config 
            # 

            if config.as == 'spy'

                return original arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, areYouMad

            return config.returning


        @replaceOriginal name, object, realizer

        @realizers[key].realizations.push realization



    @getOriginal: (name, object) ->
        if object.fing.type == 'prototype'
            originalFunction = object.prototype[name]
        else 
            originalFunction = object[name]


    @replaceOriginal: (name, object, fn) ->
        if object.fing.type == 'prototype'
            object.prototype[name] = fn
        else 
            object[name] = fn


module.exports = Realizer
