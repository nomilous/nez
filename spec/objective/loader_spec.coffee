should    = require 'should'
Objective = require '../../lib/objective/loader'
Realizers = require '../../lib/realization/realizers'
Develop   = require '../../lib/defaults/develop'
Phrase    = require 'phrase'
Notice    = require 'notice'
Hound     = require 'hound'
fs        = require 'fs'

describe 'objective', -> 

    beforeEach -> 

        @noticeListen       = Notice.listen
        @phraseCreate       = Phrase.createRoot
        @onBoundry          = Develop.prototype.onBoundry
        @watch              = Hound.watch

    afterEach -> 

        Notice.listen               = @noticeListen
        Phrase.createRoot           = @phraseCreate
        Develop.prototype.onBoundry = @onBoundry
        Hound.watch                 = @watch
        
    xcontext 'message bus', ->

        it 'starts a notice hub named "objective/{uuid}"', (done) -> 

            Notice.listen = (hubname, opts, linkFn) ->

                hubname.should.equal 'objective/2'
                done()
                

            try Objective
                title:       'title'
                uuid:        '2'
                description: 'description'


        it 'allows the hub to default the listen parameters', (done) -> 

            objectiveOpts = 
                

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

                -> done()


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

                -> done()

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


        xit 'creates a phrase tree', (done) -> 

            Phrase.createRoot = (opts) -> 

                opts.should.eql 
                    title:       'untitled'
                    uuid:        '0'
                    description: 'description'

                    #
                    # default objective sets boundry signatire match
                    #

                    boundry:     ['spec', 'test']

                -> done()
                
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


        xit 'starts a file monitor on each linked directory', (done) -> 

            Hound.watch = (directory) ->

                directory.should.equal './test/path'
                done()

            Phrase.createRoot = (opts, linkFn) => 

                linkFn( 
                    mockToken    = on: ->
                    mockNotifier = 
                        use: (middleware) -> 
                            middleware
                                context: title: 'phrase::link:directory'
                                directory: './test/path'
                                ->
                )
                ->


            Objective 

                title:       'untitled'
                uuid:        '0'
                description: 'description'


        it 'filters changes according to the linked directory match (regex)'


        xit 'does not re-watch already watched directories', (done) -> 

            #
            # um... (pass)
            #

            WATCHED = []

            Hound.watch = (directory) ->

                WATCHED.push directory

            Phrase.createRoot = (opts, linkFn) => 

                linkFn( 
                    mockToken    = on: ->
                    mockNotifier = 
                        use: (middleware) -> 

                            middleware
                                context: title: 'phrase::link:directory'
                                directory: './test/path'
                                ->
                            middleware
                                context: title: 'phrase::link:directory'
                                directory: './test/path2'
                                ->
                            middleware
                                context: title: 'phrase::link:directory'
                                directory: './test/path/um/no'
                                ->

                )
                ->
                    WATCHED.should.eql [
                        './test/path'
                        './test/path2'
                    ]

            Objective 

                title:       'untitled'
                uuid:        '0'
                description: 'description'



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

    

    # context 'realizers collection', -> 

    #     it "is created with the hub messenger and the objective phrase tree's token and bus", (done) -> 

    #         Realizers.createCollection = (opts, realizerHub, objectiveToken, objectiveNotice) ->

    #             opts.should.eql 
    #                 title:       'Title'
    #                 uuid:        '00000000-0700-0000-0000-fffffffffff0'
    #                 description: 'description'

    #             realizerHub.should.equal        'MOCK_REALIZER_HUB'
    #             objectiveToken.should.equal     'MOCK TOKEN'
    #             objectiveNotice.should.equal    'MOCK NOTIFIER'

    #             done()


    #         Notice.listen = (hubname, opts, linkFn) ->
    #             linkFn null, 'MOCK_REALIZER_HUB'

    #         Phrase.createRoot = (opts, linkFn) -> 
    #             linkFn 'MOCK TOKEN', 'MOCK NOTIFIER'
    #             ->

            
    #         Objective

    #             title:       'Title'
    #             uuid:        '00000000-0700-0000-0000-fffffffffff0'
    #             description: 'description'




# should    = require 'should'
# objective = require '../../lib/objective/objective'
# notice    = require 'notice'
# eo        = require 'eo'

# notice.listen = (hubName, opts, cb) -> cb()

# describe 'objective', -> 

    # it 'starts a notice hub listening for realizers', (done) -> 

        # notice.listen = (hubName, opts, cb) -> done()
        # objective 'title', description: 'd', ->


    # it 'attaches tools onto the context', (done) -> 

        # notice.listen = (hubName, opts, cb) -> 
            # opts.tools.should.equal require '../../lib/tools'
            # done()

        # objective 'title', description: 'd', -> 

