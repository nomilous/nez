module.exports = class Objective


    defaultObjective: (Signature) -> 

        Signature 'Title', (done) -> 

            @does = 'nothing' 
            done()


    startMonitor: (opts, tokens, jobEmitter) -> 

        throw new Error 'Objective.startMonitor() undefined override.'
