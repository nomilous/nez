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


    


    describe 'has an event emitter', ->

        before ->

            @stack = new Stack 'Title'

        it 'emits "start" and "push" events on first push', (done) ->

            ranStart = false
            ranPush = false
            @stack.once 'begin', -> ranStart = true
            @stack.once 'push', -> ranPush = true
            
            @stack.stacker 'pushing', ->
                ranStart.should.equal true
                ranPush.should.equal true
                done()


        it 'emits "end" and "pop" events on last pop', (done) ->

            ranPop = false
            ranEnd = false
            @stack.once 'pop', -> ranPop = true
            @stack.once 'end', -> ranEnd = true

            @stack.stacker 'pushing', ->

            ranPop.should.equal true
            ranEnd.should.equal true
            done()

        it 'emits only "push" and "pop" from child node', (done) ->

            @stack.stacker 'push1', () =>
                ranPush = false
                ranPop = false
                @stack.once 'push', -> ranPush = true
                @stack.once 'pop', -> ranPop = true

                @stack.stacker 'push2', () ->
                    ranPop.should.equal false
                    ranPush.should.equal true
                
                ranPop.should.equal true
                done()

        describe 'sends the node being "entered"', -> 

            it 'begin', (done) ->

                @stack.once 'begin', (placeholder, node) -> 
                    node.label.should.equal 'Label1'
                    done()
                @stack.stacker 'Label1', () ->

            it 'push', (done) ->

                @stack.once 'push', (placeholder, node) -> 
                    node.label.should.equal 'Label1'
                    done()
                @stack.stacker 'Label1', () ->


        describe 'sends the node being "exited"', ->


            it 'pop', (done) ->

                @stack.once 'pop', (placeholder, node) -> 
                    node.label.should.equal 'Label1'
                    done()
                @stack.stacker 'Label1', () ->


            it 'end', (done) ->

                @stack.once 'end', (placeholder, node) -> 
                    node.label.should.equal 'Label1'
                    done()
                @stack.stacker 'Label1', () ->

        describe 'edge event', ->

            it 'is emitted with each traversal from one node to another', (done) ->

                STACK = @stack
                @stack.on 'edge', (placeholder, nodes) ->
                    #
                    # exiting THREE?
                    #
                    if nodes.from.label == 'THREE'
                        #
                        # GOT thing in it?
                        #
                        nodes.from.stick.this.into.should.equal 'IT'
                        done()


                @stack.stacker 'ONE', (Parent) -> 
                    Parent 'TWO', (Child) -> 
                        Child 'THREE', (GrandChild) -> 
                            #
                            # PUT thing in it
                            #
                            STACK.node.stick = this: into: 'IT'

                


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

        it 'runs beforeAll hook immediately', (done) ->

            stack = new Stack 'stack'
            @ran = false
            stack.stacker beforeAll: => @ran = true
            stack.stacker 'into child node', =>
                @ran.should.equal true
                done()

        it 'runs afterAll hook immediately afterwards', (done) ->

            stack = new Stack 'stack'
            ran = 'not run yet'
            
            stack.stacker afterAll: -> 
                ran = 'has run now'

            stack.stacker 'into child node', ->
                console.log ran

            ran.should.equal 'has run now'
            done()

        it 'runs beforeEach on every ancestors edge', (done) ->

            stack = new Stack 'stack'
            ran = 0
            stack.stacker afterAll: -> ran++

            stack.stacker 'into child node', (child) ->
                child 'child', (grandchild) ->
                    grandchild 'grandchild', ->

            ran.should.equal 3
            done()



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


