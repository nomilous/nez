module.exports = class Objective

    #
    # configure()
    # -----------
    # 
    # * Objective can ammend options ahead of the PhraseTree recursion
    #

    configure: (opts, done) -> done() 


    #
    # defaultObjective()
    # ------------------
    # 
    # * This objectiveFn is used if no objective is passed into 
    #   `nez.objective(opts, objectiveFn)`
    # 

    defaultObjective: (Signature) -> 

        Signature 'Title', (done) -> 

            @does = 'nothing' 
            done()


    onBoundry: (params, callback) -> 

        console.log  'WARNING Objective.onBoundry() undefined override.'


    startMonitor: (opts, jobTokens, jobEmitter) -> 

        console.log  'WARNING Objective.startMonitor() undefined override.'
