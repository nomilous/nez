should  = require 'should'
Realize = require '../../lib/realization/realize'
coffee  = require 'coffee-script' 
fs      = require 'fs'
notice  = require 'notice'

describe 'realize', -> 

    beforeEach -> 
        @compile = coffee.compile
        @readfile = fs.readFileSync
        @connect  = notice.connect

    afterEach -> 
        coffee.compile = @compile
        fs.readFileSync = @readfile
        notice.connect = @connect

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


    context 'runRealizer', -> 

        it ''
