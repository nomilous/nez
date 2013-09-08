#
# Realizers Collection (factory)
# ==============================
# 
# 
#

{defer} = require 'when'
spawner = require './spawner'

module.exports.createClass = (classOpts) -> 

    realizers    = {}
    fromfilename = {}

    return api = 

        autospawn: false

        get: (opts = {}) -> 


            console.log get: opts

            getting = defer()
            process.nextTick => 

                #
                # TODO: autospawn
                # TODO: no such realizer
                #

                if opts.filename? 

                    realizer = fromfilename[opts.filename]

                    console.log AUTOSPAWN: api.autospawn

                    return getting.resolve( realizer) unless api.autospawn



                    spawner.spawn classOpts, realizer.token


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
