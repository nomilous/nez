should     = require 'should'
prototypes = require '../lib/prototypes'

describe 'prototypes', ->

    describe 'extends Object.prototype', ->



        describe '.expect()', -> 


            it 'is a function', (done) ->

                prototypes.object.set.expect()
                Function.prototype.expect.should.be.an.instanceof Function
                done()


            it 'enables setting function call expectations', (done) ->

                done()



        describe 'expectSet()', ->

            it 'is a function', (done) ->

                prototypes.object.set.expectSet()
                Function.prototype.expectSet.should.be.an.instanceof Function
                done()

            it 'enables placing property setting expectations'



        describe 'expectGet()', ->

            it 'is a function', (done) ->

                prototypes.object.set.expectGet()
                Function.prototype.expectGet.should.be.an.instanceof Function
                done()

            it 'enables placing property getting expectations'

