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


        objective {}, (requirements) -> 

            #
            # not going to implement the graph paths from
            # objective to specs via the requirements
            # 
            #  (dependancy maps, for client view, later)
            #

            'theObjective'











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

