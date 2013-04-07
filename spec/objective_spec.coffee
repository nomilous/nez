should       = require 'should'
# Config       = require('nezcore').config
# PluginLoader = require '../lib/plugin_loader'
Objective  = require '../lib/objective'
ActiveNode = require '../lib/active_node'
Defaults   = require '../lib/defaults' 
Plex       = require 'plex'
Develop    = require('eo').Develop

# Exec         = require '../lib/exec/nez'
# swap         = undefined



describe 'Objective', -> 

    it 'is a function', (done) -> 

        Objective.should.be.an.instanceof Function
        done()


    it 'starts an ActiveNode node default objective plugin', (done) -> 

        swap1 = Defaults.Develop
        Defaults.Develop = (id, tags, callback) -> callback null, 'Develop'

        swap2 = ActiveNode.prototype.start
        ActiveNode.prototype.start = (config) -> 
            Defaults.Develop = swap1
            ActiveNode.prototype.start = swap2  
            config.should.equal 'Develop'
            done()

        Objective 'LABEL', {}, -> 


    it 'starts the Objective plugin monitor', (done) -> 

        Plex.start = -> stop: ->
        Develop.monitor = -> done()

        Objective 'LABEL', {}, -> 
        

    it 'knows the objective origin path', (done) -> 

        #
        # For now it is assumed the ./objective file...
        # 
        #  ie. the script that calls nez:Objective
        #
        # ...is in the root of it's supporting module
        #

        ActiveNode.prototype.outerValidate = -> 

            @config.path.should.match /nimbal\/node_modules\/nez\/spec/
            done()

        Objective 'LABEL', as: ->


    it 'can specify path', (done) -> 

        ActiveNode.prototype.outerValidate = -> 

            @config.path.should.match /\/path/
            done()

        Objective 'LABEL', 
            as: -> 
            path: '/path'


