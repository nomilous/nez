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

                                                            #
                                                            # TODO: perhaps all events, will need to protect
                                                            #       from concurrent calls to spawn
                                                            #
                                                            #       currently only on change because the only
                                                            #       use case is a changeing spec file requiring
                                                            #       a call to run the spec file at the realizer
                                                            # 
                            
                                return @emit event, filename, stats, ref


                            #
                            # * if autospawn is enabled and the changed file refers 
                            #   to a realizer then pend the change event propagation 
                            #   until the realizer is spawned and connected
                            # 
                            # * (or found already connected)
                            #

                            Realizers.get( filename: filename ).then(

                                (realizer) => 

                                    #
                                    # * include the realizer on emitted change event
                                    #

                                    @emit event, filename, stats, ref, realizer


                                (error) ->    

                                    console.log

                                        #
                                        # TODO: send rootward, later
                                        #

                                        description: "Failed autospawn realizer file:#{filename}"
                                        error: error



                            )

    
    monitor.dirs ||= new DirectoryMonitor

    return monitor

