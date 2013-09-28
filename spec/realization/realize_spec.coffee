should  = require 'should'
Realize = require '../../lib/realization/realize'
coffee  = require 'coffee-script' 
fs      = require 'fs'

describe 'realize', -> 

    beforeEach -> 
        @compile = coffee.compile
        @readfile = fs.readFileSync

    afterEach -> 
        coffee.compile = @compile
        fs.readFileSync = @readfile

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

        it ''

    context 'runRealizer', -> 

        it ''
