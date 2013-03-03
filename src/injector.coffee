require 'fing'
Nez        = require './nez' # Doesn't work here. Don't CLEARLY understand why.
Inflection = require 'inflection'
fs         = require 'fs'
wrench     = require 'wrench'

module.exports = Injector = 


    #
    # TODO: factor this into the Realizer (later...)
    #
    realize: -> 


        #
        # objective (test Subject) as argument1
        #

        objective = arguments[0]
        module    = Injector.findModule objective

        #console.log '(test)', objective


        #
        # initialize test stack
        #

        Nez = require './nez'
        stack = Nez.link objective

        #
        # Test stack validator()
        # 

        validator = stack.validator


        #
        # Test stack stacker()
        #

        stacker = stack.stacker



        #
        # testFunction as last argument
        # 
        #    (receives the injection)
        #

        for key of arguments

            #
            # function is the last argument
            #

            testFunction = arguments[key]    


        Injector.inject [require(module), validator, stacker], testFunction

    #
    # ** Injector.inject (module1,,, noduleN) -> ** 
    # ** Injector.inject [list,of,things], (list, of, things, module1, ... ) **
    # 

    inject: ->

        if typeof arguments[0] == 'function' 

            fn = arguments[0]
            fn.apply null, Injector.loadServices fn.fing.args

        else

            list = arguments[0]

            #
            # fn as last argument
            #

            for key of arguments

                #
                # function is the last argument
                #

                fn = arguments[key]

            console.log "LIST:", list

            fn.apply null, Injector.loadServices(fn.fing.args, list)



    loadServices: (args, list = []) ->

        # console.log "services:", args

        skip = list.length

        services = list

        for arg in args

            continue if skip-- > 0

            if arg.name.match /^[A-Z]/

                #
                # Inject local module (from ./lib of ./app)
                #

                services.push require Injector.findModule arg.name

            else

                #
                # Inject installed npm module
                #

                services.push require arg.name

        #console.log "services:", services

        return services


    findModule: (klass) -> 

        #
        # returns absolute path to module source
        #

        #
        # Assumptions: 
        # 
        # 0. The sourcefile containing a klass 'CalledThisOne'
        #    will be located in a file 'called_this_one'
        # 
        #    a. the.(coffee|js) not being relevant
        #    b. Maya
        #    c. http://www.youtube.com/watch?v=rlwueICyUxk
        # 
        #
        # 1. A directory called 'spec' will be one of cwd's 
        #    ancestors.
        # 
        # 
        # 2. The source file will be nested somewhere
        #    within a directory called 'lib' or 'app'
        # 
        # 
        # 3. The 'lib' or 'app' directory will be cwd's 
        #    sibling, uncle or great(n) uncle...
        #    
        #    a. Think about it...
        #    b. LOL
        #    c. 'lib' or 'app' is a sibling of 'spec'
        #

        name   = Inflection.underscore klass
        source = undefined

        # console.log fing.trace()

        for calls in fing.trace()

            if match = calls.file.match /(.*)\/spec\/(.*)_spec\./

                repoRoot = match[1]
                depth = match[2].split('/').length

        for srcDir in ['lib', 'app']

            searchPath = repoRoot + "/#{srcDir}"

            # console.log "SEARCH:", searchPath

            if fs.existsSync searchPath

                for file in wrench.readdirSyncRecursive(searchPath)

                    if match = file.match new RegExp "^(.*#{name})\.(coffee|js)$"

                        if source 

                            # console.log "TODO: name: '../' as inject options"
                            throw "Found more than 1 source for module '#{name}'"

                        else

                            source = "#{searchPath}/#{match[1]}"

        unless source
            # console.log "Found no source files for module '#{name}'" 
            throw "Found no source files for module '#{name}'" 

        return source

