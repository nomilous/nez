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

        console.log "new confirmation", arguments

        #
        # A Confirmation contains a pending Validation that is
        # constructed from the Expectation Configuration 
        #

        @pending    = true
        @validation = new Validation (

            new Expectation object, configuration

        )

 
    


module.exports = Confirmation
