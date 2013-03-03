should   = require 'should'
Nez      = require '../lib/nez'
Injector = require '../lib/injector'
Nez.link 'name'
test     = idea = blueprint = Nez.stack.validator
nez      = it


describe 'Nez', -> 




    nez 'is French for "nose" ', (knows) ->

        test knows




    nez 'is Flower for "hello" ', (stamen) ->

        idea -> stamen()




    nez 'is Tree for "blueprint" ', (pollinate) ->

        blueprint( ->->-> pollinate() )('A')('I')




    nez is: 'realization', -> 






describe 'Nez.realize()', -> 

    it 'is a property that returns the realization flavoured injector', (done) -> 

        Nez.realize.should.equal require('../lib/injector').realize
        done()


describe 'Nez.objective()', -> 

    it 'is a property that returns the validation looper', (done) ->

        Nez.objective.should.equal require('../lib/objective').validate
        done()



#
# Later...
#


describe 'Nez.link()', -> 

    it 'returns a new test stack', (done) -> 

        stack = Nez.link 'thing'
        stack.stacker.should.be.an.instanceof Function
        stack.validator.should.be.an.instanceof Function
        done()

    xit 'enables building a dependancy tree using the callback chain', (done) -> 


        project = Nez.link 'project'
        project 'Get your ducks in a row', (milestone) ->

            milestone 'Found all the ducks'
            milestone 'Trained a team of duck herders'
            milestone 'Located suitable pond'

            done()

    xit 'provides a rootside hyper edge'

    xit 'provides a leafside hyper edge', (done) -> 

        animal = Nez.link 'Animals'

        animal 'Elephant', (properties) ->

            properties.link 'Asian'
            properties.link 'African'
            properties.link 'Pink'

            properties.link.should.be.an.instanceof Function
            done()


