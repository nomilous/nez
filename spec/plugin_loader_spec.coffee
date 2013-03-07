should       = require 'should'
PluginLoader = require '../lib/plugin_loader'
Plugin       = require '../lib/plugin'
Nez          = require '../lib/nez'

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


    it 'load() passes the stacker to Plugin.configure() and returs it', (done) ->

        stacker = null
        Plugin.configure = (arg1, arg2) ->
            stacker = arg1

        PluginLoader.load('../lib/plugin').should.equal stacker
        done()

