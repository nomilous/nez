should = require 'should'
Hooks  = require '../lib/hooks'
Node   = require '../lib/node'

describe 'Hooks', ->

    it 'subscribes to stack edge events', (yip) ->

        stack = 

            #
            # mock stack with on() subscriber
            #

            on: (event, handler) -> 

                yip() if event == 'edge'


        Hooks.getFor stack


    it 'binds only prefefined hooks to the node', (done) ->

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


    it 'runs beforeAll only once and beforeEach every time', (done) ->

        hooks = Hooks.getFor on:(event, handler)=>
        node  = new Node 'name'
        beforeAll = 0
        beforeEach = 0
        hooks.set node, beforeAll: -> beforeAll++
        hooks.set node, beforeEach: -> beforeEach++

        hooks.handle '', 
            from: node 
            to: {}

        hooks.handle '', 
            from: node 
            to: {}

        beforeAll.should.equal 1
        beforeEach.should.equal 2

        done()

    it 'runs afterAll only once and afterEach every time', (done) ->

        hooks = Hooks.getFor on:(event, handler)=>
        node  = new Node 'name'
        afterAll = 0
        afterEach = 0
        hooks.set node, afterAll: -> afterAll++
        hooks.set node, afterEach: -> afterEach++

        hooks.handle '', 
            from: {}
            to: node

        hooks.handle '', 
            from: {} 
            to: node

        afterAll.should.equal 1
        afterEach.should.equal 2

        done()
        
