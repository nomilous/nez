Validation  = require '../src/validation'
Expectation = require '../src/expectation'
should      = require 'should'

describe 'Validation', -> 

    it 'converts Expectations + Realizations into...', (confirmations) -> 

        confirmations()


    it 'is constructed with the expectation', (done) ->

        Validation.fing.args.should.eql [

            { name: 'expectation' }

        ]
        done()


    it 'contains reference to expectation', (done) ->

        expectation = new Expectation (new Object), 'function'
        validation  = new Validation expectation
        validation.expectation.should.equal expectation
        done()


    it 'contains storage for the realization - pending validation', (done) ->

        validation = new Validation (new Expectation (new Object), 'function')
        validation.realization.should.eql {}
        done()


    describe 'creates the realizer', ->

        beforeEach ->

            @object     = new Object
            expectation = new Expectation @object, 'function1'
            @validation  = new Validation expectation


        it 'as a function', (done) ->

            should.exist @object.function1
            done()


        it 'populates the realization with the realized data', (done) ->

            @object.function1('ARG')
            @validation.realization.args[0].should.equal 'ARG'
            done()




