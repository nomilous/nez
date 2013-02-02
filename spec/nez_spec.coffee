should = require 'should'

Nez    = require '../src/nez'
test   = Nez.test


describe 'Nez', -> 


    it 'is French for nose', (knows) -> 

        knows()


    it 'is actually', (because) ->

        ('nez'[2] + 'nez'[1] + 'nez'[0]).should.equal 'zen'
        because()


    it 'alludes to an hopefully', (improvedClarity) -> 

        'pince nez'.expectCall toPerchUponNose: for: improvedClarity()


    it 'creates Object.expect()', (done) -> 

        Object.expectCall.should.be.an.instanceof Function
        done()


    it 'returns a function when required', (done) ->

        test.should.be.an.instanceof Function
        done() 


    it 'calls back', (done) -> 

        test done


    it 'enables setting expectations', (done) -> 

        class TextExample1

        TextExample1.expectCall methodName: with: 'arg'

        Nez.expectArray[0].functionName.should.equal 'methodName'
        Nez.expectArray[0].functionArgs.with.should.equal 'arg'
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


    it 'replaces functions that already exists', (done) -> 

        called = false
        class TestExample4
            @existingFn: (args) -> 
                called = true

        TestExample4.expectCall existingFn: with: 'args'
        TestExample4.existingFn('args')

        called.should.equal false
        test done


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

        Nez.expectArray[first].functionArgs.with.should.equal "first call's arg"
        Nez.expectArray[second].functionArgs.with.should.equal "second call's arg"

        done()

    xit 'has BUG1 fixed properly', (done) -> 

        #
        # The call to expectCall is itself being registered as an
        # expectation... 
        # 
        # The problem is fixed 'symptomatically' but not 'rootcausally' 
        #


    describe 'keeps a failedArray of expectations', -> 

        class TestExample8

            constructor: (@val) ->

            passingInstanceMethod: (arg) ->
                #
                # call unimplemented function
                # 
                @unImplemented(arg * @val)

            failingInstanceMethod: (arg) -> 
                #
                # does not call unimplemented function
                #
                # @unImplemented(arg * @val)



        it 'is empty when none fail', (done) -> 

            # Nez.debug = true

            eg = new TestExample8( 5 )
            eg.expectCall unImplemented: with: 555
            
            eg.passingInstanceMethod 111

            Nez.failedArray.length.should.equal 0
            test done


        xit 'has the fail exception', (done) -> 

            #Nez.debug = true

            eg = new TestExample8( 5 )
            eg.expectCall unImplemented: with: 555
            
            eg.failingInstanceMethod 111

            Nez.failedArray.length.should.equal 1
            test done



    describe 'raises AssertionError when', -> 


        xit 'expected function calls are not made', (done) -> 


        xit 'expected arguments are not received', (done) -> 





