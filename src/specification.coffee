require 'fing'
Confirmation = require './confirmation'

#
# **Specification()** houses hash of objects each 
# with a stack of pending expectation Confirmations
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


        confirmation = new Confirmation object, expectation
        @objects[ object.fing.ref ].confirmations.push confirmation

module.exports = Specification
