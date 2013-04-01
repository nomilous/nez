Defaults = require './defaults'
Plex     = require 'plex'

module.exports = class Scaffold

    constructor: (@label, @config, @injectable) ->

        @validate()


    validate: ->

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

                throw new Error "Scaffold as '#{@config.as}' is not defined"


        unless typeof @injectable == 'function'

            throw new Error "Scaffold requires injectable function arg3"
