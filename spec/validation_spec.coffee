Validation    = require '../lib/validation'
Expectation   = require '../lib/expectation'
Specification = require('../lib/specification')
should        = require 'should'

test = require('../lib/nez').test

describe 'Validation', -> 


    it 'validates the entire stack when the walker reaches a validatable leaf'
    

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



    xit 'can validate the Realization against the Expectation for functions', (done) ->

        test 'fuction expectation', (to) ->

            to 'ensure the validation has the Expectation and the Realization', -> 


                #
                # mock a function and call it
                #

                (class Thing).expect mockFunction: with: 1: 'ARG1', 2: 'EXPECTED SECOND ARG'
                thing = new Thing
                thing.mockFunction 'ARG1', 'WRONG SECOND ARG'


                #
                # ensure that action is now validatable
                #

                specification = Specification.objects[ Thing.fing.ref ]
                validation    = specification.confirmations[0].validation


                #
                # it has the expectation
                #

                validation.expectation.with.should.eql 

                    1: 'ARG1'
                    2: 'EXPECTED SECOND ARG'


                #
                # it has the realization
                #

                validation.realization.args.should.eql

                    0: 'ARG1'
                    1: 'WRONG SECOND ARG'


                test done


    xit 'can validate the Realization against the Expectation for properties', (done) ->

        test 'property expectation', (to) ->

            to 'ensure the validation has the Expectation and the Realization', -> 

                (class Thing).expect mockProperty: as: 'set', with: 'EXPECTED VALUE'
                thing = new Thing
                thing.mockProperty = 'WRONG VALUE'

                specification = Specification.objects[ Thing.fing.ref ]
                validation    = specification.confirmations[0].validation

                validation.expectation.with.should.eql 'EXPECTED VALUE'
                validation.realization.args.should.eql 'WRONG VALUE'


                test done


    it 'allows inline mock function definition', (done) ->

        (class Thing).expect mockFunction: (arg) -> 

            arg.should.equal 'THIS'
            done()

        (new Thing).mockFunction 'THIS'


    xit 'validates expected args against realised args', (done) ->

        thing1 = new (class Thing)
        thing1.expect function: with: 1:1, 2:2, 4:4, 6:7

        thing1.function 1, 2, 3, 4, 5, 6

        try
            test done

        catch error

            error.should.match /expected/
            done()


    



