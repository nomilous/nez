should     = require 'should'
prototypes = require '../lib/prototypes'

describe 'prototypes', ->

    describe 'extends Object.prototype', ->

        test = new (class Test)
        push = require('../lib/nez').test 'stackName'

        push 'grand parent', (push1) ->

            push1 'parent', (push2) ->

                push2 'sibling'

                describe '.expect()', -> 

                    it 'is a function', (done) ->

                        prototypes.object.set.expect 'stackName'
                        Function.prototype.expect.should.be.an.instanceof Function
                        done()


                    xit 'it pushes expectations into the current node', (done) ->
                 

