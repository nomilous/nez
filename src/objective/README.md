Objective
=========

What is it?
-----------

Each component of a system has a particular purpose (or **function**) which necessarilly complements the surrounding system with its additional functionality.<br />

`Objective` is a formalization of the notion of a component's purpose in order to enable the **declaration** thereof - and consequently - the capacity for **instrumentation** and **maintenance** of that purpose. <br />

The `Objective` is essentially a contextualized monitoring loop and information proxy, the actual work is done by the component [realizers](https://github.com/nomilous/nez/tree/develop/src/realization) for which it is responsible.


How do I use it?
----------------

```coffee

#
# nez.objective( opts, objectiveFn )
#

require('nez').objective 

    #
    # Opts / Configuration
    # ====================
    # 
    # As a hash of key value pairs
    # 

    #
    # opts.title (required) 
    # ---------------------
    #
    # * Give it a name
    # 

    title: 'Title of the Objective'

    # 
    # opts.uuid (required)
    # --------------------
    # 
    # * Make it persistable (with a certainly unique reference)
    #

    uuid:  '00000000-0700-0000-0000-fffffffffff0'

    # 
    # opts.description (required)
    # ---------------------------
    # 
    # * Provide a succinct description of the objective.
    # 

    description: 'Description of the Objective'

########################    #
########################    # opts.messenger (optional)
######  possibly  ######    # -------------------------
######    not     ######    # 
########################    # * A messenger function can be defined.
########################    # * It will override the default eo.messenger.
########################    # * It will receive all messages generated with the built in notifier
########################    # 
########################
########################    messenger: (message, next) -> 
########################
########################        console.log message.content
########################        next()
########################
########################    #
########################    # opts.error (optional)
########################    # ---------------------
########################    # 
########################    # * Errors that terminate the objective are sent here
########################    # 
########################
########################    error: (error) -> 
########################
########################        console.log 'ERROR!!', error.stack

    #
    # opts.otherConfig
    # ----------------
    #
    # * Additional config items as perhaps required
    # 

    keyName1: 'value1'


    #
    # Objective Loop (objectiveFn)
    # ============================
    # 
    # User defined objective main loop
    #

    (end) -> 


```


How do I use it in a system?
----------------------------


### The Objective Tree

...