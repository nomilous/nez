{defer}      = require 'when'
ChildProcess = require 'child_process'
path         = require 'path'

module.exports.createClass = (opts, messageBus) -> 

    waiting   = {}
    connected = {}

    messageBus.use (msg, next) -> 

        if msg.event == 'connect'  # um? or msg.event == 'reconnect'

            #
            # * realizer sends pid on connect, resolve the corresponding 
            #   conneciton waiting 
            #

            if waiting[msg.pid]?

                {promise, token} = waiting[msg.pid]
                return next() unless token.uuid == msg.uuid

                console.log CONNECT: token.uuid, PID: msg.pid
                connected[msg.pid] = token: token

                token.localPID = msg.pid
                promise.resolve token
                delete waiting[msg.pid]



            else 

                if opts.autospawn

                    #
                    # TODO: perhaps disconnect it 
                    #

                    console.log "autospawn ignored realizer at pid:#{msg.pid}"

        next()

    spawn: (token = {}) ->

        spawning = defer()

        process.nextTick -> 

            return spawning.reject new Error( 

                "Already running realizer at pid: #{token.localPID}"

            ) if token.localPID? 

            return spawning.reject new Error( 

                "Realizer can only spawn local source"

            ) unless (

                token.source? and 
                token.source.type == 'file' and 
                token.source.filename?

            )

            #
            # * spawn the realizer runner and pend the promise into waiting
            #

            runner    = path.normalize __dirname + '/../../node_modules/.bin/realize'
            args      = [ '-p', opts.listening.port]
            args.push '-X' unless opts.listening.transport == 'https'
            args.push token.source.filename

            try process.env['SECRET'] = opts.listen.secret

            child = ChildProcess.spawn runner, args

            console.log SPAWN: token.uuid, PID: child.pid

            waiting[child.pid] = 

                promise: spawning
                token:   token


            child.stderr.on 'data', (data) -> 
            child.stdout.on 'data', (data) -> console.log '------->', data.toString()

            child.on 'exit', (code, signal) -> 

                #
                # TODO: formalize realizer exit codes
                #       - exec/bin_realize.coffee
                #       - src/realization/realize
                #

                if waiting[child.pid]?
                    
                    {promise, token} = waiting[child.pid]
                    promise.reject new Error "Realizer exited with code:#{code}, signal:#{signal}"
                    return

                if connected[child.pid]? 

                    #
                    # TODO: more about disconnecting realizer to be handled
                    #       - the notice hub connection
                    #

                    {token} = connected[child.pid]
                    delete token.localPID
                    delete connected[child.pid]
                    console.log DISCONNECT: token.uuid, PID: child.pid, code: code, signal: signal
                    return



        spawning.promise
