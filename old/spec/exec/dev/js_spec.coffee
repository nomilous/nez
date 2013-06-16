should = require 'should'
Js     = require '../../../lib/exec/dev/js'


describe 'Js', ->

    it 'converts src to spec file name and assumes spec in coffeescript', (done) ->

        js = new Js 

            srcdir: './src'
            specdir: './spec'

        js.toSpec( 

            './src/directory/directory/file.coffee'

        ).should.equal './spec/directory/directory/file_spec.coffee'

        done()

