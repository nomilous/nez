should  = require 'should'
print   = require('prettyjson').render
Stack   = require '../lib/stack'
Plugins = require '../lib//plugin_register'

describe 'Stack', -> 

    

    it 'has a root node', (done) ->

        stack = new Stack label: 'LABEL1'
        stack.node.label.should.equal 'root'
        done()


    describe 'has an event emitter', ->

        describe 'start event', -> 

            it 'is emitted once as the walker enters the branch', (done) ->

                begun = false
                test = new Stack label: 'STACK1'
                test.on 'enter', (error, stack) -> 
                    should.not.exist error
                    begun.should.equal false
                    stack.label.should.equal 'STACK1'
                    stack.stack.length.should.equal 0
                    done()

                test.stacker 'one', (two) -> 
                    begun = true
                    two 'two', (three) ->

        describe 'end event', -> 

            it 'is emitted once as the walker exits the stack', (done) -> 

                begun = false
                test = new Stack label: 'STACK2'
                test.on 'exit', (error, stack) -> 
                    should.not.exist error
                    begun.should.equal true
                    stack.label.should.equal 'STACK2'
                    stack.stack.length.should.equal 0
                    done()

                test.stacker 'one', (two) -> 
                    two 'two', (three) ->
                    begun = true

            it 'is emitted once if an exception is raised in the stack', (done) -> 

                begun = false
                test = new Stack label: 'STACK3'
                test.on 'exit', (error, stack) -> 
                    error.should.match /ERROR/
                    stack.stack.length.should.equal 2
                    done()

                test.stacker 'one', (two) -> 
                    two 'two', (three) ->
                        throw new Error 'ERROR'

        describe 'edge event', ->

            it 'is emitted with each traversal from one node to another', (done) ->

                stack = new Stack label: 'LABEL2'
                STACK = stack
                stack.on 'tree:traverse', (traversal) ->
                    #
                    # exiting THREE?
                    #
                    if traversal.from.label == 'THREE'
                        #
                        # GOT thing in it?
                        #
                        traversal.from.stick.this.into.should.equal 'IT'
                        done()     


                stack.stacker 'ONE', (Parent) -> 
                    Parent 'TWO', (Child) -> 
                        Child 'THREE', (GrandChild) -> 
                            #
                            # PUT thing in it
                            #
                            STACK.node.stick = this: into: 'IT'

                


    xdescribe 'stacker()', -> 

        it 'calls push() if received args', (done) -> 

            wasCalled = false
            originalFn = stack.push
            stack.push = -> wasCalled = true
            stack.stacker 'label'
            stack.push = originalFn

            wasCalled.should.equal true
            done()


    xit 'hands the new node through each registered plugin', (done) -> 

        stack.stacker 'parent', (CLASS) ->

            swap = Plugins.handle
            Plugins.handle = (node) -> 
                Plugins.handle = swap
                node.class.should.equal 'CLASS'
                node.label.should.eql 'LABEL'
                done()

            CLASS 'LABEL', (next) ->
        

    xdescribe 'ancestorsOf()', ->

        it 'get all ancestors of a node', (done) -> 

            stack.stacker 'label1', (child) ->
                child 'label2', (child) ->
                    child 'label3', ->
                        a = stack.ancestorsOf stack.stack[3]
                        a.should.eql [
                            stack.stack[0]
                            stack.stack[1]
                            stack.stack[2]
                        ]
                        done()

    xdescribe 'validate()', -> 

        it 'calls onward to ActiveNode.plugin.validate supplying entire stack', (done) -> 

            test = new Stack label: 'LABEL'

            finalCall = (Done) -> test.validate Done

            test.activeNode.plugin = 

                validate: (STACK, error) ->

                    STACK[0].label.should.equal 'LABEL'
                    STACK[1].label.should.equal 'Sub LABEL'
                    STACK[1].class.should.equal 'Class'
                    STACK[1].function.should.equal finalCall
                    done()

            test.stacker 'LABEL', (Class) -> 

                Class 'Sub LABEL', finalCall



    xdescribe 'push()', -> 



        xit 'attaches refence to the stack onto the node', (done) ->

            stack = new Stack label: 'LABEL'

            stack.stacker 'into child node', ->
                node = stack.stack[0]
                node.stack.should.equal stack
                done()


        it 'pushes a new labeled node into the stack', (done) -> 

            stack.stacker 'A thing', (With) -> 

                stack.stack[0].label.should.equal 'A thing'
                done()


        describe 'with function as second arg', ->

            it 'stores the function on the new node pushed into the stack', (done) -> 

                callback = -> 
                    stack.stack[0].function.should.equal callback
                    done()

                stack.stacker 'A thing', callback


            it 'runs the function', (done) -> 

                
                stack.stacker 'A thing', -> 
                
                    done()


        it 'passes the pusher() as arg to the called function', (done) ->

            stacker = stack.stacker

            stack.stacker 'A thing', (arg) ->

                arg.should.equal stacker
                done()

        it 'enables access to the top node in the stack', (done) ->

            push = stack.stacker
            push 'label1', (again) ->
                again 'label2', (more) ->
                    more 'label3', (evenmore) ->
                    more 'label4'

                    stack.node.label.should.equal 'label2'
                    done()

