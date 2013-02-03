should      = require 'should' 
Realization = require '../src/realization'

describe 'Realization', -> 

    it 'potentially Realizes an Expectation into a...', (Confirmation) -> 

        Confirmation()


    it 'contains the object upon which an Expectation has been placed', (done) -> 

        class Thing
        instance = new Thing()
        realization = new Realization( instance )

        realization.object.should.equal instance
        done()


    describe 'create an interface to Realization ', -> 

        beforeEach -> 

            class Thing
            @instance = new Thing()
            

        describe 'as function', ->
        
            it 'can be a Mock/Double'
            it 'can be a Spy'


        describe 'as Property', -> 

            xit 'can be a Mock/Double'
            xit 'can be a Spy'


    describe 'can be realized', -> 

        before -> 

            class Thing
            @instance = new Thing()
            @realization = new Realization( @instance )


        it 'remembers the realization', (done) -> 

            arg1AsString   = 'functionArg1'
            arg2AsArray    = ['second','arg']
            arg3AsFunction = -> 'yummy coffee'

            @realization.realize 1:arg1AsString, 2:arg2AsArray, 3:arg3AsFunction

            @realization.functionArgs.should.eql 

                1: arg1AsString
                2: arg2AsArray
                3: arg3AsFunction

            done()
