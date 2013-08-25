should    = require 'should'

describe 'realizers', ->














#should    = require 'should'
#Realizers = require '../lib/realizers'
#core      = require 'nezcore'
#Notice    = require 'notice'
#tasks     = require('does').tasks 
#
#describe 'realizers', ->
#
#
#    CONTEXT  = {} 
#    INFO     = undefined
#    BADEVENT = undefined
#    NOTICE   = 
#        info: -> INFO = arguments
#        event: 
#            bad:-> BADEVENT = arguments
#
#    MIDDLEWARE    = undefined
#    Notice.listen = (title, opts, callback) -> 
#
#        #
#        # stub Notice networkings
#        # -----------------------
#        # 
#        # callback with connected notifer 
#        # (as would happen when a realizer connects)
#        #
#
#        callback null, 
#
#            #
#            # stub notice middleware registrar
#            # 
#
#            use: (fn) -> MIDDLEWARE = fn
#
#
#    context 'provides api to realizer collection', -> 
#
#        it 'defines start()', (done) -> 
#
#            Realizers CONTEXT, NOTICE, (error, api) -> 
#
#                api.start.should.be.an.instanceof Function
#                done()
#
#        it 'defines get()', (done) -> 
#
#            Realizers CONTEXT, NOTICE, (error, api) -> 
#
#                api.get.should.be.an.instanceof Function
#                done()
#
#
#    context 'handle realizers registering', -> 
#
#        it 'creates a task to encapsulate the remote realizer', (done) -> 
#
#            REPLY_FUNCTION = -> 
#
#            mock = tasks.task
#            tasks.task = (opts) -> 
#                tasks.task = mock
#
#                opts.uuid.should.equal 'REALIZER_UUID'
#                opts.otherProperty.should.equal 'VALUE'
#
#                #
#                # task is created with the messenger pipeline
#                # attached to the remote realizer process
#                #
#
#                opts.notice.should.equal REPLY_FUNCTION
#                done()
#
#            Realizers CONTEXT, NOTICE, (error, api) -> 
#
#                #
#                # send fake realizer registration to the
#                # middleware
#                # 
#
#                MIDDLEWARE 
#                    context:
#                        title: 'realizer::register'
#                    properties: 
#                        uuid: 'REALIZER_UUID'
#                        otherProperty: 'VALUE'
#                    reply: REPLY_FUNCTION
#                    ->
#
#    context 'api', -> 
#
#        beforeEach (done) -> 
#
#            @SPAWNED = []
#            @REPLY_FUNCTION = ->
#            @CHECKSUM = 'cc'
#            @KILLED = undefined
#            CONTEXT  = 
#
#                #
#                # objective runs a notice hub and populates context with 
#                # the listening port, fake it
#                #
#
#                listening: 
#                    transport: 'http'
#                    address: '127.0.0.1'
#                    port: 64653
#
#                tools: 
#
#                    #
#                    # get(opts) can spawn the realizer script if 
#                    # not registered and opts.script is defined
#                    #
#
#                    spawn: (notice, args, callback) => 
#                        @SPAWNED = arguments
#
#                        #
#                        # callback a fake child process
#                        #
#
#                        callback null, 
#                            pid: 'SPAWNED_PID'
#                            kill: => @KILLED = args.arguments[0]
#                            stdout: 
#                                on: ->
#
#                    #
#                    # get(opts) that refers to a spawned realizer 
#                    # will respawn the realizer if the script checksum
#                    # changed
#                    #
#
#                    checksum: 
#                        file: => @CHECKSUM
#
#
#            Realizers CONTEXT, NOTICE, (error, @api) => 
#
#                MIDDLEWARE 
#                    context:
#                        title: 'realizer::register'
#                    properties: 
#                        uuid: 'REGISTERED_REALIZER_UUID'
#                        otherProperty: 'VALUE'
#                    reply: @REPLY_FUNCTION
#                    ->
#                
#                done()
#
#
#        context 'get()', -> 
#
#            it 'callsback with if the realizer is not present (has not registered)', (done) -> 
#
#                    @api.get uuid: 'MISSING_REALIZER_UUID', (err, realizer) -> 
#
#                        err.should.match /missing realizer/
#                        done()
#
#            it 'calls back with the realizer', (done) -> 
#
#                @api.get uuid: 'REGISTERED_REALIZER_UUID', (err, realizer) -> 
#
#                    realizer.uuid.should.equal 'REGISTERED_REALIZER_UUID'
#                    should.exist realizer.running
#                    done()
#
#
#            it 'spawns the realizer if opts.script is specified', (done) -> 
#
#                process.nextTick =>
#
#                    @SPAWNED[1].arguments.should.eql ['FILENAME.coffee']
#                    done()
#
#                @api.get 
#
#                    uuid: 'SPAWN_THIS_REALIZER'
#                    script: 'FILENAME.coffee'
#
#                    (err, realizer) -> 
#
#
#            it 'does not spawn a second instance if still waiting for the first to register', (done) -> 
#
#                @api.get 
#
#                    uuid: 'SPAWN_THIS_REALIZER'
#                    script: 'FILENAME.coffee'
#
#                    (err, realizer) -> 
#
#                process.nextTick =>
#
#                    @api.get 
#
#                        uuid: 'SPAWN_THIS_REALIZER'
#                        script: 'FILENAME.coffee'
#
#                        (err, realizer) -> 
#
#                process.nextTick -> 
#
#                    INFO.should.eql 
#
#                        '0': 'already waiting for realizer'
#                        '1': description: "pid:SPAWNED_PID, script:FILENAME.coffee"
#
#                    done()
#
#
#
#            it 'respawns if the script checksum changed', (done) ->
#
#                @api.get 
#
#                    uuid: 'SPAWN_ANOTHER_REALIZER'
#                    script: 'FILENAME.coffee'
#
#                    (err, realizer) -> 
#
#                #
#                # fake the remote realizer registering
#                #
#
#                MIDDLEWARE 
#                    context:
#                        title: 'realizer::register'
#                    properties: 
#                        uuid: 'SPAWN_ANOTHER_REALIZER'
#                        otherProperty: 'VALUE'
#                    reply: @REPLY_FUNCTION
#                    ->
#
#                process.nextTick => 
#
#                    @SPAWNED  = undefined
#                    @CHECKSUM = 'dd'
#
#                    @api.get 
#
#                        uuid: 'SPAWN_ANOTHER_REALIZER'
#                        script: 'FILENAME.coffee'
#                        (err, realizer) -> 
#
#                process.nextTick => 
#
#                    @KILLED.should.equal 'FILENAME.coffee'
#                    @SPAWNED[1].arguments[0].should.equal 'FILENAME.coffee'
#                    done()
#                    
#            it 'kills changed script a more gracefully - perhaps via notifier'
#
#
#        context 'start()', -> 
#
#            it 'calls to get() the realizer from the collection', (done) -> 
#
#                spy = @api.get
#                @api.get = => 
#                    @api.get = spy
#                    done()
#
#                @api.start uuid: 'REALIZER_UUID'
#
#            it 'returns a promise', (done) -> 
#
#                spy = @api.get
#                @api.get = => 
#                    @api.get = spy
#
#                @api.start( uuid: 'REALIZER_UUID' ).then.should.be.an.instanceof Function
#                done()
#
#
#            it 'the promise is rejected if the realizer could not be gotten', (done) -> 
#
#                spy = @api.get
#                @api.get = (opts, callback) => 
#                    @api.get = spy
#                    process.nextTick -> 
#
#                        callback new Error 'a problem'
#
#                @api.start( uuid: 'REALIZER_UUID', script: 'SCRIPT.coffee' ).then(
#
#                    (result) ->
#                    (error)  => 
#                        error.should.match /a problem/
#                        
#                        #
#                        # and notifies
#                        #
#
#                        BADEVENT[0].should.equal 'missing or broken realizer'
#                        BADEVENT[1].realizer.should.equal 'REALIZER_UUID'
#                        BADEVENT[1].script.should.equal 'SCRIPT.coffee'
#                        BADEVENT[1].error.should.match /a problem/
#                        done()
#
#                )
#
#
#            it 'passes opts to the realizer.start()', (done) -> 
#
#                spy = @api.get
#                @api.get = (opts, callback) => 
#                    @api.get = spy
#                    callback null, start: (opts) -> 
#                        opts.key.should.equal 'VALUE' 
#                        done()
#                        return then: ->
#
#                @api.start 
#                    uuid: 'REALIZER_UUID'
#                    key: 'VALUE' 
#
#
#            it 'calls realizer.start() and binds the resulting promise', (done) -> 
#
#                spy = @api.get
#                @api.get = (opts, callback) => 
#                    @api.get = spy
#                    callback null, 
#
#                        #
#                        # realizer is a task, calling start returns a promise
#                        #
#
#                        start: -> 
#
#                            then: (onResolve, onError, onStatus) -> 
#
#                                #
#                                # fake a status update from the realizer
#                                #
#
#                                onStatus 'UPDATE'
#
#
#                @api.start( uuid: 'REALIZER_UUID' ).then(
#
#                    (resolve) -> 
#                    (error)   -> 
#                    (status)  -> 
#
#                        status.should.equal 'UPDATE'
#                        done()
#
#                )
#
#
#
#            it 'handles the calling of start() when already running'
#