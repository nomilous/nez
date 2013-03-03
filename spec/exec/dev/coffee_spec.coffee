should = require 'should'
Coffee = require '../../../lib/exec/dev/coffee'
hound  = require 'hound'


describe 'Coffee', ->

    beforeEach -> 

        @coffee = new Coffee 
        
            srcdir: './src'
            specdir: './spec'


    it 'watches specdir and srcdir dir', (done) ->

        swap = hound.watch
        watched = {}

        hound.watch = (what) -> 
            on: (event, callback)->
                watched[what] = for: event

        @coffee.start()
        hound.watch = swap

        watched['./spec'].should.eql for: 'change'
        watched['./src'].should.eql for: 'change'
        done()

    it 'failes gracefully if spec or src dir are missing', (done) ->

        coffee = new Coffee
            srcdir: './lib'   # eg. js dev (no src)
            specdir: './test'

        try
            coffee.start()

        catch error
            should.not.exist error

        done()


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

    it 'uses a global coffee script compiler if installed'


    it 'uses the local coffee-script compiler', (done) ->

        @coffee.getCompiler().should.match /nez\/node_modules\/\.bin\/coffee/
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

