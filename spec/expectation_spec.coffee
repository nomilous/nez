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

        it 'can be a function name as string', (done) ->

            e = new Expectation (new Object), 'function1'
            e.configuration.function1.should.eql {}
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

            e.configuration.on.should.equal obj
            e.configuration.function1.with.should.equal 'ARG'
            e.configuration.function1.returning.should.equal 'VALUE'
            done()


