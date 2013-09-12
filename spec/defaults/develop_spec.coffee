should    = require 'should'
Develop   = require '../../lib/defaults/develop'
Objective = require '../../lib/objective/objective'
mkdirp    = require 'mkdirp'
uuid      = require 'node-uuid'
fs        = require 'fs'

describe 'Develop', -> 

    beforeEach (done) -> 

        @lstat = fs.lstatSync
        mkdirp.sync = (dir) ->      # no, don't
        fs.writeFileSync = (file) ->  
        uuid.v1 = -> '00000000-0000-0000-0000-000000000000'

        @dev = new Develop
        @dev.configure {}, -> done()

    afterEach (done) -> 

        fs.lstatSync = @lstat
        #fw.writeFileSync = @writeFile
        done()

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

        context 'with autospec disabled', -> 

            it 'does nothing', (done) -> 

                fs.writeFileSync = -> 

                    throw 'should not run'

                @dev.opts.autospec = false
                @dev.handleCreatedSourceFile 'src/path/file_name.coffee'
                done()


        context 'with autospec enabled', -> 

            it 'tests for the presence of the spec file', (done) -> 

                fs.lstatSync = (file) -> 
                    file.should.equal 'spec/path/file_name_spec.coffee'
                    done()
                    throw 'go no further'

                try @dev.handleCreatedSourceFile 'src/path/file_name.coffee'

            it 'tests for the presence of the spec dir if no file', (done) -> 

                fs.lstatSync = (dir) -> 
                    throw errno: 34 if dir.match /coffee$/
                    dir.should.equal 'spec/path'
                    done()
                    throw 'go no further'

                try @dev.handleCreatedSourceFile 'src/path/file_name.coffee'


            it 'makes the spec dir if not present', (done) -> 

                mkdirp.sync = (dir) -> 
                    dir.should.equal 'spec/path'
                    done()

                @dev.handleCreatedSourceFile 'src/path/file_name.coffee'


            it 'makes the spec file', (done) -> 

                fs.writeFileSync = (file, data) -> 

                    file.should.equal 'spec/path/landing_gear_spec.coffee'
                    data.should.equal """
                        title: 'Landing Gear'
                        uuid:  '00000000-0000-0000-0000-000000000000'
                        realize: (context, LandingGear, should) -> 

                    """
                    done()

                @dev.handleCreatedSourceFile 'src/path/landing_gear.coffee'


    context 'toSpecFilename()', -> 

        it 'converts src filename to spec filename', (done) -> 

            specFile = @dev.toSpecFilename 'src/path/file_name.coffee'
            specFile.should.equal 'spec/path/file_name_spec.coffee'
            done()
