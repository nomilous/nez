should   = require 'should' 
Notifier = require '../lib/notifier'

describe 'Notifier', ->

    it 'is an event emitter', (done) ->

        n = Notifier.create()
        n.on.should.be.an.instanceof Function
        n.emit.should.be.an.instanceof Function
        done()


    describe 'initialized with predefined events', -> 

        beforeEach -> 

            @subject = Notifier.create 'name',

                #
                # possibly don;t need descriptions
                #

                event1: { event: 'config' }
                event2: { event: 'config' }


        it 'throws on non event registrations', (done) ->


            try 
                @subject.on 'event3', -> 

            catch error
                error.should.match /No such event/
                done()


        it 'registers handlers', (thisFunctionRan) ->

            @subject.on 'event1', -> thisFunctionRan()
            @subject.emit 'event1', ''

