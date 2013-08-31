should    = require 'should'
Develop   = require '../../lib/defaults/develop'
Objective = require '../../lib/objective/objective' 

describe 'Develop', -> 

    before -> @dev = new Develop

    it 'is an Objective', (done) -> 

        @dev.should.be.an.instanceof Objective
        done()

    it 'configures phrase boundry signatures', (done) -> 

        @dev.configure ( opts = {} )

        opts.should.eql boundry: ['spec', 'test']
        done()

        #
        # TODO: allow breakout on configure
        #

    it 'handles phrase boundry assembly', (done) -> 

        @dev.onBoundry {}, -> done()