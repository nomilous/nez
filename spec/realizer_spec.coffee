should   = require 'should'
Realizer = require '../lib/realizer'

describe 'Realizer', ->

    
    it 'contains a reference to all created realizers', (done) ->
        Realizer.realizers.should.be.an.instanceof Object
        done()




    describe 'creates an interface to Realization ', -> 

        beforeEach -> 


            class Thing
                #
                # A test class
                #
                existingFunction: (arg1, arg2) -> 
                    "-> #{arg1},#{arg2} <-"

            #
            # A test instance 
            #
            @thing = new Thing()


        describe 'as a function that', ->


            it 'is actually created', (done) ->

                Realizer.createFunction 'newFunction', @thing
                @thing.newFunction.should.be.an.instanceof Function
                done()


            it 'calls realization() when the function is fired', (done) ->

                realizationCallback = ->

                    done() # will timeout test unless the callback is fired


                Realizer.createFunction 'newFunction', @thing, realizationCallback
                @thing.newFunction()



