require 'fing'

#
# Private class
#

class Hooks

    constructor: (subscribe) -> 

        subscribe 'edge', @handle

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
