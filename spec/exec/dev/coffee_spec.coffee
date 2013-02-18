should = require 'should'
Coffee = require '../../../lib/exec/dev/coffee'


describe 'Coffee', ->

    it 'converts src to spec file name', (done) ->

        coffee = new Coffee 

            srcdir: './src'
            specdir: './spec'

        coffee.toSpec( 

            './src/directory/directory/file.coffee'

        ).should.equal './spec/directory/directory/file_spec.coffee'

        done()


    it 'converts app to spec file name', (done) ->

        coffee = new Coffee 
        
            srcdir: './app'
            specdir: './spec'

        coffee.toSpec( 

            './app/directory/directory/file.coffee'

        ).should.equal './spec/directory/directory/file_spec.coffee'

        done()
