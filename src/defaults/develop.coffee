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
    #           boundry: ['tests']
    # 
    #           (tests) -> tests.link directory: '../path/to/tests/'
    #

    defaultObjective: (spec) -> spec.link directory: './spec'


module.exports = Develop
