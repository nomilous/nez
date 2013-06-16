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

    it 'returns true when provided a valid hook config', (done) ->

        hooks = Hooks.getFor on:(event, handler)=>
        node  = new Node 'name'
        hooks.set( node, beforeEach: -> ).should.equal true
        done()

    it 'returns false when provided an invalid hook config', (done) ->

        hooks = Hooks.getFor on:(event, handler)=>
        node  = new Node 'name'
        hooks.set( node, giantPeach: -> ).should.equal false
        done()


    it 'binds only predefined hooks to the node', (done) ->

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
            #
            # mock stack with two ancestors
            #
            stack:
                ancestorsOf: -> [ 
                    new Node 'parent'
                    new Node 'pparent' 
                ]


        beforeAll = 0
        hooks.set node, beforeAll: -> beforeAll++

        hooks.handle '', 
            class: 'Tree:Leafward'
            from: node 
            to: new Node 'other'

        hooks.handle '', 
            class: 'Tree:Leafward'
            from: node 
            to: new Node 'other'

        beforeAll.should.equal 1

        done()

    it 'runs afterAll only once', (done) ->

        hooks = Hooks.getFor on:(event, handler)=>
        node  = new Node 'name',
            stack:
                ancestorsOf: -> [ 
                    new Node 'parent'
                    new Node 'pparent' 
                ]
        afterAll = 0
        hooks.set node, afterAll: -> afterAll++

        hooks.handle '', 
            class: 'Tree:Rootward'
            from: new Node 'other'
            to: node

        hooks.handle '', 
            class: 'Tree:Rootward'
            from: new Node 'other'
            to: node

        afterAll.should.equal 1
        done()
        

    it 'runs beforeEach every time', (done) ->

        hooks = Hooks.getFor on:(event, handler)=>

        beforeEach = 0
        ancestor1 = new Node 'ancestor1'
        ancestor1.hooks.beforeEach = -> beforeEach++
        ancestor2 = new Node 'ancestor2'
        ancestor2.hooks.beforeEach = -> beforeEach++

        node  = new Node 'name',
            #
            # mock stack with to ancestors each having a 
            # before each hook
            #
            stack:
                ancestorsOf: -> 
                    [ ancestor1, ancestor2 ]
        
        hooks.set node, beforeEach: -> beforeEach++

        hooks.handle '', 
            class: 'Tree:Leafward'
            from: node 
            to: new Node  """

                    entering this child node, so run all before hooks 
                    on the 'departed' from.nodes's ancestry (and self)

            """

        hooks.handle '', 
            class: 'Tree:Leafward'
            from: node 
            to: new Node 'other'

        #
        # it should have run all beforeEach hooks 
        # on the ancestors for each handled edge
        # ie. 
        #      2 hooks X 2 node (test 'leafs')
        #      + 1 X 2 for each local beforeEach
        #

        beforeEach.should.equal 6

        done()

    it 'runs afterEach every time', (done) ->

        hooks = Hooks.getFor on:(event, handler)=>

        afterEach = 0
        ancestor1 = new Node 'ancestor1'
        ancestor1.hooks.afterEach = -> afterEach++
        ancestor2 = new Node 'ancestor2'
        ancestor2.hooks.afterEach = -> afterEach++


        node  = new Node 'name', 
            stack: 
                ancestorsOf: -> 
                    [ ancestor1, ancestor2 ]

        hooks.set node, afterEach: -> afterEach++

        hooks.handle '', 
            class: 'Tree:Rootward'
            from: new Node 'other'
            to: node

        hooks.handle '', 
            class: 'Tree:Rootward'
            from: new Node """

                    exitting this child node, so run all after hooks 
                    on the 'destination' to.nodes's ancestry (and self)

            """
            to: node

        afterEach.should.equal 6

        done()
        

