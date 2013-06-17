should = require 'should'
Nez    = require '../lib/nez'
nez    = it

describe 'nez', -> 

    nez 'is French for "nose" ', (done) ->

        done()


    nez 'is Flower for "hello" ', (hello) ->

        hello()


    it 'exports objective()', (done) ->

        Nez.objective.should.equal require '../lib/objective/objective' 
        done()



    it 'exports realize()', (done) -> 

        Nez.realize.should.equal require '../lib/realization/realize'
        done()

