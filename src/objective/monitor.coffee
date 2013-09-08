Hound  = require 'hound'

class DirectoryMonitor

    constructor: ->

        @monitors = {}

    add: (directory) -> 

        @monitors[directory] = Hound.watch directory



module.exports.DirectoryMonitor = DirectoryMonitor
