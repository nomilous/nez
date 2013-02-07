require 'should'
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

            return "existing(  #{ @missingFunction() }  )"


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



    it 'stores the called args for both a mock and spy'
    it 'supports setting more than one expectation on the same function/property'
    it 'maintains called sequance to match up against the expected sequence'
    it 'thows if a spy and a mock are set on the same function in the same test'