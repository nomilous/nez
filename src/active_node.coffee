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
        # Initialize transport
        # 
        # TODO: use https if config.cert: path: is defined
        #

        if typeof activeConfig._objective != 'undefined' 

            type = '_objective'

            #
            # Objectives proxy realizers into the system
            #

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
        # load plugin
        #

        @config._class = activeConfig[type].class
        @plugin = PluginLoader.load @config


        #
        # bind method for assigning protocol on connect
        #

        activeConfig[type].plex.protocol = @plugin.bind


        #
        # create the local stack
        #

        stack      = require('./nez').link()
        stack.name = @label


        #
        # start transport
        #

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
