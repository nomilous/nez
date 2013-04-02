Stack          = require './stack'
prototypes     = require './prototypes' # eligable? DELETE
Injector       = require './injector' # eligable? DELETE
Objective      = require './objective'
Realization    = require './realization'
PluginLoader   = require './plugin_loader'
PluginRegister = require './plugin_register'

stack          = new Stack()


Nez = 

    #
    # **Nez.objective(`label`, `config`, `injectable`)**
    # 
    # Spawns an [ActiveNode](active_node.html) as an `Objective`
    # 
    # Default [objective implementation](https://github.com/nomilous/eo)
    # 
    # 

    objective: Objective


    # 
    # **Nez.realize(`label`, `config`, `injectable`)**
    # 
    # Default [realizer implementation](https://github.com/nomilous/ipso)
    # 

    realize: Realization

    # realize: Injector.realize



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

        PluginLoader.load _module: './plugin/requirement', {}
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
