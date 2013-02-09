should        = require 'should'
prototypes    = require '../lib/prototypes'
Specification = require '../lib/ospecification'

describe 'prototypes', ->

    describe 'extends Object.prototype', ->

        class Test
            constructor: ->
                @tes = 't'

        testTHIS = new Test()
        push = require('../lib/nez').test 'stackName'

        describe '.expect()', -> 

            it 'is a function', (done) ->

                prototypes.object.set.expect 'stackName'
                Function.prototype.expect.should.be.an.instanceof Function
                done()


            it 'calls Specification.create with an expectation configuration', (done) ->

                push 'node', ->

                    swap = Specification.create
                    Specification.create = (opts) -> 

                        #
                        # test expectation creation
                        #

                        expectation = opts.expectation
                        expectation.object.should.equal testTHIS
                        expectation.opts.thisFunction.with.should.equal 'args'
                      
                        Specification.create = swap 
                        done()


                    #
                    # set expectation
                    #

                    testTHIS.expect thisFunction: with: 'args'
                    
                    
                 
