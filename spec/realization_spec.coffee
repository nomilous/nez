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
                existingFunction: (arg1, arg2) -> 
                    "-> #{arg1},#{arg2} <-"

            @thing = new Thing()


        describe 'as function that', ->


            it 'is actually created', (done) ->

                r = new Realization @thing
                r.createFunction 'newFunction'

                @thing.newFunction.should.be.an.instanceof Function 

                #
                # it keeps record of the called args
                # 

                fn = -> 
                    "function as argument"


                @thing.newFunction 'a', 42, ['b','c'], {d: 'EFG'}, fn

                r.realized.args.should.eql 

                    1: 'a'
                    2: 42
                    3: ['b','c']
                    4: {d: 'EFG'}
                    5: fn

                done()

            it 'sets type', (done) -> 

                r = new Realization @thing
                r.createFunction 'newFunction'

                r.type.should.equal 'function'
                done()

        
            it 'can be a Mock/Double', (done) -> 

                #
                # overrides the original function and 
                # returns as specified 
                #

                r = new Realization @thing
                r.createFunction 'existingFunction', returns: 'this'

                @thing.existingFunction('alpha','omega').should.equal 'this'

                r.realized.args.should.eql 

                    1: 'alpha', 
                    2: 'omega'

                done()


            it 'can be a Spy', (done) -> 

                #
                # calls the original function and 
                # returns whatever it returns
                # 

                r = new Realization @thing
                r.createFunction 'existingFunction'

                @thing.existingFunction('alpha','omega').should.equal '-> alpha,omega <-'

                r.realized.args.should.eql 

                    1: 'alpha', 
                    2: 'omega'

                done()




        describe 'as Property', -> 

            it 'sets type', (done) -> 

                r = new Realization @thing
                r.createProperty 'name'

                r.type.should.equal 'property'
                done()


            xit 'can be a Mock/Double'
            xit 'can be a Spy'


    describe 'can be realized', -> 

        before -> 

            class Thing
            @instance = new Thing()
            @realization = new Realization( @instance )


        it 'remembers the realization, stores the args in a 1 based Hrray', (done) -> 

            arg1AsString   = 'functionArg1'
            arg2AsArray    = ['second','arg']
            arg3AsFunction = -> 'yummy coffee'

            @realization.realize 0:arg1AsString, 1:arg2AsArray, 2:arg3AsFunction

            @realization.realized.args.should.eql 

                1: arg1AsString
                2: arg2AsArray
                3: arg3AsFunction

            done()


