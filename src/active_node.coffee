Defaults     = require './defaults'
PluginLoader = require './plugin_loader'
Injector     = require('nezcore').injector
Runtime      = require('./exec/nez').exec  
Http         = require 'http'
Plex         = require 'plex'

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
        # Initialize proxy transport layer
        # 
        # TODO: use https if config.cert: path: is defined
        #

        server = Http.createServer()
        server.listen 20202, 'localhost', => 

            console.log '[ActiveNode] - listening @ %s:%s',
                server.address().address
                server.address().port

        activeConfig._objective.proxy.listen.server = server


        #
        # load objective plugin
        #

        @config._class = activeConfig._objective.class
        @plugin = PluginLoader.load @config


        #
        # bind method for assigning protocol on connect
        #

        activeConfig._objective.proxy.protocol = @plugin.bind


        #
        # create the local stack
        #

        stack      = require('./nez').link()
        stack.name = @label

        #
        # start proxy
        #

        @context = Plex.start activeConfig._objective.proxy


        #
        # Runtime
        # 
        # TODO: These need more thought...
        # 
        #       - Runtime is specifically a Dev ENV (née. CakeFile)
        #         and shouldn't be so specific
        # 

        Runtime @label, @config


        #
        # Injector walks into the tree 
        #

        if typeof @injectable == 'function'

            Injector.inject [stack.stacker], @injectable



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

            #
            # Default objective plugin to 'Develop'
            #

            @config.as = process.env.NODE_AS


        if typeof @config.as == 'string'

            if typeof Defaults[@config.as] != 'undefined'

                @config.as = Defaults[@config.as]

            else

                try

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

        # else if 

        #     if typeof @config._as != 'function'

        #         throw new Error "ActiveNode requires behaviour definition in config._as"

        # else 

        #     if typeof Defaults[ @config.as ] == 'undefined'

        #         #
        #         # defined config factory does not exist
        #         #

        #         throw new Error "ActiveNode as '#{@config.as}' is not defined"

        #     @config._as = Defaults[ @config.as ]


        unless typeof @injectable == 'function'

            throw new Error "ActiveNode requires injectable function arg3"
