should    = require 'should'
Realizers = require '../lib/realizers'
core      = require 'nezcore'
Notice    = require 'notice'
tasks     = require('does').tasks 

describe 'realizers', ->


    CONTEXT  = {} 
    INFO     = undefined
    BADEVENT = undefined
    NOTICE   = 
        info: -> INFO = arguments
        event: 
            bad:-> BADEVENT = arguments

    MIDDLEWARE    = undefined
    Notice.listen = (title, opts, callback) -> 

        #
        # stub Notice networkings
        # -----------------------
        # 
        # callback with connected notifer 
        # (as would happen when a realizer connects)
        #

        callback null, 

            #
            # stub notice middleware registrar
            # 

            use: (fn) -> MIDDLEWARE = fn


    context 'provides api to realizer collection', -> 

        it 'defines start()', (done) -> 

            Realizers CONTEXT, NOTICE, (error, api) -> 

                api.start.should.be.an.instanceof Function
                done()

        it 'defines get()', (done) -> 

            Realizers CONTEXT, NOTICE, (error, api) -> 

                api.get.should.be.an.instanceof Function
                done()


    context 'handle realizers registering', -> 

        it 'creates a task to encapsulate the remote realizer', (done) -> 

            REPLY_FUNCTION = -> 

            mock = tasks.task
            tasks.task = (opts) -> 
                tasks.task = mock

                opts.uuid.should.equal 'REALIZER_UUID'
                opts.otherProperty.should.equal 'VALUE'

                #
                # task is created with the messenger pipeline
                # attached to the remote realizer process
                #

                opts.notice.should.equal REPLY_FUNCTION
                done()

            Realizers CONTEXT, NOTICE, (error, api) -> 

                #
                # send fake realizer registration to the
                # middleware
                # 

                MIDDLEWARE 
                    context:
                        title: 'realizer::register'
                    properties: 
                        uuid: 'REALIZER_UUID'
                        otherProperty: 'VALUE'
                    reply: REPLY_FUNCTION
                    ->

    context 'api', -> 

        beforeEach (done) -> 

            @SPAWNED = []
            @REPLY_FUNCTION = ->
            @CHECKSUM = 'cc'
            @KILLED = undefined
            CONTEXT  = 

                #
                # objective runs a notice hub and populates context with 
                # the listening port, fake it
                #

                listening: 
                    transport: 'http'
                    address: '127.0.0.1'
                    port: 64653

                tools: 

                    #
                    # get(opts) can spawn the realizer script if 
                    # not registered and opts.script is defined
                    #

                    spawn: (notice, args, callback) => 
                        @SPAWNED = arguments

                        #
                        # callback a fake child process
                        #

                        callback null, 
                            pid: 'SPAWNED_PID'
                            kill: => @KILLED = args.arguments[0]
                            stdout: 
                                on: ->

                    #
                    # get(opts) that refers to a spawned realizer 
                    # will respawn the realizer if the script checksum
                    # changed
                    #

                    checksum: 
                        file: => @CHECKSUM


            Realizers CONTEXT, NOTICE, (error, @api) => 

                MIDDLEWARE 
                    context:
                        title: 'realizer::register'
                    properties: 
                        uuid: 'REGISTERED_REALIZER_UUID'
                        otherProperty: 'VALUE'
                    reply: @REPLY_FUNCTION
                    ->
                
                done()


        context 'get()', -> 

            it 'callsback with if the realizer is not present (has not registered)', (done) -> 

                    @api.get uuid: 'MISSING_REALIZER_UUID', (err, realizer) -> 

                        err.should.match /missing realizer/
                        done()

            it 'calls back with the realizer', (done) -> 

                @api.get uuid: 'REGISTERED_REALIZER_UUID', (err, realizer) -> 

                    realizer.uuid.should.equal 'REGISTERED_REALIZER_UUID'
                    should.exist realizer.running
                    done()


            it 'spawns the realizer if opts.script is specified', (done) -> 

                process.nextTick =>

                    @SPAWNED[1].arguments.should.eql ['FILENAME.coffee']
                    done()

                @api.get 

                    uuid: 'SPAWN_THIS_REALIZER'
                    script: 'FILENAME.coffee'

                    (err, realizer) -> 


            it 'does not spawn a second instance if still waiting for the first to register', (done) -> 

                @api.get 

                    uuid: 'SPAWN_THIS_REALIZER'
                    script: 'FILENAME.coffee'

                    (err, realizer) -> 

                process.nextTick =>

                    @api.get 

                        uuid: 'SPAWN_THIS_REALIZER'
                        script: 'FILENAME.coffee'

                        (err, realizer) -> 

                process.nextTick -> 

                    INFO.should.eql 

                        '0': 'already waiting for realizer'
                        '1': description: "pid:SPAWNED_PID, script:FILENAME.coffee"

                    done()



            it 'respawns if the script checksum changed', (done) ->

                @api.get 

                    uuid: 'SPAWN_ANOTHER_REALIZER'
                    script: 'FILENAME.coffee'

                    (err, realizer) -> 

                #
                # fake the remote realizer refistering
                #

                MIDDLEWARE 
                    context:
                        title: 'realizer::register'
                    properties: 
                        uuid: 'SPAWN_ANOTHER_REALIZER'
                        otherProperty: 'VALUE'
                    reply: @REPLY_FUNCTION
                    ->

                process.nextTick => 

                    @SPAWNED  = undefined
                    @CHECKSUM = 'dd'

                    @api.get 

                        uuid: 'SPAWN_ANOTHER_REALIZER'
                        script: 'FILENAME.coffee'
                        (err, realizer) -> 

                process.nextTick => 

                    @KILLED.should.equal 'FILENAME.coffee'
                    @SPAWNED[1].arguments[0].should.equal 'FILENAME.coffee'
                    done()
                    
            it 'kills changed script a more gracefully - perhaps via notifier'


        context 'start()', -> 

            it 'calls to get() the realizer from the collection', (done) -> 

                spy = @api.get
                @api.get = => 
                    @api.get = spy
                    done()

                @api.start uuid: 'REALIZER_UUID'

            it 'returns a promise', (done) -> 

                spy = @api.get
                @api.get = => 
                    @api.get = spy

                @api.start( uuid: 'REALIZER_UUID' ).then.should.be.an.instanceof Function
                done()


            it 'the promise is rejected if the realizer could not be gotten', (done) -> 

                spy = @api.get
                @api.get = (opts, callback) => 
                    @api.get = spy
                    process.nextTick -> 

                        callback new Error 'a problem'

                @api.start( uuid: 'REALIZER_UUID', script: 'SCRIPT.coffee' ).then(

                    (result) ->
                    (error)  => 
                        error.should.match /a problem/
                        
                        #
                        # and notifies
                        #

                        BADEVENT[0].should.equal 'missing or broken realizer'
                        BADEVENT[1].realizer.should.equal 'REALIZER_UUID'
                        BADEVENT[1].script.should.equal 'SCRIPT.coffee'
                        BADEVENT[1].error.should.match /a problem/
                        done()

                )


            it 'calls realizer.start() and binds the resulting promise', (done) -> 

                spy = @api.get
                @api.get = (opts, callback) => 
                    @api.get = spy
                    callback null, 

                        #
                        # realizer is a task, calling start returns a promise
                        #

                        start: -> 

                            then: (onResolve, onError, onStatus) -> 

                                #
                                # fake a status update from the realizer
                                #

                                onStatus 'UPDATE'


                @api.start( uuid: 'REALIZER_UUID' ).then(

                    (resolve) -> 
                    (error)   -> 
                    (status)  -> 

                        status.should.equal 'UPDATE'
                        done()

                )


            it 'handles the calling of start() when already running'




    # NOTIFIED       = {}
    # NOTIFIER       = info: -> NOTIFIED.info = arguments

    # LISTENING      = {}
    # HUB_MIDDLEWARE = undefined
    
    # #
    # # mock notice hub
    # #

    # REMOTE_NOTIFIERS = 

    #     use: (fn) -> 

    #         #
    #         # keep ref to the middleware being registered 
    #         # to handle inbound messages from realizers
    #         #

    #         HUB_MIDDLEWARE = fn


    # Notice.listen  = (title, opts, callback) -> 

    #     LISTENING['listen'] = opts

    #                               #
    #                               # pending integrations
    #                               #


    #                               #
    #                               #  
    #                               # Notice attaches ref to listening address once
    #     opts.listening =   {}     # the hub is up, this stub needs to mimic that
    #                               # behaviour
    #                               # 
    #                               # 

    #                               # 
    #                               # 
    #                               # Notice calls back with middleware pipeline
    #                               # attached to the remote notifiers, 
    #                               # 

    #     callback null, REMOTE_NOTIFIERS  

    #                               # 
    #                               # callback with mock notice hub
    #                               # 

    # #
    # # mock realizer start message (as sent by realizer after handshake)
    # #

    # INBOUND_REALIZER_START_MESSAGE = 

    #     context:
    #         title: 'realizer::start'
    #     properties:
    #         uuid: '___REALIZER_ID___'

    # #
    # # mock realizer reply pipeline (as used to send message back to realizers)
    # #

    # REPLY_TO_REALIZER_MESSENGER = -> 

    # #
    # # mock reply property on the realizer start message
    # #

    # REPLY_PROPERTY_SPY = -> return REPLY_TO_REALIZER_MESSENGER

    # Object.defineProperty INBOUND_REALIZER_START_MESSAGE, 'reply', get: -> REPLY_PROPERTY_SPY()



    # CONTEXT       = 
    #     listen: 'LISTENSPEC'
    #     tools: 
    #         spawn: ->          
    #         checksum: file: -> '................................'

    # realizers     = undefined

    # before (done) -> 

    #     #
    #     # Realizers is an async factory class, it calls back with
    #     # the assembled realizers collection
    #     #

    #     Realizers CONTEXT, NOTIFIER, (err, result) -> 

    #         realizers = result
    #         done()


    # context 'listens', -> 

    #     it 'for realizers', (done) -> 

    #         LISTENING.listen.listen.should.equal 'LISTENSPEC'
    #         done()


    #     it 'get the reply pipeline from attaching realizers', (done) -> 
            
    #         spy = REPLY_PROPERTY_SPY
    #         REPLY_PROPERTY_SPY = -> 
    #             REPLY_PROPERTY_SPY = spy
    #             done()

    #         HUB_MIDDLEWARE INBOUND_REALIZER_START_MESSAGE, ->
            


    # context 'task(title, ref)', -> 

    #     it 'emits a task to a realizer', (done) -> 

    #         spy = realizers.get
    #         realizers.get = (ref, callback) -> 
    #             realizers.get = spy

    #             #
    #             # mock the getting of the realizer
    #             # by returning a realize with spy
    #             # on the call to task
    #             #

    #             callback null, 

    #                 task: (title) -> 

    #                     title.should.equal 'The Frabjous Day'

    #                     #
    #                     # and handles the returned promise
    #                     #

    #                     then: -> done()


    #         realizers.task 'The Frabjous Day'


    #     it 'can get more minerals', (done) -> 

    #         spy = realizers.get
    #         realizers.get = (ref, callback) -> 
    #             realizers.get = spy
    #             callback null, task: -> then: -> done()

    #         realizers.task 'get more minerals', 

    #             match: 'miners/group3/*'
    #             scroll: 'to corner of map'
    #             location: 'CL!CK'
    #             'huh?': 'https://github.com/nomilous/nez/tree/develop/.metadata/.metadata/.metadata/.metadata/.metadata/.metadata/.metadata/.metadata/.metadata'

            

    # context 'get( ref, callback )', -> 

    #     #
    #     # gets reference to an attached realizer
    #     #

    #     it 'requires a realizer uuid', (done) -> 

    #         try realizers.get()
    #         catch error 

    #             error.should.match /realizers.get\(ref, callback\) requires ref.uuid as the realizer uuid/
    #             done()


    #     it 'callback missing realizer if not present', (done) -> 

    #         realizers.get uuid: 'ID', (error, realizer) -> 

    #             error.should.match /missing realizer/
    #             done()


    #     it 'returns the realizer reply object if the realizer is already connected', (done) -> 

    #         #
    #         # mock attaching realizer
    #         #

    #         HUB_MIDDLEWARE INBOUND_REALIZER_START_MESSAGE, ->

    #         #
    #         # get it
    #         #

    #         realizers.get id: '___REALIZER_ID___', (error, realizer) -> 

    #             realizer.should.equal REPLY_TO_REALIZER_MESSENGER
    #             done()



    #     context 'can spawn the realizer', -> 

    #         it 'if opts.script is specified', (done) -> 

    #             CONTEXT.tools.spawn = (notice, opts, cb) -> 

    #                 opts.arguments.should.eql ['SCRIPT.coffee']
                    
    #                 setTimeout (->

    #                     #
    #                     # spawning child fails after 10 miliseconds
    #                     #

    #                     opts.exit '__PID__'

    #                 ), 10
                    
    #                 cb null,

    #                     #
    #                     # mock child
    #                     # 

    #                     pid: '__PID__'
    #                     stdout: on: ->

    #             CONTEXT.hub = listening: {}

    #             realizers.get 

    #                 id: 'ID'
    #                 script: 'SCRIPT.coffee'
    #                 (error, realizer) -> done()


    #         it 'only spawns coffeescript realizers', (done) -> 

    #             realizers.get 

    #                 id: 'ID'
    #                 script: 'SCRIPT.js'
    #                 (error, realizer) -> 

    #                     error.should.match /nez supports only coffee-script realizers/
    #                     done()


    #         it 'exiting spawned realizer generates error if it never sent the realizer::start event', (done) -> 

    #             CONTEXT.tools.spawn = (notice, opts, cb) -> 

    #                 setTimeout (->

    #                     opts.exit '__PID__'

    #                 ), 10

    #                 cb null,

    #                     pid: '__PID__'
    #                     stdout: on: ->

    #             realizers.get 

    #                 id: 'SCRIPT.coffee'
    #                 script: 'SCRIPT.coffee'
    #                 (error, realizer) -> 

    #                     error.should.match /realizer exited before connecting/
    #                     done()



    #         it 'subsequent calls to spawn a realizer that is already buzy spawning notified and ignored', (done) -> 

    #             CONTEXT.tools.spawn = (notice, opts, cb) -> 

    #                 setTimeout (->

    #                     opts.exit '__PID__'

    #                 ), 100

    #                 cb null,

    #                     pid: '__PID__'
    #                     stdout: on: ->

    #             realizers.get 

    #                 id: 'SCRIPT.coffee'
    #                 script: 'SCRIPT.coffee'
    #                 (error, realizer) -> 

    #             realizers.get 

    #                 id: 'SCRIPT.coffee'
    #                 script: 'SCRIPT.coffee'
    #                 (error, realizer) -> 

                
    #             NOTIFIED.info.should.eql 

    #                 0: 'already waiting for realizer'
    #                 1: description: 'pid:__PID__, script:SCRIPT.coffee'

    #             done()



    #         it 'an exiting realizer which succeeded to send the realizer::start event generates no error', (done) -> 

    #             ERROR = undefined
    #             CONTEXT.tools.spawn = (notice, opts, cb) -> 

    #                 setTimeout (->

    #                     opts.exit '__PID__'

    #                 ), 100

    #                 cb null,

    #                     pid: '__PID__'
    #                     stdout: on: ->

    #             realizers.get 

    #                 id: 'SCRIPT.coffee'
    #                 script: 'SCRIPT.coffee'

    #                 (error, realizer) -> 

    #                     should.exist realizer
    #                     ERROR = error


    #             INBOUND_REALIZER_START_MESSAGE.properties.id = 'SCRIPT.coffee'

    #             HUB_MIDDLEWARE INBOUND_REALIZER_START_MESSAGE, ->

    #             setTimeout (->
    #                 should.not.exist ERROR
    #                 done()
    #             ), 200


    #         it 'a spawned realizer is respawned on get() if the script checksum changed', (done) -> 

    #             CONTEXT.tools.spawn = (notice, opts, cb) -> cb null,

    #                 pid: '__PID__'
    #                 stdout: on: ->
    #                 kill: -> 

    #             realizers.get 

    #                 id: 'SCRIPT.coffee'
    #                 script: 'SCRIPT.coffee'
    #                 (error, realizer) -> 

    #                     #
    #                     # successfully spawned realizer
    #                     #

    #                     CONTEXT.tools.checksum.file = -> '__NEW_CHECKSUM__'

    #                     CONTEXT.tools.spawn = -> 

    #                         #
    #                         # it was spawned again
    #                         #

    #                         done()

    #                     realizers.get 

    #                         id: 'SCRIPT.coffee'
    #                         script: 'SCRIPT.coffee'
    #                         (error, realizer) -> 


    #             INBOUND_REALIZER_START_MESSAGE.properties.id = 'SCRIPT.coffee'
    #             HUB_MIDDLEWARE INBOUND_REALIZER_START_MESSAGE, ->
 

    #         it 'a spawned realizer is not respawned on get() if the script checksum did not change', (done) -> 

    #             CONTEXT.tools.spawn = (notice, opts, cb) -> cb null,

    #                 pid: '__PID__'
    #                 stdout: on: ->

    #             realizers.get 

    #                 id: 'SCRIPT.coffee'
    #                 script: 'SCRIPT.coffee'
    #                 (error, realizer1) -> 

    #                     #
    #                     # successfully spawned realizer
    #                     #

    #                     realizers.get 

    #                         id: 'SCRIPT.coffee'
    #                         script: 'SCRIPT.coffee'
    #                         (error, realizer2) -> 

    #                             realizer1.should.equal realizer2
    #                             done()


    #             INBOUND_REALIZER_START_MESSAGE.properties.id = 'SCRIPT.coffee'
    #             HUB_MIDDLEWARE INBOUND_REALIZER_START_MESSAGE, ->

              



