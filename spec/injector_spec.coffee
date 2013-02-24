should   = require 'should'
Injector = require '../lib/injector'

describe 'Injector', ->


    it 'call the function passed as last argument', (thisFunctionWasCalled) -> 

        Injector.inject 'Node', optional: 'thing', ->

            thisFunctionWasCalled()

    it 'can find the relative path to a module definition by ClassName', (done) ->

        Injector.findModule('Uplink').should.equal '../lib/exec/uplink'
        done()


    xit 'injects the prototype of the specified ClassName as arg1', (done) ->  

        Injector.inject 'Node', (Node) -> 

            Node.should.equal require('../lib/node')
            done()


    xit 'injects the validator as arg2', (done) -> 

        Injector.inject 'Node', (Node, validate) -> 

            validate.should.equal blueprint
            done()

    xit 'injects the test stack assembler as arg3', (done) -> 

        Injector.inject 'Node', (Node, validate, push) -> 

            push.should.equal blueprint
            done()


    xit 'injects all further args as third party modules/services', (done) -> 

       Injector.inject 'Node', (Node, validate, push, hound, fing, colors) -> 

            hound.should.equal  require 'hound'
            fing.should.equal   require 'fing'
            colors.should.equal require 'colors'
            done()
