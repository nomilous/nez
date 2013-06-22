should    = require 'should'
Realizers = require '../lib/realizers'

describe 'realizers', -> 

    realizers = Realizers()

    context 'get( opts )', -> 

        it 'requires a realizer id', (done) -> 

            try realizers.get()
            catch error 

                error.should.match /realizers.get\(opts, callback\) requires opts.id as the realizer id/
                done()


        it 'callback missing realizer if not present', (done) -> 

            realizers.get id: 'ID', (error, realizer) -> 

                error.should.match /missing realizer/
                done()


        context 'can spawn the realizer', -> 

            it 'if opts.script is specified', (done) -> 

                #
                # only coffee
                #

                realizers.get 

                    id: 'ID'
                    script: 'SCRIPT'
                    (error, realizer) -> done()

                