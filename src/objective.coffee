module.exports = Objective = 

    validate: (objective, config) ->

        #
        # start dev environment WITH objective
        #

        require('./exec/nez').exec objective, config

        

