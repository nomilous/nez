require 'fing'
Confirmation = require './confirmation'

#
# **Specification()** 
# 
# Houses hash of objects each with a stack of 
# pending expectation Confirmations.
# 

class Specification

    @objects: {}

    @create: (object, expectation) ->

        @objects[ object.fing.ref ] ||=

            #
            # firsttime initialize storage for this
            # object and it's expectation Confirmations 
            #

            object: object
            confirmations: []



        #
        # Create a pending Expectation Confirmation with a
        # callback for Realization.
        # 
        # The callback will fire with the action being
        # expectated.
        # 

        confirmation = new Confirmation object, expectation, (realization) -> 

            console.log 'REALIZATION:', realization
            console.log 'TODO: it this realization back into the Confirmation stack'


        #
        # Push the new confirmation into the stack
        #

        @objects[ object.fing.ref ].confirmations.push confirmation
        

module.exports = Specification
