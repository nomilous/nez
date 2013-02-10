Validation = require '../src/validation'
require 'should'
require 'fing'

describe 'Validation', -> 

    it 'converts Expectations + Realizations into...', (confirmations) -> 

        confirmations()


    it 'is constructed with the expectation', (done) ->

        Validation.fing.args.should.eql [

            { name: 'expectation' }

        ]
        done()


    it 'contains reference to expectation', (done) ->

        expectation = {}
        validation = new Validation expectation
        validation.expectation.should.equal expectation
        done()


    it 'creates the realization callback', (done) ->

        expectation = {}
        validation = new Validation expectation
        realization = validation.createRealization()

        realization().should.equal 'REALIZATION CALLBACK'
        console.log 'TODO: test this once realization has flesh'
        done()

