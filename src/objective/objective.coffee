Notice    = require 'notice'
Phrase    = require 'phrase'
Realizers = require '../realization/realizers'

module.exports = ( opts, objectiveFn = (end) -> ) ->

                                #
                                # default the objectiveFn as PhraseLeaf
                                #
    
    missing = for required in ['title', 'uuid', 'description']
        continue if opts[required]?
        required

    if missing.length > 0
        console.log "objective(opts, objectiveFn) requires #{
            missing.map( (p) -> "opts.#{p}" ).join ', '
        }"
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
            process.exit 1

        #
        # hub up and listening
        # --------------------
        # 
        # * `opts.listening` now contains details (transport, address, port)
        #
        # 
        # Initialize PhraseTree with the objectiveFn
        # ------------------------------------------
        # 

        try Phrase.createRoot( opts, (objectiveToken, objectiveNotice) -> 

                #
                # * Objective PhraseTree is online.
                # * Pass all 'integratables' into the realizer collection.
                # 

                Realizers.createCollection opts, realizerHub, objectiveToken, objectiveNotice

            ) 'objective', objectiveFn

        catch error

            try delete opts.listen.secret
            try delete opts.listening
            console.log OPTS: opts, ERROR: error
            process.exit 3



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