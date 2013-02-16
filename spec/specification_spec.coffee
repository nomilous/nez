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
        confirmation1.should.not.equal confirmation2
        done()


    it 'distinguishes between global and local specifications', (done) ->

        object = new Object
        object.expect function: ->
        Specification.objects[ object.fing.ref ].global.should.equal false

        swap = beforeEach
        expect beforeEach: ->
        beforeEach = swap  # best not to stomp on mocha's one

        Specification.objects[ fing.ref ].global.should.equal true

        done()


    it 'does not allow userdefined expectations on global', (done) ->

        try
            expect newFunction: returning: """

                Doing this would define newFunction() { return "this explanation" } on 
                the running Node instance itself.

                Sounds like a bad idea.

                So i'm going to use global expect() as the mechanism for pushing
                beforeAll, beforeEach, afterAll and afterEach into the spec stack.

            """ 

        catch error

            delete newFunction # or mocha says, "Error: global leak detectedd: newFunction"
            error.should.match /Cannot create global specifications/
            done()



