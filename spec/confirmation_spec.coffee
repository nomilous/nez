should       = require 'should'
Confirmation = require '../lib/confirmation'
Validation   = require '../lib/validation'
test         = require('../lib/nez').test



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

        confirmation = new Confirmation (new Object), expectation: 'function'
        confirmation.pending.should.equal true
        done()


    it 'contains the validation details', (done) ->

        confirmation = new Confirmation (new Object), expectation: 'function'

        should.exist confirmation.validation
        confirmation.validation.fing.name.should.equal 'Validation'
        done()


    it 'calls onward to validation.validate()', (done) ->

        swap = Validation.prototype.validate
        Validation.prototype.validate = ->

            Validation.prototype.validate = swap
            done()

        confirmation = new Confirmation (new Object), expectation: 'function'
        confirmation.validate()

