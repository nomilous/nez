Notification = require './notification'

module.exports = Realization = class Realization extends Notification

    #
    # Realization
    # =========== 
    # 
    # * Implements the ability to capture behaviour.
    # * Red Handed.
    # * And store it in a jar.
    # * With carefully punched holes.
    # * For later... (Expectation Validation)
    # 


    #
    # *constructor( object )* 
    # 
    # `object` - as the thing upon which an Expectation has been placed
    #
    constructor: (@object) -> 


    #
    # *createFunction( name, opts )*
    # 
    # Configures the `object` such that a function becomes Realizable
    # 
    # `name` - The name of a function whose calling 
    #          has an associated Expectation
    # 
    # `opts' - To define what to do when the expected 
    #          call ocurrs
    #
    createFunction: (@name, opts = {}) ->


    # 
    # *createProperty( name, opts )*
    #
    # Configures the `object` such that a property becomes Realizable
    #
    # `name` - The name of a property whose calling
    #          has an associated Expectation
    # 
    # `opts' - To define what to do when the expected 
    #          call ocurrs
    #
    #  
    createProperty: (@name, opts = {}) ->
     

    #
    # *realize(args)* 
    #
    realize: (@functionArgs) -> 

