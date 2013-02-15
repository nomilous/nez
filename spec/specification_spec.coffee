should        = require 'should'
Specification = require '../lib/specification'
test          = require('../lib/nez').test
Confirmation  = require '../lib/confirmation'

describe 'Specification', ->


    it 'maintains a hash of objects that have specification', (done) ->

        Specification.objects.should.be.an.instanceof Object
        done()


    it 'defines a function to create specifications', (done) ->

        Specification.create.should.be.an.instanceof Function
        Specification.create.fing.args.should.eql [

            {name: 'opts'}

        ]

        done()

    describe 'creates confirmations', ->
    

        it 'inserts confirmation interfaces/objects and a confirmations stack into the hash', (done) ->

            object = new Object

            Specification.create 
                stack: '0'
                interface: object
                realizer: 'PLACEHOLDER'
                config: 
                    function: {}


            Specification.objects[ object.fing.ref ].interface.should.equal object
            Specification.objects[ object.fing.ref ].confirmations.should.be.an.instanceof Array
            done()


    it 'stores a new instance of a Confirmation for each specification', (done) ->

        object = new Object

        Specification.create 
            stack: '0'
            interface: object
            realizer: 'PLACEHOLDER'
            config: 
                specification1: {}
                specification2: {}

        confirmation1 = Specification.objects[ object.fing.ref ].confirmations[0]
        confirmation2 = Specification.objects[ object.fing.ref ].confirmations[1]

        confirmation1.fing.name.should.equal 'Confirmation'
        confirmation2.fing.name.should.equal 'Confirmation'
        confirmation1.fing.ref.should.not.equal confirmation2.fing.ref
        done()


