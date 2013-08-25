should    = require 'should'
objective = require '../../lib/objective/objective'
phrase    = require 'phrase'

describe 'objective', -> 

    it 'creates a phrase tree', (done) -> 

        swap = phrase.createRoot
        phrase.createRoot = (opts) -> 
            phrase.createRoot = swap

            opts.should.eql 
                title: 'untitled'
                uuid:  '0'

            done()
            
        objective {}, ->













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

