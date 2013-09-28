#
# Realizers Collection (factory)
# ==============================
# 
# 
#

{defer}         = require 'when'
SpawnerFactory = require './spawner'

module.exports.createClass = (classOpts, messageBus) -> 

    realizers    = {}
    fromfilename = {}


    console.log TODO: 'realizer connected/not connected'

    messageBus.use (msg, next) -> 

        return next() unless uuid = msg.uuid

        switch msg.event

            when 'connect', 'reconnect'

                #
                # * Assign realizer messenger
                # 
                #   TODO: consider support for more than one instance of
                #         a realizer, keying on uuid will not suffice in
                #         that case
                #

                realizers[uuid] ||= {}
                realizers[uuid].notice = try msg.context.responder
                realizers[uuid].connected = true
                next()

            else next()


    return api = 

        autospawn: false

        spawner: SpawnerFactory.createClass classOpts, messageBus

        get: (opts = {}) -> 

            getting = defer()
            process.nextTick => 


                if opts.uuid?

                    return getting.resolve( realizers[opts.uuid] ) if realizers[opts.uuid]?
                    return getting.reject new Error "Missing realizer uuid:#{opts.uuid}"


                if opts.filename? 

                    realizer = fromfilename[opts.filename]

                    return getting.resolve( realizer ) if (

                                            #
                                            # TODO: fix 'realizer may have died'
                                            # 
                                            #       - perhaps cleanup on notifier disconnect
                                            #       - perhaps check for pid
                                            #       - likely both
                                            #

                        not api.autospawn or alreadySpawned = realizer.token.localPID?

                    )

                    api.spawner.spawn( realizer.token ).then(

                        (token)  -> getting.resolve realizers[token.uuid]
                        (error)  -> getting.reject error

                    )

            getting.promise

        update: (tokens) -> 

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

