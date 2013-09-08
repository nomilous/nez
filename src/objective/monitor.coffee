{EventEmitter} = require 'events'
Hound          = require 'hound'

class DirectoryMonitor extends EventEmitter

    constructor: ->

        @monitors = {}

    add: (directory) -> 

        unless @monitors[directory]?

            @monitors[directory] = watch = Hound.watch directory

            for event in ['create', 'change', 'delete']
                
                do (event) => watch.on event, (filename) =>


                    @emit event, filename


module.exports.DirectoryMonitor = DirectoryMonitor
