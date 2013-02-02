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


    it 'keeps reference to failed expectations', (done) -> 

        #Nez.debug = true

        class TestExample8

            constructor: (@val) ->

            instanceMethod: (arg) ->

                #
                # call unimplemented function
                # 

                @unImplemented(arg * @val)


        eg = new TestExample8( 5 )
        eg.expectCall unImplemented: with: 555
        eg.instanceMethod 111

        #
        # Expectetions here should have been met
        #

        Nez.failedArray.length.should.equal 0
        test done





