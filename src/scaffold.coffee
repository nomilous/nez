Defaults = require './defaults'
Plex     = require 'plex'

module.exports = class Scaffold

    constructor: (@label, @config, @injectable) ->

        @outerValidate()

        nodeID    = process.env.NODE_ID
        abilities = process.env.NODE_ABILITIES || ''

        @config._as nodeID, abilities.split(' '), (config) -> 

            #
            # config ok
            #

            #
            # start
            #

    outerValidate: ->

        unless typeof @label == 'string'
        
            throw new Error "Scaffold requires 'label' string as arg1"

        unless typeof @config == 'object'

            throw new Error "Scaffold requires config hash as arg2"

        if typeof @config.as == 'undefined'

            #
            # no config factory defined
            #

            if typeof @config._as != 'function'

                throw new Error "Scaffold requires behaviour definition in config._as"

        else 

            if typeof Defaults[ @config.as ] == 'undefined'

                #
                # defined config factory does not exist
                #

                throw new Error "Scaffold as '#{@config.as}' is not defined"

            @config._as = Defaults[ @config.as ]


        unless typeof @injectable == 'function'

            throw new Error "Scaffold requires injectable function arg3"
