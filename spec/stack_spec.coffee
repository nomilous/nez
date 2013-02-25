should = require 'should'
print  = require('prettyjson').render
Stack  = require '../lib/stack'

describe 'Stack', -> 

    describe 'is a eventEmitter', ->

        it 'allows assembling the tree in parallel'


    it 'has a root node', (done) ->

        stack = new Stack 'stack'
        stack.node.label.should.equal 'root'
        done()


    it 'has an event emitter', (thisFunctionRan) ->

        stack = new Stack 'stack'
        stack.once 'start', -> thisFunctionRan()
        stack.stacker 'pushing'


    describe 'stacker()', -> 

        it 'calls push() if received args', (done) -> 

            stack = new Stack 'stack'
            wasCalled = false
            originalFn = stack.push
            stack.push = -> wasCalled = true
            stack.stacker 'label'
            stack.push = originalFn

            wasCalled.should.equal true
            done()


    describe 'push()', -> 

        it 'pushes a new labeled node into the stack', (done) -> 

            stack  = new Stack 'design'
            stack.stacker 'A thing', -> 

                stack.stack[0].label.should.equal 'A thing'
                done()


        describe 'with function as second arg', ->



            it 'stores the function on the new node pushed into the stack', (done) -> 

                stack = new Stack 'stack'

                callback = -> 
                    stack.stack[0].callback.should.equal callback
                    done()

                stack.stacker 'A thing', callback


            it 'runs the function', (done) -> 

                stack = new Stack 'stack'
                stack.stacker 'A thing', -> 
                
                    done()


        it 'passes the pusher() as arg to the called function', (done) ->

            stack = new Stack 'stack'
            stacker = stack.stacker

            stack.stacker 'A thing', (arg) ->

                arg.should.equal stacker
                done()

        it 'enables access to the top node in the stack', (done) ->

            stack = new Stack 'stack'
            push = stack.stacker

            push 'label1', (again) ->
                again 'label2', (more) ->
                    more 'label3', (evenmore) ->
                    more 'label4'

                    stack.node.label.should.equal 'label2'
                    done()



    it 'it populates a stack', (done) -> 

        s = new Stack 'stack'
        design = s.stacker
        stack = s.stack
        
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

        s = new Stack 'design'
        design = s.stacker
        stack  = s.stack

        design 'A thing', -> 

            stack[0].class.should.equal 'design'
            stack[0].label.should.equal 'A thing'
            done()


    it "is uses the callback arg label for all other node class names", (done) ->

        s = new Stack 'design'
        design = s.stacker
        stack  = s.stack

        design 'A thing', (For) -> 

            For 'increasingly evident reasons', -> 

                stack[1].class.should.equal 'For'
                stack[1].label.should.equal 'increasingly evident reasons'
                done()


    describe 'the walker that', ->  

        it 'starts at the root of the tree', (done) ->

            s = new Stack 'design'
            design = s.stacker
            tree   = s.tree
            walker = s.walker

            tree.should.be.an.instanceof Array
            tree.should.eql walker
            done()


        xit 'walks when pushed, placing nodes into the tree', (done) -> 

            s = new Stack 'design'
            design = s.stacker
            tree   = s.tree
            walker = s.walker

            design 'A thing', (With) -> 
                With 'child1', (one) -> 
                    one '1'
                With 'child2', (two) -> 
                    two()

            tree[0].edges[0].class.should.equal 'With'
            tree[0].edges[0].label.should.equal 'child1'

            tree[0].edges[0].edges[0].class.should.equal 'one'
            tree[0].edges[0].edges[0].label.should.equal '1'

            tree[0].edges[1].class.should.equal 'With'
            tree[0].edges[1].label.should.equal 'child2'

            done()

    describe 'validator()', ->

        it 'validates the stack when called', (done) ->

            s = new Stack 'Implement'
            implement    = s.stacker
            validate  = s.validator
            stack  = s.stack

            implement 'a thing', (For) ->
                For 'a reason', (reason) ->
                    validate reason
                    done()


