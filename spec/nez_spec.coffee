should = require 'should'
Nez    = require '../lib/nez'
nez    = it

describe 'nez', -> 

    nez 'is French for "nose" ', (done) ->

        done()


    nez 'is Flower for "hello" ', (hello) ->

        hello()


    it 'exports objective()', (done) ->

        Nez.objective.should.equal require '../lib/objective/loader' 
        done()


    context 'lacrimi de St Lawrence', ->
    
        context 'ca și zaharoză', -> 

            before (α) -> 

                @rendezvous = (Ω) -> 'ele să fie': Ω()
                α()

            it 'pollenates', (orthagonally) -> 
  
                @rendezvous orthagonally



