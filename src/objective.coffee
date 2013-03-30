Config       = require('nezcore').config
Injector     = require('nezcore').injector
Runtime      = require('./exec/nez').exec  
PluginLoader = require './plugin_loader'


module.exports = Objective = 

    load: (label, config, injectable) -> 

        #
        # Start the objective plugin
        #

        defaults = Config.get 'objective'
        
        defaults.label      = label
        defaults.injectable = injectable

        for key of config

            defaults[key] = config[key]

        PluginLoader.load defaults


        #
        # start nez
        #

        # 
        # TODO: This is the developer runtime...
        # 
        #       It only belongs here for as long
        #       as oe.Develop is the only kind 
        #       of objective
        # 

        stack = require('./nez').link()
        stack.name = label

        if typeof injectable == 'function'

            Injector.inject [stack.stacker], injectable

        Runtime label, defaults

