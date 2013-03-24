injector = require('nezkit').injector
require 'fing'

injector.inject (Node, Link:fixPath, should) -> 

    Node.should.equal require './node'
    fixPath('moo').should.equal 'moo.coffee'
