should    = require 'should'
nez       = require '../../lib/nez'

describe 'Objective', -> 

    beforeEach -> 

        @objective = new nez.Objective


    context 'Objective.defaultObjective()', -> 

        it 'does nothing', (done) -> 

            nez.Objective.prototype.startMonitor = (opts, monitor, jobTokens, jobEmitter) -> 

                jobEmitter( jobTokens['/Untitled/objective'] ).then (result) ->

                    result.should.eql job: does: 'nothing'
                    done()

            nez.objective

                title: 'Untitled'
                uuid:  '00000000'
                description: ''

                module: '../nez'
                class: 'Objective'



    context 'startMonitor( opts, tokens, emitter )', -> 

        context 'objectiveTree', -> 

            before (done) -> 

                nez.Objective.prototype.startMonitor = (opts, @monitor, @jobTokens, @jobEmitter) => done()

                nez.objective

                    title: 'Failsafe Loop'
                    uuid:  '11'
                    description: ''

                    module: '../nez'
                    class: 'Objective'  
                    

                    leaf: ['ok']

                    (telemetry) -> 

                        for code in [   'BOOSTER',   'RETRO',    'FIDO',
                                        'GUIDANCE',  'SURGEON',  'EECOM',
                                        'GNC',       'TELMU',    'CONTROL',
                                        'PROCEDURES','INCO',     'FAO',
                                        'NETWORK',   'RECOVERY', 'CAPCOM'  ] 

                            do (code) -> 

                                # 
                                # BUG: (possibly) this failing after each hook is
                                #                 notifying three times, um...
                                # 
                                #                     
                                #
                                #
                                # before each: -> @sequence++
                                # after  each: -> @payload = @payload.toUpperCase()
                                #  
                                # 

                                
                                before each: -> @payload = @payload.toUpperCase()
                                after  each: -> @sequence++

                                telemetry code, (ok) -> 

                                    @metric1  = 42014.22
                                    @metric2  = 19
                                    @STILL_GO = true

                                    ok()



            it 'receives tokens from the objective phrase tree', (done) -> 

                should.exist @jobTokens['/Failsafe Loop/objective/telemetry/FIDO']
                done()


            it 'can call a token run via the tokenEmitter', (done) -> 

                @jobEmitter( 

                    @jobTokens['/Failsafe Loop/objective/telemetry/BOOSTER']

                    sequence: 1232
                    payload:  'elephant'

                ).then (result) -> 

                    result.should.eql

                        job: 
                            sequence:      1233
                            payload:       'ELEPHANT'
                            metric1:       42014.22
                            metric2:       19
                            STILL_GO:      true

                    done()


            it 'gets notified of failing steps', (done) -> 

                @jobEmitter( @jobTokens['/Failsafe Loop/objective/telemetry/BOOSTER'] ).then( 

                    -> 
                    -> 
                    (notify) => 

                        # console.log notify

                        if notify.state == 'run::step:failed' then @ERROR_IS = notify.error

                        else if notify.state == 'run::complete'

                            @ERROR_IS.should.match /Cannot call method 'toUpperCase' of undefined/

                            notify.progress.should.eql steps: 3, done: 0, failed: 1, skipped: 2
                            done()

                )

           

