ActiveNode     = require './active_node'

module.exports = () -> 

    label      = arguments[0]
    config     = arguments[1]
    injectable = arguments[2]

    #
    # config is optional
    #

    if typeof injectable == 'undefined'

        injectable = arguments[1]

        #
        # default as 'SpecRun'
        #

        config = as: 'SpecRun'

    unless typeof config == 'function' 

        if typeof config.as == 'undefined'

            config.as = 'SpecRun' 

    try
    
        new ActiveNode label, config, injectable

    catch error

        process.stderr.write 'ERROR:' + error.message
        process.exit 1
