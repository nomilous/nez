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
    # `interface` - Object or interface to/from the object to 
    #               which the Specification is assocaited.
    # 
    # `config`    - A hash of config for the specification.
    # 
    # `realizer`  - For realizer plugins. Later.
    #  --------------


    @create: (opts) ->

        object    = opts.interface
        config    = opts.config
        realizer  = opts.realizer

        # console.log 'Specification on:', object

        #
        # is object 'node' global 
        #

        try

            global = object.process.title == 'node'

        catch error

            global = false


        @validateGlobals config if global


        #
        # Ensure initialized Confirmation stack
        #

        @objects[ object.fing.ref ] ||=

            interface: object
            global: global
            confirmations: []


        #
        # Confirmations are referenced internally by object ref
        # as key into a local hash
        #

        confirmations = @objects[ object.fing.ref ].confirmations


        #
        # Confirmations are referenced externally by insertion into
        # the tree as Edges/Children of the current Node
        #

        unless edges = @getNode().edges

            throw "Cannot access current Node"


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


    @validateGlobals: (config) ->

        for key of config

            continue if key == 'beforeAll'
            continue if key == 'beforeEach'
            continue if key == 'afterAll'
            continue if key == 'afterEach'
            
            throw 'Cannot create global specifications'


    @getNode: ->

        #
        # late require, need the stack as it currently is
        #

        return require('./nez').stack.node



module.exports = Specification
