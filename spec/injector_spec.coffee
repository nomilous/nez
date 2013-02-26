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


        it 'can inject npm installed modules', (done) -> 

            Injector.inject (hound) ->

                hound.should.equal require 'hound'
                done()


        it 'can inject local source modules', (done) ->

            Injector.inject (hound, Node, colors) -> 

                colors.should.equal require 'colors'
                hound.should.equal require 'hound'
                Node.should.equal require '../lib/node'
                done()


        it 'can append injectables', (done) -> 

            Injector.inject [1,2,3], (one, two, three, Objective, fing) -> 

                one.should.equal 1
                two.should.equal 2
                three.should.equal 3

                Objective.should.equal require '../lib/objective'
                fing.should.equal require 'fing'
                done()

        it 'recurses in search of the local module', (done) ->

            Injector.inject (Node, Js) -> 

                Node.should.equal require '../lib/node'
                Js.should.equal require '../lib/exec/dev/js'
                done()


        xit 'has a better mechanism to handle this:'
        it 'throws on duplicate names', (done) ->

            try
                Injector.inject (Nez) -> 

            catch error
                error.should.match /Found more than 1 source for module 'nez'/
                done()


        it 'enables heirarchy - meaning', (what) ->

            Injector.inject [ (->), (-> 'syn'), (-> 'haptein'), '!'], (the, door, mouse, said) ->

                what the door mouse said

                # 
                # http://www.youtube.com/watch?v=R_raXzIRgsA
                # 


                
