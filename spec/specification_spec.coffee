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
            {name: 'expectation'}

        ]

        done()


    it 'inserts expectant objects and an expectations stack into the hash', (done) ->

        object = new Object
        expectation = null
        Specification.create object, expectation

        Specification.objects[ object.fing.ref ].object.should.equal object
        Specification.objects[ object.fing.ref ].expectations.should.be.an.instanceof Array
        done()


    it 'pushes expectations into the object associated expectation stack', (done) ->


        object = new Object
        expectation1 = { e: 'xpectation1' }
        expectation2 = { e: 'xpectation2' }
        Specification.create object, expectation1
        Specification.create object, expectation2


        Specification.objects[ object.fing.ref ].expectations[0].should.equal expectation1
        Specification.objects[ object.fing.ref ].expectations[1].should.equal expectation2
        done()






