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


    it 'can be realized, and remember it', (done) -> 

        class Thing
        instance = new Thing()
        realization = new Realization( instance )

        arg1AsString   = 'functionArg1'
        arg2AsArray    = ['second','arg']
        arg3AsFunction = -> 'yummy coffee'

        realization.realize 'functionName', 1:arg1AsString, 2:arg2AsArray, 3:arg3AsFunction

        realization.functionName.should.equal 'functionName'
        realization.functionArgs.should.eql 

            1: arg1AsString
            2: arg2AsArray
            3: arg3AsFunction

        done()
