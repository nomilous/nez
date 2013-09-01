should    = require 'should'
Develop   = require '../../lib/defaults/develop'
Objective = require '../../lib/objective/objective' 
fs        = require 'fs'

describe 'Develop', -> 

    before -> @dev = new Develop

    it 'is an Objective', (done) -> 

        @dev.should.be.an.instanceof Objective
        done()

    it 'allows async config of phrase opts', (done) -> 

        @dev.configure ( opts = {} ), -> 

            opts.should.eql boundry: ['spec', 'test']
            done()


    it 'handles phrase boundry assembly', (done) -> 

        @dev.onBoundryAssemble {}, -> done()


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

                    opts: 
                        uuid: 'UUID'
                        other: 'stuff'

                    fn: phrase.fn

                phrase.fn().should.equal 'ok,good.'
                done()
