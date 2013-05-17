should = require 'should'
Nez    = require '../lib/nez'
test   = (done) -> done()
nez    = it


describe 'Nez', -> 


    nez 'is French for "nose" ', (knows) ->

        test knows



    nez 'is Flower for "hello" ', (hello) ->

        hello()



    it 'exports objective()', (done) ->

        Nez.objective.should.equal require '../lib/objective' 
        done()



    it 'exports realize()', (done) -> 

        Nez.realize.should.equal require '../lib/realization'
        done()

