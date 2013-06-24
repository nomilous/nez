should  = require 'should'
realize = require '../../lib/realization/realize'
ipso    = require 'ipso'
Notice  = require 'notice'
 
describe 'realize', -> 

    it 'validates via ipso.validate()', (done) -> 

        spy = ipso.validate
        ipso.validate = -> 
            ipso.validate = spy
            throw 'run no further'
        
        try realize()
        catch error 
            error.should.match /run no further/
            done()


    it 'connects to an objective', (done) -> 

        spy = Notice.connect
        Notice.connect = (title, opts, callback) -> 
            Notice.connect = spy
            opts.connect.should.equal 'CONNECTSPEC'
            done()

        realize 'this', connect: 'CONNECTSPEC', ->

