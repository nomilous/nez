should = require 'should'

Nez    = require '../src/nez'
test   = Nez.test


describe 'Nez', -> 


    it 'is French for "nose"', (knows) -> 

        knows()


    it 'is Flower for "hello"', (again) ->

        ('nez'[2] + 'nez'[1] + 'nez'[0]).should.equal(

            'zen' )& again() 


    allude = it

     
    allude 'to an hopefully', (improvedClarity) -> 

        'pince nez'.expectCall toPerchUponNose: for: improvedClarity()


    it 'creates Object.expectCall()', (done) -> 

        Object.expectCall.should.be.an.instanceof Function
        done()


    it 'returns an expectation validator (test())', (done) ->

        require('../src/nez').test.should.be.an.instanceof Function
        done() 


    it 'calls back with..', (Done) -> 

        test Done


    it 'enables setting expectations', (done) -> 

        class TextExample1

        TextExample1.expectCall methodName: with: 'arg'

        Nez.expectArray[0].functionName.should.equal 'methodName'
        Nez.expectArray[0].functionArgs[1].should.equal 'arg'
        test done


    it 'creates the function on the object', (done) -> 

        class TextExample2
        TextExample2.expectCall unImplementedFn: with: 'args'

        TextExample2.unImplementedFn.should.be.an.instanceof Function
        test done


    it 'removes the function after test()', (done) ->

      class TestExample3

      TestExample3.expectCall fn: with: 'args'
      
      test -> 

      should.not.exist TestExample3.fn
      done()


    it 'replaces functions that already exist', (done) -> 

        called = false
        class TestExample4
            @existingFn: (args) -> 
                called = true

        TestExample4.expectCall existingFn: with: 'args'
        TestExample4.existingFn('args')

        called.should.equal false
        test done


    xit 'can optionally still call the original function', (done) -> 


    it 'restores the original function', (done) -> 

        called = false
        class TestExample5
            @existingFn: (args) -> 
                called = true

        TestExample5.expectCall existingFn: with: 'args'

        TestExample5.existingFn('args')
        called.should.equal false       # original fn was not called
        test ->                         # restores original

        TestExample5.existingFn('args') # call original
        called.should.equal true        # original fn was called
        done()


    it 'resets on the expectation test', (done) -> 

        class TestExample6
        TestExample6.expectCall existingFn: with: 'args'
        TestExample6.existingFn 'args'

        test ->   # evaluate expectation and reset

        Nez.expectArray.length.should.equal 0
        Nez.calledArray.length.should.equal 0
        done()


    it 'keeps track of calls to the ex-spectated function', (done) -> 

        #Nez.debug = true

        class TestExample7

        TestExample7.expectCall func: with: 'arg'  # set expectation
        TestExample7.func('arg')                   # meet expectation

        Nez.calledArray[0].functionName.should.equal 'func'
        
        test done


    it 'keeps an index of expectations', (done) -> 

        #Nez.debug = true

        Object.expectCall functionName: with: "first call's arg"
        Object.expectCall functionInBetween: with: ''
        Object.expectCall functionName: with: "second call's arg"

        first = Nez.expectIndex.functionName[0]
        second = Nez.expectIndex.functionName[1]

        Nez.expectArray[first].functionArgs[1].should.equal "first call's arg"
        Nez.expectArray[second].functionArgs[1].should.equal "second call's arg"

        test done


    xit 'has BUG1 fixed properly', (done) -> 

        #
        # The call to expectCall is itself being registered as an
        # expectation... 
        # 
        # The problem is fixed 'symptomatically' but not 'rootcausally' 
        #


    it 'has BUG2 fixed properly', (done) -> 

        #Nez.debug = true

        eg = new Object()
        eg.expectCall complicatedActivity: with: 0: [4,3,2], 1: 'zero'
        eg.complicatedActivity [4,3,2], 'zero'

        test done



    describe 'keeps a failedArray of expectations', -> 

        class TestExample8

            constructor: (@val) ->

            passingInstanceMethod: (arg) ->
                #
                # call unimplemented function
                # 
                @unImplemented1(arg * @val)
                @unImplemented2('')

            failingInstanceMethod: (arg) -> 
                #
                # does not call unimplemented function
                #
                # @unImplemented1(arg * @val)



        it 'is empty when none fail', (done) -> 

            # Nez.debug = true

            eg = new TestExample8( 5 )
            eg.expectCall unImplemented1: with: 555
            eg.expectCall unImplemented2: with: ''
            
            eg.passingInstanceMethod 111
            test -> 

            Nez.failedArray.length.should.equal 0
            done()


        it 'has the expectations that were not realized', (done) -> 

            # Nez.debug = true

            eg = new TestExample8( 5 )
            eg.expectCall unImplemented1: with: 555
            eg.expectCall unImplemented2: with: ''
            
            eg.failingInstanceMethod 111
            test -> 

            Nez.failedArray.length.should.equal 2
            Nez.failedArray[0].type.should.equal 'Expectation'
            Nez.failedArray[1].type.should.equal 'Expectation'
            done()


        it 'has the realizations that were not expected', (done) -> 

            # Nez.debug = true

            eg = new TestExample8( 5 )
            eg.expectCall passingInstanceMethod: with: 5

            eg.passingInstanceMethod 5
            eg.passingInstanceMethod 5

            test -> 

            Nez.failedArray.length.should.equal 1
            Nez.failedArray[0].type.should.equal 'Realization'
            done()


        describe 'has the expectations that were incorrectly realized', ->

            
            it 'called "type" arg did not match expected', (done) -> 

                # Nez.debug = true

                eg = new TestExample8( 5 )
                eg.expectCall passingInstanceMethod: with: 5
                eg.passingInstanceMethod 'not five'

                test -> 

                Nez.failedArray.length.should.equal 1
                Nez.failedArray[0].type.should.equal 'Expectation'

                done()


            it 'called "object" arg did not match expected', (done) -> 

                eg = new TestExample8( 5 )
                eg.expectCall useThisArray: with: [3,2,1]

                eg.useThisArray [3,2,2]

                test -> 

                Nez.failedArray.length.should.equal 1
                Nez.failedArray[0].type.should.equal 'Expectation'
                Nez.failedArray[0].failed.should.equal 'Argument Mismatch'
                done()


            it 'called multiple args did not match expected', (done) -> 

                #Nez.debug = true

                eg = new TestExample8( 5 )
                eg.expectCall complicatedActivity: with: 1: [3,2,1], 2: 'zero'

                eg.complicatedActivity [4,3,2], 'zero'

                test ->

                Nez.failedArray.length.should.equal 1
                Nez.failedArray[0].failed.should.equal 'Argument Mismatch'

                done()


            describe 'allows matching only specific args', (done) -> 

                it 'with failure', (done) ->  

                    # Nez.debug = true

                    eg = new TestExample8( 5 )
                    eg.expectCall veryComplicatedActivity: with: 3:[3,2,1]
                    eg.veryComplicatedActivity {}, {}, {}, [3,2,1]
                    test -> 

                    Nez.failedArray.length.should.equal 1
                    done()

                it 'with successure', (done) ->

                    # Nez.debug = true

                    eg = new TestExample8( 5 )
                    eg.expectCall veryComplicatedActivity: with: 4:[3,2,1]
                    eg.veryComplicatedActivity {}, {}, {}, [3,2,1]
                    test -> 

                    Nez.failedArray.length.should.equal 0
                    done()


            #
            # There will be more...
            #


    describe 'raises AssertionError when', -> 


        xit 'expectated function calls were called too few times', (done) -> 


        xit 'expectated function calls were called too many times', (done) -> 


        xit 'expectated arguments were not received', (done) -> 





