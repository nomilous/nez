require 'should'
Expectation = require '../src/expectation'
test = require('../lib/nez').test 'name'

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

