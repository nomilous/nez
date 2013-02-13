Expectation = require './expectation'
Validation  = require './validation'


class Confirmation

    #
    # A confirmation is created for each expectation
    # 
    # `object` - The object upon which the expectation has
    #            been placed
    # 
    # `configuration` - Config for the Confirmation
    #

    constructor: (object, configuration) ->

        #
        # A Confirmation contains a pending Validation that is
        # constructed from the Expectation Configuration 
        #

        for key of configuration

            if key == 'expectation'

                @pending    = true
                @validation = new Validation (

                    new Expectation object, configuration[key]

                )

            # else if 'hmm...'

    validate: ->

        @validation.validate()


module.exports = Confirmation
