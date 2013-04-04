Defaults        = require './defaults'
PluginLoader    = require './plugin_loader'
Injector        = require('nezcore').injector
Runtime         = require('./exec/nez').exec  
Stack           = require './stack'
Http            = require 'http'
Plex            = require 'plex'

module.exports = class ActiveNode

    constructor: (@label, @config, @injectable) ->

        @outerValidate()

        nodeID = process.env.NODE_ID
        tags   = process.env.NODE_TAGS || ''

        @config.as nodeID, tags.split(' '), (activeConfig) => 

            #
            # TODO: timeout awaiting activeConfig
            #

            @innerValidate activeConfig

            @start activeConfig


    start: (activeConfig) -> 

        console.log 'START:', JSON.stringify activeConfig, null, 2

        #
        # Initialize transport
        # 
        # TODO: use https if config.cert: path: is defined
        #

        if typeof activeConfig._objective != 'undefined' 

            type = '_objective'

            #
            # Objectives proxy realizers into the system
            #

            unless typeof activeConfig[type].plex == 'undefined' 

                server = Http.createServer()

                server.listen 20202, 'localhost', => 

                    console.log '[ActiveNode] - listening @ %s:%s',
                        server.address().address
                        server.address().port

                activeConfig[type].plex.listen.server = server 

        else if typeof activeConfig._realizer != 'undefined'

            type = '_realizer'

        else 

            throw new Error "ActiveNode should be an Objective or a Realizer"


        #
        # create the local stack
        #

        @stack = new Stack this


        #
        # load plugin
        #

        @config._class = activeConfig[type].class
        @plugin = PluginLoader.load @stack, @config        


        #
        # start transport
        #

        unless typeof activeConfig[type].plex == 'undefined' 

            activeConfig[type].plex.protocol = @plugin.bind
            @context = Plex.start activeConfig[type].plex


        #
        # Objective spawns a Runtime
        # 
        # TODO: Make this configurable
        # 
        #       - Runtime is specifically a Dev ENV (née. CakeFile)
        #         and shouldn't be so specific
        # 

        Runtime @label, @config if type == '_objective'


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

                    console.log "[ActiveNode] - Error loading service '#{service}'"

                    #
                    # TODO: perhaps this should process.exit()
                    #

                    services.push undefined # keeps the places


        if typeof @injectable == 'function'

            Injector.inject services, @injectable


    innerValidate: (config) -> 

        #
        # TODO: validate inner config
        #

    outerValidate: ->

        unless typeof @label == 'string'
        
            throw new Error "ActiveNode requires 'label' string as arg1"


        unless typeof @config == 'object'

            throw new Error "ActiveNode requires config hash as arg2"


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

                    console.log "[ActiveNode] - FAILED to configure as '#{@config.as}'"
                    throw error


        unless typeof @injectable == 'function'

            throw new Error "ActiveNode requires injectable function arg3"
