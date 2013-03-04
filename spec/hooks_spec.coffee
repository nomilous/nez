should = require 'should'
Hooks  = require '../lib/hooks'
Node   = require '../lib/node'

describe 'Hooks', ->

    xit 'subscribes to stack edge events', (yip) ->

        stack = 

            #
            # mock stack with on() subscriber
            #

            on: (event, handler) -> 

                yip() if event == 'edge'


        Hooks.getFor stack


    xit 'binds only prefefined hooks to the node', (done) ->

        hooks = Hooks.getFor on:(event, handler)=>
        node  = new Node 'name'

        beforeEachFn = ->
        afterEachFn = ->
        beforeAllFn = ->
        afterAllFn = ->
        otherThingFn = -> 

        hooks.set node, 
            beforeEach: beforeEachFn
            afterEach: afterEachFn
            beforeAll: beforeAllFn
            afterAll: afterAllFn
            otherThing: otherThingFn

        node.hooks.beforeEach.should.equal beforeEachFn
        node.hooks.afterEach.should.equal afterEachFn
        node.hooks.beforeAll.should.equal beforeAllFn
        node.hooks.afterAll.should.equal afterAllFn
        should.not.exist node.hooks.otherThing
        done()


    it 'runs beforeAll only once', (done) ->


        hooks = Hooks.getFor on:(event, handler)=>
        node  = new Node 'name',
            stack:
                ancestorsOf: -> [ 
                    new Node 'parent'
                    new Node 'pparent' 
                ]


        beforeAll = 0
        hooks.set node, beforeAll: -> beforeAll++

        hooks.handle '', 
            tree: 'down'
            from: node 
            to: new Node 'other'

        hooks.handle '', 
            tree: 'down'
            from: node 
            to: new Node 'other'

        beforeAll.should.equal 1

        done()

    it 'runs afterAll only once', (done) ->

        hooks = Hooks.getFor on:(event, handler)=>
        node  = new Node 'name'
        afterAll = 0
        hooks.set node, afterAll: -> afterAll++

        hooks.handle '', 
            tree: 'up'
            from: new Node 'other'
            to: node

        hooks.handle '', 
            tree: 'up'
            from: new Node 'other'
            to: node

        afterAll.should.equal 1
        done()
        

    xit 'runs beforeEach every time', (done) ->

        hooks = Hooks.getFor on:(event, handler)=>
        node  = new Node 'name'
        beforeEach = 0
        hooks.set node, beforeEach: -> beforeEach++

        hooks.handle '', 
            tree: 'down'
            from: node 
            to: new Node 'other'

        hooks.handle '', 
            tree: 'down'
            from: node 
            to: new Node 'other'

        beforeEach.should.equal 2

        done()

    xit 'runs afterEach every time', (done) ->

        hooks = Hooks.getFor on:(event, handler)=>
        node  = new Node 'name'
        afterEach = 0
        hooks.set node, afterEach: -> afterEach++

        hooks.handle '', 
            tree: 'up'
            from: new Node 'other'
            to: node

        hooks.handle '', 
            tree: 'up'
            from: new Node 'other'
            to: node

        afterEach.should.equal 2

        done()
        

