ActiveNode     = require './active_node'

module.exports = Objective = (label, config, injectable) -> 

    try

        #
        # ASSUMPTION: 
        # 
        # Objective file will be in the root of its module.
        # Will expend for further posibilities later.
        #

        if typeof config.path == 'undefined'

            objectiveFile = Error.apply(this).stack.split('\n')[3].match(/\((.*):\d*:\d*/)[1]
            path = require('path').dirname objectiveFile
            config.path = path

        if typeof config.as == 'undefined'

            config.as = 'Develop'
    
        new ActiveNode label, config, injectable

    catch error

        process.stderr.write 'ERROR:' + error.message
        process.exit 1
