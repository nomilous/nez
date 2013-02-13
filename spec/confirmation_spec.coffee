should       = require 'should'
Confirmation = require '../lib/confirmation'
Validation  = require '../lib/validation'

describe 'Confirmation', -> 

    xit 'is a Realizable Expectation', (okgood) -> 

        okgood()

    xit 'is constructed with object and configuration', (done) ->

        Confirmation.fing.args.should.eql [

            { name: 'object' },
            { name: 'configuration' }

        ]

        done()


    xit 'is pending and unvalidated', (done) ->

        confirmation = new Confirmation (new Object), expectation: 'function'
        confirmation.pending.should.equal true
        done()


    xit 'contains the validation details', (done) ->

        confirmation = new Confirmation (new Object), expectation: 'function'

        should.exist confirmation.validation
        confirmation.validation.fing.name.should.equal 'Validation'
        done()


    it 'calls validate', (done) ->

        swap = Validation.prototype.validate
        Validation.prototype.validate = ->

            Validation.prototype.validate = swap
            done()

        test = require('../lib/nez').test
        object = new Object
        object.expect 'function'
        object.function()

        test ->

