should   = require 'should'
Scaffold = require '../lib/scaffold'

describe 'Scaffold', ->

    context 'async config lookup', -> 

        it 'enables an ENV based config lookup', (done) -> 

            process.env.NODE_ID        = 'ID'
            process.env.NODE_ABILITIES = 'sing juggle'

            new Scaffold 'LABEL', 

                _as: (id, abilities, callback) -> 

                    id.should.equal 'ID'
                    abilities.should.eql ['sing','juggle']
                    done()

                -> 


    context 'validate()', ->  

        it 'requires label as arg1 string', (done) -> 

            try  
                new Scaffold
            catch error
                error.should.match /Scaffold requires 'label' string as arg1/
                done()

        it 'requires config as arg2 object', (done) -> 

            try
                new Scaffold 'LABEL'
            catch error
                error.should.match /Scaffold requires config hash as arg2/
                done()

        it 'requires behaviour definition in config._as', (done) -> 

            try
                new Scaffold 'LABEL', {}
            catch error
                error.should.match /Scaffold requires behaviour definition in config._as/
                done()

        it 'requires specified default factory to exist', (done) -> 

            try
                new Scaffold 'LABEL', as: 'Thing' 
            catch error
                error.should.match /Scaffold as 'Thing' is not defined/
                done()

        it 'requires injectable as arg3 function', (done) -> 

            try
                new Scaffold 'LABEL', as: 'Develop'
            catch error
                error.should.match /Scaffold requires injectable function arg3/
                done()
