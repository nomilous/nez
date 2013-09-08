should = require 'should'
Realizers = require( '../../lib/objective/realizers' ).createClass {}
spawner   = require '../../lib/objective/spawner'

describe 'Realizers', -> 

    before (done) -> 

        Realizers.update( 

            '/Objective Title/objective/spec/Spec title': 

                type: 'tree'
                uuid: '0'
                source:
                    type:     'file'
                    filename: 'path/to/realizer.coffee'

         ).then -> done()


    beforeEach -> 
        @spawn = spawner.spawn
        Realizers.autospawn = false

    afterEach ->
        spawner.spawn = @spawn

    it 'has autospawn option property', (done) -> 

        Realizers.autospawn.should.equal false
        done()

    context 'get()', -> 

        it 'returns a promise', (done) -> 

            Realizers.get().then.should.be.an.instanceof Function
            done()


        it 'autospawns the realizer if enabled', (done) -> 

            Realizers.autospawn = true

            spawner.spawn = (opts, token) -> 

                token.should.eql
                    type: 'tree'
                    uuid: '0'
                    source:
                        type:     'file'
                        filename: 'path/to/realizer.coffee'

                done()

            Realizers.get filename: 'path/to/realizer.coffee'


    context 'update(tokens)', -> 

        it 'returns a promise', (done) -> 

            Realizers.update( {} ).then.should.be.an.instanceof Function
            done()


        it 'loads boundry phrase tokens into the realizer reference collection', (done) -> 

            Realizers.update( 

                '/Objective Title/objective/spec/Spec title': 

                    type: 'tree'
                    uuid: '0'
                    source:
                        type:     'file'
                        filename: 'path/to/realizer.coffee'

             ).then -> 
                
                Realizers.get( 

                    filename: 'path/to/realizer.coffee' 

                ).then (realizer) -> 

                    realizer.token.uuid.should.equal '0'
                    done()
