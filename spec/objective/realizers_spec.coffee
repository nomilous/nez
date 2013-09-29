should = require 'should'
Realizers = undefined 
spawner   = undefined

describe 'Realizers', -> 

    beforeEach (done) -> 

        @MIDDLEWARES = []

        Realizers = require( '../../lib/objective/realizers' ).createClass(
            {
                autospawn: false
                autoinit:  false
            } 
            @messageBus = use: (middleware) => @MIDDLEWARES.push middleware
        )


        Realizers.update( 

            '/Objective Title/objective/spec/Spec title': 

                type: 'tree'
                uuid: '1'
                source:
                    type:     'file'
                    filename: 'path/to/realizer1.coffee'

            '/Objective Title/objective/spec/Another spec title': 

                type: 'tree'
                uuid: '2'
                localPID: 54321
                source:
                    type:     'file'
                    filename: 'path/to/realizer2.coffee'

         ).then -> 

            spawner = Realizers.spawner
            done()

    afterEach ->
        #spawner.spawn = @spawn

    it 'has autospawn option property', (done) -> 

        Realizers.autospawn.should.equal false
        done()


    context 'on connect', -> 

        it 'assigns realizer response notifiers into collection', (done) -> 

            @MIDDLEWARES[0]

                event: 'connect'
                context: 
                    responder: use: -> 'REALIZER_BOUND_MESSAGE_BUS'
                uuid: 'UUID'
                ->

                    Realizers.get( uuid: 'UUID' ).then (realizer) -> 

                        realizer.notice.use().should.eql 'REALIZER_BOUND_MESSAGE_BUS'
                        done()

        it 'sets the realizer connected state', (done) -> 

            @MIDDLEWARES[0]

                event: 'connect'
                context: 
                    responder: use: ->
                uuid: 'UUID'
                ->

                    Realizers.get( uuid: 'UUID' ).then (realizer) -> 

                        realizer.connected.should.equal true
                        done()

        it 'emits event', (done) -> 

            Realizers.on 'connect', (realizer) -> 

                realizer.connected.should.equal true
                done()

            @MIDDLEWARES[0]

                event: 'connect'
                context: 
                    responder: use: ->
                uuid: 'UUID'
                ->

        it 'rejects on multiple instances of same realizer', (done) -> 

            @MIDDLEWARES[0]

                event: 'connect'
                context: 
                    responder: use: ->
                uuid: 'UUID'
                pid: 'PID'
                hostname: 'host.name'
                =>

                    @MIDDLEWARES[0]

                        event: 'connect'
                        context: 
                            responder: 
                                use: ->
                                event: bad: (title, payload) -> 

                                    title.should.equal 'reject'
                                    payload.reason.should.equal 'realizer:UUID already running @ PID.host.name'
                                    done()

                        uuid: 'UUID'
                        pid: 'ANOTHERPID'
                        hostname: 'hostname'
                        ->


        it 'sends load event if autoload is enabled', (done) -> 

            Realizers = require( '../../lib/objective/realizers' ).createClass(
                {
                    autospawn: false
                    autoload:  true
                } 
                use: (middleware) -> 
                    return unless middleware.toString().match /realizers collection middleware 1/
                    middleware 
                        event: 'connect'
                        context: 
                            responder: 
                                use: ->
                                event: (title) -> 
                                    
                                    title.should.equal 'load'
                                    then: -> done()

                        uuid: 'UUID'
                        pid: 'PID'
                        hostname: 'host.name'
                        ->
            )

        it 'sends no load event if autoload is disabled', (done) ->

            Realizers = require( '../../lib/objective/realizers' ).createClass(
                {
                    autospawn: false
                    autoload:  false
                } 
                use: (middleware) -> 
                    return unless middleware.toString().match /realizers collection middleware 1/
                    middleware 
                        event: 'connect'
                        context: 
                            responder: 
                                use: ->
                                event: (title) -> 
                                    
                                    title.should.not.equal 'load'
                                    then: -> 

                        uuid: 'UUID'
                        pid: 'PID'
                        hostname: 'host.name'
                        ->
            )

            setTimeout (->
                done()
            ), 100


    context 'on reconnect', -> 

        it 'sets the realizer connected state', (done) -> 

            @MIDDLEWARES[0]

                event: 'reconnect'
                context: 
                    responder: use: ->
                uuid: 'UUID'
                ->

                    Realizers.get( uuid: 'UUID' ).then (realizer) -> 

                        realizer.connected.should.equal true
                        done()

        it 'emits event', (done) -> 

            Realizers.on 'reconnect', (realizer) -> 

                realizer.connected.should.equal true
                done()

            @MIDDLEWARES[0]

                event: 'reconnect'
                context: 
                    responder: use: ->
                uuid: 'UUID'
                ->


        it 'rejects on multiple instances of same realizer', (done) -> 

            @MIDDLEWARES[0]

                event: 'connect'
                context: 
                    responder: use: ->
                uuid: 'UUID'
                pid: 'PID'
                hostname: 'host.name'
                =>

                    @MIDDLEWARES[0]

                        event: 'connect'
                        context: 
                            responder: 
                                use: ->
                                event: bad: (title, payload) -> 

                                    title.should.equal 'reject'
                                    payload.reason.should.equal 'realizer:UUID already running @ PID.host.name'
                                    done()

                        uuid: 'UUID'
                        pid: 'ANOTHERPID'
                        hostname: 'hostname'
                        ->

    context 'on ready::SEQ', ->

        it 'emits event', (done) ->
        
            Realizers.on 'ready', (realizer, seq) -> 

                realizer.pid.should.equal 'PID'
                seq.should.equal 1
                done()


            @MIDDLEWARES[0]
                event: 'connect'
                context: 
                    responder: use: ->
                uuid: 'UUID'
                pid: 'PID'
                hostname: 'host.name'
                =>
                    @MIDDLEWARES[0]
                        event: 'ready::1'
                        context: 
                            responder: use: ->
                        uuid: 'UUID'
                        ->

        it 'sends run event on ready::1 if autorun is enabled', (done) ->

            Realizers = require( '../../lib/objective/realizers' ).createClass(
                {
                    autospawn: false
                    autoinit:  true
                    autorun:   true
                } 
                use: (middleware) -> 
                    return unless middleware.toString().match /realizers collection middleware 1/
                    middleware 
                        event: 'ready::1'
                        context: 
                            responder: 
                                use: ->
                                event: (title, payload) -> 

                                    title.should.equal 'run'
                                    payload.should.eql uuid: 'UUID'
                                    then: -> done()

                        uuid: 'UUID'
                        pid: 'PID'
                        hostname: 'host.name'
                        ->
            )


        it 'sends no run event on ready::(N>1) event if autorun is enabled', (done) ->

            Realizers = require( '../../lib/objective/realizers' ).createClass(
                {
                    autospawn: false
                    autoinit:  true
                    autorun:   true
                } 
                use: (middleware) -> 
                    return unless middleware.toString().match /realizers collection middleware 1/
                    middleware 
                        event: 'ready::2'
                        context: 
                            responder: 
                                use: ->
                                event: (title, payload) -> 

                                    title.should.not.equal 'run'

                        uuid: 'UUID'
                        pid: 'PID'
                        hostname: 'host.name'
                        ->
            )

            setTimeout (->
                done()
            ), 100


    context 'on error', -> 

        it 'emits event', (done) ->
        
            Realizers.on 'error', (realizer) -> 

                realizer.pid.should.equal 'PID'
                done()


            @MIDDLEWARES[0]
                event: 'connect'
                context: 
                    responder: use: ->
                uuid: 'UUID'
                pid: 'PID'
                hostname: 'host.name'
                =>
                    @MIDDLEWARES[0]
                        event: 'error'
                        context: 
                            responder: use: ->
                        uuid: 'UUID'
                        ->


    context 'on disconnect', -> 

        it 'set the realizer connected state', (done) -> 

            @MIDDLEWARES[0]

                    event: 'connect'
                    context: 
                        responder: use: (middleware) -> 

                            middleware event: 'disconnect', ->

                    uuid: 'UUID'
                    ->

                        Realizers.get( uuid: 'UUID' ).then (realizer) -> 

                            realizer.connected.should.equal false
                            done()

        it 'emits event', (done) -> 

            Realizers.on 'disconnect', (realizer) -> 

                realizer.connected.should.equal false
                done()

            @MIDDLEWARES[0]

                    event: 'connect'
                    context: 
                        responder: use: (middleware) -> 

                            middleware event: 'disconnect', ->

                    uuid: 'UUID'
                    ->

    context 'get()', -> 

        it 'returns a promise', (done) -> 

            Realizers.get().then.should.be.an.instanceof Function
            done()


        it 'autospawns the realizer if enabled', (done) -> 

            Realizers.autospawn = true

            spawner.spawn = (token) -> 

                token.should.eql
                    type: 'tree'
                    uuid: '1'
                    source:
                        type:     'file'
                        filename: 'path/to/realizer1.coffee'

                done()
                then: ->

            Realizers.get filename: 'path/to/realizer1.coffee'


        it 'resolves with already spawned realizers', (done) -> 

            Realizers.autospawn = true
            spawner.spawn = -> throw 'should not run'

            Realizers.get( filename: 'path/to/realizer2.coffee' ).then(

                (realizer) -> 

                    realizer.token.uuid.should.equal '2'
                    done()


                (error)    -> console.log REALIZERS_SPEC_ERROR_1: error.stack

            )


    context 'update(tokens)', -> 

        it 'returns a promise', (done) -> 

            Realizers.update( {} ).then.should.be.an.instanceof Function
            done()


        it 'loads boundry phrase tokens into the realizer reference collection', (done) -> 

            Realizers.update( 

                '/Objective Title/objective/spec/Spec title': 

                    type: 'tree'
                    uuid: '1'
                    source:
                        type:     'file'
                        filename: 'path/to/realizer1.coffee'

             ).then -> 
                
                Realizers.get( 

                    filename: 'path/to/realizer1.coffee' 

                ).then (realizer) -> 

                    realizer.token.uuid.should.equal '1'
                    realizer.connected.should.equal false
                    done()
