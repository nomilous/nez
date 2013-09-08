{EventEmitter} = require 'events'
Hound          = require 'hound'

class DirectoryMonitor extends EventEmitter

    constructor: ->

        @monitors = {}

    add: (dirname, match, ref) -> 

        unless @monitors[dirname]?

            @monitors[dirname] = watch = Hound.watch dirname

            for event in ['create', 'change', 'delete']
                
                do (event) => watch.on event, (filename, stats) =>

                    if match? then return unless filename.match match
                    @emit event, filename, stats, ref


module.exports = monitor = (opts) ->  

    if opts.directory? then monitor.dirs.add opts.directory, opts.match

monitor.dirs ||= new DirectoryMonitor

module.exports.DirectoryMonitor = DirectoryMonitor

