should       = require 'should'
Config       = require('nezcore').config
PluginLoader = require '../lib/plugin_loader'
Objective    = require '../lib/objective'
Exec         = require '../lib/exec/nez'
swap         = undefined



describe 'Objective', -> 

    it 'defines load()', (done) -> 

        Objective.load.should.be.an.instanceof Function
        done()

    it 'loads the Config specified objective plugin', (done) -> 

        
        calledConfig = false

        swap = Config.get
        Config.get = (key) -> 
            calledConfig = true
            Config.get = swap
            swap key

        loader = PluginLoader.load
        PluginLoader.load = (config) -> 

            PluginLoader.load = loader
            config._module.should.equal 'eo'
            config.label.should.equal 'LABEL'
            calledConfig.should.equal true
            done()  

        Objective.load 'LABEL'


    it 'overrides default config with supplied config', (done) -> 

        loader = PluginLoader.load
        PluginLoader.load = (config) -> 

            PluginLoader.load = loader
            config._module.should.equal 'eo'
            config._class.should.equal 'Develop'
            config.label.should.equal 'LABEL'
            config.override.should.equal 'EXTENDED CONFIG'
            done() 

        Objective.load 'LABEL', override: 'EXTENDED CONFIG'


    # it 'knows the repo root', (done) ->

    #     #
    #     # ./objective script should always be placed
    #     #             in the repo root
    #     #

    #     Objective.validate 'NameOfThing'
    #     Objective.root.should.match /nez\/spec$/
    #     done()
        

    # it 'returns the dev environment exec() if config was supplied', (wasCalled) ->

    #     old = Exec.exec 
    #     Exec.exec = -> 
    #         Exec.exec = old
    #         wasCalled()

    #     Objective.validate 'NameOfThing', {'config'}


    # it 'returns the dev environment start()er if no config was passed', (done) ->

    #     loader = Objective.validate 'NameOfThing'
    #     loader.should.equal Exec.start
    #     done()
