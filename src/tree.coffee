require 'fing'

#
# private Tree
#

trees = {}

class Tree

    constructor: (subscribe) -> 

        subscribe 'edge', @edge

    edge: (door, nodes) => 

        @traverse nodes.from, nodes.to

    traverse: (from, to) ->

        console.log arguments


#
# Public Tree Factory
#

module.exports = create: (stack) -> 

    trees[stack.fing.id] ||= new Tree stack.on

