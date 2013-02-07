Realization = require './realization'

module.exports = class Expectation

    className: 'Expectation'

    #
    # *constructor( config )*
    # 
    # `config.object` 
    #  
    #  The object upon which the expectation expectation is 
    #  being placed.
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

        call = 'createFunction'
        name = undefined

        for key of config.opts
            name = key
            break # only 1

        if config.opts[name].as == 'spy'

            #
            # TODO: properly warn
            #

            unless config.object[name]

                console.log 'WARNING: spy on non existant function %s(...)', name 

        throw 'Malformed Expectation' unless name


        @realization = new Realization config.object
        @realization[call] name, config.opts[name]



