should     = require 'should'
Objective  = require '../lib/objective'
Exec       = require '../lib/exec/nez'


describe 'Objective', -> 

    it 'returns the dev environment exec()', (wasCalled) ->

        Exec.exec = -> wasCalled()

        Objective.validate()

