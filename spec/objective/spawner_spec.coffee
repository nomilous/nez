should         = require 'should'
SpawnerFactory = require '../../lib/objective/spawner'
Spawner        = undefined
ChildProcess   = require 'child_process'

describe 'Spawner', ->

    before (done) -> 

        mockOpts = 
            listening: 
                port: 22122

        mockMessageBus =
            use: (@middleware) =>  

        Spawner = SpawnerFactory.createClass mockOpts, mockMessageBus
        done()

    beforeEach -> 
        @spawn = ChildProcess.spawn

    afterEach ->
        ChildProcess.spawn = @spawn


    context 'spawn()', -> 

        it 'returns a promise', (done) -> 

            Spawner.spawn().then.should.be.an.instanceof Function
            done()


        it 'rejects if already spawned', (done) ->  

            Spawner.spawn( localPID: 12345 ).then( 

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


        it 'spawns the realizer runner', (done) -> 

            ChildProcess.spawn = (bin, args) -> 
                
                bin.should.match /bin\/realize/
                args.should.eql ['-c', '-p', 22122, '-X', 'path/to/realizer.coffee']
                done()

                pid: 12345
                stderr: on: ->
                stdout: on: ->
                on: -> 

            Spawner.spawn 
                source:
                    type: 'file'
                    filename: 'path/to/realizer.coffee'


        it 'resolves the promise on realizer::connect with connected realizer token and attached localPID', (done) -> 

            ChildProcess.spawn = (bin, args) -> 
                
                pid: 12345
                stderr: on: ->
                stdout: on: ->
                on: -> 

            Spawner.spawn(

                uuid: 'UUID'
                source:
                    type: 'file'
                    filename: 'path/to/realizer.coffee'
            
            ).then (token) -> 

                token.localPID.should.equal 12345
                done()

            process.nextTick =>

                #
                # fake realizer connecting with pid
                #

                @middleware 

                    context: title: 'realizer::connect'
                    uuid: 'UUID'
                    pid:  12345
                    ->


        it 'errors on spawn exit before connect', (done) -> 

            ChildProcess.spawn = (bin, args) -> 
                
                pid: 12345
                stderr: on: ->
                stdout: on: ->
                on: (childEvent, callback) -> 

                    #
                    # fake child exitting immediately on exit listener registration
                    #

                    if childEvent == 'exit'

                        exitcode   = 101
                        exitsignal = null
                        callback exitcode, exitsignal


            Spawner.spawn(

                uuid: 'UUID'
                source:
                    type: 'file'
                    filename: 'path/to/realizer.coffee'
            
            ).then( 

                (token) -> 
                (error) -> 
                    error.should.match /Realizer exited with code:101/
                    done()
            
            )


        it '"disconnects" on spawn exit after connect'
