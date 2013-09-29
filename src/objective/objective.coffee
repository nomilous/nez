{configure} = require 'realize'

module.exports = class Objective

    #
    # configure()
    # -----------
    # 
    # * Objective can ammend options ahead of the PhraseTree recursion
    #

    configure: (@opts, done) -> done() 


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


    onBoundryAssemble: (opts, callback) -> 

        #
        # * loads the local reference nodes
        # * one per remote realizer's phrase tree
        #

        configure( opts ).then( 

            (realizer) -> 

                #
                # convert to phrase format
                #

                phrase =
                    title: realizer.opts.title
                    control: realizer.opts
                    fn: realizer.realizerFn

                delete phrase.control.title

                #
                # does not load the objective's clone of the linked
                # realizer PhraseTrees
                #

                opts.loadTree = false
                callback null, phrase

            (error) -> callback error

        )



    startScheduler: (monitor, jobTokens, jobEmitter) -> 

        console.log  'WARNING Objective.startScheduler() undefined override.'
