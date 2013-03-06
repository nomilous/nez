Exception = require './exception'

module.exports = PluginFactory = 

    load: (name, config) -> 

        plugin = PluginFactory.validate require name

    validate: (plugin) ->

        unless typeof plugin.configure == 'function'

            throw Exception.create 'INVALID_PLUGIN', 'Undefined Plugin.configure()'

        return plugin

