should       = require 'should'
Confirmation = require '../src/confirmation'

describe 'Confirmation', -> 

    it 'is a Realizable Expectation', (okgood) -> 

        okgood()

    it 'is constructed with object, configuration and a realization callback', (done) ->

        Confirmation.fing.args.should.eql [

            { name: 'object' },
            { name: 'configuration' },
            { name: 'realization' }

        ]

        done()


    it 'is pending and unvalidated', (done) ->

        confirmation = new Confirmation (new Object), expectation: {}, ->
        confirmation.pending.should.equal true
        done()


    it 'stores the expectation details', (done) ->

        confirmation = new Confirmation (new Object), expectation: {}, ->

        should.exist confirmation.expectation
        confirmation.expectation.fing.name.should.equal 'Expectation'
        done()
