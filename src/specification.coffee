#  --------------
# Houses hash of interfaces/objects each with a stack of 
# pending Confirmations.
#  --------------

require 'fing'
Confirmation = require './confirmation'

class Specification

    @objects: {}


    #
    # Specification.create( `opts` )
    # -------------------------------
    # 
    # Create a new Specification with `opts` as:
    # 
    # `stack`     - Name of the active Stack
    # 
    # `interface` - Object or interface to/from the object to 
    #               which the Specification is assocaited.
    # 
    # `config`    - A hash of config for the specification.
    # 
    # `realizer`  - For realizer plugins. Later.
    #  --------------


    @create: (opts) ->

        stackName = opts.stack

        object    = opts.interface
        config    = opts.config
        realizer  = opts.realizer


        #
        # Ensure initialized Confirmation stack
        #

        @objects[ object.fing.ref ] ||=

            interface: object
            confirmations: []


        #
        # Confirmations are referenced internally by object
        #

        confirmations = @objects[ object.fing.ref ].confirmations


        #
        # Confirmations are referenced externally by associating with
        # as Edges/Children of the current Node in the tree
        #

        unless edges = @getNode(stackName).edges

            throw "Cannot access current Node in stack='#{stackName}'"


        confirmations = @objects[ object.fing.ref ].confirmations

        #
        # Support multiple Specifications defined in 
        # opts.config
        # 
        # For each key in the has
        #

        for name of config

            expectation = {}

            expectation[name] = config[name]
            expectation[name].realizer = realizer


            confirmation = new Confirmation object,

                expectation: expectation


            confirmations.push confirmation
            edges.push confirmation



        #
        # Push the new confirmation into the stack
        #

        @objects[ object.fing.ref ].confirmations.push confirmation



    @getNode: (stackName) ->

        #
        # late require, need the stack as it currently is
        #

        return require('./nez').stacks[stackName].node



module.exports = Specification
