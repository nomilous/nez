should      = require 'should'
Realization = require '../lib/realization'
ActiveNode  = require '../lib/active_node' 
Plex        = require 'plex'

describe 'Realization', -> 

    it 'starts an ActiveNode as "SpecRun"', (done) -> 

        swap = ActiveNode.prototype.start
        ActiveNode.prototype.start = (config) -> 
            ActiveNode.prototype.start = swap
            config._realizer.class.should.equal 'ipso:SpecRun'
            done() 

        Realization 'LABEL', ->

    

    it 'works on a clean run with no failures/exceptions', (done) -> 

        Plex.start = -> 'dont start link to objective'



        new Realization 'Realization Label'

            with: [ -> done ]

            (Context, Validate, getTestDoneFn) -> 

                Context 'Some Context', (it) -> 

                    it 'is', (ok) -> 

                        Validate ok

                        getTestDoneFn()()

