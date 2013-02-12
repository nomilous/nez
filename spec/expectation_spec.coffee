should      = require 'should'
Expectation = require '../lib/expectation'
require 'fing'

describe 'Expectation', -> 

    it 'is constructed with object and configuration', (done) ->

        Expectation.fing.args.should.eql [

            { name: 'object' },
            { name: 'configuration' }

        ]
        done()

    describe 'validates the configuration - ', ->

        it 'cannot be null', (done) ->

            try
                e = new Expectation (new Object)

            catch error
                error.message.should.equal 'undefined Expectation configuration'
                done()


        it 'should be an object (hash)', (done) ->

            try
                e = new Expectation (new Object), []

            catch error
                error.message.should.equal 'Array not a valid Expectation configuration'
                done()
          
        it 'should contain only one toplevel key', (done) ->

            try
                e = new Expectation (new Object), 
                    newFunction: {}
                    newFunction2: {}

            catch error
                error.message.should.equal 'Multiple key hash not a valid Expectation configuration'
                done()


        it 'exposes configuration', (done) ->

            obj = new Object
            e = new Expectation obj, function1: with: 'ARG', returning: 'VALUE'

            e.on.should.equal obj
            e.with.should.equal 'ARG'
            e.returning.should.equal 'VALUE'
            done()


        it 'marshals the expectation configuration', (done) ->

            basic = new Expectation (new Object), 'function1'
            mock = new Expectation (new Object), function2: returning: 'VALUE'
            spy = new Expectation  (new Object), function3: as: 'spy', with: 'ARG'
            get = new Expectation  (new Object), property1: as: 'get', returning: 'VALUE'
            set = new Expectation  (new Object), property2: as: 'set', with: 'VALUE'

            basic.realizerName.should.equal 'function1'
            basic.realizerCall.should.equal 'createFunction'
            basic.realizerType.should.equal 'mock'

            mock.realizerName.should.equal 'function2'
            mock.realizerCall.should.equal 'createFunction'
            mock.realizerType.should.equal 'mock'

            spy.realizerName.should.equal 'function3'
            spy.realizerCall.should.equal 'createFunction'
            spy.realizerType.should.equal 'spy'

            get.realizerName.should.equal 'property1'
            get.realizerCall.should.equal 'createProperty'
            get.realizerType.should.equal 'get'

            set.realizerName.should.equal 'property2'
            set.realizerCall.should.equal 'createProperty'
            set.realizerType.should.equal 'set'

            done()

        it 'sets the mock substitute function if defined', (done) ->

            sub = ->
            expectation = new Expectation (new Object), mockedFunction: sub
            expectation.substitute.should.equal sub
            done()  

