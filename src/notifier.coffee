events = require 'events'

#
# Private Notifier.
#

class Notifier extends events.EventEmitter

    constructor: (@events) ->

    on: (event, callback) -> 

        unless @events[event]
        
            throw new Error 'No such event: "' + event + '"'

        super event, callback


#
# Public NotifierFactory
#

module.exports = NotifierFactory =

    notifiers: {}
    
    create: (name, events) -> 

        #
        # TODO: (consider) When notifier by name already 
        #       exists, no new one is created despite the 
        #       request to create()
        #

        NotifierFactory.notifiers[name] ||= new Notifier events

