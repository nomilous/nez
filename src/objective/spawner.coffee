{defer} = require 'when'
spawn   = require('child_process').spawn
path    = require 'path'

module.exports.createClass = (opts, messageBus) -> 

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

            runner    = path.normalize __dirname + '/../../bin/realize'
            args      = [ '-c', '-p', opts.listening.port]
            args.push '-X' unless opts.listening.transport == 'https'
            args.push token.source.filename

            process = spawn runner, args

            token.pid = process.pid

            #
            # TODO: handle spawn error / exit
            # 

            spawning.resolve token

        spawning.promise
