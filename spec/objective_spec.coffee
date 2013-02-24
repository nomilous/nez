should     = require 'should'
Objective  = require '../lib/objective'
Exec       = require '../lib/exec/nez'


describe 'Objective', -> 

    it 'runs the dev environment', (wasCalled) ->

        Exec.exec = -> wasCalled()

        Objective.validate()()

    