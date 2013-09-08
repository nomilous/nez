should = require 'should'
Realizers = require '../../lib/objective/realizers'

describe 'Realizers', -> 

    context 'get()', -> 

        it 'returns a promise', (done) -> 

            Realizers.get().then.should.be.an.instanceof Function
            done()
