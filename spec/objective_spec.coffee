should       = require 'should'
# Config       = require('nezcore').config
# PluginLoader = require '../lib/plugin_loader'
Objective  = require '../lib/objective'
ActiveNode = require '../lib/active_node'
Defaults   = require '../lib/defaults' 
# Exec         = require '../lib/exec/nez'
# swap         = undefined



describe 'Objective', -> 

    it 'is a function', (done) -> 

        Objective.should.be.an.instanceof Function
        done()


    it 'starts an ActiveNode node default objective plugin', (done) -> 

        Defaults['Develop'] = (id, tags, callback) -> callback 'Develop'

        ActiveNode.prototype.start = (config) -> 

            config.should.equal 'Develop'
            done()

        Objective 'LABEL', {}, -> 
