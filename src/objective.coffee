ActiveNode     = require './active_node'

module.exports = Objective = (label, config, injectable) -> 

    try
    
        new ActiveNode label, config, injectable

    catch error

        process.stderr.write 'ERROR:' + error.message
        process.exit 1
