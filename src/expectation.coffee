AssertionError = require('assert').AssertionError

class Expectation

    constructor: (object, configuration) ->

        @validate configuration
        @on = object


    validate: (configuration) -> 

        if typeof configuration == 'undefined'
            throw new AssertionError
                message: 'undefined Expectation configuration'

        if typeof configuration == 'string'
            @realizerName = configuration
            @realizerCall = 'createFunction'
            @realizerType = 'mock'
            
            return

        if typeof configuration == 'object'
            if configuration instanceof Array
                throw new AssertionError 
                    message: 'Array not a valid Expectation configuration'

        count = 0
        for key of configuration

            continue if key == 'expect'

            @realizerName = key
            @assignParameters configuration[key]

            if ++count > 1
                throw new AssertionError 
                    message: 'Multiple key hash not a valid Expectation configuration'



    assignParameters: (parameters) ->

        @realizerCall = 'createFunction'
        @realizerType = 'mock'

        for key of parameters

            if key == 'as'

                @setRealizationConfig parameters[key]
                continue

            @[key] = parameters[key]


    setRealizationConfig: (parameter) ->

        switch parameter

            when 'mock'

                @realizerCall = 'createFunction'
                @realizerType = 'mock'

            when 'spy'

                @realizerCall = 'createFunction'
                @realizerType = 'spy'

            when 'get'

                @realizerCall = 'createProperty'
                @realizerType = 'get'

            when 'set'

                @realizerCall = 'createProperty'
                @realizerType = 'set'



module.exports = Expectation
