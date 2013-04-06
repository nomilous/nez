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

        @logger.info 'active config lookup'

            as: @config.as || process.env.NODE_AS
            nodeID: @nodeID
            tags: @tags

        @outerValidate()

        @config.as @nodeID, @tags, (error, activeConfig) => 

            #
            # TODO: timeout awaiting activeConfig
            #

            @logger.verbose 'received active config', activeConfig

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


        @logger.verbose 'starting'

            label: @label
            category: @config.category

        if type == '_objective' 

            #
            # Objectives proxy realizers into the system
            #

            unless typeof activeConfig[type].plex == 'undefined' 

                server = Http.createServer()

                server.listen 20202, 'localhost',  => 

                    iface = server.address().address
                    port  = server.address().port

                    @logger.info "listening for realizers @ #{iface}:#{port}"

                activeConfig[type].plex.listen.server = server 


        #
        # create the local stack
        #

        @stack = new Stack this


        #
        # load plugin
        #

        @config._class   = activeConfig[type].class
        @plugin = PluginLoader.load @stack, @config        


        #
        # start transport
        #

        unless typeof activeConfig[type].plex == 'undefined' 

            activeConfig[type].plex.protocol = @plugin.bind
            @plex = Plex.start activeConfig[type].plex

            #
            # realizer stops plex at the end of the run
            #

            # plex is stopped at the end of this function
            # will be fine until edge traversals go async
            # 
            # if type == '_realizer'
            #     @stack.on 'end', (error, stack) => 
            #         @plex.stop()
            #

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

                    @logger.error "error loading service '#{service}'"

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
                    @logger.error "active config lookup failed for '#{@config.as}'"
                    throw error
