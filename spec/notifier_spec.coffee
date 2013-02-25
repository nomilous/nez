should   = require 'should' 
Notifier = require '../lib/notifier'

describe 'Notifier', ->

    it 'is an event emitter', (done) ->

        n = new Notifier
        n.on.should.be.an.instanceof Function
        n.emit.should.be.an.instanceof Function
        done()


    describe 'initialized with predefined events', -> 

        beforeEach -> 

            @subject = new Notifier

                #
                # possibly don;t need descriptions
                #

                event1: 'Description1'
                event2: 'Description2'


        it 'throws on non event registrations', (done) ->


            try 
                @subject.on 'event3', -> 

            catch error
                error.should.match /No such event/
                done()


        it 'registers handlers', (thisFunctionRan) ->

            @subject.on 'event1', -> thisFunctionRan()
            @subject.emit 'event1', ''

