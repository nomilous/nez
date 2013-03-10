should         = require 'should'
PluginLoader   = require '../lib/plugin_loader'
PluginRegister = require '../lib/plugin_register'
Plugin         = require '../lib/plugin'

describe 'PluginLoader', ->

    it 'loads plugin modules', (done) ->

        try

            PluginLoader.load 'test'

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

        PluginLoader.load '../lib/plugin'
        PluginLoader.validate = swap
        validated.should.equal true
        done()


    it 'throws a PluginException on invalid plugin', (done) ->

        try
        
            PluginLoader.validate {}

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

            error.message.should.match /Undefined Plugin.YellowLorry/
            done()


    it 'registers the plugin', (wasRegistered) ->

        swap = PluginRegister.register
        PluginRegister.register = (plugin) -> 

            PluginRegister.register = swap
            wasRegistered() if plugin == Plugin

        PluginLoader.load '../lib/plugin'


    it 'load() passes the stacker to Plugin.configure() and returs it', (done) ->

        stacker = null
        Plugin.configure = (arg1, arg2) ->
            stacker = arg1

        PluginLoader.load('../lib/plugin').should.equal stacker
        done()

