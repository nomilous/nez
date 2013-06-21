should    = require 'should'
objective = require '../../lib/objective/objective'
notice    = require 'notice'
eo        = require 'eo'

notice.listen = (hubName, opts, cb) -> cb()

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

    xit 'accepts options object as second arg', (done) -> 

        objective 'title', key: 'value', ->
        done()


    it 'starts a notice hub listening for realizers', (done) -> 

        notice.listen = (hubName, opts, cb) -> done()
        objective 'title', key: 'value', ->


    it 'attaches tools onto the context', (done) -> 

        notice.listen = (hubName, opts, cb) -> 
            opts.tools.should.equal require '../../lib/tools'
            done()

        objective 'title', key: 'value', -> 





