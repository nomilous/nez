Objective
=========

What is it?
-----------

Each component of a system has a particular purpose or **function** to perform in order to achieve whatever outcome the system was assembled to achieve. <br />

`Objective` is a formalization of that notion of a component's purpose in order to enable its **declaration**, and more specifically, the **instrumentation** and **maintenance** of that purpose. <br />


How do you use it?
------------------

```coffee

#
# nez.objective( title, opts, objectiveFn )
#

require('nez').objective 'Title of the Objective', 

    #
    # Opts / Configuration
    # ====================
    # 
    # As a hash of key value pairs
    # 
    # 
    # opts.description (required)
    # ---------------------------
    # 
    # * Provide a succinct description of the objective.
    # 

    description: 'Description of the Objective'

    #
    # opts.messenger (optional)
    # -------------------------
    # 
    # * A messenger function can be defined.
    # * It will override the default eo.messenger.
    # * It will receive all messages generated with the built in notifier
    # 

    messenger: (message, next) -> 

        console.log message.content
        next()

    #
    # opts.otherConfig
    # ----------------
    #
    # * Additional config items required 
    # 

    keyName1: 'value1'


    #
    # Objective Loop (objectiveFn)
    # ============================
    # 
    # User defined objective main loop
    #

    -> 


```


How do you use it in a system?
------------------------------


### The Objective Tree

...