Stack          = require './stack'
prototypes     = require './prototypes'
Injector       = require './injector'
Objective      = require './objective'
PluginLoader   = require './plugin_loader'
PluginRegister = require './plugin_register'

stack        = new Stack()


Nez = 


    # 
    # **Nez.realize(`ObjectiveClass`, `options`, `testFunction`)**
    # 

    realize: Injector.realize


    #
    # **Nez.objective(`config`)**
    # 

    objective: Objective.validate


    #
    # **Nez.plugin(`config`)**
    # 

    plugin: PluginLoader.load
    
    #
    # **Nez.hup()**
    #

    hup: -> PluginRegister.hup()



    #
    # **Nez.link(`name`)
    #

    link: (name) -> Nez.stack

        # (name) ->   
        #     stack = new Stack(name)
        #     prototypes.object.set.expect()
        #     prototypes.object.set.mock()
        #     return stack


    #
    # **Nez.linked(`name`)
    #

    linked: (name) -> 

        #
        # TODO: ensure classname in current node
        #

        Nez.stack.stacker


    #
    # **Nez.requirements(`name`)
    #

    requirements: (name) ->

        PluginLoader.load './plugin/requirement', {}
        Nez.stack.stacker


    #
    # **Nez.test()**
    #

    test: -> 

        prototypes.object.set.expect()
        prototypes.object.set.mock()
        return Nez.stack


    stack: stack


process.on 'SIGHUP', Nez.hup


module.exports = Nez
