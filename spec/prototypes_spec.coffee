should        = require 'should'
prototypes    = require '../lib/prototypes'
Specification = require '../lib/specification'

describe 'prototypes', ->

    describe 'extends Object.prototype', ->

        prototypes.object.set.expect 'stackName'

        class Test
            constructor: ->
                @tes = 't'

        testTHIS = new Test()

        describe '.expect()', -> 

            it 'is a function', (done) ->

                
                Function.prototype.expect.should.be.an.instanceof Function
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

                 
