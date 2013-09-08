{EventEmitter} = require 'events'
Hound          = require 'hound'
Realizers      = require './realizers'
autospawn      = false

class DirectoryMonitor extends EventEmitter

    constructor: (opts = {}) ->

        @monitors  = {}

    add: (dirname, match, ref) -> 

        unless @monitors[dirname]?

            @monitors[dirname] = watch = Hound.watch dirname

            for event in ['create', 'change', 'delete']
                
                do (event) => watch.on event, (filename, stats) =>

                    if match? then return unless filename.match match

                    unless autospawn and event == 'change' and ref == 'realizer'
                    
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


module.exports = monitor = (opts) ->  

    if opts.directory? then monitor.dirs.add opts.directory, opts.match, opts.ref

monitor.dirs ||= new DirectoryMonitor


Object.defineProperty monitor, 'autospawn', 

    enumareable: true
    get: -> autospawn
    set: (value) -> autospawn = value is true



module.exports.DirectoryMonitor = DirectoryMonitor

