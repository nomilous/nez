Realization = require '../lib/realization'
ActiveNode  = require '../lib/active_node' 

describe 'Realization', -> 

    it 'starts an ActiveNode as "SpecRun"', (done) -> 

        ActiveNode.prototype.start = (config) -> 

            config._objective.class = 'ipso:SpecRun'
            done() 

        Realization 'LABEL', ->

