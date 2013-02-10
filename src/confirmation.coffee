require 'fing'
Expectation = require './expectation'
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

        @expectation = new Expectation object, configuration

        @pending = true




 
    


module.exports = Confirmation
