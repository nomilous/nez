should    = require 'should'
nez       = require '../../lib/nez'

describe 'Objective', -> 

    beforeEach -> 

        @objective = new nez.Objective

    it 'is a class', (done) -> 

        @objective.should.be.an.instanceof nez.Objective
        done()


    context 'startMonitor( opts, tokens, emitter )', -> 

        it 'throws undefined override', (done) -> 

            try @objective.startMonitor {}, {}, (token, opts) -> 

            catch error

                error.should.match /undefined override/
                done()


        context 'objectiveTree', -> 

            before (done) -> 

                nez.Objective.prototype.startMonitor = (opts, @tokens, @tokenEmitter) => done()

                nez.objective

                    title: 'Failsafe Loop'
                    uuid:  '11'
                    description: ''

                    leaf: ['ok']

                    (telemetry) -> 

                        for code in [   'BOOSTER',   'RETRO',    'FIDO',
                                        'GUIDANCE',  'SURGEON',  'EECOM',
                                        'GNC',       'TELMU',    'CONTROL',
                                        'PROCEDURES','INCO',     'FAO',
                                        'NETWORK',   'RECOVERY', 'CAPCOM'  ] 

                            do (code) -> 

                                telemetry code, (ok) -> 

                                    @metric1       = 42014.22
                                    @metric2       = 19
                                    @GO_FOR_LAUNCH = true

                                    ok()



            it 'receives tokens from the objective phrase tree', (done) -> 

                should.exist @tokens['/Failsafe Loop/objective/telemetry/FIDO']
                done()


            it 'can call a token run via the tokenEmitter', (done) -> 

                @tokenEmitter( @tokens['/Failsafe Loop/objective/telemetry/BOOSTER'] ).then (result) -> 

                    result.should.eql

                        job: 

                            metric1:       42014.22
                            metric2:       19
                            GO_FOR_LAUNCH: true

                    done()

           

