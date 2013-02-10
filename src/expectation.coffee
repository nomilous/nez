AssertionError = require('assert').AssertionError

class Expectation

    constructor: (object, configuration) ->

        @validate configuration
        @configuration.on = object


    validate: (configuration) -> 

        @configuration = {}

        if typeof configuration == 'undefined'
            throw new AssertionError
                message: 'undefined Expectation configuration'

        if typeof configuration == 'string'
            @configuration[configuration] = {}
            return

        if typeof configuration == 'object'
            if configuration instanceof Array
                throw new AssertionError 
                    message: 'Array not a valid Expectation configuration'

        count = 0
        for key of configuration
            name = key
            if ++count > 1
                throw new AssertionError 
                    message: 'Multiple key hash not a valid Expectation configuration'

        @configuration = configuration






module.exports = Expectation
