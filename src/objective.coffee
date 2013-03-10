module.exports = Objective = 

    validate: (objective, config, callback) ->

        #
        # walk the entire objective tree
        #

        stack = require('./nez').link()
        stack.name = objective

        console.log "objective:", objective

        if typeof callback == 'function'

            console.log "calling:", callback.toString()
        
            require('./injector').inject [stack.stacker], callback

        #
        # start dev environment WITH objective
        #

        require('./exec/nez').exec objective, config
