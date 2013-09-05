#
# Develop (Objective)
# ===================
# 
# Runs the objective loop as a development environment.
# 

Objective = require '../objective/objective'
Realize   = require '../realization/realize'

class Develop extends Objective

    startMonitor: (opts, jobTokens, jobEmitter) -> 

        console.log Develop: startMonitor: opts

        for key of jobTokens

            if jobTokens[key].type == 'tree'

                console.log REALIZER: jobTokens[key].source.filename

        #
        # TEMPORARY: run entire tree immediately
        #
        # jobEmitter( jobTokens['/cetera/objective'] ).then(
        #     (result) -> console.log RESULT: result
        #     (error)  -> console.log ERROR: error
        #     (notify) -> 
        #         #
        #         # NOISEY... 
        #         #       
        #         if notify.update == 'run::step:failed' then console.log FAIL: notify.error
        #         else if notify.update == 'run::complete'    then console.log COMPLETE: notify
        # )

    onBoundryAssemble: (opts, callback) -> 

        Realize.loadRealizer( opts ).then( 

            (realizer) -> 

                #
                # convert to phrase format
                #

                phrase =
                    title: realizer.opts.title
                    control: realizer.opts
                    fn: realizer.realizerFn

                delete phrase.control.title

                callback null, phrase

            (error) -> callback error

        )

    #
    # configuration defaults
    # ----------------------
    # 
    # * Setting the objectiveFn in the objective file will override this.
    # 
    #   eg. 
    # 
    #        require('nez').objective
    # 
    #           title: '...'
    #           uuid:  '...'
    #           description: '...'
    # 
    #           boundry: ['units']
    # 
    #           (units) -> units.link directory: '../path/to/test/units'
    #

    configure: (opts, done) ->  

        opts.boundry = ['spec', 'test']
        done()


    defaultObjective: (spec) -> spec.link directory: './spec'


module.exports = Develop
