#
# Develop (Objective)
# ===================
# 
# Runs the objective loop as a development environment.
# 

Objective = require '../objective/objective'
Realize   = require '../realization/realize'

class Develop extends Objective


    onBoundry: (params, callback) -> 

        Realize.loadRealizer( params ).then( 

            (realizer) -> 

                #
                # convert to phrase format
                #

                result = 
                    title: realizer.opts.title
                    opts: realizer.opts
                    fn: realizer.realizerFn  

                delete realizer.opts.title

                callback null, result

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
