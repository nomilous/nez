should = require 'should'
Nez = require '../lib/nez'

describe 'Nez.link()', -> 

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



    #
    # later...
    #

    it 'provides a rootward edge linker'

    it 'provides a leafward edge linker', (done) -> 

        animal = Nez.link 'Animals'

        animal 'Elephant', (properties) ->

            properties.link 'Asian'
            properties.link 'African'

            properties.link.should.be.an.instanceof Function
            done()
