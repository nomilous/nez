should = require 'should'
print  = require('prettyjson').render
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


    describe 'push()', -> 





        it 'pushes a new labeled node into the stack', (done) -> 

            design = Stack.create 'design'
            stack  = Stack.get 'design'
            design 'A thing', -> 

                stack.stack[0].label.should.equal 'A thing'
                done()


        it 'stores a callback on the new node', (done) -> 

            design = Stack.create 'design'
            stack  = Stack.get 'design'

            callback = -> 
                stack.stack[0].callback.should.equal callback
                done()

            design 'A thing', callback

                

        it "creates a place for the node's children", (done) -> 

            design = Stack.create 'design'
            stack  = Stack.get 'design'

            callback = -> 
                stack.stack[0].children.should.be.an.instanceof Array
                done()

            design 'A thing', callback


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

        leaf = -> 

            stack[0].label.should.equal 'A thing'
            stack[1].label.should.equal 'uses a callback chain'
            stack[2].label.should.equal 'build a stack'
            stack[3].label.should.equal 'having the push() _BE_ the callback()'
            stack[4].label.should.equal 'immediate execution!'
            done()


        design 'A thing', (that) -> 
            that 'uses a callback chain', (to) -> 
                to 'build a stack', (By) -> 
                    By 'having the push() _BE_ the callback()', (For) ->
                        For 'immediate execution!', -> 
                            leaf()
        

    it 'uses the stack name as the root node class name', (done) -> 

        design = Stack.create 'design'
        stack  = Stack.get('design').stack

        design 'A thing', -> 

            stack[0].class.should.equal 'design'
            stack[0].label.should.equal 'A thing'
            done()


    it "is uses the callback arg label for all other node class names", (done) ->

        design = Stack.create 'design'
        stack  = Stack.get('design').stack


        design 'A thing', (For) -> 

            For 'increasingly evident reasons', -> 

                stack[1].class.should.equal 'For'
                stack[1].label.should.equal 'increasingly evident reasons'
                done()


    describe 'the walker that', ->  

        it 'starts at the root of the tree', (done) ->

            design = Stack.create 'design'
            walker = Stack.get('design').walker
            tree   = Stack.get('design').tree

            tree.should.be.an.instanceof Array
            tree.should.eql walker
            done()


        it 'walks when pushed, placing nodes into the tree', (done) -> 

            design = Stack.create 'design'
            tree   = Stack.get('design').tree   

            design 'A thing', (With) -> 
                With 'child1', (one) -> 
                    one '1'
                With 'child2', (two) -> 
                    two()

            #console.log print Stack.get('design').tree

            tree[0].children[0].class.should.equal 'With'
            tree[0].children[0].label.should.equal 'child1'

            tree[0].children[0].children[0].class.should.equal 'one'
            tree[0].children[0].children[0].label.should.equal '1'

            tree[0].children[1].class.should.equal 'With'
            tree[0].children[1].label.should.equal 'child2'


            done()






