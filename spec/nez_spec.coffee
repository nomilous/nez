should      = require 'should'
Nez         = require '../lib/nez'
Injector    = require '../lib/injector'
Requirement = require '../lib/plugin/requirement'
Nez.link     'name'
test        = Nez.stack.validator
nez         = it


describe 'Nez', -> 


    nez 'is French for "nose" ', (knows) ->

        test knows



    nez 'is Flower for "hello" ', (hello) ->

        hello()




    it 'exports objective()', (done) ->

        Nez.objective.should.equal require '../lib/objective' 
        done()

    it 'defines realize()', (done) -> 

        Nez.realize.should.equal require('../lib/realization').load
        done()



    it 'defines requirements() which loads the requirement plugin', (wasCalled) ->

        swap = Requirement.configure
        Requirement.configure = -> 
            Requirement.configure = swap
            wasCalled()

        Nez.requirements 'name'
        


    it 'defines plugin()', (done) ->

        Nez.plugin.should.equal require('../lib/plugin_loader').load
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


