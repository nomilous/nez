should    = require 'should'
objective = require '../lib/objective'

describe 'objective', -> 

    it 'expects a title', (done) -> 

        try objective()
        catch error
            error.should.match /objective\(title, opts, fn\) requires title as string/
            done()

    it 'expects a function as last arg', (done) -> 

        try objective 'title'
        catch error
            error.should.match /objective\(title, opts, fn\) requires function as last argument/
            done()

    it 'accepts options object as second arg', (done) -> 

        objective 'title', key: 'value', -> done()

