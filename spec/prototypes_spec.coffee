should        = require 'should'
prototypes    = require '../lib/prototypes'
Specification = require '../lib/specification'

require 'fing'

describe 'prototypes', ->

    describe 'extends Object.prototype', ->

        prototypes.object.set.expect 'stackName'
        prototypes.object.set.mock()

        class Test
            constructor: ->
                @tes = 't'

        testTHIS = new Test()

        describe '.expect()', -> 

            it 'is a property that returns a function', (done) ->
                
                Object.expect.should.be.an.instanceof Function
                done()


            it 'thows on more than one arg', (done) ->

                    try
                        Object.expect '', ""
                    catch error
                        error.should.match /Malformed expectation config/
                        done()



            it 'creates specifications', (done) ->

                swap1 = Specification.create
                swap2 = Specification.getNode
                Specification.getNode = -> edges: []
                Specification.create = (object, configuration) ->

                    object.should.equal testTHIS
                    configuration.should.eql

                        expectation: 
                            thisFunction: 
                                with: 'args'

                    Specification.create = swap1
                    Specification.getNode = swap2
                    done()

                testTHIS.expect thisFunction: with: 'args'
                    
                  
            it 'supports multiple inline expectations', (done) ->

                class Test
                count = 0

                swap1 = Specification.create
                swap2 = Specification.getNode
                Specification.getNode = -> edges: []
                Specification.create = (object, configuration) ->

                    object.should.equal Test
                    if ++count == 2

                        #
                        # test second calls config
                        #

                        configuration.should.eql
                            expectation: 
                                function2: 
                                    with: 1:'arg1', 5:'arg5'

                        Specification.create = swap1
                        Specification.getNode = swap2
                        done()


                Test.expect

                    function1: with: 'ARG'
                    function2: with: 1:'arg1', 5:'arg5'

                 
        describe '.mock()', ->


            it 'is a property that returns a function', (done) ->

                Object.mock.should.be.an.instanceof Function
                done()


            it 'thows on missing arg1 as MockClass', (done) ->

                try
                    Object.mock {}
                catch error
                    error.should.match /Malformed mock config/
                    done()


            it 'returns an instance of MockClassName with configured expectations', (done) ->

                swap = Specification.getNode
                Specification.getNode = -> edges: []
                thing = Object.mock 'MockClassName', functionName: returning: 'VALUE'
                Specification.getNode = swap

                thing.fing.name.should.equal 'MockClassName'
                thing.fing.type.should.equal 'instance'

                thing.functionName().should.equal 'VALUE'
                done()

