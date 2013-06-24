should    = require 'should'
Realizers = require '../lib/realizers'
core      = require 'nezcore'
Notice    = require 'notice'

describe 'realizers', ->

    LISTENING     = {}
    Notice.listen = (title, opts, callback) -> 

        LISTENING['listen'] = opts

                                  #
                                  # pending integrations
                                  #


                                  #
                                  #  
                                  # Notice attaches ref to listening address once
        opts.listening =   {}     # the hub is up, this stub needs to mimic that
                                  # behaviour
                                  # 
                                  # 

                                  # 
                                  # 
                                  # Notice calls back with middleware pipeline
        callback null,     {}     # attached to the remote notifiers
                                  # 
                                  # 
                                  # 

    CONTEXT       = 
        listen: 'LISTENSPEC'
        tools: spawn: ->

    realizers     = undefined

    before (done) -> 

        #
        # Realizers is an async factory class, it calls back with
        # the assembled realizers collection
        #

        Realizers CONTEXT, {}, (err, result) -> 

            realizers = result
            done()


    context 'listens', -> 

        it 'for realizers', (done) -> 

            LISTENING.listen.listen.should.equal 'LISTENSPEC'
            done()


    context 'task(title, ref)', -> 

        it 'emits a task to a realizer', (done) -> 

            spy = realizers.get
            realizers.get = (ref, callback) -> 
                realizers.get = spy

                #
                # mock the getting of the realizer
                # by returning a realize with spy
                # on the call to task
                #

                callback null, 

                    task: (title) -> 

                        title.should.equal 'The Frabjous Day'
                        done()


            realizers.task 'The Frabjous Day'


        it 'can get more minerals', (done) -> 

            spy = realizers.get
            realizers.get = (ref, callback) -> 
                realizers.get = spy
                callback null, task: -> done()

            realizers.task 'get more minerals', 

                match: 'miners/group3/*'
                scroll: 'to corner of map'
                location: 'CL!CK'
                'huh?': 'https://github.com/nomilous/nez/tree/develop/.metadata/.metadata/.metadata/.metadata/.metadata/.metadata/.metadata/.metadata/.metadata'

            

    context 'get( ref, callback )', -> 

        #
        # gets reference to an attached realizer
        #

        it 'requires a realizer id', (done) -> 

            try realizers.get()
            catch error 

                error.should.match /realizers.get\(ref, callback\) requires ref.id as the realizer id/
                done()


        it 'callback missing realizer if not present', (done) -> 

            realizers.get id: 'ID', (error, realizer) -> 

                error.should.match /missing realizer/
                done()


        context 'can spawn the realizer', -> 

            it 'if opts.script is specified', (done) -> 

                CONTEXT.tools.spawn = -> 
                    CONTEXT.tools.spawn = ->
                    done()

                CONTEXT.hub = listening: {}

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



