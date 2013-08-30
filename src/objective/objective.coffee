module.exports = class Objective

    #
    # Default Objective
    # -----------------
    # 
    # * This objectiveFn is used if no objective is passed into 
    #   `nez.objective(opts, objectiveFn)`
    # 

    defaultObjective: (Signature) -> 

        Signature 'Title', (done) -> 

            @does = 'nothing' 
            done()


    startMonitor: (opts, jobTokens, jobEmitter) -> 

        throw new Error 'Objective.startMonitor() undefined override.'
