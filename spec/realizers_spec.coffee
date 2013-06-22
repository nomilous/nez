should    = require 'should'
Realizers = require '../lib/realizers'
core      = require 'nezcore'
Notice    = require 'notice'

describe 'realizers', -> 

    Notice.listen = (title, opts, callback) -> callback null, opts
    CONTEXT       = tools: spawn: ->
    realizers     = undefined

    before (done) -> 

        #
        # Realizers is an async factory class, it calls back with
        # the assembled realizers collection
        #

        Realizers CONTEXT, {}, (err, result) -> 

            realizers = result
            done()        



    context 'get( opts )', -> 


        it 'requires a realizer id', (done) -> 

            try realizers.get()
            catch error 

                error.should.match /realizers.get\(opts, callback\) requires opts.id as the realizer id/
                done()


        it 'callback missing realizer if not present', (done) -> 

            realizers.get id: 'ID', (error, realizer) -> 

                error.should.match /missing realizer/
                done()


        context 'can spawn the realizer', -> 

            it 'if opts.script is specified', (done) -> 

                #
                # only coffee
                #

                CONTEXT.tools.spawn = -> 
                    CONTEXT.tools.spawn = ->
                    done()

                realizers.get 

                    id: 'ID'
                    script: 'SCRIPT.coffee'
                    (error, realizer) -> 

            it 'if opts.script is coffee-script', (done) -> 

                realizers.get 

                    id: 'ID'
                    script: 'SCRIPT.js'
                    (error, realizer) -> 

                        error.should.match /nez supports only coffee-script realizers/
                        done()

