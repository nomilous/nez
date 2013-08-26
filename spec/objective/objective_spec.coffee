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

                nez.Objective.prototype.startMonitor = (opts, @tokens, @jobEmitter) => done()

                nez.objective

                    title: 'Failsafe Loop'
                    uuid:  '11'
                    description: ''

                    leaf: ['ok']

                    (telemetry) -> 

                        before each: -> @sequence++
                        after  each: -> @input9 = @input9.toUpperCase()

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

                @jobEmitter( 

                    @tokens['/Failsafe Loop/objective/telemetry/BOOSTER']

                    sequence: 1232
                    input9:   'elephant'

                ).then (result) -> 

                    result.should.eql

                        job: 
                            sequence:      1233
                            input9:        'ELEPHANT'
                            metric1:       42014.22
                            metric2:       19
                            GO_FOR_LAUNCH: true

                    done()

           

