should = require 'should'
Coffee = require '../../../lib/exec/dev/coffee'


describe 'Coffee', ->

    beforeEach -> 

        @coffee = new Coffee 
        
            srcdir: './src'
            specdir: './spec'



    it 'converts src to spec file name', (done) ->

        @coffee.toSpec( 

            './src/directory/directory/file.coffee'

        ).should.equal './spec/directory/directory/file_spec.coffee'

        done()


    it 'can convert to spec file', (done) ->

        @coffee.toSpec( 

            './src/dir/ectory/class_name.coffee'

        ).should.equal './spec/dir/ectory/class_name_spec.coffee'

        done()


    it 'can klast a specfile', (done) ->

        @coffee.klast(

            './spec/dir/ectory/class_name_spec.coffee'

        ).should.eql 

            path: './spec/dir/ectory/'
            specname: 'class_name_spec.coffee'
            filename: 'class_name.coffee'
            require: '../../../lib/dir/ectory/class_name'
            classname: 'ClassName'

        done()

