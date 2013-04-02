Defaults = require '../lib/defaults'
should   = require 'should'

describe 'Defaults', -> 

    context 'has a default scaffold config for', -> 

        it 'Develop', (done) ->

            Defaults.Develop.should.be.an.instanceof Function
            done()


        it 'SpecRun', (done) ->

            Defaults.SpecRun.should.be.an.instanceof Function
            done()

