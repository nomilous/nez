should   = require 'should'
Injector = require '../lib/injector'

describe 'Injector', ->


    it 'call the function passed as last argument', (thisFunctionWasCalled) -> 

        Injector.realize 'Node', optional: 'thing', ->

            thisFunctionWasCalled()

    it 'can find the absolute path to a module definition by ClassName', (done) ->

        Injector.findModule('Uplink').should.match /\/.*\/lib\/exec\/uplink/
        done()


    it 'injects the prototype of the specified ClassName as arg1', (done) ->  

        Injector.realize 'Node', (Node) -> 

            Node.should.equal require('../lib/node')
            done()

    it 'initializes the test stack', (done) ->

        Injector.realize 'Node', (Node) -> 

            should.exist require('../lib/nez').stack

            done()

    it 'injects the validator as arg2', (done) -> 

        Injector.realize 'Node', (Node, validate) -> 

            validate.should.equal require('../lib/nez').stack.validator
            done()

    it 'injects the test stack assembler as arg3', (done) -> 

        Injector.realize 'Node', (Node, validate, context) -> 

            context.should.equal require('../lib/nez').stack.stacker
            done()


    it 'injects all further args (if downcased) as third party modules/services', (done) -> 

       Injector.realize 'Node', (Node, validate, context, hound, fing, colors) -> 

            hound.should.equal  require 'hound'
            fing.should.equal   require 'fing'
            colors.should.equal require 'colors'
            done()

    it 'injects all further args (if CamelCase) as local modules', (done) ->

        Injector.realize 'Node', (Node, validate, context, hound, Notifier) ->

            Notifier.should.equal require '../lib/notifier'
            done()


    describe 'inject()', ->

        it 'can inject', (done) -> 

            Injector.inject (hound) ->

                hound.should.equal require 'hound'
                done()


        xit 'can append injectables', (done) -> 

            Injector.expect findModule: with: 'four', returning: 4

            Injector.inject [1,2,3], (one, two, three, four) -> 

                three.should.equal 3
                four.should.equal 4

                done()

