should    = require 'should'
Develop   = require '../../lib/defaults/develop'
Objective = require '../../lib/objective/objective' 

describe 'Develop', -> 

    before -> @dev = new Develop

    it 'is an Objective', (done) -> 

        @dev.should.be.an.instanceof Objective
        done()

    it 'allows async config of phrase opts', (done) -> 

        @dev.configure ( opts = {} ), -> 

            opts.should.eql boundry: ['spec', 'test']
            done()


    it 'handles phrase boundry assembly', (done) -> 

        @dev.onBoundry {}, -> done()