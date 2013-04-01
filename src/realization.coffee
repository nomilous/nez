Config       = require('nezcore').config
Injector     = require('nezcore').injector
PluginLoader = require './plugin_loader'

#
# TODO: Realizer plugin as ActiveNode (leaf)
#

module.exports = 

    load: (label, injectable) -> 

        # console.log '\n\nrun realize with:\n', arguments, '\n\n'

        #
        # Load default realizer config
        #

        defaults            = _class: 'ipso:SpecRun'
        defaults.label      = label
        defaults.injectable = injectable


        #
        # Override with local config and 
        # register plugin
        #

        # for key of config

        #     defaults[key] = config[key]

        PluginLoader.load defaults


        #
        # TODO: move those of this specifically SpecRun related to ipso
        #

        subject    = Injector.support.findModule module: label
        stack      = require('./nez').link()
        stack.name = label
        validator  = stack.validator
        scaffold   = stack.stacker

        Injector.inject [subject, validator, scaffold], injectable
