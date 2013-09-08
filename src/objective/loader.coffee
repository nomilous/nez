Notice         = require 'notice'
Phrase         = require 'phrase'
Objective      = require './objective'
monitor        = require './monitor'

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


        realizerHub.use (msg, next) -> 

            console.log msg.content
            next()


        #
        # * register listener for changes in linked directories
        #

        monitor.dirs.on 'create', (filename, stats, ref) -> 
            return unless ref == 'linked'
            console.log CREATED_REALIZER: filename

        monitor.dirs.on 'delete', (filename, stats, ref) -> 
            return unless ref == 'linked'
            console.log DELETED_REALIZER: filename

        


        # 
        # * Start the Objective processor
        # 

        objective = new Objective

        objective.configure opts, ->

            try 

                # 
                # Initialize PhraseTree with the objectiveFn
                # ------------------------------------------
                # 

                recursor = Phrase.createRoot( opts, (objectiveToken, objectiveNotice) -> 

                    #
                    # * PhraseTree is ready for the 'first walk'
                    # * Assign middleware to proxy selected messages into the objective 
                    #

                    objectiveNotice.use (msg, next) -> 

                        switch msg.context.title

                            when 'phrase::link:directory'

                                monitor 
                                    directory: msg.directory
                                    match:     msg.match
                                    ref:       'linked'

                                next()

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

                        #console.log 'IGNORED:', msg.context.title
                        next()



                    objectiveToken.on 'ready', ( {tokens} ) -> 

                        objective.startMonitor opts, monitor, tokens, (token, opts) -> 

                            objectiveToken.run token, opts

                    
                ) 

                #
                # * Walk the objectiveFn (creates the objective PhraseTree)
                #

                recursor 'objective', objectiveFn || objective.defaultObjective

            catch error

                try delete opts.listen.secret
                try delete opts.listening
                console.log OPTS: opts, ERROR: error
                process.exit 4



#Notice    = require 'notice'
#async     = require('also').inject.async
#tools     = require '../tools'
#Realizers = require '../realizers'
#eo        = require 'eo'
#
#module.exports = (title, opts, objectiveFn) ->
#
#    context    = eo.validate.apply this, arguments
#    objective  = async
#
#        #
#        # asynchronous config assembly for args injection into eo
#        # 
#
#        beforeAll: (done, inject) -> 
#
#            context.tools = tools
#
#            #
#            # create local messenger for interactions with 
#            # console and users personal notice middleware
#            # 
#            #  see: https://github.com/nomilous/notice/tree/develop
#            #
#
#            notice = Notice.create 'objective', context.messenger || eo.messenger context
#                 # 
#                 # 
#                 # 
#                 #
#                 #         DECISION POINT
#                 #         ==============
#                 # 
#                 #         Separate notifiers in the objective?
#                 # 
#                 #         * one attached to remote realizers
#                 #           and the other for local notifications
#                 # 
#                 #         * or both on the same pipeline
#                 # 
#                 # 
#                 #         UM
#                 #         
#                 # 
#                 ###################################
#                                                   #
#                                                   # 
#                                                   #
#            Realizers context, notice, (error, realizers) -> 
#
#                return done error if error?
#
#                #
#                # realizer collection class is online and 
#                # listening for realizers
#                #
#
#                context.realizers = realizers
#
#
#                #
#                # injects into eo module runner
#                # 
#                # arg1 - objective context 
#                # arg2 - local notifier
#                # argN - remaining args as called externally
#                #
#
#                inject.first[0]   = context
#                inject.first[1]   = notice
#
#
#                #
#                # proceed to injection
#                #
#
#                done()
#
#
#        beforeEach: (done, inject) -> 
#
#            #
#            # activate alternative resolver injection
#            # to prevent `done` being injected into eo 
#            # as arg1
#            # 
#            # TODO: resolve this deferral somewhere
#            # 
#
#            inject.defer
#            done()
#
#
#        #
#        # assign a default error handler if none was configured
#        #
#
#        error: context.error || (
#
#            console.log 'WARNING', 'objective without error handler'
#            (error) -> console.log 'ERROR', error
#
#        )
#        
#        #
#        # inject into eo(context, notifier, objectiveFn)
#        #
#
#        eo
#
#
#    #
#    # start the objective
#    #
#
#    objective objectiveFn
#
#
#