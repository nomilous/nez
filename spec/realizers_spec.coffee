should    = require 'should'
realizers = require '../lib/realizers'

describe 'realizers', -> 

    context 'get( opts )', -> 

        it 'requires a realizer id', (done) -> 

            try realizers.get()
            catch error 

                error.should.match /realizers.get\(opts, callback\) opts.id as the realizer id/
                done()


        it 'callback missing realizer if not present', (done) -> 

            realizers.get id: 'ID', (error, realizer) -> 

                error.should.match /missing realizer/
                done()


        
