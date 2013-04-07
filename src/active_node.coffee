Defaults        = require './defaults'
PluginLoader    = require './plugin_loader'
Injector        = require('nezcore').injector
Runtime         = require('nezcore').runtime
#Runtime         = require('./exec/nez').exec  
Stack           = require './stack'
Http            = require 'http'
Plex            = require 'plex'

module.exports = class ActiveNode

    constructor: (@label, @config = {}, @injectable = ->) ->

        @config._runtime = new Runtime()
        @logger  = @config._runtime.logger

        

        @nodeID = process.env.NODE_ID
        tags   = process.env.NODE_TAGS || ''
        @tags  = tags.split(' ')

        @logger.log
            info: => 'active config lookup'
            verbose: => 'active config lookup':
                as: @config.as || process.env.NODE_AS
                path: @config.path
                nodeID: @nodeID
                tags: @tags


        @outerValidate()

        @config.as @nodeID, @tags, (error, activeConfig) => 

            #
            # TODO: timeout awaiting activeConfig
            #

            @logger.verbose => 'received active config': 

                config: activeConfig

            @innerValidate activeConfig

            @start activeConfig


    start: (activeConfig) -> 

        #
        # Initialize transport
        # 
        # TODO: use https if config.cert: path: is defined
        #

        if typeof activeConfig._objective != 'undefined' 

            type = '_objective'

        else if typeof activeConfig._realizer != 'undefined'

            type = '_realizer'

        else 

            throw new Error "ActiveNode should be an Objective or a Realizer"


        @logger.verbose => 'active node starting':

            label: @label
            category: @config.category


        #
        # create the local stack
        #

        @stack = new Stack this


        #
        # load plugin
        #

        @config._class   = activeConfig[type].class
        @plugin = PluginLoader.load @config._runtime, @stack, @config      


        if type == '_objective' 

            #
            # Objectives proxy realizers into the system
            #

            unless typeof activeConfig._plex == 'undefined' 

                #
                # activeConfig CANNOT set plex listen parameters 
                #

                server = Http.createServer()
                listen = @config._runtime.listen

                server.listen listen.port, listen.iface,  => 

                    @logger.info => 'started listening for realizers': 

                        iface: server.address().address
                        port: server.address().port

                    #
                    # start the objective monitor loop
                    #

                    @plugin.monitor (error, payload) => 





                activeConfig._plex.listen =

                    #
                    # override from commandline / defaults
                    #

                    adaptor: listen.adaptor
                    server: server

                activeConfig._plex.logger = @logger  


        #
        # start transport
        #

        unless typeof activeConfig._plex == 'undefined' 

            plexConfig = activeConfig._plex
            
            plexConfig.prototcol = @plugin.bind

            #
            # activeConfig CANNOT set plex connect parameters 
            #

            plexConfig.connect = @config._runtime.connect

            @plex = Plex.start plexConfig

        #
        # Load service and walk into the tree 
        #

        services = []

        #
        # primary injectables
        # 
        # * the stacker()
        # * the validator() (if _realizer and present in the plugin)
        #
        # both these service functions are ensured to run on the original stack 
        # instance context
        #
        # 

        stacker      = => @stack.stacker.apply @stack, arguments
        stacker.link = @stack.stacker.link # preserve link property
        services.push stacker


        if type == '_realizer' 

            validate = => @stack.validate.apply @stack, arguments
            services.push validate
       
            
        #
        # secondary injectables from Array config.with (if supplied) 
        # 
        # * this allows injection of modules with names incompatible as function args
        #   eg. with '-'es or '.'ots in the module names
        #  

        unless typeof @config.with == 'undefined'

            for service in @config.with

                unless typeof service == 'string'

                    services.push service
                    continue

                try

                    if match = service.match /^(.*):(.*)$/

                        services.push Injector.support.findModule( 

                            module: match[1] 

                        )[match[2]]

                    else

                        services.push Injector.support.findModule 

                            module: service

                catch error

                    @logger.error => "error loading service '#{service}'"

                    #
                    # TODO: perhaps this should process.exit()
                    #

                    services.push undefined # keeps the places


        if typeof @injectable == 'function'

            Injector.inject services, @injectable

            if type == '_realizer'

                @plex.stop()




    innerValidate: (config) -> 

        #
        # TODO: validate inner config
        #

    outerValidate: ->

        unless typeof @label == 'string'
        
            throw new Error "ActiveNode requires 'label' string as arg1"


        if typeof @config.as == 'undefined'

            @config.as = process.env.NODE_AS


        if typeof @config.as == 'string'

            if typeof Defaults[@config.as] != 'undefined'

                @config.as = Defaults[@config.as]

            else

                try

                    # REPEAT
                    if match = @config.as.match /^(.*):(.*)$/

                        #
                        # config loader as module:function
                        #

                        @config.as = require(match[1])[match[2]]

                    else

                        #
                        # config loader as module
                        #

                        @config.as = require @config.as

                catch error
                    @logger.error => "active config lookup failed for '#{@config.as}'"
                    throw error
