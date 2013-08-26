should    = require 'should'
Objective = require '../../lib/objective/objective'

describe 'Objective', -> 

    beforeEach -> 

        @objective = new Objective


    it 'is a class', (done) -> 

        @objective.should.be.an.instanceof Objective
        done()

