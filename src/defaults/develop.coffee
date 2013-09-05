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
    # TODO: 
    # 
    # * handle new realizers (additional boundry tree to load)
    # * configurable/optional src folder
    # * monitor spec and src and compile appropriately
    # * on change spawn realizer unless already spawned
    # * if already spawned instruct to reload and apply changeset
    # * only run changed specs on first run after reload
    #

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


    configure: (opts, done) ->  

        opts.boundry = ['spec', 'test']
        done()


    defaultObjective: (spec) -> 

        spec.link directory: './spec'


module.exports = Develop
