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

        push 'node', ->

            describe '.expect()', -> 

                it 'is a function', (done) ->

                    prototypes.object.set.expect 'stackName'
                    Function.prototype.expect.should.be.an.instanceof Function
                    done()


                it 'pushes pending confirmations into the current node', (done) ->

                    push 'node', ->

                        testTHIS.expect thisFunction: with: 'args'

                        current = require('../lib/nez').stacks['stackName'].node.edges
                        current[0].fing.name.should.equal 'Confirmation'
                        console.log "TODO: finish this test once the Confirmation is identifiable" 
                        done()
                        
                      
                it 'supports multiple inline expectations', (done) ->

                    push 'node', ->

                        class Test

                        Test.expect
                            function1: with: 'ARG'
                            function2: with: 1:'arg1', 5:'arg5'

                        current = require('../lib/nez').stacks['stackName'].node.edges
                        current[0].fing.name.should.equal 'Confirmation'
                        current[1].fing.name.should.equal 'Confirmation'
                        console.log "TODO: finish this test once the Confirmation is identifiable" 

                        done()
                     
