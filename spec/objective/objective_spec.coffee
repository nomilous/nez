should    = require 'should'
Objective = require '../../lib/objective/objective'

describe 'Objective', -> 

    beforeEach -> 

        @objective = new Objective


    it 'is a class', (done) -> 

        @objective.should.be.an.instanceof Objective
        done()


    context 'startMonitor( opts, tokens, emitter )', -> 

        it 'throws undefined override', (done) -> 

            try @objective.startMonitor {}, {}, (token, args...) -> 

            catch error

                error.should.match /undefined override/
                done()

                