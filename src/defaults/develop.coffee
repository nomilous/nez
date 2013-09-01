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

        #console.log jobTokens
        # 
        #
        #  '/cetera/objective': 
        #   { type: 'root', 
        #     uuid: 'cetera-0.0.1', 
        #     signature: 'cetera' },
        #  '/cetera/objective/story/User Stories': 
        #   { type: 'vertex',
        #     uuid: 'fry day, satay day, run day',
        #     signature: 'story' },
        #  '/cetera/objective/story/User Stories/requirement/A Requirement': 
        #   { type: 'vertex',
        #     uuid: '58392510-1323-11e3-a09f-9b7d7dbfa30d',
        #     signature: 'requirement' },
        #  '/cetera/objective/story/User Stories/requirement/A Requirement/need/A Feature': 
        #   { type: 'boundry',
        #     uuid: '58399a40-1323-11e3-a09f-9b7d7dbfa30d',
        #     signature: 'need' },
        #  '/cetera/objective/story/User Stories/requirement/A Requirement/need/A Feature/spec/submarine test': 
        #   { type: 'vertex',
        #     uuid: '63e2d6b0-f242-11e2-85ef-03366e5fcf9a',
        #     signature: 'spec' },
        #  '/cetera/objective/story/User Stories/requirement/A Requirement/need/A Feature/spec/submarine test/it/has deeper phrases': 
        #   { type: 'vertex',
        #     uuid: '583d91e1-1323-11e3-a09f-9b7d7dbfa30d',
        #     signature: 'it' },
        #  '/cetera/objective/story/User Stories/requirement/A Requirement/need/A Feature/spec/submarine test/it/has deeper phrases/that/confirms the recursor has spanned the boundry': 
        #   { type: 'leaf',
        #     uuid: '583de000-1323-11e3-a09f-9b7d7dbfa30d',
        #     signature: 'that' },
        #  '/cetera/objective/story/User Stories/requirement/A Requirement/need/A Feature/spec/submarine test/it/can peek topside': 
        #   { type: 'leaf',
        #     uuid: '583e0710-1323-11e3-a09f-9b7d7dbfa30d',
        #     signature: 'it' } 
        # 

        jobEmitter( jobTokens['/cetera/objective'] ).then(

            (result) -> console.log RESULT: result
            (error)  -> console.log ERROR: error
            (notify) -> 

                #
                # NOISEY... 
                #

                if notify.update == 'run::complete' then console.log NOTIFY: notify
        
        )

        #
        #   { NOTIFY: 
        #       { update: 'run::complete',
        #         class: 'Job',
        #         jobUUID: '3ddcce20-1327-11e3-8b52-e1b46bf7a0cb',
        #         progress: { steps: 10, done: 9, failed: 1, skipped: 0 },
        #         at: 1378054501394 } }
        #         
        #   { RESULT: 
        #        { job: 
        #              { before_each_ON_THE_OBJECTIVE: 1,
        #                before_each_REQUIREMENT: 1,
        #                periscope: {},
        #                created_on_realizer: 1,
        #                confirmed: 1,
        #                after_all_REQUIREMENT: 1 } } }
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



                #
                # TEMPORARY: Develop objective nests each realizer tree into
                #            the objective tree.
                #

                opts.mode = 'nest'


                callback null, phrase

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

        opts.boundry = ['story', 'spec', 'test']
        done()


    defaultObjective: (spec) -> spec.link directory: './spec'


module.exports = Develop
