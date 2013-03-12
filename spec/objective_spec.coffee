require 'fing'
should     = require 'should'
Objective  = require '../lib/objective'
Exec       = require '../lib/exec/nez'
swap       = undefined


describe 'Objective', -> 

    it 'knows the repo root', (done) ->

        #
        # ./objective script should always be placed
        #             in the repo root
        #

        Objective.validate 'NameOfThing'
        Objective.root.should.match /nez\/spec$/
        done()
        

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
