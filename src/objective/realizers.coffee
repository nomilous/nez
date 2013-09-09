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

    return api = 

        autospawn: false

        spawner: SpawnerFactory.createClass classOpts, messageBus

        get: (opts = {}) -> 

            getting = defer()
            process.nextTick => 

                #
                # TODO: autospawn
                # TODO: no such realizer
                #

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
                    continue unless token.source? 

                    switch token.source.type

                        when 'file' 

                            filename = token.source.filename
                            fromfilename[filename] = realizers[uuid]


                updating.resolve()

            updating.promise

