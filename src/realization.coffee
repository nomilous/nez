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

        @type = 'function'

        newFunction = (arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, areYouMad) =>

            #
            # This is a Mock() or a Spy()
            # 
            # Both cases save the arguments when called.
            # 

            @realize( arguments )

            #
            # It becomes a Mock() if opts.returns is defined... 
            #

            return opts.returns if opts.returns

            #
            # It becomes a spy if no opts.returns was defined
            # and the @originalFunction exists
            #

            return @originalFunction.call(

                @object, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, areYouMad

            ) if @originalFunction


            return # for clarity




        @originalFunction = @object[@name]

        @object[@name] = newFunction


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

        @type = 'property'
        
     

    #
    # *realize(args)* 
    # 
    # Store the args received
    #

    realize: (args) -> 

        @realized ||= {}

        @realized.args = @slide( args, 1 )


    #
    # *slide(args, amount)*
    # 
    # Given:   {0:'ZERO',1:'ONE'}, 3003
    # Returns  {3003:'ZERO',3004:'ONE'}
    #

    slide: (args, amount) -> 

        slid = {}

        for key of args

            newKey = (parseInt(key) + amount).toString()
            slid[newKey] = args[key]

        return slid

