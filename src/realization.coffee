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

    try
    
        new ActiveNode label, config, injectable

    catch error

        process.stderr.write 'ERROR:' + error.message
        process.exit 1










    # load: (label, injectable) -> 

    #     # console.log '\n\nrun realize with:\n', arguments, '\n\n'

    #     #
    #     # Load default realizer config
    #     #

    #     defaults            = _class: 'ipso:SpecRun'
    #     defaults.label      = label
    #     defaults.injectable = injectable


    #     #
    #     # Override with local config and 
    #     # register plugin
    #     #

    #     # for key of config

    #     #     defaults[key] = config[key]

    #     PluginLoader.load defaults


    #     #
    #     # TODO: move those of this specifically SpecRun related to ipso
    #     #

    #     subject    = Injector.support.findModule module: label
    #     stack      = require('./nez').link()
    #     stack.name = label
    #     validator  = stack.validator
    #     scaffold   = stack.stacker

    #     Injector.inject [subject, validator, scaffold], injectable
