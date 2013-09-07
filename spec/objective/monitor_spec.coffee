monitor = require '../../lib/objective/monitor'
should  = require 'should'

describe 'DirectoryMonitor', -> 

    it 'maintains the list of directories to monitor', (done) ->

        m = new monitor.DirectoryMonitor
        m.watchers.should.be.an.instanceof Array
        done()

