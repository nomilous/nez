should  = require 'should'
print   = require('prettyjson').render
stack   = require('../lib/nez').link()
Plugins = require '../lib//plugin_register'

describe 'Stack', -> 

    describe 'is a eventEmitter', ->

        it 'allows assembling the tree in parallel'


    it 'has a root node with backref to the stack', (done) ->

        stack.node.label.should.equal 'root'
        stack.node.stack.should.equal stack
        done()


    describe 'has an event emitter', ->

        describe 'edge event', ->

            it 'is emitted with each traversal from one node to another', (done) ->

                STACK = stack
                stack.on 'edge', (placeholder, nodes) ->
                    #
                    # exiting THREE?
                    #
                    if nodes.from.label == 'THREE'
                        #
                        # GOT thing in it?
                        #
                        nodes.from.stick.this.into.should.equal 'IT'
                        done()


                stack.stacker 'ONE', (Parent) -> 
                    Parent 'TWO', (Child) -> 
                        Child 'THREE', (GrandChild) -> 
                            #
                            # PUT thing in it
                            #
                            STACK.node.stick = this: into: 'IT'

                


    describe 'stacker()', -> 

        it 'calls push() if received args', (done) -> 

            wasCalled = false
            originalFn = stack.push
            stack.push = -> wasCalled = true
            stack.stacker 'label'
            stack.push = originalFn

            wasCalled.should.equal true
            done()


    it 'hands the new node through each registered plugin', (done) -> 

        stack.stacker 'parent', (CLASS) ->

            swap = Plugins.handle
            Plugins.handle = (node) -> 
                Plugins.handle = swap
                node.class.should.equal 'CLASS'
                node.label.should.eql 'LABEL'
                done()

            CLASS 'LABEL', (next) ->
        

    describe 'ancestorsOf()', ->

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


    describe 'push()', -> 

        it 'attaches refence to the stack onto the node', (done) ->

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
                    stack.stack[0].callback.should.equal callback
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

