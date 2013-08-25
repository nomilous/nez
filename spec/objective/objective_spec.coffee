should    = require 'should'
objective = require '../../lib/objective/objective'
Phrase    = require 'phrase'
Notice    = require 'notice'

describe 'objective', -> 

    beforeEach -> 

        @noticeListen = Notice.listen
        @swap2 = Phrase.createRoot

    afterEach -> 

        Notice.listen     = @noticeListen
        Phrase.createRoot = @swap2


    context 'message bus', ->

        it 'starts a notice hub named "objective/{uuid}"', (done) -> 

            Notice.listen = (hubname, opts, linkFn) ->

                hubname.should.equal 'objective/2'
                done()
                throw 'go no further'

            try objective

                uuid: '2'


        it 'allows the hub to default the listen parameters', (done) -> 

            objectiveOpts = 
                title: 'title'
                uuid:  '2'

            #
            # restore Notice.listen to un-stubbed
            #

            Notice.listen = @noticeListen


            objective objectiveOpts, (end) -> 
            setTimeout (->
                
                #
                # using timeout to allow phrase to complete the walk
                # --------------------------------------------------
                # 
                # * otherwise it won't do another one
                # 
                # * hub appends opts with details of the listening server
                #   that it created
                #

                objectiveOpts.listening.transport.should.equal 'http'
                objectiveOpts.listening.address.should.equal   '127.0.0.1'
                should.exist objectiveOpts.listening.port 
                done()

            ), 10


        it 'can specify listen parameters', (done) -> 

            objectiveOpts = 

                title: 'title'
                uuid:  '2'
                listen: 
                    port:    10101
                    address: '0.0.0.0'

            Notice.listen = @noticeListen
            objective objectiveOpts, (end) -> 
            setTimeout (->
                
                objectiveOpts.listening.should.eql 

                    transport: 'http'
                    address:   '0.0.0.0'
                    port:      10101

                done()

            ), 10
            


    context 'phrase tree', ->

        before -> 

            @mockHub = {}

            Notice.listen = (hubname, opts, linkFn) =>

                linkFn null, @mockHub


        it 'creates a phrase tree', (done) -> 

            Phrase.createRoot = (opts) -> 

                opts.should.eql 
                    title: 'untitled'
                    uuid:  '0'

                done()
                
            try objective {}, ->


        it 'initializes the phrase tree with the objectiveFn', (done) -> 

            Phrase.createRoot = -> 

                #
                # mock rootRegistrar
                #

                (phraseFn) -> 

                    phraseFn.toString().should.match /theObjective/
                    done()


            objective {}, (requirement) -> 'theObjective'



        xit '...what lies down this road', (done) -> 


            objective 

                title:    'Some App or New Feature'
                uuid:     'uniqueness, for state / metric persistance'
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

