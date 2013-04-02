ActiveNode     = require './active_node'

module.exports = Objective = (label, config, injectable) -> 

    try

        if typeof config.as == 'undefined'

            config.as = 'Develop'
    
        new ActiveNode label, config, injectable

    catch error

        process.stderr.write 'ERROR:' + error.message
        process.exit 1
