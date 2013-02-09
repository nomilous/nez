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