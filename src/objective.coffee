module.exports = Objective = 

    validate: (objective, config, callback) ->

        #
        # walk the entire objective tree
        #

        stack = require('./nez').link()
        stack.name = objective

        if typeof callback == 'function'
        
            require('./injector').inject [stack.stacker], callback

        #
        # start dev environment WITH objective
        #

        require('./exec/nez').exec objective, config
