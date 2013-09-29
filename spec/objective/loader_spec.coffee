should           = require 'should'
Objective        = require '../../lib/objective/loader'
MonitorFactory   = require '../../lib/objective/monitor'
RealizersFactory = require '../../lib/objective/realizers'
Develop          = require '../../lib/defaults/develop'
Phrase           = require 'phrase'
Notice           = require 'notice'
fs               = require 'fs'

describe 'objective', -> 

    beforeEach -> 

        @noticeListen       = Notice.listen
        @phraseCreate       = Phrase.createRoot
        @onBoundry          = Develop.prototype.onBoundry
        @monitorFn          = MonitorFactory.createFunction
        

    afterEach -> 

        Notice.listen                 = @noticeListen
        Phrase.createRoot             = @phraseCreate
        Develop.prototype.onBoundry   = @onBoundry
        MonitorFactory.createFunction = @monitorFn
        
    context 'message bus', ->

        it 'starts a notice hub named "objective/{uuid}"', (done) -> 

            Notice.listen = (hubname, opts, linkFn) ->

                hubname.should.equal 'objective/2'
                done()
                

            try Objective
                title:       'title'
                uuid:        '2'
                description: 'description'


        it 'allows the hub to default the listen parameters', (done) -> 

            #
            # restore Notice.listen to un-stubbed
            #

            Notice.listen = @noticeListen

            Phrase.createRoot = (opts) ->

                #
                # notice hub appended listening details onto 
                # opts
                #

                opts.listening.transport.should.equal 'http'
                opts.listening.address.should.equal   '127.0.0.1'
                should.exist opts.listening.port 

                done()

                -> 


            Objective 

                title:       'title'
                uuid:        '2'
                description: 'description'

                (end) -> 

        it 'can specify listen parameters', (done) -> 

            Notice.listen = @noticeListen

            Phrase.createRoot = (opts) ->

                opts.listening.should.eql

                    transport: 'http'
                    address:   '0.0.0.0'
                    port:      10101

                done()

                -> 

            Objective 

                title:       'title'
                uuid:        '2'
                description: 'description'
                listen: 
                    port:    10101
                    address: '0.0.0.0'

                (end) -> 

    xcontext 'objective processor', ->

        it 'loads the default objective processor', (done) -> 

            Develop.prototype.startMonitor = -> 

                done()

            Objective 

                title:       'title'
                uuid:        '2'
                description: 'description'


    context 'phrase tree', ->

        before -> 

            @mockHub = use: ->

            Notice.listen = (hubname, opts, linkFn) =>

                linkFn null, @mockHub


        it 'creates a phrase tree', (done) -> 

            Phrase.createRoot = (opts) -> 

                console.log 'test final defaults'

                # opts.should.eql 
                #     title:       'untitled'
                #     uuid:        '0'
                #     description: 'description'
                #     relativePath: 'node_modules/mocha/lib'

                #     #
                #     # default objective sets boundry signature match
                #     #

                #     boundry:     ['spec']

                #     #
                #     # default objective sets src directory monitor opts
                #     #

                #     src: 
                #         directory: 'src'
                #         match: /\.coffee$/

                #     autospawn:   true
                #     autoload:    true
                #     autorun:     true
                #     autospec:    true
                #     autocompile: true

                done()

                -> 
                
            Objective 

                title:       'untitled'
                uuid:        '0'
                description: 'description'


        xit 'proxies the boundry phrase assembly into the objective', (done) ->

            Develop.prototype.onBoundry = (params, callback) -> 

                params.filename.should.match new RegExp __dirname
                done()

            Objective 

                title:       'untitled'
                uuid:        '0'
                description: 'description'

                (spec) -> spec.link directory: __dirname


        it 'monitors realizer directory for change and filters by link match', (done) -> 

            MonitorFactory.createFunction = -> 

                fn = (opts) -> 

                    fn.dirs.add opts.directory, opts.match, opts.ref

                fn.dirs = 
                    on: -> 
                    add: (dirname, match, ref) ->

                        dirname.should.equal './test/path'
                        match.should.eql /\.match$/
                        ref.should.equal 'realizer'
                        done()

                return fn


            Develop.prototype.startMonitor = (opts, monitors, jobTokens, jobEmitter) -> 

                monitors.dirs.on 'change', (filename) -> 

                    CHANGED.push filename
                    
            Phrase.createRoot = (opts, linkFn) => 
                linkFn( 
                    mockToken = 
                        on: (event, listener) -> 

                            #
                            # fake tree initialization complete
                            #

                            if event == 'ready' then process.nextTick -> 
                                listener walk: {}, tokens: {}
                    mockNotifier = 
                        use: (middleware) -> 
                            middleware
                                context: title: 'phrase::link:directory'
                                directory: './test/path'
                                match: /\.match$/
                                ->
                )
                ->

            Objective 

                title:       'untitled'
                uuid:        '0'
                description: 'description'


        xit 'rewalks the objective on created/deleted realizer files (realizers) and updates tokens into the Realizer collection'





        xit 'initializes the phrase tree with the objectiveFn', (done) -> 

            Phrase.createRoot = -> 

                #
                # mock rootRegistrar
                #

                (phraseString, phraseFn) -> 

                    phraseString.should.equal 'objective'
                    phraseFn.toString().should.match /the Objective phrase tree/     
                    done()

            Objective 

                title:       'untitled'
                uuid:        '0'
                description: 'description'

                (requirement) -> 

                    'the Objective phrase tree'

