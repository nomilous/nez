should     = require 'should'
Objective  = require '../lib/objective'
Exec       = require '../lib/exec/nez'


describe 'Objective', -> 

    it 'returns the dev environment exec() if config was supplied', (wasCalled) ->

        old = Exec.exec 
        Exec.exec = -> 
            Exec.exec = old
            wasCalled()

        Objective.validate 'NameOfThing', {'config'}


    it 'returns the dev environment start()er if no config was passed', (done) ->

        loader = Objective.validate 'NameOfThing'
        loader.should.equal Exec.start
        done()
