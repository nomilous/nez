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

    @create: (object, configuration) ->

        @objects[ object.fing.ref ] ||=

            #
            # firsttime initialize storage for this
            # object and it's expectation Confirmations 
            #

            object: object
            confirmations: []


        #
        # Create a pending Expectation Confirmation
        #

        confirmation = new Confirmation object, configuration


        #
        # Push the new confirmation into the stack
        #

        @objects[ object.fing.ref ].confirmations.push confirmation


        #
        # return the new confirmation
        #

        return confirmation


    @getNode: (stackName) ->

        #
        # late require, need the stack as it currently is
        #

        return require('./nez').stacks[stackName].node



module.exports = Specification
