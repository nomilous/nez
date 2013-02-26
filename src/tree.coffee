require 'fing'

#
# private Tree
#

trees = {}

class Tree

    constructor: (subscribe) -> 

        subscribe 'edge', @edge

    edge: (placeholder, nodes) => 

        @traverse nodes.from, nodes.to

    traverse: (from, to) ->

        console.log "#{from.class} #{from.label}", '\t------>\t', "#{to.class} #{to.label}"


#
# Public Tree Factory
#

module.exports = create: (stack) -> 

    trees[stack.fing.id] ||= new Tree stack.on

