Defaults = require '../lib/defaults'
should   = require 'should'

describe 'Defaults', -> 

    context 'has a default scaffold config for', -> 

        it 'Develop as an objective', (done) ->

            Defaults.Develop.should.be.an.instanceof Function

            Defaults.Develop null, null, (error, config) -> 

                should.exist config._objective
                done() 
                


        it 'SpecRun as a realizer', (done) ->

            Defaults.SpecRun.should.be.an.instanceof Function

            Defaults.SpecRun null, null, (error, config) -> 

                should.exist config._realizer
                done()

