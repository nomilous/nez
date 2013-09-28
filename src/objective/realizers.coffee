#
# Realizers Collection (factory)
# ==============================
# 
# 
#

{defer}         = require 'when'
{EventEmitter}  = require 'events'
SpawnerFactory  = require './spawner'

module.exports.createClass = (classOpts, messageBus) -> 

    realizers    = {}
    fromfilename = {}
    emitter      = new EventEmitter

    messageBus.use (msg, next) -> 

        unless uuid = msg.uuid

            if msg.event.match /^phrase/

                #
                # TODO: (later) - assemble objective-side clone of remote 
                #                 realizer phrase tree for metric store
                #                 and persistance
                # 

                # 
                console.log 'ignoring remote phrase tree activity:', msg.event
                # 
                # ignoring remote phrase tree activity: phrase::recurse:start
                # ignoring remote phrase tree activity: phrase::edge:create
                #                                       ...
                #                                       ...
                #                                       ...
                # ignoring remote phrase tree activity: phrase::edge:create
                # ignoring remote phrase tree activity: phrase::recurse:end
                # 

            else

                console.log 'ignoring other stuff i may have forgotten about: ', msg.content

            return next()

        switch msg.event

            when 'connect', 'reconnect'

                realizers[uuid] ||= {}

                if realizers[uuid].connected

                    #
                    # * Assign realizer messenger
                    # 
                    #   TODO: consider support for more than one instance of
                    #         a realizer, keying on uuid will not suffice in
                    #         that case
                    #

                    responder = msg.context.responder
                    return responder.event.bad 'reject',
                        reason: "realizer:#{uuid} already running @ #{realizers[uuid].pid}.#{realizers[uuid].hostname}"


                realizers[uuid].notice = try msg.context.responder
                realizers[uuid].connected = true
                realizers[uuid].pid       = msg.pid
                realizers[uuid].hostname  = msg.hostname

                emitter.emit msg.event, realizers[uuid]

                realizers[uuid].notice.use (msg, next) -> 
                    if msg.event == 'disconnect'    
                        realizers[uuid].connected = false
                        emitter.emit msg.event, realizers[uuid]
                    next()

                next()

            else next()


    api = emitter

    api.autospawn = false

    api.spawner = SpawnerFactory.createClass classOpts, messageBus

    api.get = (opts = {}) -> 

        getting = defer()
        process.nextTick => 


            if opts.uuid?

                return getting.resolve( realizers[opts.uuid] ) if realizers[opts.uuid]?
                return getting.reject new Error "Missing realizer uuid:#{opts.uuid}"


            if opts.filename? 

                realizer = fromfilename[opts.filename]
                doSpawn  = api.autospawn and not realizer.token.localPID?

                return getting.resolve( realizer ) unless doSpawn

                        #
                        # TODO: fix 'realizer may have died'
                        # 
                        #       - perhaps cleanup on notifier disconnect
                        #       - perhaps check for pid
                        #       - likely both
                        #


                api.spawner.spawn( realizer.token ).then(

                    (token)  -> getting.resolve realizers[token.uuid]
                    (error)  -> getting.reject error

                )

        getting.promise

    api.update = (tokens) -> 

        updating = defer()
        process.nextTick => 

            for path of tokens

                token = tokens[path]
                uuid  = token.uuid
                continue unless token.type == 'tree'

                realizers[uuid] ||= {}
                realizers[uuid].token = token
                realizers[uuid].connected = false
                continue unless token.source? 

                switch token.source.type

                    when 'file' 

                        filename = token.source.filename
                        fromfilename[filename] = realizers[uuid]


            updating.resolve()

        updating.promise


    return api
