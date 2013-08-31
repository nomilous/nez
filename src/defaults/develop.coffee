#
# Develop (Objective)
# ===================
# 
# Runs the objective loop as a development environment.
# 

Objective = require '../objective/objective'

class Develop extends Objective

    #
    # default develop objective links into the spec directory
    # -------------------------------------------------------
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


    configure: (opts) ->  

        opts.boundry = ['spec', 'test']


    onBoundry: (params, callback) -> 

        console.log TODO: Develop: AssembleBoundryPhrase: params

        callback null, null

    defaultObjective: (spec) -> spec.link directory: './spec'


module.exports = Develop
