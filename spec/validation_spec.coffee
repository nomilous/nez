Validation    = require '../lib/validation'
Expectation   = require '../lib/expectation'
Specification = require('../lib/specification')
should        = require 'should'

describe 'Validation', -> 

    it 'converts Expectations + Realizations into...', (confirmations) -> 

        confirmations()


    it 'is constructed with the expectation', (done) ->

        Validation.fing.args.should.eql [

            { name: 'expectation' }

        ]
        done()


    it 'contains reference to expectation', (done) ->

        expectation = new Expectation (new Object), 'function'
        validation  = new Validation expectation
        validation.expectation.should.equal expectation
        done()


    it 'contains storage for the realization - pending validation', (done) ->

        validation = new Validation (new Expectation (new Object), 'function')
        validation.realization.should.eql {}
        done()


    describe 'creates the realizer', ->

        beforeEach ->

            @object     = new Object
            expectation = new Expectation @object, 'function1'
            @validation  = new Validation expectation


        it 'as a function', (done) ->

            should.exist @object.function1
            done()


        it 'populates the realization with the realized data', (done) ->

            @object.function1('ARG')
            @validation.realization.args[0].should.equal 'ARG'
            done()



    xit 'can validate the Realization against the Expectation', (done) ->

        test = require('../lib/nez').test 'Example'

        test 'Example', (to) ->

            to 'ensure the validation has the Expectation and the Realization', -> 


                #
                # mock a function and call it
                #

                (class Thing).expect mockFunction: with: 2: 'EXPECTED SECOND ARG'
                thing = new Thing
                thing.mockFunction 'ACTUAL ARG 1', 'ACTUAL ARG 2'


                #
                # ensure that action is now validatable
                #

                specification = Specification.objects[ Thing.fing.ref ]
                validation    = specification.confirmations[0].validation


                #
                # it has the expectation
                #

                validation.expectation.with.should.eql 

                    2: 'EXPECTED SECOND ARG'


                #
                # it has the realization
                #

                validation.realization.args.should.eql

                    0: 'ACTUAL ARG 1'
                    1: 'ACTUAL ARG 2'



                done() 


