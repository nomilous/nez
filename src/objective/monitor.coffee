Hound  = require 'hound'

class DirectoryMonitor

    constructor: ->

        @monitors = {}

    add: (directory) -> 

        unless @monitors[directory]?
        
            @monitors[directory] = Hound.watch directory



module.exports.DirectoryMonitor = DirectoryMonitor
