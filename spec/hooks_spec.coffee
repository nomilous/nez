should = require 'should'
Hooks = require '../lib/hooks'

describe 'Hooks', ->

    it 'subscribes to stack edge events', (yip) ->

        stack = 

            #
            # mock stack with on() subscriber
            #

            on: (event, handler) -> 

                yip() if event == 'edge'


        Hooks.getFor stack


    describe 'hooks onto nodes', (done) ->

        beforeEach -> 

            @stack = 

                #
                # mock stack with on() subscriber
                #

                on: (event, handler) => 


            @hooks = Hooks.getFor @stack

            @node = {}

        
        it 'stores the hook callback keyed on node/hookName', (done) ->


            beforeEachCallback = ->
            @hooks.set 'beforeEach', @node, beforeEachCallback

            @hooks.hooks[@stack.fing.ref].should.eql 
                beforeEach: beforeEachCallback

            done()

