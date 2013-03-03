require 'fing'

#
# Private class
#

class Hooks

    constructor: (subscribe) -> 

        subscribe 'edge', @handle

    set: (node, config) -> 

        for key of config

            if key == 'beforeEach' or key == 'afterEach'

                node.hooks[key] = config[key]

            if key == 'beforeAll' or key == 'afterAll'

                node.hooks[key] = config[key]



    handle: (placeholder, nodes) -> 

        fromHooks = nodes.from.hooks



        #
        # from hooks run when traversing
        # a childward edge
        #

        for hook of fromHooks

            if hook == 'beforeAll'

                fromHooks[hook]() if fromHooks[hook]

                #
                # only run beforeAll once
                #

                delete fromHooks[hook]

            else if hook == 'beforeEach'

                fromHooks[hook]() if fromHooks[hook]


        toHooks = nodes.to.hooks

        #
        # to hooks run when traversing
        # from the chile back into the parent
        #

        for hook of toHooks

            if hook == 'afterAll'

                toHooks[hook]() if toHooks[hook]
                delete toHooks[hook]

            else if hook == 'afterEach'

                toHooks[hook]() if toHooks[hook]


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
