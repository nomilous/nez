should        = require 'should'
Specification = require '../src/specification'

describe 'Specification', ->


    it 'maintains a hash of objects that have expectations', (done) ->

        Specification.objects.should.be.an.instanceof Object
        done()


    it 'defines a function to create an expectation on an object', (done) ->

        Specification.create.should.be.an.instanceof Function
        Specification.create.fing.args.should.eql [

            {name: 'object'}
            {name: 'configuration'}

        ]

        done()


    it 'inserts expectant objects and a confirmations stack into the hash', (done) ->

        object = new Object
        expectation = {}
        Specification.create object, expectation

        Specification.objects[ object.fing.ref ].object.should.equal object
        Specification.objects[ object.fing.ref ].confirmations.should.be.an.instanceof Array
        done()


    it 'stores a new instance of a Confirmation for each expectation', (done) ->

        object = new Object
        expectation1 = { expectation: 'xpectation1' }
        expectation2 = { expectation: 'xpectation2' }
        Specification.create object, expectation1
        Specification.create object, expectation2

        confirmation1 = Specification.objects[ object.fing.ref ].confirmations[0]
        confirmation2 = Specification.objects[ object.fing.ref ].confirmations[1]


        confirmation1.fing.name.should.equal 'Confirmation'
        confirmation2.fing.name.should.equal 'Confirmation'
        confirmation1.fing.ref.should.not.equal confirmation2.fing.ref
        done()


    it 'returns a not yet validated Confirmation', (done) ->

        object = new Object
        confirmation = Specification.create object, expectation: {}
        confirmation.fing.name.should.equal 'Confirmation'
        confirmation.pending.should.equal true
        done()



