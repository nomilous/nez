require 'fing'
Expectation = require './expectation'
Validation  = require './validation'
Realizer    = require './realizer'

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
        # A Confirmation is initialized as pending and 
        # contains an Expectation and a Validation.
        #

        @pending     = true
        @expectation = new Expectation object, configuration
        @validation  = new Validation @expectation
        

 
    


module.exports = Confirmation
