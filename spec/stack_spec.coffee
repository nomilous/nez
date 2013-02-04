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


        it 'runs the callback', (done) -> 

            design = Stack.create 'design'
            stack  = Stack.get 'design'

            #
            #   my best line of code...
            #

            design 'A thing', -> done()

            #
            #   ,ever!
            #




    describe 'end()', -> 





        xit 'pops the top node from the stack', (done) -> 

            design = Stack.create 'design'
            stack  = Stack.get 'design'
            callback = -> 
            design 'A thing', callback

            stack.end()
            stack.stack.length.should.equal 0
            done()


        xit "passes stack.pusher() to the popped node's callback", (done) -> 

            design = Stack.create 'design'
            stack  = Stack.get 'design'

            #
            # design is a reference to stack.pusher()
            #

            design 'A thing', (that) -> 

                that.should.equal design
                done()

            stack.end()


    it 'builds a stack', (done) -> 

        design = Stack.create 'design'
        stack  = Stack.get('design').stack

        design 'A thing', (that) -> 
            that 'uses a callback chain', (to) -> 
                to 'build a stack', (By) -> 
                    By 'handing the push() into the callback()', (For) ->
                        For 'immediate execution!'


        stack[0].label.should.equal 'A thing'
        stack[1].label.should.equal 'uses a callback chain'
        stack[2].label.should.equal 'build a stack'
        stack[3].label.should.equal 'handing the push() into the callback()'
        stack[4].label.should.equal 'immediate execution!'

        done()

    it 'uses the stack name as the root node class name', (done) -> 

        design = Stack.create 'design'
        stack  = Stack.get('design').stack

        design 'A thing'

        stack[0].class.should.equal 'design'
        stack[0].label.should.equal 'A thing'
        done()


    it "is uses the callback arg label for all other node class names", (done) ->

        design = Stack.create 'design'
        stack  = Stack.get('design').stack


        design 'A thing', (For) -> 

            For 'increasingly evident reasons'


        stack[1].class.should.equal 'For'
        stack[1].label.should.equal 'increasingly evident reasons'
        done()



