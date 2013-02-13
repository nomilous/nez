should = require 'should'
print  = require('prettyjson').render
Stack  = require '../lib/stack'

describe 'Stack', -> 

    it 'has a root node', (done) ->

        stack = new Stack 'stack'
        stack.node.label.should.equal 'root'
        done()


    describe 'pusher()', -> 

        it 'calls to validate when the first arg is a function', (done) ->

            stack = new Stack 'stack'
            wasCalled = false
            originalFn = stack.validate
            stack.validate = -> wasCalled = true
            stack.pusher ->
            stack.validate = originalFn

            wasCalled.should.equal true
            done()

        it 'runs done', (done) ->

            stack = new Stack 'stack'
            stack.pusher done


        it 'calls push() if received args', (done) -> 

            stack = new Stack 'stack'
            wasCalled = false
            originalFn = stack.push
            stack.push = -> wasCalled = true
            stack.pusher 'label'
            stack.push = originalFn

            wasCalled.should.equal true
            done()


    describe 'push()', -> 

        it 'pushes a new labeled node into the stack', (done) -> 

            stack  = new Stack 'design'
            stack.pusher 'A thing', -> 

                stack.stack[0].label.should.equal 'A thing'
                done()


        it 'stores a passed function on the new node', (done) -> 

            stack = new Stack 'stack'

            callback = -> 
                stack.stack[0].callback.should.equal callback
                done()

            stack.pusher 'A thing', callback


        it 'runs the function', (done) -> 

            stack = new Stack 'stack'
            stack.pusher 'A thing', -> done()


        it 'passes the pusher() as arg to the called function', (done) ->

            stack = new Stack 'stack'
            pusher = stack.pusher

            stack.pusher 'A thing', (arg) ->

                arg.should.equal pusher
                done()

        it 'enables access to the top node in the stack', (done) ->

            stack = new Stack 'stack'
            push = stack.pusher

            push 'label1', (again) ->
                again 'label2', (more) ->
                    more 'label3', (evenmore) ->
                    more 'label4'

                    stack.node.label.should.equal 'label2'
                    done()



    it 'it populates a stack', (done) -> 

        s = new Stack 'stack'
        design = s.pusher
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
        design = s.pusher
        stack  = s.stack

        design 'A thing', -> 

            stack[0].class.should.equal 'design'
            stack[0].label.should.equal 'A thing'
            done()


    it "is uses the callback arg label for all other node class names", (done) ->

        s = new Stack 'design'
        design = s.pusher
        stack  = s.stack

        design 'A thing', (For) -> 

            For 'increasingly evident reasons', -> 

                stack[1].class.should.equal 'For'
                stack[1].label.should.equal 'increasingly evident reasons'
                done()


    describe 'the walker that', ->  

        it 'starts at the root of the tree', (done) ->

            s = new Stack 'design'
            design = s.pusher
            tree   = s.tree
            walker = s.walker

            tree.should.be.an.instanceof Array
            tree.should.eql walker
            done()


        xit 'walks when pushed, placing nodes into the tree', (done) -> 

            s = new Stack 'design'
            design = s.pusher
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

    describe 'validate()', ->

        it 'validates each validatable object in the current node', (done) ->

            count = 0
            stack = new Stack 'stack'

            stack.node.edges.push
                validate: -> 
                    count++

            stack.node.edges.push {}

            stack.validate()
            count.should.equal 1

            done()




