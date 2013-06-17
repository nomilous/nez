Objective
=========

### Usage

`nez.objective( title, opts, objectiveFn )`

```coffee

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
