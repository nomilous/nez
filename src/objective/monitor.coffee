{EventEmitter} = require 'events'
Hound          = require 'hound'

module.exports.createFunction = (Realizers) ->

    monitor = (opts) ->  

        if opts.directory? then monitor.dirs.add opts.directory, opts.match, opts.ref


    monitor.DirectoryMonitor = class DirectoryMonitor extends EventEmitter

            constructor: (opts = {}) ->

                @monitors  = {}

            add: (dirname, match, ref) -> 

                unless @monitors[dirname]?

                    @monitors[dirname] = watch = Hound.watch dirname

                    for event in ['create', 'change', 'delete']
                        
                        do (event) => watch.on event, (filename, stats) =>

                            if match? then return unless filename.match match

                            unless Realizers.autospawn and event == 'change' and ref == 'realizer'
                            
                                return @emit event, filename, stats, ref

                            #
                            # TODO: if autospawn is enabled and the changed file refers 
                            #       to a realizer then pend the change event propagation 
                            #       until the realizer is spawned (or already running)
                            #

                            Realizers.get( filename: filename ).then(

                                (realizer) -> console.log GOT_REALIZER: realizer
                                (error) ->    console.log TODO: 'handle error getting realizer@' + filename 

                            )

    
    monitor.dirs ||= new DirectoryMonitor

    return monitor

