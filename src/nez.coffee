
process.on 'SIGHUP', require('./plugin_register').hup

module.exports = 

    #
    # **Nez.objective(`label`, `config`, `injectable`)**
    # 
    # Spawns an [ActiveNode](active_node.html) as an `Objective`
    # 
    # Default [objective implementation](https://github.com/nomilous/eo)
    # 
    # 

    objective: require './objective'


    # 
    # **Nez.realize(`label`, `config`, `injectable`)**
    # 
    # Default [realizer implementation](https://github.com/nomilous/ipso)
    # 

    realize: require './realization'

