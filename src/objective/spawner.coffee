{defer}      = require 'when'
ChildProcess = require 'child_process'
path         = require 'path'

module.exports.createClass = (opts, messageBus) -> 

    waiting = {}

    messageBus.use (msg, next) -> 

        if msg.context.title == 'realizer::connect'

            console.log HANDLE_CONNECT: msg.content

        next()

    spawn: (token = {}) ->

        spawning = defer()

        process.nextTick -> 

            return spawning.reject new Error( 

                "Already running realizer at pid: #{token.pid}"

            ) if token.pid? 

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

            runner    = path.normalize __dirname + '/../../bin/realize'
            args      = [ '-c', '-p', opts.listening.port]
            args.push '-X' unless opts.listening.transport == 'https'
            args.push token.source.filename

            child = ChildProcess.spawn runner, args

            child.stderr.on 'data', (data) -> 
            child.stdout.on 'data', (data) -> 

            waiting[child.pid] = 

                promise: spawning
                token:   token

        spawning.promise
