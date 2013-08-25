should    = require 'should'
objective = require '../../lib/objective/objective'
phrase    = require 'phrase'

describe 'objective', -> 

    beforeEach -> 

        @swap = phrase.createRoot

    afterEach -> 

        phrase.createRoot = @swap

    it 'creates a phrase tree', (done) -> 

        phrase.createRoot = (opts) -> 

            opts.should.eql 
                title: 'untitled'
                uuid:  '0'

            done()
            throw 'go no further'
            
        try objective {}, ->


    it 'initializes the phrase tree with the objectiveFn', (done) -> 

        phrase.createRoot = -> 

            #
            # mock rootRegistrar
            #

            (phraseFn) -> 

                phraseFn.toString().should.match /theObjective/
                done()


        objective {}, (requirement) -> 'theObjective'



    it '...what lies down this road', (done) -> 


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

