should = require 'should'
Expectation = require '../src/expectation'
test = require('../lib/nez').test 'NAME'

describe 'Expectation', -> 



    class Thing

        constructor: -> 

        existing: -> 

            #
            # define existing() function that calls 
            # missingFunction()
            #

            return "existing(  #{ @missingFunction('MOCKED THIS') }  )"

        existingProperty: 'EXISTING PROPERTY'

        funcUsesProperty: ->

            return 'function returned '+ @existingProperty




    it 'defaults to mock a function', (done) ->

        thing = new Thing()

        test 'Thing', -> 

            thing.expect missingFunction: returns: 'MOCK RESULT'

            thing.missingFunction().should.equal 'MOCK RESULT'
            done()



    it 'the mock missingFunction can be called by an existing function', (done) ->

        thing = new Thing()

        test 'Thing', -> 

            thing.expect missingFunction: returns: 'MOCK RESULT'

            thing.existing().should.equal 'existing(  MOCK RESULT  )'
            done()



    it 'can spy on a function', (done) ->

        thing = new Thing()

        test 'Thing', -> 

            thing.expect existing: as: 'spy'           # still runs original
            thing.expect missingFunction: returns: ''  # therefore requires this
            
            thing.existing( 'ARG1', 2 )

            firstExpectation = require('../lib/nez').stacks.NAME.node.edges[0]
            calledDetail     = firstExpectation.realization.realized

            calledDetail.function.args[1].should.equal 'ARG1'
            calledDetail.function.args[2].should.equal 2
            done()



    it 'warns when spying on nonexistant function', (done) ->

        thing = new Thing()

        test 'Thing', -> 

            thing.expect spyOnThisMissingFunction: as: 'spy'

            console.log "NOT TESTED FOR WARN"
            done()



    it 'enables access to called args for both a mock and spy', (done) ->

        thing = new Thing()

        test 'Thing', -> 

            thing.expect existing: as: 'spy'           # still runs original
            thing.expect missingFunction: returns: ''  # therefore requires this

            thing.existing( 'SPIED ON THIS', 2 )

            thing.existing.got.args[1].should.equal 'SPIED ON THIS'
            thing.missingFunction.got.args[1].should.equal 'MOCKED THIS'
            done()



    it 'can define mocks/spies on the class (prototype)', (done) ->

        class AnotherThing

            existing: (arg) -> 

        test 'AnotherThing', -> 

            AnotherThing.expect existing: with: 'ARG'

            thing = new AnotherThing()
            thing.existing('ARG')
            thing.existing.got.args[1].should.equal 'ARG'
            done()



    it 'supports setting more than one expectation on the same function/property'
    it 'maintains called sequance to match up against the expected sequence'
    it 'thows if a spy and a mock are set on the same function in the same test'
    it 'restores the original function if there was one'



    it "can 'mock' the getting of a property", (done) ->

        thing = new Thing()

        test 'Thing', -> 

            should.not.exist thing.PROPERTY
            thing.expect PROPERTY: as: 'get', returns: 'THIS'

            thing.PROPERTY.should.equal 'THIS'
            done()



    it "can 'spy' on the getting of a property", (done) ->

        thing = new Thing()

        test 'Thing', -> 

            should.exist thing.existingProperty
            thing.expect existingProperty: as: 'get'

            thing.funcUsesProperty()
            thing._had.existingProperty.should.equal 'EXISTING PROPERTY'
            done()



    it "can 'spy' on the setting of an existing property", (done) ->

        thing = new Thing()

        test 'Thing', -> 

            should.exist thing.existingProperty
            thing.expect existingProperty: as: 'set'

            thing.existingProperty = 'SET VALUE'
            thing._got.existingProperty.should.equal 'SET VALUE'
            done()


    it 'can mock a settable property', (done) ->


        thing = new Thing()

        test 'Thing', -> 

            should.not.exist thing.noShuchProperty
            thing.expect noShuchProperty: as: 'set'

            thing.noShuchProperty = 'SET VALUE'
            thing._got.noShuchProperty.should.equal 'SET VALUE'
            done()


