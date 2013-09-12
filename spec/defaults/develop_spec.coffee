should    = require 'should'
Develop   = require '../../lib/defaults/develop'
Objective = require '../../lib/objective/objective' 
fs        = require 'fs'

describe 'Develop', -> 

    before -> @dev = new Develop

    it 'is an Objective', (done) -> 

        @dev.should.be.an.instanceof Objective
        done()

    it 'allows async config of default phrase opts', (done) -> 

        @dev.configure ( opts = {} ), -> 

            opts.should.eql 
                boundry: ['spec']
                src: 
                    directory: 'src'
                    match:   /\.coffee$/
                autospawn: true
                autospec: true

            done()

    it 'defaults objective phraseFn to link to spec directory', (done) ->

        @dev.defaultObjective link: (opt) -> 

            opt.should.eql directory: 'spec'
            done() 


    it 'handles phrase boundry assembly', (done) -> 

        @dev.onBoundryAssemble {}, -> done()


    context 'toSpecFilename()', -> 

        it 'converts src filename to spec filename', (done) -> 

            specFile = @dev.toSpecFilename 'src/path/file_name.coffee'
            specFile.should.equal 'spec/path/file_name_spec.coffee'
            done()


    context 'onBoundryAssemble()', -> 

        it 'loads the realizer into phrase format', (done) -> 

            #
            # ie.  phrase 'Title', {op:'tions'}, fn = ->
            #

            fs.readFileSync = -> return """

                title: 'Test'
                uuid:  'UUID'
                other: 'stuff'
                realize: (it) -> 'ok,good.'

            """

            @dev.onBoundryAssemble filename: 'something.coffee', (error, phrase) -> 

                phrase.should.eql

                    title: 'Test'

                    control: 
                        uuid: 'UUID'
                        other: 'stuff'

                    fn: phrase.fn

                phrase.fn().should.equal 'ok,good.'
                done()


