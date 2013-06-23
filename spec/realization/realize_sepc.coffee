should  = require 'should'
realize = require '../../lib/realization/realize'
ipso    = require 'ipso'
 
describe 'realize', -> 

    it 'validates via ipso.validate()', (done) -> 

        spy = ipso.validate
        ipso.validate = -> ipso.validate = spy; done()
        realize()
