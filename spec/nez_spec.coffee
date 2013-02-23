should = require 'should'
Nez    = require '../lib/nez'
test   = idea = blueprint = Nez.test
nez    = it


describe 'Nez', -> 




    nez 'is French for "nose" ', (knows) ->

        test -> knows()




    nez 'is Flower for "hello" ', (stamen) ->

        idea -> stamen()




    nez 'is Tree for "blueprint" ', (pollinate) ->

        blueprint( ->->-> pollinate() )('A')('I')




    nez is: 'realization', -> 






describe 'Nez.realize()', -> 

    it 'is a property that returns a function', (done) -> 

        Nez.realize.should.be.an.instanceof Function
        done()








#
# Later...
#


xdescribe 'Nez.link()', -> 

    it 'returns a function for building a callback chain', (done) -> 

        fn = Nez.link 'thing'
        fn.should.be.an.instanceof Function
        done()

    it 'enables building a dependancy tree using the callback chain', (done) -> 


        project = Nez.link 'project'
        project 'Get your ducks in a row', (milestone) ->

            milestone 'Found all the ducks'
            milestone 'Trained a team of duck herders'
            milestone 'Located suitable pond'

            done()

    it 'provides a rootside hyper edge'

    it 'provides a leafside hyper edge', (done) -> 

        animal = Nez.link 'Animals'

        animal 'Elephant', (properties) ->

            properties.link 'Asian'
            properties.link 'African'
            properties.link 'Pink'

            properties.link.should.be.an.instanceof Function
            done()


