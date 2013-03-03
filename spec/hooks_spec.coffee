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

