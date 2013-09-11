Notice           = require 'notice'
Phrase           = require 'phrase'
Objective        = require './objective'
RealizersFactory = require './realizers'
MonitorFactory   = require './monitor'

module.exports = (opts, objectiveFn) ->
    
    missing = for required in ['title', 'uuid', 'description']
        continue if opts[required]?
        required

    if missing.length > 0
        console.log "objective(opts, objectiveFn) requires #{
            missing.map( (p) -> "opts.#{p}" ).join ', '
        }"
        process.exit 1


    #
    # Initialize Objective Processor
    # ------------------------------
    #

    localopts = 

        module: opts.module || '../defaults'
        class:  opts.class  || 'Develop'

    try 
        
        Module = require localopts.module

        unless Module[ localopts.class ]?
            throw new Error "Could not initialize objective module(=#{
                localopts.module}) does not define class(=#{
                    localopts.class})"

        Objective = Module[ localopts.class ]

    catch error

            try delete opts.listen.secret
            try delete opts.listening
            console.log OPTS: opts, ERROR: error
            process.exit 2

    #
    # start notice hub
    # ----------------
    # 
    # * defaults socket.io (http, localhost, nextport)
    # * or specify in objective
    # 
    #   eg. 
    #       require('nez').objective
    # 
    #           title: 'Title'
    #           uuid:  '00000000-0700-0000-0000-fffffffffff0'
    # 
    #           listen: 
    #               secret:   '∫'
    #               address:  'localhost'
    #               port:     10001
    #               cert:     './cert/develop-cert.pem'
    #               key:      './cert/develop-key.pem'
    #

    Notice.listen "objective/#{ opts.uuid }", opts, (error, realizerHub) -> 

        if error? 

            try delete opts.listen.secret
            try delete opts.listening
            console.log OPTS: opts, ERROR: error
            process.exit 3

        #
        # hub up and listening
        # --------------------
        # 
        # * `opts.listening` now contains details (transport, address, port)
        # 
        # 

        objectiveRecursor = undefined
        objectiveMonitor  = undefined


        # realizerHub.use (msg, next) -> 

        #     console.log IGNORED_REMOTE: 
        #         event:   msg.context.title
        #         origin:  msg.context.origin
                
        #     next()


        # 
        # * Start the Objective processor
        # 

        objective = new Objective

        objective.configure opts, ->

            Realizers           = RealizersFactory.createClass opts, realizerHub
            Realizers.autospawn = opts.autospawn || false
            objectiveMonitor    = MonitorFactory.createFunction Realizers

            try 

                # 
                # Initialize PhraseTree with the objectiveFn
                # ------------------------------------------
                # 

                objectiveRecursor = Phrase.createRoot( opts, (objectiveToken, objectiveNotice) -> 

                    #
                    # * PhraseTree is ready for the 'first walk'
                    # * Assign middleware to proxy selected messages into the objective 
                    #

                    objectiveNotice.use (msg, next) -> 

                        switch msg.context.title

                            when 'phrase::link:directory'

                                objectiveMonitor
                                 
                                    directory: msg.directory
                                    match:     msg.match
                                    ref:       'realizer'

                                return next()

                            when 'phrase::boundry:assemble'

                                #
                                # proxy the boundry assembly into objective
                                # -----------------------------------------
                                # 

                                return objective.onBoundryAssemble msg.opts, (error, phrase) ->

                                    #
                                    # TODO: fix, "notice has limited capacity for error"
                                    #
                                    
                                    msg.phrase = phrase
                                    msg.error  = error
                                    next()

                            when 'phrase::recurse:end'

                                return next() unless msg.root.uuid == opts.uuid
                                return Realizers.update( msg.tokens ).then -> next()


                        #console.log 'IGNORED:', msg.context.title
                        next()



                    objectiveToken.on 'ready', ( {tokens} ) -> 

                        objective.startMonitor opts, objectiveMonitor, tokens, (token, opts) -> 

                            objectiveToken.run token, opts

                    
                ) 

                #
                # * Walk the objectiveFn (creates the objective PhraseTree)
                #

                objectiveRecursor 'objective', objectiveFn || objective.defaultObjective

            catch error

                try delete opts.listen.secret
                try delete opts.listening
                console.log OPTS: opts, ERROR: error
                process.exit 4


        #
        # * reload objective on create/delete linked file (realizer) to add/remove 
        #   the corresponding boundry token from the objective PhraseTree
        # 

        for event in ['create', 'delete']

            do (event) -> objectiveMonitor.dirs.on event, (filename, stats, ref) -> 
                
                return unless ref == 'realizer'
                objectiveRecursor 'objective', objectiveFn || objective.defaultObjective

                #
                # TODO: fix: it is likely possible to create realizers in linked directories 
                #       faster than the walker can complete the recursion through the linked
                #       tree - it will error with: 
                # 
                #       'Phrase root registrar cannot perform concurrent walks'  
                #


