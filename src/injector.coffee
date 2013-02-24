require 'fing'
Nez        = require './nez'
Inflection = require 'inflection'
fs         = require 'fs'
wrench     = require 'wrench'

module.exports = Injector = 

    inject: -> 

        for key of arguments

            #
            # function is the last argument
            #

            func = arguments[key]

        console.log Nez

        klass  = arguments[0]
        module = Injector.findModule klass
        # pusher = Nez.stack.pusher
        # validator = pusher



        # skip = 0
        # service = []
        # for arg in func.fing.args

        #     continue unless ++skip > 3
        #     service.push require arg.name

        # #
        # # dont know 'if it's possible' / 'how' to tack an array 
        # # onto the end of a function call such that the elements
        # # are appended eachly instead of allfully
        # #
        # # and googling such an abstract notion will take
        # # more time than i want to allocate right now
        # # 
        # # so...
        # # 

        func require(module) #, pusher, validator #, service[0], service[1], service[2], service[3], service[4], service[5], service[6], service[7], service[8], service[9], service[10], service[11], service[12], service[13], service[14], service[15], service[16], service[17], service[18], service[19], service[20], service[21], service[22]  # i suspect that'll suffice... :)


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

        for calls in fing.trace()

            if match = calls.file.match /(.*)\/spec\/(.*)_spec\./

                repoRoot = match[1]
                depth = match[2].split('/').length

        for srcDir in ['lib', 'app']

            searchPath = repoRoot + "/#{srcDir}"

            if fs.existsSync searchPath

                for file in wrench.readdirSyncRecursive(searchPath)

                    if match = file.match new RegExp "^(.*#{name})\.(coffee|js)$"

                        if source 

                            console.log "TODO: name: '../' as inject options"
                            throw "Found two source files for module '#{name}'"

                        else

                            source = "#{searchPath}/#{match[1]}"

        throw "Found no source files for module '#{name}'" unless source

        return source

