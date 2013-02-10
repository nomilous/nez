should       = require 'should'
Confirmation = require '../src/confirmation'

describe 'Confirmation', -> 

    it 'is a Realizable Expectation', (okgood) -> 

        okgood()

    it 'is constructed with object and configuration', (done) ->

        Confirmation.fing.args.should.eql [

            { name: 'object' },
            { name: 'configuration' }

        ]

        done()


    it 'is pending and unvalidated', (done) ->

        confirmation = new Confirmation (new Object), expectation: {}
        confirmation.pending.should.equal true
        done()


    it 'contains the validation details', (done) ->

        confirmation = new Confirmation (new Object), expectation: {}

        should.exist confirmation.validation
        confirmation.validation.fing.name.should.equal 'Validation'
        done()



