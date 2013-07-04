should    = require 'should'
Realizers = require '../lib/realizers'
core      = require 'nezcore'
Notice    = require 'notice'

describe 'realizers', ->

    NOTIFIED       = {}
    NOTIFIER       = info: -> NOTIFIED.info = arguments

    LISTENING      = {}
    HUB_MIDDLEWARE = undefined
    
    #
    # mock notice hub
    #

    REMOTE_NOTIFIERS = 

        use: (fn) -> 

            #
            # keep ref to the middleware being registered 
            # to handle inbound messages from realizers
            #

            HUB_MIDDLEWARE = fn


    Notice.listen  = (title, opts, callback) -> 

        LISTENING['listen'] = opts

                                  #
                                  # pending integrations
                                  #


                                  #
                                  #  
                                  # Notice attaches ref to listening address once
        opts.listening =   {}     # the hub is up, this stub needs to mimic that
                                  # behaviour
                                  # 
                                  # 

                                  # 
                                  # 
                                  # Notice calls back with middleware pipeline
                                  # attached to the remote notifiers, 
                                  # 

        callback null, REMOTE_NOTIFIERS  

                                  # 
                                  # callback with mock notice hub
                                  # 

    #
    # mock realizer start message (as sent by realizer after handshake)
    #

    INBOUND_REALIZER_START_MESSAGE = 

        context:
            title: 'realizer::start'
        properties:
            id: '___REALIZER_ID___'

    #
    # mock realizer reply pipeline (as used to send message back to realizers)
    #

    REPLY_TO_REALIZER_MESSENGER = -> 

    #
    # mock reply property on the realizer start message
    #

    REPLY_PROPERTY_SPY = -> return REPLY_TO_REALIZER_MESSENGER

    Object.defineProperty INBOUND_REALIZER_START_MESSAGE, 'reply', get: -> REPLY_PROPERTY_SPY()



    CONTEXT       = 
        listen: 'LISTENSPEC'
        tools: spawn: ->

    realizers     = undefined

    before (done) -> 

        #
        # Realizers is an async factory class, it calls back with
        # the assembled realizers collection
        #

        Realizers CONTEXT, NOTIFIER, (err, result) -> 

            realizers = result
            done()


    context 'listens', -> 

        it 'for realizers', (done) -> 

            LISTENING.listen.listen.should.equal 'LISTENSPEC'
            done()


        it 'get the reply pipeline from attaching realizers', (done) -> 
            
            spy = REPLY_PROPERTY_SPY
            REPLY_PROPERTY_SPY = -> 
                REPLY_PROPERTY_SPY = spy
                done()

            HUB_MIDDLEWARE INBOUND_REALIZER_START_MESSAGE, ->
            


    context 'task(title, ref)', -> 

        it 'emits a task to a realizer', (done) -> 

            spy = realizers.get
            realizers.get = (ref, callback) -> 
                realizers.get = spy

                #
                # mock the getting of the realizer
                # by returning a realize with spy
                # on the call to task
                #

                callback null, 

                    task: (title) -> 

                        title.should.equal 'The Frabjous Day'
                        done()


            realizers.task 'The Frabjous Day'


        it 'can get more minerals', (done) -> 

            spy = realizers.get
            realizers.get = (ref, callback) -> 
                realizers.get = spy
                callback null, task: -> done()

            realizers.task 'get more minerals', 

                match: 'miners/group3/*'
                scroll: 'to corner of map'
                location: 'CL!CK'
                'huh?': 'https://github.com/nomilous/nez/tree/develop/.metadata/.metadata/.metadata/.metadata/.metadata/.metadata/.metadata/.metadata/.metadata'

            

    context 'get( ref, callback )', -> 

        #
        # gets reference to an attached realizer
        #

        it 'requires a realizer id', (done) -> 

            try realizers.get()
            catch error 

                error.should.match /realizers.get\(ref, callback\) requires ref.id as the realizer id/
                done()


        it 'callback missing realizer if not present', (done) -> 

            realizers.get id: 'ID', (error, realizer) -> 

                error.should.match /missing realizer/
                done()


        it 'returns the realizer reply object if the realizer is already connected', (done) -> 

            #
            # mock attaching realizer
            #

            HUB_MIDDLEWARE INBOUND_REALIZER_START_MESSAGE, ->

            #
            # get it
            #

            realizers.get id: '___REALIZER_ID___', (error, realizer) -> 

                realizer.should.equal REPLY_TO_REALIZER_MESSENGER
                done()



        context 'can spawn the realizer', -> 

            it 'if opts.script is specified', (done) -> 

                CONTEXT.tools.spawn = (notice, opts, cb) -> 

                    opts.arguments.should.eql ['SCRIPT.coffee']
                    
                    setTimeout (->

                        #
                        # spawning child fails after 10 miliseconds
                        #

                        opts.exit '__PID__'

                    ), 10
                    
                    cb null,

                        #
                        # mock child
                        # 

                        pid: '__PID__'
                        stdout: on: ->

                CONTEXT.hub = listening: {}

                realizers.get 

                    id: 'ID'
                    script: 'SCRIPT.coffee'
                    (error, realizer) -> done()


            it 'only spawns coffeescript realizers', (done) -> 

                realizers.get 

                    id: 'ID'
                    script: 'SCRIPT.js'
                    (error, realizer) -> 

                        error.should.match /nez supports only coffee-script realizers/
                        done()


            it 'exiting spawned realizer generates error if it never sent the realizer::start event', (done) -> 

                CONTEXT.tools.spawn = (notice, opts, cb) -> 

                    setTimeout (->

                        opts.exit '__PID__'

                    ), 10

                    cb null,

                        pid: '__PID__'
                        stdout: on: ->

                realizers.get 

                    id: 'SCRIPT.coffee'
                    script: 'SCRIPT.coffee'
                    (error, realizer) -> 

                        error.should.match /realizer exited before connecting/
                        done()



            it 'subsequent calls to spawn a realizer that is already buzy spawning notified and ignored', (done) -> 

                CONTEXT.tools.spawn = (notice, opts, cb) -> 

                    setTimeout (->

                        opts.exit '__PID__'

                    ), 100

                    cb null,

                        pid: '__PID__'
                        stdout: on: ->

                realizers.get 

                    id: 'SCRIPT.coffee'
                    script: 'SCRIPT.coffee'
                    (error, realizer) -> 

                realizers.get 

                    id: 'SCRIPT.coffee'
                    script: 'SCRIPT.coffee'
                    (error, realizer) -> 

                
                NOTIFIED.info.should.eql 

                    0: 'already waiting for realizer'
                    1: description: 'pid:__PID__, script:SCRIPT.coffee'

                done()



            it 'an exiting realizer which succeeded to send the realizer::start event generates no error', (done) -> 

                ERROR = undefined
                CONTEXT.tools.spawn = (notice, opts, cb) -> 

                    setTimeout (->

                        opts.exit '__PID__'

                    ), 100

                    cb null,

                        pid: '__PID__'
                        stdout: on: ->

                realizers.get 

                    id: 'SCRIPT.coffee'
                    script: 'SCRIPT.coffee'

                    (error, realizer) -> 

                        should.exist realizer
                        ERROR = error


                INBOUND_REALIZER_START_MESSAGE.properties.id = 'SCRIPT.coffee'
                
                HUB_MIDDLEWARE INBOUND_REALIZER_START_MESSAGE, ->

                setTimeout (->
                    should.not.exist ERROR
                    done()
                ), 200


            it 'a spawned realizer is respawned on get() if the script checksum changed'
