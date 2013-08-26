should    = require 'should'
nez       = require '../../lib/nez'

describe 'Objective', -> 

    beforeEach -> 

        @objective = new nez.Objective

    it 'is a class', (done) -> 

        @objective.should.be.an.instanceof nez.Objective
        done()


    context 'startMonitor( opts, tokens, emitter )', -> 

        it 'throws undefined override', (done) -> 

            try @objective.startMonitor {}, {}, (token, args...) -> 

            catch error

                error.should.match /undefined override/
                done()


        it 'receives tokens from the objective phrase tree', (done) -> 

            #
            # spy on the prototpe
            #

            nez.Objective.prototype.startMonitor = (opts, tokens, tokenEmitter) -> 

                should.exist tokens['/Triplet Primes/objective/just/because ~ 301']
                done()

   
            nez.objective

                title: 'Triplet Primes'
                uuid:  'UUID'
                description: ''

                (just) ->

                    for triple in [[5, 7, 11], [7, 11, 13], [11, 13, 17], [13, 17, 19], [17, 19, 23], [37, 41, 43], [41, 43, 47], [67, 71, 73], [97, 101, 103], [101, 103, 107], [103, 107, 109], [107, 109, 113], [191, 193, 197], [193, 197, 199], [223, 227, 229], [227, 229, 233], [277, 281, 283], [307, 311, 313], [311, 313, 317], [347, 349, 353]]

                        do (triple) -> just "because ~ #{  triple.reduce (a,b) -> a + b }", (end) ->
