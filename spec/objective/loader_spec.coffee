should    = require 'should'
Objective = require '../../lib/objective/loader'
Realizers = require '../../lib/realization/realizers'
Develop   = require '../../lib/defaults/develop'
Phrase    = require 'phrase'
Notice    = require 'notice'

describe 'objective', -> 

    beforeEach -> 

        @noticeListen       = Notice.listen
        @phraseCreate       = Phrase.createRoot
        @onBoundry          = Develop.prototype.onBoundry 

    afterEach -> 

        Notice.listen               = @noticeListen
        Phrase.createRoot           = @phraseCreate
        Develop.prototype.onBoundry = @onBoundry
        
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

    context 'objective processor', ->

        xit 'loads the default objective processor', (done) -> 

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


        it 'proxies the boundry phrase assembly into the objective', (done) ->

            Develop.prototype.onBoundry = (params, callback) -> 

                params.filename.should.match new RegExp __dirname
                done()

            Objective 

                title:       'untitled'
                uuid:        '0'
                description: 'description'

                (spec) -> spec.link directory: __dirname


        it 'initializes the phrase tree with the objectiveFn', (done) -> 

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



        it '...what lies down this road', (done) -> 


            Objective 

                title:       'Some App or New Feature'
                uuid:        'uniqueness, for state / metric persistance'
                description: 'description'

                edge:     ['specs']

                (requirement) -> 

                    # 
                    # requirement.link
                    # 
                    #     #
                    #     # recurse user stories directory
                    #     # attaching each to this PhraseNode
                    #     #  
                    # 
                    #     directory: './stories'
                    # 
                    # 

                    requirement 'login', 

                        as:   'system user'
                        to:   'login'
                        uuid: 'again with the persistable-ness'

                        (need) -> 
                            
                            need 'a login form', (specs) -> 
                            need 'other things that have understandable meaning to customers', (specs) ->
                            need '...', (specs) -> 

                                #
                                # each user story mapping to the code specs 
                                # upon which they depend, so...
                                #

                                specs.link file: './spec/app/model/user'
                                specs.link file: './spec/app/server'
                                specs.link file: './.....'

                                #
                                # ...so  that the advance of dev progress through 
                                #        the specs can be reduced to something as 
                                #        simple as a progress bar per user story.
                                # 
                                #               (to keep customers happy)
                                # 


                            done()

                    #
                    # or something like that...
                    #

    

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

