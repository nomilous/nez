should  = require 'should'
Realize = require '../../lib/realization/realize'
coffee  = require 'coffee-script' 
fs      = require 'fs'
notice  = require 'notice'
phrase  = require 'phrase'

describe 'realize', -> 

    beforeEach -> 
        @compile = coffee.compile
        @readfile = fs.readFileSync
        @connect  = notice.connect
        @tree     = phrase.createRoot

    afterEach -> 
        coffee.compile = @compile
        fs.readFileSync = @readfile
        notice.connect = @connect
        phrase.createRoot = @tree


    context 'runRealizer', -> 

        it 'creates a phrase tree with uplink as the notifier', (done) -> 

            phrase.createRoot = (opts, linkFn) -> 

                opts.notice.should.equal 'uplink'
                done()
                throw 'go no further'

            try Realize.runRealizer

                uplink:     'uplink'
                opts:       {}
                realizerFn: ->


        context 'outbound messages', ->

            context 'connect, reconnect, ready, error', -> 

                it 'includes uuid, pid and hostname', (done) -> 

                    message = 
                        direction: 'out'
                        event: 'connect'

                    Realize.runRealizer
                        uplink:     
                            use: (middleware) ->  
                                if middleware.toString().match /realizer middleware 1/
                                    middleware message, ->
                        opts:       
                            title: 'TITLE'
                            uuid:  'UUID'
                        realizerFn: ->

                    process.nextTick -> 

                        should.exist message.hostname
                        should.exist message.uuid
                        should.exist message.hostname
                        done()




        context 'inbound messages', -> 

            it 'rejects on reject', (done) -> 

                message = 
                    direction: 'in'
                    event: 'reject'
                    reason: 'REASON'
                    other: 'STUFF'

                Realize.runRealizer(

                    uplink:     
                        use: (middleware) ->  
                            if middleware.toString().match /realizer middleware 1/
                                middleware message, ->
                    opts:       
                        title: 'TITLE'
                        uuid:  'UUID'
                    realizerFn: ->

                ).then(
                    ->
                    (error) -> 

                        error.reason.should.equal 'REASON'
                        error.should.match /reject/
                        done()

                )


            it 'recurses the phrase tree on load', (done) -> 

                message = 
                    direction: 'in'
                    event: 'load'

                phrase.createRoot = (opts, linkFn) -> -> then: -> done()

                Realize.runRealizer

                    uplink:     
                        use: (middleware) ->  
                            if middleware.toString().match /realizer middleware 1/
                                middleware message, ->

                    opts:       
                        title: 'TITLE'
                        uuid:  'UUID'

                    realizerFn: -> 


            it 'sends the ready::N on load completed', (done) -> 

               message = 
                    direction: 'in'
                    event: 'load'

                phrase.createRoot = (opts, linkFn) -> -> then: (resolve) -> resolve()

                Realize.runRealizer

                    uplink:     
                        use: (middleware) ->  
                            if middleware.toString().match /realizer middleware 1/
                                middleware message, ->

                        event: good: (title) -> 

                            title.should.equal 'ready::1'
                            done()

                    opts:       
                        title: 'TITLE'
                        uuid:  'UUID'

                    realizerFn: ->  

                        


    context 'startNotifier', -> 

        it 'starts notice messenger', (done) -> 

            notice.connect = (originName, opts, callback) -> 

                originName.should.equal 'UUID'
                opts.connect.should.eql 
                    transport: "http"
                    secret: '∆'
                    port: 10101

                opts.origin.should.eql 
                    title: 'TITLE'
                    uuid:  'UUID'
                    any:   'thing'
                    other: 'stuff'

                callback null, 'NOTIFIER'

            Realize.startNotifier( 

                opts:
                    title: 'TITLE'
                    uuid:  'UUID'
                    any:   'thing'
                    other: 'stuff'
                    connect: 
                        transport: 'http'
                        secret: '∆'
                        port: 10101

            ).then ({uplink, opts, realizerFn}) ->

                uplink.should.equal 'NOTIFIER'
                done()


    context 'loadRealizer', -> 

        it 'rejects on missing filename', (done) -> 

            Realize.loadRealizer().then(
                ->
                (error) -> 
                    error.code.should.equal 'MISSING_ARG'
                    error.errno.should.equal 101
                    error.should.match /missing realizerFile/
                    done()
            )

        it 'rejects on missing file', (done) -> 

            Realize.loadRealizer( 
                filename: 'file.coffee' 
            ).then(
                ->
                (error) -> 
                    error.code.should.equal 'ENOENT'
                    error.errno.should.equal 34
                    done()
            )

        it 'compiles coffee', (done) -> 

            fs.readFileSync = -> """
            title: 'TITLE'
            uuid:  'UUID'
            realize: -> 
            """

            coffee.compile = -> 
                done()
                throw 'go no further'

            Realize.loadRealizer filename: 'file.coffee'


        it 'compiles litcoffee', (done) -> 

            fs.readFileSync = -> """
            """

            coffee.compile = -> 
                done()
                throw 'go no further'

            Realize.loadRealizer filename: 'file.coffee'


        it 'resolves with realizer', (done) -> 

            process.env.SECRET = '∆'
            fs.readFileSync = -> """
            title:   'TITLE'
            uuid:    'UUID'
            realize: 'a function'
            """

            Realize.loadRealizer(

                filename: 'file.coffee'
                connect: true
                transport: 'http'
                port: 10101
                
            ).then( 

                (realizer) -> 

                    realizer.should.eql 
                        opts:
                            title: 'TITLE'
                            uuid: 'UUID'
                            connect: 
                                transport: 'http'
                                secret: '∆'
                                port: 10101

                        realizerFn: 'a function'
                    done()


                (error) -> 
                    console.log SPEC_ERROR_1:
                        error: error
                        filename: __filename

            )

