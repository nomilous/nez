should      = require 'should'
Realization = require '../lib/realization'
ActiveNode  = require '../lib/active_node' 
Plex        = require 'plex'

describe 'Realization', -> 

    Plex.start = -> 'dont start link to objective'

    it 'starts an ActiveNode as "SpecRun"', (done) -> 

        swap = ActiveNode.prototype.start
        ActiveNode.prototype.start = (config) -> 
            ActiveNode.prototype.start = swap
            config._realizer.class.should.equal 'ipso:SpecRun'
            done() 

        Realization 'LABEL', ->

    

    it 'works on a clean run with no failures/exceptions', (done) -> 

        
        Realization 'Realization Label'

            with: [ -> done ]

            (Context, Validate, getTestDoneFn) -> 

                Context 'Some Context', (It) -> 

                    It 'is', (ok) -> 

                        Validate ok

                        getTestDoneFn()()


    it 'works on a failing test', (done) -> 


        Realization '3', (This, test) -> 

            This 'test', (fails) -> 

                This.should.not.equal fails
                done()
