{defer}      = require 'when'
ChildProcess = require 'child_process'
path         = require 'path'

module.exports.createClass = (opts, messageBus) -> 

    waiting = {}

    messageBus.use (msg, next) -> 

        if msg.context.title == 'realizer::connect'

            #
            # * realizer sends pid on connect, resolve the corresponding 
            #   conneciton waiting 
            #

            if waiting[msg.pid]?

                {promise, token} = waiting[msg.pid]
                return next() unless token.uuid == msg.uuid

                token.localPID = msg.pid
                promise.resolve token
                delete waiting[msg.pid]

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
