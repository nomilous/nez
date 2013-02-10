should   = require 'should'
Realizer = require '../lib/realizer'

describe 'Realizer', ->

    
    it 'contains a reference to all created realizers', (done) ->

        Realizer.realizers.should.be.an.instanceof Object
        done()


    it 'enables creating function realizers', (done) ->

        Realizer.createFunction.fing.args.should.eql [

            { name: 'name' },
            { name: 'object' },
            { name: 'configuration' },
            { name: 'realization' }

        ]

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


                Realizer.createFunction 'newFunction', @thing, {}, realizationCallback
                @thing.newFunction()


            it 'creates reference to the realizable function', (done) ->

                Realizer.createFunction 'newFunction', @thing, {}, ->
                should.exist Realizer.realizers[ "#{@thing.fing.ref}:newFunction" ]
                done()


            it 'has a realization callback stack attached to each realizer', (done) ->

                # 
                # to allow multiple expectation on the same function
                #

                realizationCallback1 = ->
                realizationCallback2 = ->
                Realizer.createFunction 'functionOne', @thing, {}, realizationCallback1
                Realizer.createFunction 'functionOne', @thing, {}, realizationCallback2
                #console.log Realizer.realizers[ "#{@thing.fing.ref}:functionOne" ]
                realizations = Realizer.realizers[ "#{@thing.fing.ref}:functionOne" ].realizations
                #console.log realizations

                realizations[0].should.equal realizationCallback1
                realizations[1].should.equal realizationCallback2
                done()


            it 'has the realizable object for context', (done) ->

                Realizer.createFunction 'functionTwo', @thing, {}, ->

                realizer = Realizer.realizers[ "#{@thing.fing.ref}:functionTwo" ]
                realizer.object.should.equal @thing
                done()


            it 'knows when creating a function on a prototype', (done) ->

                Realizer.createFunction 'function', (class NewClass), {}, ->

                realizer = Realizer.realizers[ "#{NewClass.fing.ref}:function" ]
                realizer.object.fing.type.should.equal 'prototype'
                done()


            xit 'has accumulated a pile of realizations', (done) ->

                console.log JSON.stringify Realizer.realizers, null, 4
                done()


            it 'calls the realization in created order', (done) ->

                object = new (class NewClass)
                count = 0

                Realizer.createFunction 'function', object, {}, (realization) ->

                    realization.args[0].should.equal 'ONE'
                    ++count


                Realizer.createFunction 'function', object, {}, (realization) ->

                    realization.args[0].should.equal 'TWO'
                    (++count).should.equal 2 # should have been called second
                    done()


                object.function('ONE')
                object.function('TWO')

                
            it 'throws AssertionError if too many calls are made to the realizer', (done) ->


                object = new (class NewClass)

                Realizer.createFunction 'function', object, {}, (realization) ->
                Realizer.createFunction 'function', object, {}, (realization) ->

                object.function('ONE')
                object.function('TWO')


                try
                    object.function('THREE')

                catch error
                    error.message.should.match /Unexpected call to/
                    done()




