require 'fing'

module.exports = Objective = 

    validate: (objective, config, callback) ->

        #
        # walk the entire objective tree
        #

        Objective.root = fing.trace()[1].file.match( /(.*)\/.*$/ )[1]

        stack = require('./nez').link()
        stack.name = objective

        if typeof callback == 'function'
        
            require('nezcore').injector.inject [stack.stacker], callback

        #
        # start dev environment WITH objective
        #

        require('./exec/nez').exec objective, config
