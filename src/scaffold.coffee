Plex = require 'plex'

module.exports = class Scaffold

    constructor: (@label, @config, @injectable) ->

        @validate()


    validate: ->

        unless typeof @label == 'string'
        
            throw new Error "Scaffold requires 'label' string as arg1"

        unless typeof @config == 'object'

            throw new Error "Scaffold requires config hash as arg2"

        if typeof @config.as == 'undefined'

            throw new Error "Scaffold requires type definition in config.as"  

        unless typeof @injectable == 'function'

            throw new Error "Scaffold requires injectable function arg3"
