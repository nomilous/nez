#
# Develop (Objective)
# ===================
# 
# Runs the objective loop as a development environment.
# 

Objective = require '../objective/objective'

class Develop extends Objective


    onBoundry: (params, callback) -> 

        console.log AssembleBoundryPhrase: params

        callback null, null



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
