should = require 'should'
Plugin = require '../lib/plugin_loader'

describe 'Plugin', ->

    it 'loads plugin modules', (done) ->

        try

            Plugin.load 'test'

        catch error

            error.code.should.equal 'MODULE_NOT_FOUND'
            done()

    it 'validates the plugin', (done) ->

        swap = Plugin.validate 

        Plugin.validate = (potentialPlugin) -> 

            potentialPlugin.should.equal require '../lib/plugin'
            Plugin.validate = swap
            done()

        Plugin.load '../lib/plugin'


    it 'throws a PluginException on invalid plugin', (done) ->

        try
        
            Plugin.validate {}

        catch error

            error.code.should.equal 'INVALID_PLUGIN'
            done()


    describe 'extends the stack functionality', ->

        it "by assigning additional behaviours to the node 'class' names"

