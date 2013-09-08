should         = require 'should'
SpawnerFactory = require '../../lib/objective/spawner'
Spawner        = undefined

describe 'Spawner', ->

    before (done) -> 

        Spawner = SpawnerFactory.createClass {}, use: ->
        done()

    context 'spawn()', -> 

        it 'returns a promise', (done) -> 

            Spawner.spawn().then.should.be.an.instanceof Function
            done()


        it 'rejects if already spawned', (done) ->  

            Spawner.spawn( pid: 12345 ).then( 

                ->
                -> 
                    arguments[0].should.match /Already running realizer at pid: 12345/
                    done()

            )


        it 'rejects if token source is not file', (done) -> 

            Spawner.spawn(

                source: 
                    type:   'device'
                    device: '/dev/realizers/RL1'

            ).then( 

                ->
                -> 
                    arguments[0].should.match /Realizer can only spawn local source/
                    done()

            )

        it ''
