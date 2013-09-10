should = require 'should'
Realizers = undefined 
spawner   = undefined

describe 'Realizers', -> 

    beforeEach (done) -> 

        @MIDDLEWARES = []

        Realizers = require( '../../lib/objective/realizers' ).createClass(
            {} 
            use: (middleware) => @MIDDLEWARES.push middleware
        )


        Realizers.update( 

            '/Objective Title/objective/spec/Spec title': 

                type: 'tree'
                uuid: '1'
                source:
                    type:     'file'
                    filename: 'path/to/realizer1.coffee'

            '/Objective Title/objective/spec/Another spec title': 

                type: 'tree'
                uuid: '2'
                localPID: 54321
                source:
                    type:     'file'
                    filename: 'path/to/realizer2.coffee'

         ).then -> 

            Realizers.autospawn = false
            spawner = Realizers.spawner
            done()

    afterEach ->
        #spawner.spawn = @spawn

    it 'has autospawn option property', (done) -> 

        Realizers.autospawn.should.equal false
        done()


    it 'assigns realizer responce notifiers into collection', (done) -> 

        @MIDDLEWARES[0]

            context: 
                title: 'realizer::connect'
                responder: 'REALIZER_BOUND_MESSAGE_BUS'
            uuid: 'UUID'
            ->

                Realizers.get( uuid: 'UUID' ).then (realizer) -> 

                    realizer.notice.should.equal 'REALIZER_BOUND_MESSAGE_BUS'
                    done()


    context 'get()', -> 

        it 'returns a promise', (done) -> 

            Realizers.get().then.should.be.an.instanceof Function
            done()


        it 'autospawns the realizer if enabled', (done) -> 

            Realizers.autospawn = true

            spawner.spawn = (token) -> 

                token.should.eql
                    type: 'tree'
                    uuid: '1'
                    source:
                        type:     'file'
                        filename: 'path/to/realizer1.coffee'

                done()
                then: ->

            Realizers.get filename: 'path/to/realizer1.coffee'


        it 'resolves with already spawned realizers', (done) -> 

            Realizers.autospawn = true
            spawner.spawn = -> throw 'should not run'

            Realizers.get( filename: 'path/to/realizer2.coffee' ).then(

                (realizer) -> 

                    realizer.token.uuid.should.equal '2'
                    done()


                (error)    -> console.log REALIZERS_SPEC_ERROR_1: error.stack

            )


    context 'update(tokens)', -> 

        it 'returns a promise', (done) -> 

            Realizers.update( {} ).then.should.be.an.instanceof Function
            done()


        it 'loads boundry phrase tokens into the realizer reference collection', (done) -> 

            Realizers.update( 

                '/Objective Title/objective/spec/Spec title': 

                    type: 'tree'
                    uuid: '1'
                    source:
                        type:     'file'
                        filename: 'path/to/realizer1.coffee'

             ).then -> 
                
                Realizers.get( 

                    filename: 'path/to/realizer1.coffee' 

                ).then (realizer) -> 

                    realizer.token.uuid.should.equal '1'
                    done()
