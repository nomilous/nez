should      = require 'should'
Realization = require '../lib/realization'
ActiveNode  = require '../lib/active_node'
Stack       = require '../lib/stack'
Plex        = require 'plex'

describe 'Realization', -> 

    it 'starts and stops plex', (done) -> 

        started = false

        Plex.start = -> stop: -> done()

        Realization 'LABEL', (context, test) -> 

            context 'label', (ok) ->


    it 'starts an ActiveNode as "SpecRun"', (done) -> 

        swap = ActiveNode.prototype.start
        ActiveNode.prototype.start = (config) -> 
            ActiveNode.prototype.start = swap
            config._realizer.class.should.equal 'ipso:SpecRun'
            done() 

        Realization 'LABEL', ->

    

    it 'validates on an "all passing" run', (done) ->

        Plex.start = -> stop: -> 
        Stack.prototype.validate = (stacker, error) ->

            stacker.should.be.an.instanceof Function
            should.not.exist error
            done() 

        Realization 'Realization Label',

            (Context, Validate) -> 

                Context 'Some Context', (It) -> 

                    It 'is', (ok) -> 

                        Validate ok


    it 'validates on a "failing" run', (done) -> 

        Plex.start = -> stop: -> 
        Stack.prototype.validate = (stacker, error) ->

            error.should.match /expected true to equal false/
            done() 

        Realization '3', (This, test) -> 

            This 'test', (fails) -> 

                true.should.equal false
                


