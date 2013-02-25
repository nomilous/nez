events = require 'events'

module.exports = class Notifier extends events.EventEmitter
    
    constructor: (@events) ->

    on: (event, callback) -> 

        unless @events[event]
        
            throw new Error 'No such event: "' + event + '"'


        super event, callback

        console.log @