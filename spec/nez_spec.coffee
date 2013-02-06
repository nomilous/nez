should = require 'should'
Nez = require '../lib/nez'

describe 'Nez.link()', -> 

    it 'returns pusher(), a function', (done) -> 

        fn = Nez.link 'design'
        fn.should.be.an.instanceof Function
        done()

    it 'enables a rootward edge'

    it 'enables a leafward edge', (done) -> 

        animal = Nez.link 'Animals'

        animal 'Elephant', (properties) ->

            properties.link 'Asian'
            properties.link 'African'

            properties.link.should.be.an.instanceof Function
            done()
