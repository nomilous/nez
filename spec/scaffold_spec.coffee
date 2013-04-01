should   = require 'should'
Scaffold = require '../lib/scaffold'

describe 'Scaffold', -> 

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

    it 'requires injectable as arg3 function', (done) -> 

        try
            
            new Scaffold 'LABEL', {}

        catch error

            error.should.match /Scaffold requires injectable function arg3/
            done()
