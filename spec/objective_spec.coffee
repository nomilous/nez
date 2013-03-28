should       = require 'should'
PluginLoader = require '../lib/plugin_loader'
Objective    = require '../lib/objective'
Exec         = require '../lib/exec/nez'
swap         = undefined



describe 'Objective', -> 

    it 'defines load()', (done) -> 

        Objective.load.should.be.an.instanceof Function
        done()

    it 'defaults eo as objective plugin', (done) -> 

        loader = PluginLoader.load 

        PluginLoader.load = (module, config) -> 

            PluginLoader.load = loader
            module.should.equal 'eo'
            config.should.equal 'config'
            done()  

        Objective.load 'config'


    it 'can override objective plugin with env.NEZ_OBJECTIVE', (done) -> 

        process.env.NEZ_OBJECTIVE_TYPE = 'objective-type'
        loader = PluginLoader.load 

        PluginLoader.load = (module, config) -> 

            PluginLoader.load = loader
            module.should.equal 'objective-type'
            config.should.equal 'config'
            done()

        Objective.load 'config'

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
