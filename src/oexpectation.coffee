Realization = require './realization'

module.exports = class Expectation

    className: 'Expectation'

    #
    # *constructor( config )*
    # 
    # `config.object` 
    #  
    #  The object upon which the expectation is being placed.
    # 
    # 'config.opts.*' 
    # 
    #  The expectation options (as follows)
    # 
    #  `as:` 
    #   
    #     Specifies the type of expectation
    # 
    #     For functions
    #     -------------
    #               
    #     `'mock'`  (default) Expect a function call 
    #               and create a mock instance of the
    #               function. Do not call the original 
    #               funcion if present.
    # 
    # 
    #     `'spy'`   Silently observes the calling of the
    #               original function.
    # 
    # 
    #     For properties
    #     --------------
    # 
    #     `'set'`   Expect a property to be set
    # 
    #     `'get'`   Expect the getting of a property
    #
    #
    # `returns:` 
    #
    #      Specifies what the `mock` / `get` should return when 
    #      called. 
    #            
    # 

    constructor: (config = {}) -> 

        expectationType = 'createFunction'
        name            = undefined


        for key of config.opts
            name = key
            break # only 1

        throw 'Malformed Expectation' unless name

        opts = config.opts[name]
        type = opts.as

        switch type

            when 'spy'

                unless config.object[name] or ( 

                    # 
                    # function already defined on instanceprototype
                    # 
                    
                    config.object.prototype and config.object.prototype[name] 
                )

                    console.log 'WARNING: spy on non existant function %s(...)', name

            when 'get', 'set'

                expectationType = 'createProperty'


        @realization = new Realization config.object
        @realization[expectationType] name, opts



