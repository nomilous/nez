should    = require 'should'
Develop   = require '../../lib/defaults/develop'
Objective = require '../../lib/objective/objective' 
fs        = require 'fs'

describe 'Develop', -> 

    beforeEach (done) -> 
        @dev = new Develop
        @dev.configure {}, -> done()

    it 'is an Objective', (done) -> 

        @dev.should.be.an.instanceof Objective
        done()

    it 'allows async config of default phrase opts', (done) -> 

        @dev.configure ( opts = {} ), -> 

            opts.should.eql 
                boundry: ['spec']
                src: 
                    directory: 'src'
                    match:   /\.coffee$/
                autospawn:   true
                autocompile: true
                autospec:    true

            done()

    it 'promotes opts to instance variable', (done) -> 

        opts = {} 
        @dev.configure opts, => 

            @dev.opts.should.equal opts
            done()


    it 'defaults objective phraseFn to link to spec directory', (done) ->

        @dev.defaultObjective link: (opt) -> 

            opt.should.eql directory: 'spec'
            done() 


    it 'handles phrase boundry assembly', (done) -> 

        @dev.onBoundryAssemble {}, -> done()


    context 'onBoundryAssemble()', -> 

        it 'loads the realizer into phrase format', (done) -> 

            #
            # ie.  phrase 'Title', {op:'tions'}, fn = ->
            #

            fs.readFileSync = -> return """

                title: 'Test'
                uuid:  'UUID'
                other: 'stuff'
                realize: (it) -> 'ok,good.'

            """

            @dev.onBoundryAssemble filename: 'something.coffee', (error, phrase) -> 

                phrase.should.eql

                    title: 'Test'

                    control: 
                        uuid: 'UUID'
                        other: 'stuff'

                    fn: phrase.fn

                phrase.fn().should.equal 'ok,good.'
                done()


    context 'startMonitor(monitor, jobTokens, jobEmitter)', -> 

        it 'adds src to monitored directories', (done) -> 

            monitor = 
                dirs: 
                    add: (dir, match, ref) -> 
                        dir.should.equal 'app'
                        match.should.eql /\.js$/
                        ref.should.eql 'src'
                        done()
                        throw 'go no further' 

            @dev.opts.src.directory = 'app'
            @dev.opts.src.match     = /\.js$/
            @dev.opts.autocompile   = false
            try @dev.startMonitor monitor


        it 'calls handleCreatedSourceFile() on created source file', (done) -> 

            HANDLER = undefined
            monitor = 
                dirs: 
                    add: (dir, match, ref) -> 
                    on: (event, listener) -> 
                        if event == 'create'
                            HANDLER = listener

            @dev.startMonitor monitor

            @dev.handleCreatedSourceFile = -> done()

            HANDLER 'filename', {}, 'src'


        it 'calls handleDeletedSourceFile() on deleted source file', (done) -> 

            HANDLER = undefined
            monitor = 
                dirs: 
                    add: (dir, match, ref) -> 
                    on: (event, listener) -> 
                        if event == 'delete'
                            HANDLER = listener

            @dev.startMonitor monitor

            @dev.handleDeletedSourceFile = -> done()

            HANDLER 'filename', {}, 'src'


        it 'calls handleChangedSpecFile() on changed realizer', (done) ->

            HANDLER = undefined
            monitor = 
                dirs: 
                    add: (dir, match, ref) -> 
                    on: (event, listener) -> 
                        if event == 'change'
                            HANDLER = listener

            @dev.startMonitor monitor

            @dev.handleChangedSpecFile = ->                
                done()
                throw 'go no futher'

            try HANDLER 'filename', {}, 'realizer', {}

      
       it 'calls handleChangedSourceFile() and loads the realizer on changes source file', (done) ->

            HANDLER = undefined
            monitor = 
                dirs: 
                    add: (dir, match, ref) -> 
                    on: (event, listener) -> 
                        if event == 'change'
                            HANDLER = listener
                realizers:
                    get: -> 
                        then: (resolve) -> resolve 'MOCK_REALIZER'

            @dev.startMonitor monitor

            @dev.handleChangedSourceFile = (file, realizer) -> 
                realizer.should.equal 'MOCK_REALIZER'    
                done()
                throw 'go no futher'

            try HANDLER 'filename', {}, 'src', {}


    context 'handleCreatedSourceFile()', -> 

        it ''
            

    context 'toSpecFilename()', -> 

        it 'converts src filename to spec filename', (done) -> 

            specFile = @dev.toSpecFilename 'src/path/file_name.coffee'
            specFile.should.equal 'spec/path/file_name_spec.coffee'
            done()
