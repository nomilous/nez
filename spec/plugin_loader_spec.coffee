should         = require 'should'
PluginLoader   = require '../lib/plugin_loader'
PluginRegister = require '../lib/plugin_register'
Plugin         = require '../lib/plugin'

describe 'PluginLoader', ->

    it 'loads plugin modules', (done) ->

        try

            PluginLoader.load 
                _module: 'test'

        catch error

            error.code.should.equal 'MODULE_NOT_FOUND'
            done()

    it 'validates the plugin', (done) ->

        swap = PluginLoader.validate
        validated = false

        PluginLoader.validate = (potentialPlugin) -> 
            potentialPlugin.should.equal require '../lib/plugin'
            validated = true
            potentialPlugin

        PluginLoader.load 
            _module: '../lib/plugin'

        PluginLoader.validate = swap
        validated.should.equal true
        done()


    it 'throws a PluginException on invalid plugin', (done) ->

        try
        
            PluginLoader.validate 'name', {}

        catch error

            error.code.should.equal 'INVALID_PLUGIN'
            done()

    it 'ensures the plugin supplies a list of node class handlers', (done) ->

        try
            PluginLoader.validate
                configure: ->
                edge: ->
                handles: ['RedLorry','YellowLorry']
                RedLorry: ->
                YellowLolly:-> 

        catch error

            error.message.should.match /INVALID_PLUGIN - Undefined Plugin.YellowLorry/
            done()

    it 'ensures the plugin supplies a list of node metafield key matchers', (done) ->

        try
            plugin = 
                configure: ->
                edge: ->
                handles: ['AnnoyedOyster']
                AnnoyedOyster: ->
                matches: ['noiseTipe']
                noiseType: (value) -> 
                    if value == 'NOISEY'
                        return plugin.AnnoyedOyster

            PluginLoader.validate plugin

        catch error

            error.message.should.match /Undefined Plugin.noiseTipe/
            done()


    it 'registers the plugin', (wasRegistered) ->

        swap = PluginRegister.register
        PluginRegister.register = (plugin) -> 

            PluginRegister.register = swap
            wasRegistered() if plugin == Plugin

        PluginLoader.load _module: '../lib/plugin'


    it 'load() passes the stacker to Plugin.configure() and returs it', (done) ->

        stacker = null
        Plugin.configure = (arg1, arg2) ->
            stacker = arg1

        PluginLoader.load( _module: '../lib/plugin' ).should.equal stacker
        done()

