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
                return 'WATCHER'

            m = new monitor.DirectoryMonitor
            m.add __dirname 
            m.monitors[__dirname].should.eql 'WATCHER'
            done()




