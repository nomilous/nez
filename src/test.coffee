injector = require('nezkit').injector
require 'fing'

injector.inject (Node) -> 

    console.log Node == require './node'
