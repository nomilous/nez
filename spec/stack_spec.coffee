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

        it 'returns pusher(), a function', (done) -> 

            fn = Stack.create 'stack1'

            fn.should.be.an.instanceof Function
            done()




    describe 'pusher()', -> 




        it 'calls push() if received args', (done) -> 

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


        it 'calls end() if received no args', (done) -> 

            pusher = Stack.create 'stack1'
            stack  = Stack.get 'stack1'

            wasCalled = false
            originalFn = stack.end
            stack.end = -> wasCalled = true
            pusher()
            stack.end = originalFn

            wasCalled.should.equal true
            done()




    describe 'push()', -> 





        it 'pushes a new labeled node into the stack', (done) -> 

            design = Stack.create 'design'
            stack  = Stack.get 'design'
            design 'A thing'


            stack.stack[0].label.should.equal 'A thing'
            done()


        it 'stores a callback on the new node', (done) -> 

            design = Stack.create 'design'
            stack  = Stack.get 'design'
            callback = -> 
            design 'A thing', callback

            stack.stack[0].callback.should.equal callback
            done()





    describe 'end()', -> 





        it 'pops the top node from the stack', (done) -> 

            design = Stack.create 'design'
            stack  = Stack.get 'design'
            callback = -> 
            design 'A thing', callback

            stack.end()
            stack.stack.length.should.equal 0
            done()






