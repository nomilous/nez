injector = require('nezcore').injector

module.exports = 


    #
    # TODO: refactor realize() as plugin  (later...)
    #

    realize: -> 


        #
        # objective (test Subject) as argument1
        #

        objective   = arguments[0]
        testSubject = injector.support.findModule module: objective

        #console.log '(test)', objective


        #
        # connect to the stack
        #

        Nez = require './nez'
        stack = Nez.link()
        stack.name = objective

        #
        # Test stack validator()
        # 

        validator = stack.validator


        #
        # Test stack stacker()
        #

        stacker = stack.stacker



        #
        # testFunction as last argument
        # 
        #    (receives the injection)
        #

        for key of arguments

            #
            # function is the last argument
            #

            testFunction = arguments[key]


        injector.inject [testSubject, validator, stacker], testFunction
