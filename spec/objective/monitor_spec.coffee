monitor = require '../../lib/objective/monitor'
should  = require 'should'
Hound   = require 'hound'

describe 'DirectoryMonitor', -> 

    beforeEach -> 
        @watch = Hound.watch

    afterEach -> 
        Hound.watch = @watch


    it 'maintains the list of directories to monitor', (done) ->

        m = new monitor.DirectoryMonitor
        should.exist m.monitors
        done()


    context 'add(directory)', -> 

        it 'adds a directory to be monitored', (done) ->

            Hound.watch = (directory) -> 
                directory.should.equal __dirname
                return watcher: true, on: ->


            m = new monitor.DirectoryMonitor
            m.add __dirname 
            m.monitors[__dirname].watcher.should.equal true
            done()


        it 'does not add the same directory morethan 1ce', (done) -> 

            m = new monitor.DirectoryMonitor
            Hound.watch = (directory) -> on: ->
            m.add __dirname 
            Hound.watch = (directory) -> throw 'should not run'
            m.add __dirname
            done()


        xit 'does not add subdirectories of already monitored directories'


        it 'subscribes to create, change and delete of files', (done) -> 

            EVENTS = []
            Hound.watch = (directory) -> 
                on: (event) -> EVENTS.push event

            m = new monitor.DirectoryMonitor
            m.add __dirname

            EVENTS.should.eql ['create', 'change', 'delete']
            done()



    context 'as event emitter', -> 

        it 'emits create, change and delete', (done) -> 
            EVENTS
            Hound.watch = (directory) -> 
                on: (event, listener) -> 
                    listener './mock/' + event + 'd/file'

            m = new monitor.DirectoryMonitor __dirname
            
            EVENTS = {}
            m.on 'create', (filename) -> EVENTS.created = filename
            m.on 'change', (filename) -> EVENTS.changed = filename
            m.on 'delete', (filename) -> EVENTS.deleted = filename
            m.add __dirname

            EVENTS.should.eql
                created: './mock/created/file'
                changed: './mock/changed/file'
                deleted: './mock/deleted/file'

            done()

    
