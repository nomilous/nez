Notification = require './notification'

module.exports = class Realization extends Notification

    className: 'Realization'

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

            @realizeFunction( arguments )

            #
            # It becomes a Mock() if opts.returns is defined... 
            #

            if opts.returns

                return opts.returns

            #
            # It becomes a spy if no opts.returns was defined
            # and the @originalFunction exists
            #

            return @originalFunction.call(

                @object, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, areYouMad

            ) if @originalFunction


            return # for clarity


        #
        # .function.got returns realized { args: 'as called'}
        # (for spying convenience)
        #
        Object.defineProperty newFunction, 'got', 

            get: => @realized.function


        if @object.prototype and @object.prototype[@name]

            #
            # replace prototype if present
            #

            @prototyped = true
            @originalFunction = @object.prototype[@name]
            @object.prototype[@name] = newFunction

        else

            @prototyped = false
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

        @originalProperty = @object[@name]

        Object.defineProperty @object, @name,

            set: (value) => 

                #
                # store value of property being set
                # (for later expectation validation)
                #

                @object._got ||= {}
                @object._got[ @name ] = value

                @realizeProperty 0: value
                @originalProperty = value

            get: => 

                if opts.returns

                    #
                    # return the mock specified value 
                    # of the property
                    #

                    @realizeProperty 0: opts.returns
                    return opts.returns

                else

                    @object._had ||= {}
                    @object._had[ @name ] = @originalProperty
                    @realizeProperty 0: @originalProperty
                    return @originalProperty

    

    realizeFunction: (args) -> 

        @realized = function: args: @slide( args, 1 )


    realizeProperty: (args) -> 

        @object._had ||= {}

        @realized = property: args: @slide( args, 1 )


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

