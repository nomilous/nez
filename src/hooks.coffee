require 'fing'

#
# Private class
#

class Hooks

    constructor: (subscribe) -> 

        subscribe 'edge', @handle
        @hooks = {}

    set: (hookName, node, callback) -> 

        #
        # store the new hook indexed on node/hookName
        #

        @hooks[node.fing.ref] ||= {}
        @hooks[node.fing.ref][hookName] = callback

    handle: (placeholder, nodes) -> 

        console.log nodes

#
# Public Factory
#

hooks = {}
module.exports = 

    #
    # store/bind new stack or return existing
    #

    getFor: (stack) -> 

        hooks[stack.fing.ref] ||= new Hooks stack.on
