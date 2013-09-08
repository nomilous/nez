should = require 'should'
Realizers = require '../../lib/objective/realizers'

describe 'Realizers', -> 

    it 'has autospawn option property', (done) -> 

        Realizers.autospawn.should.equal false
        done()

    context 'get()', -> 

        it 'returns a promise', (done) -> 

            Realizers.get().then.should.be.an.instanceof Function
            done()
