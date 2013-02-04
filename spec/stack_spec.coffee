should = require 'should' 
Stack  = require '../src/stack'

describe 'Stack', -> 

    it 'can create multiple stacks', (done) -> 

        Stack.create 'stack1'
        Stack.create 'stack2'

        Stack.get('stack1').className.should.equal 'Stack'
        Stack.get('stack1').className.should.equal 'Stack'
        Stack.get('stack1').should.eql Stack.stacks['stack1']
        Stack.get('stack2').should.eql Stack.stacks['stack2']
        done()


    describe 'create()', -> 

        it 'returns a function', (done) -> 

            fn = Stack.create 'stack1'

            fn.should.be.an.instanceof Function
            done()

        it 'returns a function that pushes the stack', (done) -> 

            pusher = Stack.create 'stack1'
            stack  = Stack.get 'stack1'

            # 
            # temp swap push() to spy 
            # 
            wasCalled = false
            originalFn = stack.push
            stack.push = -> wasCalled = true
            #
            # was push() called?
            #
            pusher 'label'
            stack.push = originalFn

            wasCalled.should.equal true
            done()

        it 'calls end() if pushed without args', (done) -> 

            pusher = Stack.create 'stack1'
            stack  = Stack.get 'stack1'

            wasCalled = false
            originalFn = stack.end
            stack.end = -> wasCalled = true
            pusher()
            stack.end = originalFn

            wasCalled.should.equal true
            done()

