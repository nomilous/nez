should = require 'should'
Realizers = require '../../lib/objective/realizers'

describe 'Realizers', -> 

    it 'has autospawn option property', (done) -> 

        Realizers.autospawn.should.equal false
        done()

    context 'get()', -> 

        it 'returns a promise', (done) -> 

            Realizers.get().then.should.be.an.instanceof Function
            done()



    context 'update(tokens)', -> 

        it 'returns a promise', (done) -> 

            Realizers.update( {} ).then.should.be.an.instanceof Function
            done()


        it 'loads boundry phrase tokens', (done) -> 

            Realizers.update( 

                '/Objective Title/objective/spec/Spec title': 

                    type: 'tree'
                    uuid: '0'
                    source:
                        type:     'file'
                        filename: 'path/to/realizer.coffee'

             ).then -> 
                
                Realizers.get( 

                    filename: 'path/to/realizer.coffee' 

                ).then (realizer) -> 

                    realizer.token.uuid.should.equal '0'
                    done()
